//
//  TwitterController.h
//  DiaDelPatrimonio
//
//  Created by Matias Castro on 05-04-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol twitter <NSObject>
-(void)didSelectAccount;
@end

@interface TwitterController : NSObject <UIActionSheetDelegate>{
    
}

@property id <twitter> delegate;

+(TwitterController *) instance;

-(BOOL) canSendTweet;
-(NSString *)nombreCuenta;
-(void) cambiarCuentaPorDefectoWithSender:(id)sender;
-(BOOL) tengoCuentas;
-(BOOL) twitterOn;
-(int) cantidadDeCuentas;
-(void) logout;
-(void) loginWithSender:(id)sender AndHandler:(void (^)(NSError *error))handler;
-(void) enviarTweet:(NSString *)_tweet ConImagen:(UIImage *)imagen YHandler:(void (^)(NSError *error))handler;

@end
