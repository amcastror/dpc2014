//
//  PuntoCultural.h
//  diaPatrimonio
//
//  Created by Matias Castro on 23-02-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PuntoCultural : NSObject{
    NSString *nombre;
    NSNumber *latitud;
    NSNumber *longitud;
}

@property (nonatomic, readonly) NSString *nombre;
@property (nonatomic, readonly) NSNumber *latitud;
@property (nonatomic, readonly) NSNumber *longitud;

-(id) initWithNombre:(NSString *)_nombre
            AndLatitud:(NSNumber *)_latitud
           AndLongitud:(NSNumber *)_longitud;


@end
