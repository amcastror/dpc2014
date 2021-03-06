//
//  FacebookController.m
//  diaPatrimonio
//
//  Created by Matias Castro on 05-03-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "FacebookController.h"

@implementation FacebookController

@synthesize nombre_usuario;

+(FacebookController *) instance
{
    static FacebookController *singleton = nil;
    @synchronized(self)
    {
        if (!singleton) {
            singleton = [[FacebookController alloc] init];
        }
    }
    return singleton;
    
}

-(BOOL) handleOpenUrl:(NSURL *)url{
    return [FBSession.activeSession handleOpenURL:url];
}

-(void) handleDidBecomeActive{
    [FBSession.activeSession handleDidBecomeActive];
}

-(BOOL) tengoSession{
    if (FBSession.activeSession.isOpen) {
        return YES;
    }
    return NO;
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
{
    switch (FBSession.activeSession.state) {
        case FBSessionStateOpen:
            break;
        case FBSessionStateClosed:
            break;
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        case FBSessionStateCreatedTokenLoaded:
            break;
        case FBSessionStateOpenTokenExtended:
            break;
        case FBSessionStateCreated:
            break;
        default:
            break;
    }  
}

- (void)openSessionWithUI:(BOOL)withUI AndHandler:(void (^)(NSError *error))handler
{
    [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                       defaultAudience:FBSessionDefaultAudienceEveryone
                                          allowLoginUI:withUI
                                     completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                         [self sessionStateChanged:session state:status];
                                         [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                             if ([(NSDictionary *)result objectForKey:@"name"]) {
                                                 nombre_usuario = [(NSDictionary *)result objectForKey:@"name"];
                                             }
                                             if (handler) {
                                                 handler(error);
                                             }
                                         }];
    }];
}

-(void) trataDeAbrirSesionWithUI:(BOOL) withUI AndHandler:(void (^)(NSError *error))handler{
    switch (FBSession.activeSession.state) {
        case FBSessionStateOpen:
            if (handler) {
                handler(nil);
            }
            break;
        case FBSessionStateClosed:
            [self openSessionWithUI:withUI AndHandler:handler];
            break;
        case FBSessionStateClosedLoginFailed:
            [self openSessionWithUI:withUI AndHandler:handler];
            /*
             if (handler) {
                NSError *err;
                handler(err);
            }
             */
            break;
        case FBSessionStateCreatedTokenLoaded:
            [self openSessionWithUI:withUI AndHandler:handler];
            break;
        case FBSessionStateOpenTokenExtended:
            if (handler) {
                handler(nil);
            }
            break;
        case FBSessionStateCreated:
            [self openSessionWithUI:withUI AndHandler:handler];
            break;
        default:
            break;
    }
}

-(void) logout{
    [FBSession.activeSession closeAndClearTokenInformation];
}

-(void)publishStoryOnWallWithParams:(NSDictionary *)_params
                           AndImage:(UIImage *)image
                         AndAttemps:(int)attemps
             AndCompletitionHandler:(CompletionHandler)block{
    
    if ([self tengoSession]) {
        
        NSData *imageData;
        NSString *accion = @"me/feed";
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:_params];
        if (image) {
            imageData = UIImageJPEGRepresentation(image, 0.f);
            accion = @"me/photos";
            if (![params objectForKey:@"data"]) {
                [params setObject:imageData forKey:@"data"];
            }
        }
        
        if (attemps>0) {
            NSLog(@"Intento de publicar");
            int newAttempts = attemps - 1;
            [FBRequestConnection
             startWithGraphPath:accion
             parameters:[NSDictionary dictionaryWithDictionary:params]
             HTTPMethod:@"POST"
             completionHandler:^(FBRequestConnection *connection,
                                 id result,
                                 NSError *error) {
                 if(!error){
                     if (block) {
                         block(nil);
                         
                     }
                 }else if (attemps>0){
                     [self publishStoryOnWallWithParams:[NSDictionary dictionaryWithDictionary:params] AndImage:image AndAttemps:newAttempts AndCompletitionHandler:block];
                 }else{
                     if (block) {
                         block(error);
                         
                     }
                 }
             }];
        }
    }else{
        if (block) {
            NSError *err = [[NSError alloc] initWithDomain:@"sin sesion" code:1 userInfo:nil]; //tengo que decirle que no hay sesión
            block(err);
        }
    }
}

@end
