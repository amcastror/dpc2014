//
//  PuntoCultural.h
//  diaPatrimonio
//
//  Created by Matias Castro on 23-02-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import <Foundation/Foundation.h>

enum TipoPunto
{
    TIPO_APERTURA = 1,
    TIPO_RECORRIDO_GUIADO = 2,
    TIPO_RUTA_TEMATICA = 3,
    TIPO_ACTIVIDAD = 4,
    TIPO_OTRO = 5
};
typedef enum TipoPunto TipoPunto;

@interface PuntoCultural : NSObject{
    NSNumber *id_punto;
    NSString *nombre;
    NSString *descripcion;
    NSString *descripcion_larga;
    NSString *direccion;
    NSString *url_foto;
    NSString *web;
    
    NSString *horario;
    
    NSNumber *latitud;
    NSNumber *longitud;
    NSNumber *id_zona;
    NSNumber *id_sub_zona;
    NSNumber *distancia;
    NSNumber *id_tipo;
    NSArray *comentarios;
    BOOL visitado;
}

@property (nonatomic, readonly) NSString *nombre;
@property (nonatomic, readwrite) NSString *descripcion;
@property (nonatomic, readonly) NSString *descripcion_larga;
@property (nonatomic, readonly) NSString *direccion;
@property (nonatomic, readonly) NSString *url_foto;
@property (nonatomic, readonly) NSString *web;

@property (nonatomic, readonly) NSString *horario;

@property (nonatomic, readonly) NSNumber *id_punto;
@property (nonatomic, readonly) NSNumber *latitud;
@property (nonatomic, readonly) NSNumber *longitud;
@property (nonatomic, readonly) NSNumber *id_zona;
@property (nonatomic, readonly) NSNumber *id_sub_zona;
@property (nonatomic, readonly) NSNumber *distancia;
@property (nonatomic, readonly) NSNumber *id_tipo;
@property (nonatomic, readonly) NSArray *comentarios;
@property (readwrite) BOOL visitado;

-(id) initWithIDPunto:(NSNumber *) _id_punto
            AndNombre:(NSString *)_nombre
           AndLatitud:(NSNumber *)_latitud
          AndLongitud:(NSNumber *)_longitud
              AndZona:(NSNumber *)_id_zona
           AndSubZona:(NSNumber *)_id_sub_zona
            AndIdTipo:(NSNumber *)_id_tipo
          AndVisitado:(BOOL)_visitado;

-(void) requestCompletarInformacionWithSuccess:(void (^)())success
                                       AndFail:(void (^)(NSError *error))fail;
-(void)requestDejarComentarioConAutor:(NSString *)autor
                               Titulo:(NSString *)titulo
                          YComentario:(NSString *)comentario
                          WithSuccess:(void (^)())success
                              AndFail:(void (^)(NSError *error))fail;
-(void)requestComentariosWithSuccess:(void (^)())success
                             AndFail:(void (^)(NSError *error))fail;
-(void) cambiarEstadoPuntoWithSuccess:(void (^)())success
                              AndFail:(void (^)(NSError *error))fail;
@end
