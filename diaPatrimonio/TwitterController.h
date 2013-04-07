//
//  TwitterController.h
//  DiaDelPatrimonio
//
//  Created by Matias Castro on 05-04-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterController : NSObject <UIActionSheetDelegate>{
    
}

//@property (nonatomic, readonly) BOOL twitterOn;

+(TwitterController *) instance;

-(BOOL) canSendTweet;
-(void) imprimeCuentas;
-(void) conectarseALasCuentasDelUsuarioWithSender:(id)sender AndHandler:(void (^)(NSError *error))handler;
-(void) cambiarCuentaPorDefectoWithSender:(id)sender;
-(BOOL) tengoCuentas;
-(BOOL) twitterOn;
-(int) cantidadDeCuentas;
-(NSArray *) nombresDeCuentas;
-(void) logout;
-(void) loginWithSender:(id)sender AndHandler:(void (^)(NSError *error))handler;
-(void) enviarTweetWith:(void (^)(NSError *error))handler;

@end
