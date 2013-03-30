//
//  Filtros.h
//  DiaDelPatrimonio
//
//  Created by Matias Castro on 30-03-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIClient.h"
#import "Zona.h"

@interface Filtros : NSObject{
    
}

@property (nonatomic, readonly) BOOL *activos;
@property (nonatomic, readonly) NSArray *zonas;

+ (Filtros *)instance;

@end
