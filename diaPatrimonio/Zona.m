//
//  Zona.m
//  DiaDelPatrimonio
//
//  Created by Matias Castro on 30-03-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "Zona.h"

@implementation Zona

@synthesize id_zona, nombre, sub_zonas;

- (id) initWithId:(NSNumber *)_id_zona AndNombre:(NSString *)_nombre{
    
    if (self = [super init]) {
        id_zona = _id_zona;
        nombre = _nombre;
    }
    
    return self;
    
}

- (void) agregarSubZona:(Zona *)sub_zona{
    NSMutableArray *sub_zonas_tmp = [NSMutableArray arrayWithArray:sub_zonas];
    [sub_zonas_tmp addObject:sub_zona];
    sub_zonas = [NSArray arrayWithArray:sub_zonas_tmp];
}

@end
