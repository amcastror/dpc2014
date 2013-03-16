//
//  MisPuntosCulturales.m
//  diaPatrimonio
//
//  Created by Matias Castro on 10-03-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "MisPuntosCulturales.h"

@implementation MisPuntosCulturales

@synthesize misPuntosCulturales;

+ (MisPuntosCulturales *)instance {
    static MisPuntosCulturales *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[MisPuntosCulturales alloc] init];
        
    });
    
    return _sharedClient;
}

-(void) requestMisPuntosCulturalesWithSuccess:(void (^)(NSArray *puntosCulturales))success AndFail:(void (^)(NSError *error))fail{
    
    misPuntosCulturales = [NSArray arrayWithObjects:
                           @"a", @"b", @"c"
                           , nil];
}

@end
