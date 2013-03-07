//
//  MapItem.m
//  diaPatrimonio
//
//  Created by Matias Castro on 23-02-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "MapItem.h"

@implementation MapItem

@synthesize nombre, coordinate, title, subtitle;

-(id) initWithCoordinate:(CLLocationCoordinate2D)_coordenadas AndNombre:(NSString *)_nombre{
    if (self = [super init]) {
        nombre = _nombre;
        coordinate = _coordenadas;
        title = _nombre;
        subtitle = _nombre;
    }
    return self;
}

@end
