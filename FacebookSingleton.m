//
//  FacebookSingleton.m
//  prototipoTabbed2
//
//  Created by Eduardo Alberti on 16-10-12.
//
//


/******************************************************************************
        Para accesar a los detalles de la cuenta con la interfaz nativa


 ACAccountStore *accountStore = [[ACAccountStore alloc] init];
 ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
 NSDictionary *options = @{
 @"ACFacebookAppIdKey" : @"155281724595577",
 @"ACFacebookPermissionsKey" : @[@"publish_actions"],
 @"ACFacebookAudienceKey" : ACFacebookAudienceEveryone}; // Needed only when write permissions are requested
 
 [accountStore requestAccessToAccountsWithType:accountType options:options completion:^(BOOL granted, NSError *error) {
 if (error) {
 NSLog(@"Error: %@",error);
 }
 if(granted) {
 NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
 NSLog(@"Cuentas de FB: %@",accountsArray);
 }else{
 NSLog(@"Sin acceso a la cuenta de FB");
 }
 }];

***************************************************************************/

#import "FacebookSingleton.h"
#import <Accounts/Accounts.h>

@implementation FacebookSingleton

+(FacebookSingleton *) sharedFacebookSession
{
    static FacebookSingleton *singleton = nil;
    @synchronized(self)
    {
        if (!singleton) {
            singleton = [[FacebookSingleton alloc] init];
        }
    }
    return singleton;
     
}

#pragma mark - Sigleton Methods
-(BOOL)isTokenLoaded
{
    if ([[FBSession activeSession] state] == FBSessionStateCreatedTokenLoaded) {
        return YES;
    }
    return NO;
}

-(BOOL)canUseNativeDialogs{
    return [FBNativeDialogs canPresentShareDialogWithSession:[FBSession activeSession]];
}

-(void)canAccessNativeAccountWithCompletitionHandler:(void (^)(BOOL granted, NSError *error))block{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    NSDictionary *options = @{
    @"ACFacebookAppIdKey" : @"355375187904342",
    @"ACFacebookPermissionsKey" : @[@"email"],
    @"ACFacebookAudienceKey" : ACFacebookAudienceEveryone}; // Needed only when write permissions are requested
    
    [accountStore requestAccessToAccountsWithType:accountType options:options completion:^(BOOL granted, NSError *error) {
        if (error) {
            if (block) {
                block(NO,error);
            }
        }else {
            if (block) {
                block(granted,nil);
            }
        }
    }];
}

