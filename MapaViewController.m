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
#import "ViewPuntoMapa.h"
#import "BuscadorPuntosCulturalesViewController.h"
#import "Usuario.h"
#import "GAI.h"
#import "GAITracker.h"

@interface MapaViewController ()

@end

@implementation MapaViewController
@synthesize botonBuscarAqui;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

#pragma mark system methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.trackedViewName = @"mapa";
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) { // if iOS 7
        self.edgesForExtendedLayout = UIRectEdgeNone; //layout adjustements
        self.navigationController.navigationBar.translucent = NO;
    }
    
    UIImage *lupa = [UIImage imageNamed:@"dpc-nav-bar-lupa-"];
    UIButton *botonLupa = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, lupa.size.width, lupa.size.height)];
    [botonLupa setBackgroundImage:lupa forState:UIControlStateNormal];
    [botonLupa setBackgroundImage:lupa forState:UIControlStateHighlighted];
    [botonLupa addTarget:self action:@selector(presentaBuscador:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buscarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:botonLupa];
    self.navigationItem.rightBarButtonItem = buscarButtonItem;

    [mapa setDelegate:self];
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"localizando..."];
    [[Usuario instance] updateLocationWithPrecision:100 AndTimeInterval:3 AndSuccessHandler:^(NSError *error) {
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"cargando..."];
        [[PuntosCulturales instance] requestPuntosCulturalesCercanosWithSuccess:^(NSArray *puntosCulturales) {
            [DejalBezelActivityView removeView];
            //ahora tengo que decirle al mapa que se dibuje..
            [self dibujarMapaConAjuste:YES];
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
        [self dibujarMapaConAjuste:YES];
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

-(void)dibujarMapaConAjuste:(BOOL)ajustar{
    
    NSMutableArray *toRemove = [NSMutableArray arrayWithCapacity:[mapa.annotations count]];
    
    for (id annotation in mapa.annotations) {
        if (annotation != mapa.userLocation) {
            [toRemove addObject:annotation];
        }
    }
    
    [mapa removeAnnotations:toRemove];
    
    for (PuntoCultural *puntoCultural in [[PuntosCulturales instance] puntosCulturales]) {
        BOOL muestra_punto = YES;
        if (
            boton_actividades.selected ||
            boton_recorridos.selected ||
            boton_rutas.selected ||
            boton_aperturas.selected
            ) { //entonces tengo que ver si el punto corresponde a alguno apretado
            muestra_punto = NO; //por defecto no los muestro a no ser de que el botón esté apretado
            if (boton_aperturas.selected && puntoCultural.id_tipo.intValue == TIPO_APERTURA) {
                muestra_punto = YES;
            }else if(boton_recorridos.selected && puntoCultural.id_tipo.intValue == TIPO_RECORRIDO_GUIADO){
                muestra_punto = YES;
            }else if(boton_actividades.selected && puntoCultural.id_tipo.intValue == TIPO_ACTIVIDAD){
                muestra_punto = YES;
            }else if(boton_rutas.selected && puntoCultural.id_tipo.intValue == TIPO_RUTA_TEMATICA){
                muestra_punto = YES;
            }
        }
        if (muestra_punto) {
            CLLocationCoordinate2D coordenadaItem = {puntoCultural.latitud.doubleValue, puntoCultural.longitud.doubleValue};
            MapItem *item = [[MapItem alloc] initWithIDPunto:puntoCultural.id_punto AndCoordinate:coordenadaItem AndNombre:puntoCultural.nombre AndDescripcion:puntoCultural.descripcion AndOriginalArrayIndex:[[[PuntosCulturales instance] puntosCulturales] indexOfObject:puntoCultural]];
            [mapa addAnnotation:item];
        }
    }
    if (ajustar && [[[PuntosCulturales instance] puntosCulturales] count] > 0) {
        [self ajustarMargenesDelMapa];
    }
}

-(void) ajustarMargenesDelMapa{
    
    NSMutableArray *lats = [[NSMutableArray alloc] init];
    NSMutableArray *lons = [[NSMutableArray alloc] init];
    
    for (PuntoCultural *punto in [[PuntosCulturales instance] puntosCulturales]) {
        [lats addObject:[punto latitud]];
        [lons addObject:[punto longitud]];
    }
    NSLog(@"test");
    float maxLat = [[lats valueForKeyPath:@"@max.self"] doubleValue];
    float maxLon = [[lons valueForKeyPath:@"@max.self"] doubleValue];
    float minLat = [[lats valueForKeyPath:@"@min.self"] doubleValue];
    float minLon = [[lons valueForKeyPath:@"@min.self"] doubleValue];
    
    MKCoordinateSpan span;
    MKCoordinateRegion laRegion;
    
    laRegion.center.latitude = (minLat+ maxLat)/2;
    laRegion.center.longitude = (minLon + maxLon)/2;
    span.latitudeDelta= (fabs(minLat) - fabs(maxLat))*1.15;
    span.longitudeDelta= (fabs(minLon) - fabs(maxLon))*1.15;
    laRegion.span = span;
    
    [mapa setRegion:laRegion animated:YES];
}

-(void)muestraPuntoCultural:(id)sender{ //me llama un botón. Hay que ponerle tag
    
    PuntoCultural *puntoCultural = [[PuntosCulturales instance] requestPuntoConID:[NSNumber numberWithInt:((UIButton *)sender).tag]];
    
    PuntoCulturalViewController *puntoCulturalViewController = [[PuntoCulturalViewController alloc] initWithNibName:@"PuntoCulturalViewController" bundle:[NSBundle mainBundle] AndPuntoCultural:puntoCultural];
    puntoCulturalViewController.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dpc-nav-bar-logos"]];
    [[self navigationController] pushViewController:puntoCulturalViewController animated:YES];
    
    UIBarButtonItem *atras = [[UIBarButtonItem alloc] initWithTitle:@"Mapa" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    if([[UIBarButtonItem class] instancesRespondToSelector:@selector(setTintColor:)]){
        atras.tintColor = [UIColor darkGrayColor];
    }
    
    self.navigationItem.backBarButtonItem = atras;
}

-(IBAction) presentaBuscador:(id)sender{
    BuscadorPuntosCulturalesViewController *buscador = [[BuscadorPuntosCulturalesViewController alloc] initWithNibName:@"BuscadorPuntosCulturalesViewController" bundle:[NSBundle mainBundle]];
    [[self navigationController] presentViewController:buscador animated:YES completion:^{}];
}

-(IBAction)botonBuscarAquiPressed:(id)sender{
    
    boton_rutas.selected = NO;
    boton_actividades.selected = NO;
    boton_aperturas.selected = NO;
    boton_recorridos.selected = NO;
    
    CGPoint nwPoint = CGPointMake(mapa.bounds.origin.x, mapa.bounds.origin.y);
    CGPoint sePoint = CGPointMake(mapa.bounds.origin.x+ mapa.bounds.size.width, mapa.bounds.origin.y + mapa.bounds.size.height);
    CLLocationCoordinate2D nwCoord = [mapa convertPoint: nwPoint toCoordinateFromView:mapa];
    CLLocationCoordinate2D seCoord = [mapa convertPoint: sePoint toCoordinateFromView:mapa];
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"buscando..."];
    [[PuntosCulturales instance] requestPuntosCulturalesEntre:nwCoord Y:seCoord WithSuccess:^(NSArray *puntosCulturales) {
        [self dibujarMapaConAjuste:YES];
        [DejalBezelActivityView removeViewAnimated:YES];
    } AndFail:^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:YES];
    }];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker trackEventWithCategory:@"UI" withAction:@"buscar" withLabel:@"aqui" withValue:nil];
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
    
    ViewPuntoMapa *annotationView = (ViewPuntoMapa *) [thisMapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    annotationView = [[ViewPuntoMapa alloc] initWithPunto:[[[PuntosCulturales instance] puntosCulturales] objectAtIndex:aMapPoint.originalArrayIndex]];
    
    annotationView.canShowCallout = YES;
    
    annotationView.annotation = annotation;
    UIImage *flecha = [UIImage imageNamed:@"dpc-mapa-call-flecha"];
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton setImage:flecha forState:UIControlStateNormal];
    [rightButton setImage:flecha forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(muestraPuntoCultural:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.tag = [aMapPoint.id_punto intValue];
    annotationView.rightCalloutAccessoryView = rightButton;
    return annotationView;
}

#pragma mark - botones

-(IBAction)aperturasPressed:(id)sender{
    UIButton *boton = (UIButton *)sender;
    if (boton.selected) {
        [boton setSelected:NO];
    }else{
        [boton setSelected:YES];
    }
    [self dibujarMapaConAjuste:NO];
}

-(IBAction)recorridosPressed:(id)sender{
    UIButton *boton = (UIButton *)sender;
    if (boton.selected) {
        [boton setSelected:NO];
    }else{
        [boton setSelected:YES];
    }
    [self dibujarMapaConAjuste:NO];
}

-(IBAction)rutasPressed:(id)sender{
    UIButton *boton = (UIButton *)sender;
    if (boton.selected) {
        [boton setSelected:NO];
    }else{
        [boton setSelected:YES];
    }
    [self dibujarMapaConAjuste:NO];
}

-(IBAction)actividadesPressed:(id)sender{
    UIButton *boton = (UIButton *)sender;
    if (boton.selected) {
        [boton setSelected:NO];
    }else{
        [boton setSelected:YES];
    }
    [self dibujarMapaConAjuste:NO];
}

@end
