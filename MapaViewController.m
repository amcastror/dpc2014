//
//  MapaViewController.m
//  diaPatrimonio
//
//  Created by Matias Castro on 22-02-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "MapaViewController.h"
#import "PuntosCulturales.h"
#import "PuntoCultural.h"
#import "PuntoCulturalViewController.h"
#import "MapItem.h"
#import "BuscadorPuntosCulturalesViewController.h"
#import "Usuario.h"

@interface MapaViewController ()

@end

@implementation MapaViewController
@synthesize botonBuscarAqui;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"TITULO_MAPA", @"Patrimonio Cultural");
        UIBarButtonItem *buscar = [[UIBarButtonItem alloc] initWithTitle:@"buscar" style:UIBarButtonItemStyleBordered target:self action:@selector(presentaBuscador)];
        [buscar setTintColor:[UIColor darkGrayColor]];
        self.navigationItem.rightBarButtonItem = buscar;
    }
    return self;
}

#pragma mark system methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [mapa setDelegate:self];
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"localizando..."];
    [[Usuario instance] updateLocationWithPrecision:100 AndTimeInterval:3 AndSuccessHandler:^(NSError *error) {
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"cargando..."];
        [[PuntosCulturales instance] requestPuntosCulturalesCercanosWithSuccess:^(NSArray *puntosCulturales) {
            [DejalBezelActivityView removeView];
            //ahora tengo que decirle al mapa que se dibuje..
            [self dibujarMapa];
        } AndFail:^(NSError *error) {
            [DejalBezelActivityView removeView];
        }];
    }];
    
    [[APIClient instance] requestZonasYSubZonasWithSuccess:^(NSDictionary *results) {
        //
    } AndFail:^(NSError *error) {
        //
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [mapa setShowsUserLocation:YES];
    if ([[PuntosCulturales instance] recienDescargados]) {
        [self dibujarMapa];
        [[PuntosCulturales instance] setRecienDescargados:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [mapa setShowsUserLocation:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark custom methods

-(void)dibujarMapa{
    
    NSMutableArray *toRemove = [NSMutableArray arrayWithCapacity:[mapa.annotations count]];
    
    for (id annotation in mapa.annotations) {
        if (annotation != mapa.userLocation) {
            [toRemove addObject:annotation];
        }
    }
    
    [mapa removeAnnotations:toRemove];
    
    for (PuntoCultural *puntoCultural in [[PuntosCulturales instance] puntosCulturales]) {
         //necesito hacer un punto en el mapa...
        CLLocationCoordinate2D coordenadaItem = {puntoCultural.latitud.doubleValue, puntoCultural.longitud.doubleValue};
        MapItem *item = [[MapItem alloc] initWithIDPunto:puntoCultural.id_punto AndCoordinate:coordenadaItem AndNombre:puntoCultural.nombre];
        [mapa addAnnotation:item];
    }
}

-(void)muestraPuntoCultural:(id)sender{ //me llama un botón. Hay que ponerle tag
    
    PuntoCultural *puntoCultural = [[PuntosCulturales instance] requestPuntoConID:[NSNumber numberWithInt:((UIButton *)sender).tag]];
    
    PuntoCulturalViewController *puntoCulturalViewController = [[PuntoCulturalViewController alloc] initWithNibName:@"PuntoCulturalViewController" bundle:[NSBundle mainBundle] AndPuntoCultural:puntoCultural];
    //PuntoCulturalViewController *puntoCulturalViewController = [[PuntoCulturalViewController alloc] initWithPuntoCultural:puntoCultural];
    [[self navigationController] pushViewController:puntoCulturalViewController animated:YES];
    //[[self navigationController] presentViewController:puntoCultural animated:YES completion:^{}];
}

-(void) presentaBuscador{
    BuscadorPuntosCulturalesViewController *buscador = [[BuscadorPuntosCulturalesViewController alloc] initWithNibName:@"BuscadorPuntosCulturalesViewController" bundle:[NSBundle mainBundle]];
    [[self navigationController] presentViewController:buscador animated:YES completion:^{}];
}

-(IBAction)botonBuscarAquiPressed:(id)sender{
    
    [[Usuario instance] apagarGPS];
    CGPoint nwPoint = CGPointMake(mapa.bounds.origin.x, mapa.bounds.origin.y);
    CGPoint sePoint = CGPointMake(mapa.bounds.origin.x+ mapa.bounds.size.width, mapa.bounds.origin.y + mapa.bounds.size.height);
    CLLocationCoordinate2D nwCoord = [mapa convertPoint: nwPoint toCoordinateFromView:mapa];
    CLLocationCoordinate2D seCoord = [mapa convertPoint: sePoint toCoordinateFromView:mapa];
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"buscando..."];
    [[PuntosCulturales instance] requestPuntosCulturalesEntre:nwCoord Y:seCoord WithSuccess:^(NSArray *puntosCulturales) {
        [self dibujarMapa];
        [DejalBezelActivityView removeViewAnimated:YES];
    } AndFail:^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:YES];
    }];
}

#pragma mark mapa delegate methods

- (MKAnnotationView *)mapView:(MKMapView *)thisMapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    //hacer el boton derecho que abre la ficha Sucursal
    MapItem *aMapPoint = (MapItem *)annotation;
    //NSLog(@"title: %@", aMapPoint.title);
    static NSString *AnnotationViewID = @"annotationViewID";
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [thisMapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    
    annotationView.canShowCallout = YES;
    
    annotationView.annotation = annotation;
    
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton addTarget:self action:@selector(muestraPuntoCultural:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.tag = [aMapPoint.id_punto intValue];
    
    annotationView.rightCalloutAccessoryView = rightButton;
    return annotationView;
}
@end
