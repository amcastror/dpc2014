//
//  PerfilViewController.m
//  diaPatrimonio
//
//  Created by Matias Castro on 03-03-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "PerfilViewController.h"
#import "FacebookController.h"

@interface PerfilViewController ()

@end

@implementation PerfilViewController

@synthesize estadoSesionFacebook, publish, facebookSwitch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Perfil", @"Perfil");
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [facebookSwitch addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[FacebookController instance] tengoSession]) {
        estadoSesionFacebook.text = @"Estoy logueado..";
        facebookSwitch.on = YES;
    }else{
        estadoSesionFacebook.text = @"No estoy logueado..";
        facebookSwitch.on = NO;
    }
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
                    estadoSesionFacebook.text = @"Estoy logueado..";
                }else{
                    estadoSesionFacebook.text = @"No estoy logueado";
                }
            }];
        }else{
            [[FacebookController instance] logout];
            estadoSesionFacebook.text = @"No estoy logueado";
        }
    }else if(switchControl.tag ==1) {//Twitter
        
    }
}

- (IBAction)publishOnWall:(id)sender{
    
    NSMutableDictionary *parametros = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @"http://diapatrimonio.cl", @"link",
                                       @"AppDiaPatrimonio", @"name",
                                       @"Post de la app del día del patrimonio", @"message",
                                       @"no se lo que es caption",@"caption",
                                       @"descripcion de la app del dia del .", @"description",nil];
    
    if ([[FacebookController instance] tengoSession]) {
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Publicando..."];
        [[FacebookController instance] publishStoryOnWallWithParams:parametros AndAttemps:2 AndCompletitionHandler:^(NSError *error) {
            [DejalBezelActivityView removeView];
            if (!error) {
                NSLog(@"terminé bien de publicar");
                //[self viewDidEndWithResult:@"Published" Error:nil];
            }else{
                NSLog(@"terminé mal de publicar, error: %@", error);
                //[self viewDidEndWithResult:@"Error" Error:error];
            }
        }];
    }else{
        
        [[FacebookController instance] trataDeAbrirSesionWithUI:YES AndHandler:^(NSError *error) {
            [DejalBezelActivityView activityViewForView:self.view withLabel:@"Publicando..."];
            [[FacebookController instance] publishStoryOnWallWithParams:parametros AndAttemps:2 AndCompletitionHandler:^(NSError *error) {
                [DejalBezelActivityView removeView];
                if (!error) {
                    NSLog(@"terminé bien de publicar");
                    //[self viewDidEndWithResult:@"Published" Error:nil];
                }else{
                    NSLog(@"terminé mal de publicar, error: %@", error);
                    //[self viewDidEndWithResult:@"Error" Error:error];
                }
            }];
        }];
    }
}

@end
