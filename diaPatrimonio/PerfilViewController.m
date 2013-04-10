//
//  PerfilViewController.m
//  diaPatrimonio
//
//  Created by Matias Castro on 03-03-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "PerfilViewController.h"

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
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[FacebookController instance] tengoSession]) {
        estadoSesionFacebook.text = @"facebook on";
        facebookSwitch.on = YES;
    }else{
        estadoSesionFacebook.text = @"facebook off";
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
                        estadoSesionFacebook.text = @"facebook on";
                    }else{
                        estadoSesionFacebook.text = @"facebook off";
                        switchControl.on = NO;
                    }
                }else{
                    
                }
            }];
        }else{
            [[FacebookController instance] logout];
            estadoSesionFacebook.text = @"facebook off";
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
        nombreCuenta.text = @"";
    }else{
        estadoSesionTwitter.text = @"twitter on";
        twitterSwitch.on = YES;
        nombreCuenta.text = [NSString stringWithFormat:@"Estas usando la cuenta %@", [[TwitterController instance] nombreCuenta]];
        if ([[TwitterController instance] cantidadDeCuentas] > 0) {
            cuentaPorDefecto.hidden = NO;
        }else{
            cuentaPorDefecto.hidden = YES;
        }
    }
}

@end
