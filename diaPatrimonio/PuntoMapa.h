//
//  PuntoMapa.h
//  DiaDelPatrimonio
//
//  Created by Matias Castro on 12-04-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PuntoMapa : NSObject <MKAnnotation>{
    NSString *titulo;
	NSString *subtitulo;
	CLLocationCoordinate2D coordenadas;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordenadas;
@property (nonatomic, copy) NSString *titulo;
@property (nonatomic, copy) NSString *subtitulo;
@end
