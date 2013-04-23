//
//  PuntoCultural.m
//  diaPatrimonio
//
//  Created by Matias Castro on 23-02-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "PuntoCultural.h"
#import "APIClient.h"
#import "Usuario.h"
#import "Comentario.h"

@implementation PuntoCultural

//aca sintetizo las propiedades
@synthesize nombre, latitud, longitud, id_punto, descripcion, descripcion_larga, direccion, url_foto, id_zona, id_sub_zona, distancia, id_tipo, visitado, comentarios, horario;

-(id) initWithIDPunto:(NSNumber *) _id_punto
            AndNombre:(NSString *)_nombre
           AndLatitud:(NSNumber *)_latitud
          AndLongitud:(NSNumber *)_longitud
              AndZona:(NSNumber *)_id_zona
           AndSubZona:(NSNumber *)_id_sub_zona
            AndIdTipo:(NSNumber *)_id_tipo
          AndVisitado:(BOOL)_visitado{
    if (self = [super init]) {
        id_punto = _id_punto;
        nombre = _nombre;
        latitud = _latitud;
        longitud = _longitud;
        id_tipo = _id_tipo;
        if (_id_zona) {
            id_zona = _id_zona;
        }
        if (_id_sub_zona) {
            id_sub_zona = _id_sub_zona;
        }
        if (_visitado) {
            visitado = _visitado;
        }else{
            visitado = NO;
        }
        [self calculaDistancia]; //si el usuario no tiene coordenadas entonces no lo voy a calcular
    }
    return self;
}

