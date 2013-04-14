//
//  PuntoCulturalViewController.m
//  diaPatrimonio
//
//  Created by Matias Castro on 23-02-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "PuntoCulturalViewController.h"
#import "MisPuntosCulturales.h" 
#import "ShareViewController.h"

@interface PuntoCulturalViewController (){
    PuntoCultural *puntoCultural;
}

@end

@implementation PuntoCulturalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AndPuntoCultural:(PuntoCultural *)_puntoCultural;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.title = NSLocalizedString(@"Ficha Cultural", @"Ficha Cultural");
        self.hidesBottomBarWhenPushed = YES;
        puntoCultural = _puntoCultural;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"cargando..."];
    [puntoCultural requestCompletarInformacionWithSuccess:^{
        resumen.text = [NSString stringWithFormat:@"id: %@, nombre: %@, descripción: %@, lat: %@, long: %@", puntoCultural.id_punto, puntoCultural.nombre, puntoCultural.descripcion, puntoCultural.latitud, puntoCultural.longitud];
        if (puntoCultural.url_foto) {
            ImagenAsincrona *foto = [[ImagenAsincrona alloc] initWithFrame:CGRectMake(40, 30, 240, 120) AndURL:puntoCultural.url_foto AndStartNow:YES];
            [self.view addSubview:foto];
        }
        [DejalBezelActivityView removeViewAnimated:YES];
    } AndFail:^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:YES];
    }];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self actualizaDisplayBotonAccion];
}

-(void) actualizaDisplayBotonAccion{
    
    if ([[MisPuntosCulturales instance] puntoCulturalConID:puntoCultural.id_punto]) {
        if (puntoCultural.visitado) {
            [botonAccionPunto setTitle:@"marcar como no visitado" forState:UIControlStateNormal];
            [botonAccionPunto setTitle:@"marcar como no visitado" forState:UIControlStateSelected];
            [botonAccionPunto setTitle:@"marcar como no visitado" forState:UIControlStateHighlighted];
        }else{
            [botonAccionPunto setTitle:@"marcar como visitado" forState:UIControlStateNormal];
            [botonAccionPunto setTitle:@"marcar como visitado" forState:UIControlStateSelected];
            [botonAccionPunto setTitle:@"marcar como visitado" forState:UIControlStateHighlighted];
        }
    }else{
        [botonAccionPunto setTitle:@"Agregar a mis puntos culturales" forState:UIControlStateNormal];
        [botonAccionPunto setTitle:@"Agregar a mis puntos culturales" forState:UIControlStateSelected];
        [botonAccionPunto setTitle:@"Agregar a mis puntos culturales" forState:UIControlStateHighlighted];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - acciones del punto

- (IBAction)botonAccionPuntoPressed:(id)sender{
    
    if ([[MisPuntosCulturales instance] puntoCulturalConID:puntoCultural.id_punto]) {
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Cargando..."];
        [puntoCultural cambiarEstadoPuntoWithSuccess:^{
            [self actualizaDisplayBotonAccion];
            [DejalBezelActivityView removeViewAnimated:YES];
        } AndFail:^(NSError *error) {
            [self actualizaDisplayBotonAccion];
            [DejalBezelActivityView removeViewAnimated:YES];
        }];
        
    }else{
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Agregando punto..."];
        if ([[MisPuntosCulturales instance] puntoCulturalConID:puntoCultural.id_punto]) {
            [DejalBezelActivityView removeViewAnimated:YES];
            [[[UIAlertView alloc] initWithTitle:@"Alerta" message:@"Este lugar ya está dentro de tu ruta" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return;
        }
        
        [[MisPuntosCulturales instance] agregarPuntoCultural:puntoCultural AMisPuntosWithSuccess:^{
            [DejalBezelActivityView removeViewAnimated:YES];
            [self actualizaDisplayBotonAccion];
        } AndFail:^(NSError *error) {
            [DejalBezelActivityView removeViewAnimated:YES];
            [self actualizaDisplayBotonAccion];
        }];
    }
    
}

- (IBAction)botonCompartirEnRedesSocialesPressed:(id)sender{
    ShareViewController *share = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:[NSBundle mainBundle]];
    [[self navigationController] pushViewController:share
                                           animated:YES];
    
    UIBarButtonItem *atras = [[UIBarButtonItem alloc] initWithTitle:@"Ficha" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    if([[UIBarButtonItem class] instancesRespondToSelector:@selector(setTintColor:)]){
        atras.tintColor = [UIColor darkGrayColor];
    }
    
    [self.navigationItem setBackBarButtonItem:atras];
}

@end
