//
//  Usuario.m
//  DiaDelPatrimonio
//
//  Created by Matias Castro on 24-03-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "Usuario.h"

@implementation Usuario

@synthesize udid, latitud, longitud;

+ (Usuario *)instance {
    static Usuario *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[Usuario alloc] init];
        
    });
    
    return _sharedClient;
}

- (void)updateLocationWithPrecision:(float)precision
                    AndTimeInterval:(NSTimeInterval)timeInterval
                  AndSuccessHandler:(void(^)(NSError * error))block
{
    radioPrecision = precision;
    successHandler = block;
    isFirstTime = YES;
    [locationManager startUpdatingLocation];
    if (timeInterval > 0) {
        temporizador = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(timeoutReached) userInfo:nil repeats:NO];
    }
}

-(id)init
{
    if (self = [super init]) {
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        [locationManager setDistanceFilter:kCLDistanceFilterNone];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        //[locationManager startMonitoringSignificantLocationChanges];
    }
    return self;
}

//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self setLatitud:newLocation.coordinate.latitude];
    [self setLongitud:newLocation.coordinate.longitude];

    if ([newLocation horizontalAccuracy]<=radioPrecision && [newLocation verticalAccuracy]<= radioPrecision && !isFirstTime) {
        NSLog(@"Entro!");
        [temporizador invalidate];
        [manager stopUpdatingLocation];
        if (successHandler) {
            successHandler(nil);
            successHandler=nil;
        }
    }
    isFirstTime = NO;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [manager stopUpdatingLocation];
    [temporizador invalidate];
    if (successHandler) {
        successHandler(error);
        successHandler=nil;
    }
}

-(void)timeoutReached
{
    NSLog(@"Location Timeout reached");
    [temporizador invalidate];
    [locationManager stopUpdatingLocation];
    if (successHandler) {
        successHandler(nil);
        successHandler=nil;
    }
}

-(void) apagarGPS{
    NSLog(@"apago el GPS");
    [locationManager stopMonitoringSignificantLocationChanges];
    [locationManager stopUpdatingLocation];
}

-(void) prenderGPS{
    //[locationManager startMonitoringSignificantLocationChanges];
}

@end
