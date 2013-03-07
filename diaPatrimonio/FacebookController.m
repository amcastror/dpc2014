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

-(BOOL) isTokenLoaded{
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        return YES;
    } else {
        // No, display the login page.
        return NO;
    }
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            NSLog(@"FBSessionStateOpen");
        }
            break;
        case FBSessionStateClosed:
            NSLog(@"FBSessionStateClosed");
            break;
        case FBSessionStateClosedLoginFailed:{
            NSLog(@"FBSessionStateClosedLoginFailed");
            [FBSession.activeSession closeAndClearTokenInformation];
            //[self showLoginView];
        }
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }    
}

- (void)openSession
{
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
}

-(void) logout{
    [FBSession.activeSession closeAndClearTokenInformation];
}

@end
