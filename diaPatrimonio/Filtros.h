//
//  Filtros.h
//  DiaDelPatrimonio
//
//  Created by Matias Castro on 30-03-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIClient.h"
#import "Zona.h"

@interface Filtros : NSObject{
    
}

@property (nonatomic, readonly) BOOL *activos;
@property (nonatomic, readonly) NSArray *zonas;
@property (nonatomic, readonly) NSArray *categorias;
@property (nonatomic, readwrite) Zona *zona_seleccionada;
@property (nonatomic, readwrite) Zona *sub_zona_seleccionada;
@property (nonatomic, readwrite) NSString *texto_ingresado;
@property (nonatomic, readwrite) NSNumber *categoria_seleccionada;

+ (Filtros *)instance;
- (void) limpiarFiltros;
- (NSString *)nombreZonaConIDSubZona:(NSNumber *)id_sub_zona;
- (NSString *)nombreSubZonaConIDSubZona:(NSNumber *)id_sub_zona;

@end
