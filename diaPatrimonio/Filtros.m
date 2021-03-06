//
//  Filtros.m
//  DiaDelPatrimonio
//
//  Created by Matias Castro on 30-03-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "Filtros.h"

@implementation Filtros

@synthesize activos, zonas, zona_seleccionada, sub_zona_seleccionada, texto_ingresado, categorias, categoria_seleccionada;

+ (Filtros *)instance {
    static Filtros *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[Filtros alloc] init];
        
    });
    
    return _sharedClient;
}

- (id) init{
    if (self = [super init]) {
        [[APIClient instance] requestZonasYSubZonasWithSuccess:^(NSDictionary *results) {
            [self cargaZonas:results];
            [[APIClient instance] requestCategoriasWithSuccess:^(NSArray *results) {
                categorias = results;
            } AndFail:^(NSError *error) {
                //
            }];
        } AndFail:^(NSError *error) {
            //
        }];
    }
    return self;
}

- (void) cargaZonas:(NSDictionary *)_zonas{
    NSMutableArray *zonas_tmp = [[NSMutableArray alloc] init];
    
    for (NSDictionary *zona in _zonas) {
        Zona *zona_actual = [[Zona alloc] initWithId:[zona objectForKey:@"id"]
                                           AndNombre:[zona objectForKey:@"n"]];
        if ([zona objectForKey:@"subzonas"]) {
            for (NSDictionary *sub_zona in [zona objectForKey:@"subzonas"]) {
                Zona *sub_zona_actual = [[Zona alloc] initWithId:[sub_zona objectForKey:@"id"]
                                                       AndNombre:[sub_zona objectForKey:@"n"]];
                [zona_actual agregarSubZona:sub_zona_actual];
            }
        }
        [zonas_tmp addObject:zona_actual];
    }
    
    zonas = [NSArray arrayWithArray:zonas_tmp];
}

- (void) limpiarFiltros{
    zona_seleccionada = nil;
    sub_zona_seleccionada = nil;
    texto_ingresado = nil;
    categoria_seleccionada = nil;
}

#pragma mark - nombres

- (NSString *)nombreZonaConIDSubZona:(NSNumber *)id_sub_zona{
    
    for (Zona *zona in zonas) {
        for (Zona *sub_zona in [zona sub_zonas]) {
            if (sub_zona.id_zona.intValue == id_sub_zona.intValue) {
                return zona.nombre;
            }
        }
    }
    return nil;
}

- (NSString *)nombreSubZonaConIDSubZona:(NSNumber *)id_sub_zona{
    
    for (Zona *zona in zonas) {
        for (Zona *sub_zona in [zona sub_zonas]) {
            if (sub_zona.id_zona.intValue == id_sub_zona.intValue) {
                return sub_zona.nombre;
            }
        }
    }
    return nil;
}

@end
