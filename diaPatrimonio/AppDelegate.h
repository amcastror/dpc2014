//
//  AppDelegate.h
//  diaPatrimonio
//
//  Created by Matias Castro on 22-02-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//
/*
 TODO:
 1. faltan los ids de la zona y sub zona de un punto cultural
 2. falta la distancia a la que está cada punto...? Tendría que mandar las coordenadas siempre... chao.
 */

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@end
