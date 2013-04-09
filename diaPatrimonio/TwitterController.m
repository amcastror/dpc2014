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

@implementation TwitterController

@synthesize delegate;

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
        if (![self tengoCuentas]) {
            [self setTwitterOn:NO];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cambiaronPermisosDeCuenta) name:ACAccountStoreDidChangeNotification object:nil];
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

-(void) setCuentaPorDefecto:(NSInteger)_value{
    [[NSUserDefaults standardUserDefaults] setInteger:_value forKey:@"cuentaPorDefecto"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSInteger) cuentaPorDefecto{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"cuentaPorDefecto"];
}

-(NSString *)nombreCuenta{
    return [[self nombresDeCuentas] objectAtIndex:[self cuentaPorDefecto]];
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

    UIViewController * senderController = (UIViewController *)sender;
    [DejalBezelActivityView activityViewForView:senderController.view withLabel:@"conectando..."];
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
                [self setCuentaPorDefecto:0];
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
                    [actionSheet showFromTabBar:senderController.tabBarController.tabBar];
                    
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
    
    UIViewController * senderController = (UIViewController *)sender;
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
        [actionSheet showFromTabBar:senderController.tabBarController.tabBar];
        
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

- (void) cambiaronPermisosDeCuenta{
    if (![self tengoCuentas]) {
        [self setTwitterOn:NO];
    }
}

-(void) enviarTweet:(NSString *)_tweet ConImagen:(UIImage *)imagen YHandler:(void (^)(NSError *error))handler{
    int caracteresImg = 0;
    if (imagen) {
        caracteresImg = 23;
    }
    
    if (![self tengoCuentas]) {
        NSError *err = [[NSError alloc] initWithDomain:@"sin cuentas" code:1 userInfo:nil]; //tengo que decirle que no hay sesión
        handler(err);
        return;
    }
    
    if (_tweet.length + caracteresImg > 140) {
        NSError *err = [[NSError alloc] initWithDomain:@"Tweet muy largo" code:1 userInfo:nil]; //tengo que decirle que no hay sesión
        handler(err);
        return;
    }
    
    //ACAccount *twitterAccount = [cuentas objectAtIndex:0];
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    // Create an account type that ensures Twitter accounts are retrieved.
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
    ACAccount *twitterAccount = [accountsArray objectAtIndex:[self cuentaPorDefecto]];
    TWRequest *postRequest;
    
    NSData *imageData;
    if (imagen) {
        imageData = UIImageJPEGRepresentation(imagen, 0.f);
    }
    
    if (imageData) {
        postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://upload.twitter.com/1/statuses/update_with_media.json"] parameters:nil requestMethod:TWRequestMethodPOST];
        [postRequest addMultiPartData:imageData withName:@"media" type:@"image/jpeg"];
        [postRequest addMultiPartData:[_tweet dataUsingEncoding:NSUTF8StringEncoding] withName:@"status" type:@"text/plain"];
    }else{
        postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1/statuses/update.json"] parameters:[NSDictionary dictionaryWithObject:_tweet forKey:@"status"] requestMethod:TWRequestMethodPOST];
    }
    
    [postRequest setAccount:twitterAccount];
    
    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSDictionary *dict =
        (NSDictionary *)[NSJSONSerialization
                         JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"err code: %i", [urlResponse statusCode]);
        NSLog(@"dick: %@", dict);
    }];
}

#pragma mark - action sheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self setCuentaPorDefecto:buttonIndex];
    if ([delegate respondsToSelector:@selector(didSelectAccount)]) {
        [delegate didSelectAccount];
    }
}

@end
