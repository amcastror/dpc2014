//
//  Comentario.h
//  DiaDelPatrimonio
//
//  Created by Matias Castro on 23-04-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comentario : NSObject{
    
}

@property (nonatomic, readonly) NSString *autor;
@property (nonatomic, readonly) NSString *titulo;
@property (nonatomic, readonly) NSString *comentario;
@property (nonatomic, readonly) NSDate *fecha;
@property (nonatomic, readonly) NSString *fecha_string;

-(id)initWithAutor:(NSString *)_autor AndTitulo:(NSString *)_titulo AndComentario:(NSString *)_comentario AndFecha:(NSDate *)_fecha AndFechaString:(NSString *)_fecha_Strig;

@end
