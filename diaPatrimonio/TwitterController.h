//
//  TwitterController.h
//  DiaDelPatrimonio
//
//  Created by Matias Castro on 05-04-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterController : NSObject{
    
}

+(TwitterController *) instance;

-(BOOL) canSendTweet;
-(void) imprimeCuentas;
-(void) conectarseALasCuentasDelUsuarioWith:(void (^)(NSError *error))handler;
-(BOOL) tengoCuentas;
-(void) logout;
-(void) enviarTweetWith:(void (^)(NSError *error))handler;

@end
