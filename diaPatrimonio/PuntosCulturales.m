//
//  PuntosCulturales.m
//  diaPatrimonio
//
//  Created by Matias Castro on 22-02-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "PuntosCulturales.h"

@implementation PuntosCulturales
@synthesize puntosCulturales;

+ (PuntosCulturales *)instance {
    static PuntosCulturales *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[PuntosCulturales alloc] init];
    });
    
    return _sharedClient;
}

-(void) requestPuntosCulturalesCercanosWithSuccess:(void (^)(NSArray *puntosCulturales))success AndFail:(void (^)(NSError *error))fail{
    
    [[APIClient instance] requestPuntosCulturalesCercanosWithSuccess:^(id results) {
        
        NSArray *JSONPuntosCulturales = (NSArray *)results;
        NSMutableArray *arregloPuntosCulturales = [[NSMutableArray alloc] init];
        
        for (NSDictionary *punto in JSONPuntosCulturales) {
            PuntoCultural *puntoCultural = [[PuntoCultural alloc] initWithIDPunto:[NSNumber numberWithInt:[[punto objectForKey:@"id"] intValue]]
                                                                        AndNombre:[[punto objectForKey:@"d"] objectForKey:@"n"]
                                                                      AndLatitud:[NSNumber numberWithDouble:[[punto objectForKey:@"lat"] doubleValue]]
                                                                     AndLongitud:[NSNumber numberWithDouble:[[punto objectForKey:@"lon"] doubleValue]]];
            [arregloPuntosCulturales addObject:puntoCultural];
        }
        
        puntosCulturales = [NSArray arrayWithArray:arregloPuntosCulturales];
        
        if (success) {
            success(puntosCulturales);
        }
    } AndFail:^(NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}


-(void) requestPuntosCulturalesEntre:(CLLocationCoordinate2D)puntoNO
                                   Y:(CLLocationCoordinate2D)puntoSE
                         WithSuccess:(void (^)(NSArray *puntosCulturales))success AndFail:(void (^)(NSError *error))fail{
    
    [[APIClient instance] requestPuntosCulturalesEntre:puntoNO Y:puntoSE WithSuccess:^(id results) {
        NSArray *JSONPuntosCulturales = (NSArray *)results;
        NSMutableArray *arregloPuntosCulturales = [[NSMutableArray alloc] init];
        
        for (NSDictionary *punto in JSONPuntosCulturales) {
            PuntoCultural *puntoCultural = [[PuntoCultural alloc] initWithIDPunto:[NSNumber numberWithInt:[[punto objectForKey:@"id"] intValue]]
                                                                        AndNombre:[[punto objectForKey:@"d"] objectForKey:@"n"]
                                                                       AndLatitud:[NSNumber numberWithDouble:[[punto objectForKey:@"lat"] doubleValue]]
                                                                      AndLongitud:[NSNumber numberWithDouble:[[punto objectForKey:@"lon"] doubleValue]]];
            [arregloPuntosCulturales addObject:puntoCultural];
        }
        
        puntosCulturales = [NSArray arrayWithArray:arregloPuntosCulturales];
        
        if (success) {
            success(puntosCulturales);
        }
    } AndFail:^(NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
        
}

-(PuntoCultural *) requestPuntoConID:(NSNumber *)_id_punto{
    
    for (PuntoCultural *punto in puntosCulturales) {
        if ([punto.id_punto intValue] == [_id_punto intValue]) {
            return punto;
        }
    }
    
    return nil;
}

@end
