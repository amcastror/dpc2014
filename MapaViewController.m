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

@interface MapaViewController ()

@end

@implementation MapaViewController


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
    [mapa setShowsUserLocation:YES];
    [mapa setDelegate:self];
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"cargando"];
     [[PuntosCulturales instance] requestPuntosCulturalesWithSuccess:^(NSArray *puntosCulturales) {
         [DejalBezelActivityView removeView];
        //ahora tengo que decirle al mapa que se dibuje..
         [self dibujarMapa];
    } AndFail:^(NSError *error) {
        NSLog(@"hubo un error");
    }];
     
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark custom methods

-(void)dibujarMapa{
    for (PuntoCultural *puntoCultural in [[PuntosCulturales instance] puntosCulturales]) {
         //necesito hacer un punto en el mapa...
        CLLocationCoordinate2D coordenadaItem = {puntoCultural.latitud.doubleValue, puntoCultural.longitud.doubleValue};
        MapItem *item = [[MapItem alloc] initWithCoordinate:coordenadaItem AndNombre:puntoCultural.nombre];
        [mapa addAnnotation:item];
    }
}

-(void)muestraPuntoCultural:(id)sender{ //me llama un botón. Hay que ponerle tag
    PuntoCulturalViewController *puntoCultural = [[PuntoCulturalViewController alloc] initWithNibName:@"PuntoCulturalViewController" bundle:[NSBundle mainBundle]];
    [[self navigationController] pushViewController:puntoCultural animated:YES];
    //[[self navigationController] presentViewController:puntoCultural animated:YES completion:^{}];
}

-(void) presentaBuscador{
    BuscadorPuntosCulturalesViewController *buscador = [[BuscadorPuntosCulturalesViewController alloc] initWithNibName:@"BuscadorPuntosCulturalesViewController" bundle:[NSBundle mainBundle]];
    [[self navigationController] presentViewController:buscador animated:YES completion:^{}];
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
    
    annotationView.rightCalloutAccessoryView = rightButton;
    return annotationView;
}
@end
