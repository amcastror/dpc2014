//
//  PerfilViewController.m
//  diaPatrimonio
//
//  Created by Matias Castro on 03-03-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "PerfilViewController.h"
#import "FacebookController.h"
#import "TwitterController.h"

@interface PerfilViewController ()

@end

@implementation PerfilViewController

@synthesize estadoSesionFacebook, estadoSesionTwitter, publish, facebookSwitch, twitterSwitch;

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
    
    if([[TwitterController instance] tengoCuentas]){
        estadoSesionTwitter.text = @"twitter on";
        twitterSwitch.on = YES;
    }else{
        estadoSesionTwitter.text = @"twitter off";
        twitterSwitch.on = NO;
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
                    if ([[FacebookController instance] tengoSession]) {
                        estadoSesionFacebook.text = @"facebook on";
                        /*
                         UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Compartir vía:"
                         delegate:self
                         cancelButtonTitle:@"Cancel"
                         destructiveButtonTitle:nil
                         otherButtonTitles:@"Facebook",
                         @"Tweet",
                         @"Email", nil];
                         actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
                         [actionSheet showFromTabBar:self.tabBarController.tabBar];
                         */
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
            if ([[TwitterController instance] canSendTweet]) {
                
                [[TwitterController instance] conectarseALasCuentasDelUsuarioWith:^(NSError *error) {
                    //
                    if (error) {
                        estadoSesionTwitter.text = @"twitter off";
                        switchControl.on = NO;
                    }else{
                        estadoSesionTwitter.text = @"twitter on";
                    }
                }];
            }else{
                [[[UIAlertView alloc] initWithTitle:@"Twitter no disponible" message:@"Active su cuenta de twitter en Ajustes del sistema" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                estadoSesionTwitter.text = @"twitter off";
                switchControl.on = NO;
            }
        }else{
            [[TwitterController instance] logout];
            estadoSesionTwitter.text = @"twitter off";
            switchControl.on = NO;
        }
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

#pragma mark alert view delegate methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}

@end
