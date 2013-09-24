//
//  PuntosCulturales.m
//  diaPatrimonio
//
//  Created by Matias Castro on 22-02-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "PuntosCulturales.h"
#import "Filtros.h"

@implementation PuntosCulturales

@synthesize puntosCulturales, recienDescargados;

+ (PuntosCulturales *)instance {
    static PuntosCulturales *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[PuntosCulturales alloc] init];
    });
    
    return _sharedClient;
}

-(id) init{
    if (self = [super init]) {
        recienDescargados = NO;
    }
    return self;
}

-(void) requestPuntosCulturalesCercanosWithSuccess:(void (^)(NSArray *puntosCulturales))success AndFail:(void (^)(NSError *error))fail{
    
    [[APIClient instance] requestPuntosCulturalesCercanosWithSuccess:^(id results) {
        
        NSArray *JSONPuntosCulturales = (NSArray *)results;
        puntosCulturales = [self guardaPuntosCulturalesDesdeArray:JSONPuntosCulturales];
        recienDescargados = YES;
        
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
        
        puntosCulturales = [self guardaPuntosCulturalesDesdeArray:(NSArray *)results];
        recienDescargados = YES;
        
        if (success) {
            success(puntosCulturales);
        }
    } AndFail:^(NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
        
}

-(void)buscarPuntosCulturalesConFiltrosActivosWithSuccess:(void (^)())success AndFail:(void (^)(NSError *error))fail{
    
    [[APIClient instance] requestBuscarConZonaID:[[[Filtros instance] zona_seleccionada] id_zona]
                                      YSubZonaID:[[[Filtros instance] sub_zona_seleccionada] id_zona]
                                    YCategoriaID:[[Filtros instance] categoria_seleccionada]
                                          YTexto:[[Filtros instance] texto_ingresado]
                                     WithSuccess:^(NSArray *results) {
                                         puntosCulturales = [self guardaPuntosCulturalesDesdeArray:(NSArray *)results];
                                         recienDescargados = YES;
                                         if (success) {
                                             success();
                                         }
                                     }
                                     AndFail:^(NSError *error) {
                                         if (fail) {
                                             fail(error);
                                         }
                                     }];
}

-(NSArray *) guardaPuntosCulturalesDesdeArray:(NSArray *)arregloPuntos{
    
    NSMutableArray *arregloPuntosCulturales = [[NSMutableArray alloc] init];
    
    for (NSDictionary *punto in arregloPuntos) {
        if ([[punto objectForKey:@"lat"] class] != [NSNull class] && [[punto objectForKey:@"lon"] class] != [NSNull class]&& [[punto objectForKey:@"n"] class] != [NSNull class]) {
            
            PuntoCultural *puntoCultural = [[PuntoCultural alloc] initWithIDPunto:[NSNumber numberWithInt:[[punto objectForKey:@"id"] intValue]]
                                                                        AndNombre:[punto objectForKey:@"n"]
                                                                       AndLatitud:[NSNumber numberWithDouble:[[punto objectForKey:@"lat"] doubleValue]]
                                                                      AndLongitud:[NSNumber numberWithDouble:[[punto objectForKey:@"lon"] doubleValue]]
                                                                          AndZona:nil
                                                                       AndSubZona:nil AndIdTipo:[NSNumber numberWithInt:[[punto objectForKey:@"tipo"] intValue]]
                                                                      AndVisitado:NO];
            [arregloPuntosCulturales addObject:puntoCultural];
        }
    }
    
    return [NSArray arrayWithArray:arregloPuntosCulturales];
    
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
