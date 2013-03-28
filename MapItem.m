//
//  MapItem.m
//  diaPatrimonio
//
//  Created by Matias Castro on 23-02-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "MapItem.h"

@implementation MapItem

@synthesize id_punto, nombre, coordinate, title, subtitle;

-(id) initWithIDPunto:(NSNumber *)_id_punto AndCoordinate:(CLLocationCoordinate2D)_coordenadas AndNombre:(NSString *)_nombre{
    if (self = [super init]) {
        id_punto = _id_punto;
        nombre = _nombre;
        coordinate = _coordenadas;
        title = _nombre;
        subtitle = _nombre;
    }
    return self;
}

@end
