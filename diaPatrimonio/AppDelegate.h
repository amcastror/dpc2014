//
//  AppDelegate.h
//  diaPatrimonio
//
//  Created by Matias Castro on 22-02-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//
/*
 TODO:
 1. variable que diga si el punto ha sido agregado o no a mis puntos culturales.. tendría que mandar la consulta con mi udid
 2. la imagen (img) esta fuera del "d" en el json de respuesta
 3. mis puntos culturales no trae información de las coordenadas.
 */

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@end