-(void)openSessionWithCompletitionHandler:(CompletionHandler)block {
    //NSLog(@"FB session is open: %@",[[FBSession activeSession] isOpen]?@"YES":@"NO");
    
    //if (![[FBSession activeSession] isOpen]) {
        if (![self canUseNativeDialogs]) {
            if ([[FBSession activeSession] state] != FBSessionStateCreatedTokenLoaded) {
                [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                                   defaultAudience:FBSessionDefaultAudienceEveryone
                                                      allowLoginUI:YES completionHandler:^(FBSession *session,
                                                                                           FBSessionState status,
                                                                                           NSError *error) {
                                                          //NSLog(@"FB session is open: %@",[[FBSession activeSession] isOpen]?@"YES":@"NO");
                                                          /*
                                                           switch ([[FBSession activeSession] state]) {
                                                           case FBSessionStateCreated:
                                                           NSLog(@"Facebook session state: FBSessionStateCreated");
                                                           break;
                                                           case FBSessionStateCreatedTokenLoaded:
                                                           NSLog(@"Facebook session state: FBSessionStateCreatedTokenLoaded");
                                                           break;
                                                           case FBSessionStateCreatedOpening:
                                                           NSLog(@"Facebook session state: FBSessionStateCreatedOpening");
                                                           break;
                                                           case FBSessionStateOpen:
                                                           NSLog(@"Facebook session state: FBSessionStateOpen");
                                                           break;
                                                           case FBSessionStateOpenTokenExtended:
                                                           NSLog(@"Facebook session state: FBSessionStateOpenTokenExtended");
                                                           break;
                                                           case FBSessionStateClosedLoginFailed:
                                                           NSLog(@"Facebook session state: FBSessionStateClosedLoginFailed");
                                                           break;
                                                           case FBSessionStateClosed:
                                                           NSLog(@"Facebook session state: FBSessionStateClosed");
                                                           break;
                                                           default:
                                                           NSLog(@"Facebook session state: not of one of the open or openable types.");
                                                           break;
                                                           }
                                                           */
                                                          
                                                          if(!error){
                                                              if (block) {
                                                                  block(nil);
                                                                  
                                                              }
                                                          }else{
                                                              if (block) {
                                                                  block(error);
                                                                  
                                                              }
                                                          }
                                                      }];
            }else{
                //Se abre una session cuando la app ya ha sido autorizada (no vuelve a pedir autorización)
                [FBSession openActiveSessionWithReadPermissions:nil
                                                   allowLoginUI:NO
                                              completionHandler:^(FBSession *theSession,
                                                                  FBSessionState _status,
                                                                  NSError *error) {
                                                  //NSLog(@"FB session is open: %@",[[FBSession activeSession] isOpen]?@"YES":@"NO");
                                                  if(!error){
                                                      if (block) {
                                                          block(nil);
                                                          
                                                      }
                                                  }else{
                                                      if (block) {
                                                          block(error);
                                                          
                                                      }
                                                  }
                                              }];
            }
        }else{
            [self openSessionWithNativeUICompletitionHandler:block];
        }
    //}else{
      //  if (block) {
        //    block(nil);
            
        //}
    //}
    
    
    /*
     if (!self.session) {
     self.session = [FBSession activeSession];
     }
     
     if (self.session.state == FBSessionStateCreated || self.session.state == FBSessionStateClosed || self.session.state == FBSessionStateClosedLoginFailed) {
     //Se abre la nueva session, primera vez tiene que ser solo con permisos para lectura
     //Para postear se debe pedir una reautorización con mayores permisos
     [FBSession openActiveSessionWithReadPermissions:[NSArray arrayWithObjects:@"email",nil]
     allowLoginUI:YES
     completionHandler:^(FBSession *theSession,
     FBSessionState _status,
     NSError *error) {
     self.session = theSession;
     [self refreshStateSession:theSession state:_status error:error];
     }];
     
     }else if (self.session.state == FBSessionStateCreatedTokenLoaded){
     //Se abre una session cuando la app ya ha sido autorizada (no vuelve a pedir autorización)
     [FBSession openActiveSessionWithReadPermissions:nil
     allowLoginUI:YES
     completionHandler:^(FBSession *theSession,
     FBSessionState _status,
     NSError *error) {
     self.session = theSession;
     [self refreshStateSession:theSession state:_status error:error];
     }];
     }
     */
}


-(void)openSessionWithNativeUICompletitionHandler:(CompletionHandler)block
{    
    if ([[FBSession activeSession] state] != FBSessionStateCreatedTokenLoaded) {
        [FBSession openActiveSessionWithReadPermissions:[NSArray arrayWithObject:@"email"]
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                          if ([[FBSession activeSession] state] != FBSessionStateOpenTokenExtended) {
                                              if(!error){
                                                  if (block) {
                                                      block(nil);
                                                  }
                                              }else{
                                                  if (block) {
                                                      block(error);
                                                  }
                                              }
                                          }
                                      }];
    }else{
        //Se abre una session cuando la app ya ha sido autorizada (no vuelve a pedir autorización)
        [FBSession openActiveSessionWithReadPermissions:nil
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *theSession,
                                                          FBSessionState _status,
                                                          NSError *error) {
                                          //NSLog(@"FB session is open: %@",[[FBSession activeSession] isOpen]?@"YES":@"NO");
                                          if ([[FBSession activeSession] state] != FBSessionStateOpenTokenExtended) {
                                              if(!error){
                                                  if (block) {
                                                      block(nil);
                                                  }
                                              }else{
                                                  if (block) {
                                                      block(error);
                                                  }
                                              }
                                          }
                                      }];
    }
}

-(void)closeSession{
    [[FBSession activeSession] closeAndClearTokenInformation];
}

-(void)getUserDetailsWithCompletitionHandler:(void (^)(id userJSON, NSError *error))block {
    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(!error){
            if (block) {
                block(result,nil);
            }
        }else{
            if (block) {
                block(nil,error);
            }
        }
    }];
}

-(BOOL)havePermissionForPublish{
    return ([[[FBSession activeSession] permissions] indexOfObject:@"publish_actions"] == NSNotFound)?NO:YES;
}

-(void)authorizeForPublishActionsWithCompletitionHandler:(CompletionHandler)block
{
    
    [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                               defaultAudience:FBSessionDefaultAudienceEveryone
                                             completionHandler:^(FBSession *theSession,
                                                                 NSError *error) {
                                                 if(!error){
                                                     if (block) {
                                                         block(nil);
                                                     }
                                                 }else{
                                                     if (block) {
                                                         block(error);
                                                         
                                                     }
                                                 }
                                             }];
}


