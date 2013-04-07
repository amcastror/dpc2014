//
//  TwitterController.m
//  DiaDelPatrimonio
//
//  Created by Matias Castro on 05-04-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "TwitterController.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@implementation TwitterController{
    NSInteger cunetaPorDefecto;
}

+(TwitterController *) instance
{
    static TwitterController *singleton = nil;
    @synchronized(self)
    {
        if (!singleton) {
            singleton = [[TwitterController alloc] init];
        }
    }
    return singleton;
    
}

-(id) init{
    if (self = [super init]) {
        cunetaPorDefecto = 0;
        if (![self tengoCuentas]) {
            [self setTwitterOn:NO];
        }
    }
    return self;
}

-(void) setTwitterOn:(BOOL)_value{
    [[NSUserDefaults standardUserDefaults] setBool:_value forKey:@"twitter"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL) twitterOn{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"twitter"];
}

-(BOOL) canSendTweet{
    return [TWTweetComposeViewController canSendTweet];
}

-(void) imprimeCuentas{
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
    
    if (accountsArray.count > 0) {
        for (ACAccount *cuenta in accountsArray) {
            NSLog(@"cuenta: %@", [cuenta username]);
        }
    }else{
        NSLog(@"no tengo ninguna cuenta...");
    } 
}

-(void) conectarseALasCuentasDelUsuarioWithSender:(id)sender AndHandler:(void (^)(NSError *error))handler{

    UIViewController *login = (UIViewController *)sender;
    [DejalBezelActivityView activityViewForView:login.view withLabel:@"conectando..."];
     // Create an account store object.
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    // Create an account type that ensures Twitter accounts are retrieved.
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    // Request access from the user to use their Twitter accounts.
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        
        if (error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No se pudo acceder a su cuenta de Twitter" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            });
            
            [self setTwitterOn:NO];
            if (handler) {
                NSError *err = [[NSError alloc] initWithDomain:@"No se pudo acceder a su cuenta de Twitter" code:1 userInfo:nil];
                handler(err);
            }
        }else{
            if (granted) {
                [DejalBezelActivityView removeViewAnimated:YES];
                [self setTwitterOn:YES];
                if ([self cantidadDeCuentas] > 1) {
                    
                    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Cuenta por defecto:"
                                                                             delegate:self
                                                                    cancelButtonTitle:nil
                                                               destructiveButtonTitle:nil
                                                                    otherButtonTitles: nil];
                    for (NSString *nombre in [self nombresDeCuentas]) {
                        [actionSheet addButtonWithTitle:nombre];
                    }
                    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
                    [actionSheet showFromTabBar:login.tabBarController.tabBar];
                    
                }
                
                if (handler) {
                    handler(nil);
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [DejalBezelActivityView removeViewAnimated:YES];
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No se pudo acceder a su cuenta de Twitter" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    [self setTwitterOn:NO];
                    if (handler) {
                        NSError *err = [[NSError alloc] initWithDomain:@"No se pudo acceder a su cuenta de Twitter" code:1 userInfo:nil];
                        handler(err);
                    }
                });
            }
        }
    }];
}

-(void) cambiarCuentaPorDefectoWithSender:(id)sender{
    
    UIViewController *login = (UIViewController *)sender;
    if ([self cantidadDeCuentas] > 1) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Cuenta por defecto:"
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles: nil];
        for (NSString *nombre in [self nombresDeCuentas]) {
            [actionSheet addButtonWithTitle:nombre];
        }
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet showFromTabBar:login.tabBarController.tabBar];
        
    }
}

-(BOOL) tengoCuentas{
    if ([self cantidadDeCuentas] > 0) {
        return YES;
    }else{
        return NO;
    }
}

-(int) cantidadDeCuentas{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSArray *cuentas_tmp = [accountStore accountsWithAccountType:accountType];
    if (cuentas_tmp) {
        return cuentas_tmp.count;
    }
    return 0;
}

-(NSArray *) nombresDeCuentas{
    NSMutableArray *cuentas = [[NSMutableArray alloc] init];
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSArray *cuentas_tmp = [accountStore accountsWithAccountType:accountType];
    for (ACAccount *cuenta in cuentas_tmp) {
        [cuentas addObject:[cuenta username]];
    }
    return [NSArray arrayWithArray:cuentas];
}

-(void) loginWithSender:(id)sender AndHandler:(void (^)(NSError *error))handler{
    
    if ([[TwitterController instance] canSendTweet]) {
        if (![self tengoCuentas]) {
            [self conectarseALasCuentasDelUsuarioWithSender:sender AndHandler:^(NSError *error) {
                if (!error) {
                    [self setTwitterOn:YES];
                    if (handler) {
                        handler(nil);
                    }
                }else{
                    if (handler) {
                        handler(error);
                    }
                }
            }];
        }else{
            [self setTwitterOn:YES];
            if (handler) {
                handler(nil);
            }
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setTwitterOn:NO];
            if (handler) {
                NSError *err = [[NSError alloc] initWithDomain:@"No hay cuentas" code:1 userInfo:nil];
                handler(err);
            }
            [[[UIAlertView alloc] initWithTitle:@"Twitter no disponible" message:@"Active su cuenta de twitter en Ajustes del sistema" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        });
    }
}

-(void) logout{
    [self setTwitterOn:NO];
     ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    // Create an account type that ensures Twitter accounts are retrieved.
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
    for (ACAccount *cuenta in accountsArray) {
        [cuenta setCredential:nil];
        [accountStore saveAccount:cuenta withCompletionHandler:^(BOOL success, NSError *error) {
            if (error) {
                NSLog(@"err: %@", error);
            }
            if (success) {
                NSLog(@"listo!");
            }else{
                NSLog(@"no listo...");
            }
        }];
    }
}

-(void) enviarTweetWith:(void (^)(NSError *error))handler{
    
    if (![self tengoCuentas]) {
        NSError *err = [[NSError alloc] initWithDomain:@"sin cuentas" code:1 userInfo:nil]; //tengo que decirle que no hay sesión
        handler(err);
        return;
    }
    
    //ACAccount *twitterAccount = [cuentas objectAtIndex:0];
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
	
	// Create an account type that ensures Twitter accounts are retrieved.
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
	NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
    ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
    TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"] parameters:[NSDictionary dictionaryWithObject:@"Hello." forKey:@"status"] requestMethod:TWRequestMethodPOST];
    
    [postRequest setAccount:twitterAccount];

    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        //NSString *output = [NSString stringWithFormat:@"HTTP response status: %i", [urlResponse statusCode]];
        //[self performSelectorOnMainThread:@selector(displayText:) withObject:output waitUntilDone:NO];
    }];
}

#pragma mark - action sheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    cunetaPorDefecto = buttonIndex;
}

@end
