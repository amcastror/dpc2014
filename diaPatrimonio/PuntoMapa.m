//
//  PuntoMapa.m
//  DiaDelPatrimonio
//
//  Created by Matias Castro on 12-04-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "PuntoMapa.h"

@implementation PuntoMapa
@synthesize coordinate;
@synthesize coordenadas, titulo, subtitulo;

-(id) initWithCoordenadas: (CLLocationCoordinate2D)_coordenadas titulo: (NSString *)_titulo subtitulo:(NSString *) _subtitulo {
	if(self = [super init]){
        coordenadas = _coordenadas;
        titulo = _titulo;
        subtitulo = _subtitulo;
    }
	return self;
}

@end
