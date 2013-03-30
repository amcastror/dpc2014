//
//  MisPuntosCulturales.h
//  diaPatrimonio
//
//  Created by Matias Castro on 10-03-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PuntoCultural.h"

@interface MisPuntosCulturales : NSObject{
    
}

@property (nonatomic,readonly) NSArray *misPuntosCulturales;

+ (MisPuntosCulturales *)instance;

-(void) requestMisPuntosCulturalesWithSuccess:(void (^)())success AndFail:(void (^)(NSError *error))fail;
-(void) agregarPuntoCultural:(PuntoCultural *)miNuevoPunto AMisPuntosWithSuccess:(void (^)())success
                     AndFail:(void (^)(NSError *error))fail;
-(void) eliminarPuntoCultural:(PuntoCultural *)miViejoPunto DeMisPuntosWithSuccess:(void (^)())success
                      AndFail:(void (^)(NSError *error))fail;
@end
