//
//  Usuario.h
//  DiaDelPatrimonio
//
//  Created by Matias Castro on 24-03-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^UpdateLocationSuccessHandler)(NSError *error);

@interface Usuario : NSObject <CLLocationManagerDelegate>{
    NSString *udid;
    float radioPrecision;
    UpdateLocationSuccessHandler successHandler;
    BOOL isFirstTime;
    CLLocationManager *locationManager;
    NSTimer *temporizador;
    double latitud;
    double longitud;
}

@property (nonatomic, readwrite) NSString *udid;
@property double latitud;
@property double longitud;

+(Usuario *) instance;
-(void)updateLocationWithPrecision:(float)precision
                   AndTimeInterval:(NSTimeInterval)timeInterval
                 AndSuccessHandler:(void(^)(NSError * error))block;
-(void) apagarGPS;
-(void) prenderGPS;
-(BOOL) tieneCoordenadas;
@end
