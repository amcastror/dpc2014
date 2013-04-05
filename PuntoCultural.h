//
//  PuntoCultural.h
//  diaPatrimonio
//
//  Created by Matias Castro on 23-02-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PuntoCultural : NSObject{
    NSNumber *id_punto;
    NSString *nombre;
    NSString *descripcion;
    NSString *url_foto;
    NSNumber *latitud;
    NSNumber *longitud;
    NSNumber *id_zona;
    NSNumber *id_sub_zona;
    NSNumber *distancia;
}

@property (nonatomic, readonly) NSString *nombre;
@property (nonatomic, readonly) NSString *descripcion;
@property (nonatomic, readonly) NSString *url_foto;
@property (nonatomic, readonly) NSNumber *id_punto;
@property (nonatomic, readonly) NSNumber *latitud;
@property (nonatomic, readonly) NSNumber *longitud;
@property (nonatomic, readonly) NSNumber *id_zona;
@property (nonatomic, readonly) NSNumber *id_sub_zona;
@property (nonatomic, readonly) NSNumber *distancia;

-(id) initWithIDPunto:(NSNumber *) _id_punto
            AndNombre:(NSString *)_nombre
            AndLatitud:(NSNumber *)_latitud
          AndLongitud:(NSNumber *)_longitud
              AndZona:(NSNumber *)_id_zona
           AndSubZona:(NSNumber *)_id_sub_zona;

-(void) requestCompletarInformacionWithSuccess:(void (^)())success
                                       AndFail:(void (^)(NSError *error))fail;
@end
