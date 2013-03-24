//
//  PerfilViewController.m
//  diaPatrimonio
//
//  Created by Matias Castro on 03-03-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "PerfilViewController.h"
#import "FacebookController.h"
#import <Twitter/Twitter.h>

@interface PerfilViewController ()

@end

@implementation PerfilViewController

@synthesize estadoSesionFacebook, publish, facebookSwitch, twitterSwitch;

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
        if ([TWTweetComposeViewController canSendTweet]) {
            // Create an account store object.
            ACAccountStore *accountStore = [[ACAccountStore alloc] init];
            
            // Create an account type that ensures Twitter accounts are retrieved.
            ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
            
            // Request access from the user to use their Twitter accounts.
            [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
                if (granted) {
                    //[[[UIAlertView alloc] initWithTitle:@"Master!" message:@"Listo, ahora hay twitter!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    NSLog(@"master, hay twitter");
                }else{
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No se pudo acceder a su cuenta, es posible que la aplicación esté bloqueada en Ajustes/Twitter" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
                if (error) {
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No se pudo acceder a su cuenta de Twitter, por favor intentelo más tarde" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    
                }
            }];
        }else{
            [[[UIAlertView alloc] initWithTitle:@"Twitter no disponible" message:@"Active su cuenta de twitter en Ajustes del sistema" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
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