-(void)publishStoryOnWallWithParams:(NSMutableDictionary *)params
             AndCompletitionHandler:(CompletionHandler)block
{
    
    [FBRequestConnection
     startWithGraphPath:@"me/feed"
     parameters:params
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         /*
          if (error && attemps>0) {
          [self publishStoryOnWallWithParams:params attemps:attemps];
          }
          */
         //[self publishResut:result error:error];
         if(!error){
             if (block) {
                 block(nil);
                 
             }
         }else{
             if (block) {
                 block(error);
                 
             }
         }
     }];
}

-(void)publishStoryOnWallWithParams:(NSMutableDictionary *)params
                         AndAttemps:(int)attemps
             AndCompletitionHandler:(CompletionHandler)block
{
    
    if (attemps>0) {
        NSLog(@"Intento de publicar");
        attemps--;
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
                 [self publishStoryOnWallWithParams:params AndAttemps:attemps AndCompletitionHandler:block];
             }else{
                 if (block) {
                     block(error);
                     
                 }
             }
         }];
    }
}


/*
 #pragma mark - Delegate Methods
 
 -(void)refreshStateSession:(FBSession *)theSession state:(FBSessionState)state error:(NSError *)error
 {
 switch ([[FBSession activeSession] state]) {
 case FBSessionStateCreated:
 NSLog(@"Facebook session state: FBSessionStateCreated");
 break;
 case FBSessionStateCreatedTokenLoaded:
 NSLog(@"Facebook session state: FBSessionStateCreatedTokenLoaded");
 break;
 case FBSessionStateCreatedOpening:
 NSLog(@"Facebook session state: FBSessionStateCreatedOpening");
 break;
 case FBSessionStateOpen:
 NSLog(@"Facebook session state: FBSessionStateOpen");
 break;
 case FBSessionStateOpenTokenExtended:
 NSLog(@"Facebook session state: FBSessionStateOpenTokenExtended");
 break;
 case FBSessionStateClosedLoginFailed:
 NSLog(@"Facebook session state: FBSessionStateClosedLoginFailed");
 break;
 case FBSessionStateClosed:
 NSLog(@"Facebook session state: FBSessionStateClosed");
 break;
 default:
 NSLog(@"Facebook session state: not of one of the open or openable types.");
 break;
 }
 
 switch (state) {
 case FBSessionStateCreated:
 NSLog(@"Facebook session state: FBSessionStateCreated");
 break;
 case FBSessionStateCreatedTokenLoaded:
 NSLog(@"Facebook session state: FBSessionStateCreatedTokenLoaded");
 break;
 case FBSessionStateCreatedOpening:
 NSLog(@"Facebook session state: FBSessionStateCreatedOpening");
 break;
 case FBSessionStateOpen:
 NSLog(@"Facebook session state: FBSessionStateOpen");
 break;
 case FBSessionStateOpenTokenExtended:
 NSLog(@"Facebook session state: FBSessionStateOpenTokenExtended");
 break;
 case FBSessionStateClosedLoginFailed:
 NSLog(@"Facebook session state: FBSessionStateClosedLoginFailed");
 break;
 case FBSessionStateClosed:
 NSLog(@"Facebook session state: FBSessionStateClosed");
 break;
 default:
 NSLog(@"Facebook session state: not of one of the open or openable types.");
 break;
 }
 }
 
 -(void)openWithExtendedToken:(FBSession *)theSession error:(NSError *)error
 {
 if ([_delegate conformsToProtocol:@protocol(FacebookSingletonDelegate)] && [_delegate respondsToSelector:@selector(FacebookSingleton:permissionsExtendedWithError:)]) {
 [_delegate FacebookSingleton:self permissionsExtendedWithError:error];
 }
 }
 
 -(void)publishResut:(id)result error:(NSError *)error{
 if ([_delegate conformsToProtocol:@protocol(FacebookSingletonDelegate)] && [_delegate respondsToSelector:@selector(FacebookSingleton:didPublishWithResult:error:)]) {
 [_delegate FacebookSingleton:self didPublishWithResult:result error:error];
 }
 }
 
 -(void)userDetailResultsWithConnection:(FBRequestConnection *)connection User:(NSDictionary<FBGraphUser> *)user Error:(NSError *)error
 {
 if ([_delegate conformsToProtocol:@protocol(FacebookSingletonDelegate)] && [_delegate respondsToSelector:@selector(FacebookSingleton:requestForUserDatailsDidEndWithUser:andError:)]) {
 [_delegate FacebookSingleton:self requestForUserDatailsDidEndWithUser:user andError:error];
 }
 }
 */
@end
