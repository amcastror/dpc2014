//
//  FacebookSingleton.h
//  prototipoTabbed2
//
//  Created by Eduardo Alberti on 16-10-12.
//
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

typedef void (^CompletionHandler)(NSError *error);

@interface FacebookSingleton : NSObject

+(FacebookSingleton *)sharedFacebookSession;
-(BOOL)isTokenLoaded;
-(BOOL)canUseNativeDialogs;
-(void)canAccessNativeAccountWithCompletitionHandler:(void (^)(BOOL granted, NSError *error))block;
-(void)openSessionWithCompletitionHandler:(CompletionHandler)block;
-(void)closeSession;
-(void)getUserDetailsWithCompletitionHandler:(void (^)(id userJSON, NSError *error))block;
-(BOOL)havePermissionForPublish;
-(void)authorizeForPublishActionsWithCompletitionHandler:(CompletionHandler)block;
-(void)publishStoryOnWallWithParams:(NSMutableDictionary *)params
             AndCompletitionHandler:(CompletionHandler)block;
-(void)publishStoryOnWallWithParams:(NSMutableDictionary *)params
                         AndAttemps:(int)attemps
             AndCompletitionHandler:(CompletionHandler)block;
@end
