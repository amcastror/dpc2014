//
//  Zona.h
//  DiaDelPatrimonio
//
//  Created by Matias Castro on 30-03-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Zona : NSObject{
    
}

@property (nonatomic, readonly) NSNumber *id_zona;
@property (nonatomic, readonly) NSString *nombre;
@property (nonatomic, readonly) NSArray *sub_zonas;

- (id) initWithId:(NSNumber *)_id_zona AndNombre:(NSString *)_nombre;
- (void) agregarSubZona:(Zona *)sub_zona;

@end
