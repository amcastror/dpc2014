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
    BOOL recienDescargados;
}

@property (nonatomic, readonly) NSArray *puntosCulturales;
@property (nonatomic, readwrite) BOOL recienDescargados;

+ (PuntosCulturales *)instance;

-(void) requestPuntosCulturalesCercanosWithSuccess:(void (^)(NSArray *puntosCulturales))success
                                   AndFail:(void (^)(NSError *error))fail;

-(void) requestPuntosCulturalesEntre:(CLLocationCoordinate2D)puntoNO
                                   Y:(CLLocationCoordinate2D)puntoSE
                         WithSuccess:(void (^)(NSArray *puntosCulturales))success AndFail:(void (^)(NSError *error))fail;
-(void)buscarPuntosCulturalesConFiltrosActivosWithSuccess:(void (^)())success AndFail:(void (^)(NSError *error))fail;
-(PuntoCultural *) requestPuntoConID:(NSNumber *)_id_punto;
@end
