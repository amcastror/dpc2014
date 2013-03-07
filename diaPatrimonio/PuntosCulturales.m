//
//  PuntosCulturales.m
//  diaPatrimonio
//
//  Created by Matias Castro on 22-02-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "PuntosCulturales.h"

@implementation PuntosCulturales
@synthesize puntosCulturales;

+ (PuntosCulturales *)instance {
    static PuntosCulturales *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[PuntosCulturales alloc] init];
    });
    
    return _sharedClient;
}

-(void) requestPuntosCulturalesWithSuccess:(void (^)(NSArray *puntosCulturales))success AndFail:(void (^)(NSError *error))fail{
    
    [[APIClient instance] requestCustomWithSuccess:^(id results) {
        
        NSArray *JSONPuntosCulturales = (NSArray *)results;
        NSMutableArray *arregloPuntosCulturales = [[NSMutableArray alloc] init];
        
        for (NSDictionary *punto in JSONPuntosCulturales) {
            PuntoCultural *puntoCultural = [[PuntoCultural alloc] initWithNombre:[punto objectForKey:@"no_s"]
                                                                      AndLatitud:[NSNumber numberWithDouble:[[punto objectForKey:@"lat"] doubleValue]]
                                                                     AndLongitud:[NSNumber numberWithDouble:[[punto objectForKey:@"lon"] doubleValue]]];
            [arregloPuntosCulturales addObject:puntoCultural];
        }
        
        puntosCulturales = [NSArray arrayWithArray:arregloPuntosCulturales];
        
        if (success) {
            success(puntosCulturales);
        }
    } AndFail:^(NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

@end
