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

@interface FacebookController : NSObject{
    NSString *nombre_usuario;
}

@property (nonatomic, readonly) NSString *nombre_usuario;

+(FacebookController *) instance;

-(BOOL) handleOpenUrl:(NSURL *)url;
-(void) handleDidBecomeActive;
-(BOOL) tengoSession;
-(void) logout;

-(void) trataDeAbrirSesionWithUI:(BOOL) withUI AndHandler:(void (^)(NSError *error))handler;
-(void)publishStoryOnWallWithParams:(NSDictionary *)_params
                           AndImage:(UIImage *)image
                         AndAttemps:(int)attemps
             AndCompletitionHandler:(CompletionHandler)block;
@end
