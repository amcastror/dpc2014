//
//  Comentario.m
//  DiaDelPatrimonio
//
//  Created by Matias Castro on 23-04-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "Comentario.h"

@implementation Comentario

@synthesize autor, titulo, fecha, comentario, fecha_string;

-(id)initWithAutor:(NSString *)_autor AndTitulo:(NSString *)_titulo AndComentario:(NSString *)_comentario AndFecha:(NSDate *)_fecha AndFechaString:(NSString *)_fecha_Strig{
    if (self = [super init]) {
        autor = _autor;
        titulo = _titulo;
        fecha = _fecha;
        comentario = _comentario;
        fecha_string = _fecha_Strig;
    }
    return self;
}

- (NSComparisonResult) compararPorFecha:(Comentario *) anotherComment{
    return [[self fecha] compare:[anotherComment fecha]] * -1;
}

@end