-(void) requestCompletarInformacionWithSuccess:(void (^)())success
                                       AndFail:(void (^)(NSError *error))fail{
    [[APIClient instance] requestCompletarInformacionPuntoCulturalConIDPunto:id_punto AndSuccess:^(NSDictionary *informacionPunto) {
        
        NSString *lunes = nil;
        NSString *martes = nil;
        NSString *miercoles = nil;
        NSString *jueves = nil;
        NSString *viernes = nil;
        NSString *sabado = nil;
        NSString *domingo = nil;
        
        NSMutableArray *horarios = [[NSMutableArray alloc] init];
        
        if ([informacionPunto objectForKey:@"d_c"]) {
            descripcion = [informacionPunto objectForKey:@"d_c"];
        }
        if ([informacionPunto objectForKey:@"d_l"]) {
            descripcion_larga = [informacionPunto objectForKey:@"d_l"];
        }
        if ([informacionPunto objectForKey:@"direccion"]) {
            direccion = [informacionPunto objectForKey:@"direccion"];
        }
        if ([informacionPunto objectForKey:@"img"] && ![[informacionPunto objectForKey:@"img"] isEqualToString:@""]) {
            url_foto = [informacionPunto objectForKey:@"img"];
        }
        
        if ([informacionPunto objectForKey:@"subzona"]) {
            id_sub_zona = (NSNumber *)[informacionPunto objectForKey:@"subzona"];
        }
        
        /*    HORARIOS    */
        
        if ([informacionPunto objectForKey:@"l"] && [[informacionPunto objectForKey:@"l"] class] != [NSNull class]) {
            lunes = (NSString *)[informacionPunto objectForKey:@"l"];
            [horarios addObject:[NSString stringWithFormat:@"Lunes %@", lunes]];
        }
        
        if ([informacionPunto objectForKey:@"m"] && [[informacionPunto objectForKey:@"m"] class] != [NSNull class]) {
            martes = (NSString *)[informacionPunto objectForKey:@"m"];
            [horarios addObject:[NSString stringWithFormat:@"Martes %@", martes]];
        }
        
        if ([informacionPunto objectForKey:@"w"] && [[informacionPunto objectForKey:@"w"] class] != [NSNull class]) {
            miercoles = (NSString *)[informacionPunto objectForKey:@"w"];
            [horarios addObject:[NSString stringWithFormat:@"Miércoles %@", miercoles]];
        }
        
        if ([informacionPunto objectForKey:@"j"] && [[informacionPunto objectForKey:@"j"] class] != [NSNull class]) {
            jueves = (NSString *)[informacionPunto objectForKey:@"j"];
            [horarios addObject:[NSString stringWithFormat:@"Jueves %@", jueves]];
        }
        
        if ([informacionPunto objectForKey:@"v"] && [[informacionPunto objectForKey:@"v"] class] != [NSNull class]) {
            viernes = (NSString *)[informacionPunto objectForKey:@"v"];
            [horarios addObject:[NSString stringWithFormat:@"Viernes %@", viernes]];
        }
        
        if ([informacionPunto objectForKey:@"s"] && [[informacionPunto objectForKey:@"s"] class] != [NSNull class]) {
            sabado = (NSString *)[informacionPunto objectForKey:@"s"];
            [horarios addObject:[NSString stringWithFormat:@"Sábado %@", sabado]];
        }
        
        if ([informacionPunto objectForKey:@"d"] && [[informacionPunto objectForKey:@"d"] class] != [NSNull class]) {
            domingo = (NSString *)[informacionPunto objectForKey:@"d"];
            [horarios addObject:[NSString stringWithFormat:@"Domingo %@", domingo]];
        }
        
        if (
            [lunes isEqualToString:martes] &&
            [lunes isEqualToString:miercoles] &&
            [lunes isEqualToString:jueves] &&
            [lunes isEqualToString:viernes] &&
            [lunes isEqualToString:sabado] &&
            [lunes isEqualToString:domingo]
            ) {
            horario = [NSString stringWithFormat:@"Todos los días %@", lunes];
        }else{
            horario = [horarios componentsJoinedByString:@", "];
        }
        
        if (success) {
            success();
        }
    } AndFail:^(NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

-(void)requestDejarComentarioConAutor:(NSString *)autor
                               Titulo:(NSString *)titulo
                          YComentario:(NSString *)comentario
                          WithSuccess:(void (^)())success
                              AndFail:(void (^)(NSError *error))fail{
    
    [[APIClient instance] requestDejarComentarioEnPuntoCulturalID:id_punto ConAutor:autor Titulo:titulo YComentario:comentario WithSuccess:^{
        if(success){
            success();
        }
    } AndFail:^(NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

-(void)requestComentariosWithSuccess:(void (^)())success
                             AndFail:(void (^)(NSError *error))fail{
    
    [[APIClient instance] requestComentariosDePuntoCulturalID:id_punto WithSuccess:^(NSArray *results) {
        
        NSDateFormatter *df=[[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd-MM-yyy HH:mm:ss"];
        
        NSMutableArray *comentarios_tmp = [[NSMutableArray alloc] init];
        for (NSDictionary *comentario in (NSArray *)results) {
            [comentarios_tmp addObject:[[Comentario alloc] initWithAutor:[comentario objectForKey:@"autor"]
                                                               AndTitulo:[comentario objectForKey:@"titulo"]
                                                           AndComentario:[comentario objectForKey:@"comentario"]
                                                                AndFecha:[df dateFromString:[comentario objectForKey:@"fecha"]]
                                                          AndFechaString:[comentario objectForKey:@"fecha"]
                                        ]];
        }
        
        [comentarios_tmp sortUsingSelector:@selector(compararPorFecha:)];
        
        comentarios = [NSArray arrayWithArray:comentarios_tmp];
        
        for (Comentario *com in comentarios) {
            NSLog(@"comentario: %@, %@", com.comentario, com.fecha);
        }
        
        if (success) {
            success();
        }
    } AndFail:^(NSError *error) {
        NSLog(@"err: %@", error);
        if (fail) {
            fail(error);
        }
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

-(void) cambiarEstadoPuntoWithSuccess:(void (^)())success
                               AndFail:(void (^)(NSError *error))fail{
    [[APIClient instance] requestCambiarEstadoPuntoCulturalID:id_punto WithSuccess:^{
        self.visitado = !visitado;
        if (success) {
            success();
        }
    } AndFail:^(NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

- (void) calculaDistancia{
    
    if (![[Usuario instance] tieneCoordenadas]) {
        return;
    }
    
    if (!latitud || !longitud) {
        return;
    }
    
    double usr_latitud = [[Usuario instance] latitud];
    double usr_longitud = [[Usuario instance] longitud];
    double suc_latitud = latitud.doubleValue;
    double suc_longitud = latitud.doubleValue;
    distancia = [NSNumber numberWithDouble:( 6371* acos( cos( [self radians:suc_latitud] ) * cos( [self radians:usr_latitud] ) * cos( [self radians:usr_longitud] - [self radians:suc_longitud] ) + sin( [self radians:suc_latitud] ) * sin( [self radians:usr_latitud] ) ) )];
}

-(double)radians:(double)coord_component{
    return coord_component * M_PI / 180;
}

@end
