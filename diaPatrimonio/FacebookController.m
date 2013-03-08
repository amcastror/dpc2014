//
//  FacebookController.m
//  diaPatrimonio
//
//  Created by Matias Castro on 05-03-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "FacebookController.h"

@implementation FacebookController

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
                                         if (handler) {
                                             handler(error);
                                         }
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
            if (handler) {
                NSError *err;
                handler(err);
            }
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

-(void)publishStoryOnWallWithParams:(NSMutableDictionary *)params
                         AndAttemps:(int)attemps
             AndCompletitionHandler:(CompletionHandler)block{
    
    if ([self tengoSession]) {
        if (attemps>0) {
            NSLog(@"Intento de publicar");
            int newAttempts = attemps - 1;
            [FBRequestConnection
             startWithGraphPath:@"me/feed"
             parameters:params
             HTTPMethod:@"POST"
             completionHandler:^(FBRequestConnection *connection,
                                 id result,
                                 NSError *error) {
                 if(!error){
                     if (block) {
                         block(nil);
                         
                     }
                 }else if (attemps>0){
                     [self publishStoryOnWallWithParams:params AndAttemps:newAttempts AndCompletitionHandler:block];
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
