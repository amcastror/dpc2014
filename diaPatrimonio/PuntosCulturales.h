//
//  PuntosCulturales.h
//  diaPatrimonio
//
//  Created by Matias Castro on 22-02-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIClient.h"
#import "PuntoCultural.h"

@interface PuntosCulturales : NSObject{
    
}

@property (nonatomic,readonly) NSArray *puntosCulturales;

+ (PuntosCulturales *)instance;

-(void) requestPuntosCulturalesWithSuccess:(void (^)(NSArray *puntosCulturales))success AndFail:(void (^)(NSError *error))fail;

@end
