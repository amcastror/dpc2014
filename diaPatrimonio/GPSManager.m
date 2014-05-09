//
//  GPSManager.m
//  EpiAutoInjector
//
//  Created by Matias Castro on 05-05-14.
//  Copyright (c) 2014 Dsarhoya. All rights reserved.
//

#import "GPSManager.h"
#import <CoreLocation/CoreLocation.h>

@implementation GPSManager

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(BOOL)hasGPSPermissions{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusAuthorized) {
        return YES;
    }
    return NO;
}

@end