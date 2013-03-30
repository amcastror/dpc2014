//
//  PuntoCultural.m
//  diaPatrimonio
//
//  Created by Matias Castro on 23-02-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "PuntoCultural.h"
#import "APIClient.h"

@implementation PuntoCultural

//aca sintetizo las propiedades
@synthesize nombre, latitud, longitud, id_punto, descripcion, url_foto;

-(id) initWithIDPunto:(NSNumber *) _id_punto
            AndNombre:(NSString *)_nombre
           AndLatitud:(NSNumber *)_latitud
          AndLongitud:(NSNumber *)_longitud{
    if (self = [super init]) {
        id_punto = _id_punto;
        nombre = _nombre;
        latitud = _latitud;
        longitud = _longitud;
    }
    return self;
}

-(void) requestCompletarInformacionWithSuccess:(void (^)())success
                                       AndFail:(void (^)(NSError *error))fail{
    [[APIClient instance] requestCompletarInformacionPuntoCulturalConIDPunto:id_punto AndSuccess:^(NSDictionary *informacionPunto) {
        NSLog(@"info: %@", informacionPunto);
        
        if ([[informacionPunto objectForKey:@"d"] objectForKey:@"d_c"]) {
            descripcion = [[informacionPunto objectForKey:@"d"] objectForKey:@"d_c"];
        }
        if ([informacionPunto objectForKey:@"img"]) {
            url_foto = [informacionPunto objectForKey:@"img"];
        }
        
        if (success) {
            success();
        }
    } AndFail:^(NSError *error) {
        //
    }];
}

-(void) eliminarDeMisPuntosWithSuccess:(void (^)())success
                               AndFail:(void (^)(NSError *error))fail{
    [[APIClient instance] requestEliminarPuntoId:id_punto DeMisPuntosWithSuccess:^{
        if (success) {
            success();
        }
    } AndFail:^(NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

@end
