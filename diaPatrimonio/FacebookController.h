//
//  FacebookController.h
//  diaPatrimonio
//
//  Created by Matias Castro on 05-03-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookController : NSObject

+(FacebookController *) instance;

-(BOOL) handleOpenUrl:(NSURL *)url;
-(BOOL) isTokenLoaded;
-(void) openSession;
-(void) logout;
@end
