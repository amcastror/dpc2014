//
//  GPSManager.h
//  EpiAutoInjector
//
//  Created by Matias Castro on 05-05-14.
//  Copyright (c) 2014 Dsarhoya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPSManager : NSObject

+ (instancetype)sharedInstance;
-(BOOL)hasGPSPermissions;
@end
