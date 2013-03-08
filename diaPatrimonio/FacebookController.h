//
//  FacebookController.h
//  diaPatrimonio
//
//  Created by Matias Castro on 05-03-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

typedef void (^CompletionHandler)(NSError *error);

@interface FacebookController : NSObject

+(FacebookController *) instance;

-(BOOL) handleOpenUrl:(NSURL *)url;
-(BOOL) tengoSession;
-(void) logout;

-(void) trataDeAbrirSesionWithUI:(BOOL) withUI AndHandler:(void (^)(NSError *error))handler;
-(void) publishStoryOnWallWithParams:(NSMutableDictionary *)params
                         AndAttemps:(int)attemps
             AndCompletitionHandler:(CompletionHandler)block;
@end
