//
//  PuntoCultural.m
//  diaPatrimonio
//
//  Created by Matias Castro on 23-02-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "PuntoCultural.h"

@implementation PuntoCultural

//aca sintetizo las propiedades
@synthesize nombre, latitud, longitud;

-(id) initWithNombre:(NSString *)_nombre
            AndLatitud:(NSNumber *)_latitud
           AndLongitud:(NSNumber *)_longitud{
    if (self = [super init]) {
        nombre = _nombre;
        latitud = _latitud;
        longitud = _longitud;
    }
    return self;
}

@end
