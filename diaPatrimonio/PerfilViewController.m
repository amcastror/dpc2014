//
//  PerfilViewController.m
//  diaPatrimonio
//
//  Created by Matias Castro on 03-03-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "PerfilViewController.h"
//#import <QuartzCore/QuartzCore.h>

@interface PerfilViewController ()

@end

@implementation PerfilViewController

@synthesize estadoSesionFacebook, estadoSesionTwitter, publish, facebookSwitch, twitterSwitch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.title = NSLocalizedString(@"Perfil", @"Perfil");
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [facebookSwitch addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
    [twitterSwitch addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
    
    UIImageView *fondo_blanco = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 280, 90)];
    fondo_blanco.image = [[UIImage imageNamed:@"fondo-blanco"] resizableImageWithCapInsets:UIEdgeInsetsMake(40.0, 40.0, 40.0, 40.0)];
    [self.view addSubview:fondo_blanco];
    [self.view sendSubviewToBack:fondo_blanco];
    
    UIImageView *fondo_gris = [[UIImageView alloc] initWithFrame:CGRectMake(20, 95, 280, 260)];
    fondo_gris.image = [[UIImage imageNamed:@"fondo-gris"] resizableImageWithCapInsets:UIEdgeInsetsMake(40.0, 40.0, 40.0, 40.0)];
    [self.view addSubview:fondo_gris];
    [self.view sendSubviewToBack:fondo_gris];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[FacebookController instance] tengoSession]) {
        estadoSesionFacebook.text = @"Conectado";
        facebookSwitch.on = YES;
    }else{
        estadoSesionFacebook.text = @"No conectado";
        facebookSwitch.on = NO;
    }
    
    [self actualizaTwitterDisplay];
}

- (void)switchValueChange:(id)sender
{
    UISwitch* switchControl = sender;
    
    if (switchControl.tag ==0) {//Facebook
        if (switchControl.on) {
            [DejalBezelActivityView activityViewForView:self.view withLabel:@"Abriendo sesión en Facebook"];
            [[FacebookController instance] trataDeAbrirSesionWithUI:YES AndHandler:^(NSError *error) {
                [DejalBezelActivityView removeViewAnimated:YES];
                if (!error) {
                    if ([[FacebookController instance] tengoSession]) {
                        estadoSesionFacebook.text = @"Conectado";
                    }else{
                        estadoSesionFacebook.text = @"No conectado";
                        switchControl.on = NO;
                    }
                }else{
                    estadoSesionFacebook.text = @"No conectado";
                    switchControl.on = NO;
                }
            }];
        }else{
            [[FacebookController instance] logout];
            estadoSesionFacebook.text = @"No conectado";
            switchControl.on = NO;
        }
    }else if(switchControl.tag ==1) {//Twitter
        if (switchControl.on) {
            [[TwitterController instance] setDelegate:self];
            [[TwitterController instance] loginWithSender:self
                                               AndHandler:^(NSError *error) {
                                                   [self actualizaTwitterDisplay];
                                               }];
            
        }else{
            [[TwitterController instance] logout];
        }
        [self actualizaTwitterDisplay];
    }
}
- (IBAction)cambiarCuentaPorDefecto:(id)sender{
    [[TwitterController instance] setDelegate:self];
    [[TwitterController instance] cambiarCuentaPorDefectoWithSender:self];
}

-(void)didSelectAccount{
    [self actualizaTwitterDisplay];
}

-(void) actualizaTwitterDisplay{
    if (![[TwitterController instance] twitterOn]) {
        estadoSesionTwitter.text = @"twitter off";
        cuentaPorDefecto.hidden = YES;
        twitterSwitch.on = NO;
        nombreCuenta.text = @"Sin cuenta";
    }else{
        estadoSesionTwitter.text = @"twitter on";
        twitterSwitch.on = YES;
        nombreCuenta.text = [NSString stringWithFormat:@"%@", [[TwitterController instance] nombreCuenta]];
        if ([[TwitterController instance] cantidadDeCuentas] > 0) {
            cuentaPorDefecto.hidden = NO;
        }else{
            cuentaPorDefecto.hidden = YES;
        }
    }
}

@end
