//
//  MisPuntosCulturales.m
//  diaPatrimonio
//
//  Created by Matias Castro on 10-03-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "MisPuntosCulturales.h"
#import "APIClient.h"

@implementation MisPuntosCulturales

@synthesize misPuntosCulturales;

+ (MisPuntosCulturales *)instance {
    static MisPuntosCulturales *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[MisPuntosCulturales alloc] init];
        
    });
    
    return _sharedClient;
}

-(void) requestMisPuntosCulturalesWithSuccess:(void (^)())success AndFail:(void (^)(NSError *error))fail{
    
    
     [[APIClient instance] requestMisPuntosCulturalesWithSuccess:^(NSArray *puntos){
         NSMutableArray *puntos_tmp = [[NSMutableArray alloc] init];
        //Tengo que inicializar cada punto...
         for (NSDictionary *punto in puntos) {
             if ([[punto objectForKey:@"lat"] class] != [NSNull class] && [[punto objectForKey:@"lon"] class] != [NSNull class]&& [[punto objectForKey:@"n"] class] != [NSNull class]) {
                 
                 PuntoCultural *miPunto = [[PuntoCultural alloc] initWithIDPunto:[punto objectForKey:@"id"]
                                                                       AndNombre:[punto objectForKey:@"n"]
                                                                      AndLatitud:[NSNumber numberWithDouble:[[punto objectForKey:@"lat"] doubleValue]]
                                                                     AndLongitud:[NSNumber numberWithDouble:[[punto objectForKey:@"lon"] doubleValue]]
                                                                         AndZona:nil
                                                                      AndSubZona:nil AndIdTipo:[NSNumber numberWithInt:[[punto objectForKey:@"tipo"] intValue]] AndVisitado:[[punto objectForKey:@"visitado"] boolValue]];
                 [puntos_tmp addObject:miPunto];
             }
         }
         misPuntosCulturales = nil;
         misPuntosCulturales = [NSArray arrayWithArray:puntos_tmp];
    } AndFail:^(NSError *error) {
        //
    }];
}

#pragma mark - acciones mis puntos culturales

-(void) agregarPuntoCultural:(PuntoCultural *)miNuevoPunto AMisPuntosWithSuccess:(void (^)())success
                             AndFail:(void (^)(NSError *error))fail{
    [[APIClient instance] requestAgregarPuntoId:miNuevoPunto.id_punto AMisPuntosWithSuccess:^{
        NSMutableArray *misPuntos_tmp = [NSMutableArray arrayWithArray:misPuntosCulturales];
        [misPuntos_tmp addObject:miNuevoPunto];
        misPuntosCulturales = [NSArray arrayWithArray:misPuntos_tmp];
        if (success) {
            success();
        }
    } AndFail:^(NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

-(void) eliminarPuntoCultural:(PuntoCultural *)miViejoPunto DeMisPuntosWithSuccess:(void (^)())success
                               AndFail:(void (^)(NSError *error))fail{
    
    [[APIClient instance] requestEliminarPuntoId:miViejoPunto.id_punto DeMisPuntosWithSuccess:^{
        NSMutableArray *misPuntos_tmp = [NSMutableArray arrayWithArray:misPuntosCulturales];
        [misPuntos_tmp removeObject:miViejoPunto];
        misPuntosCulturales = [NSArray arrayWithArray:misPuntos_tmp];
        if (success) {
            success();
        }
    } AndFail:^(NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

-(PuntoCultural *) puntoCulturalConID:(NSNumber *)id_punto{
    
    for (PuntoCultural *punto in misPuntosCulturales) {
        if (punto.id_punto.intValue == id_punto.intValue) {
            return punto;
        }
    }
    
    return nil;
}

@end
