//
//  AppDelegate.m
//  diaPatrimonio
//
//  Created by Matias Castro on 22-02-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "AppDelegate.h"
#import "MapaViewController.h"
#import "PerfilViewController.h"
#import "MisPuntosCulturalesViewController.h"
#import "FacebookController.h"
#import "UIDevice+IdentifierAddition.h"
#import "Usuario.h"
#import "Filtros.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
     self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    /*     Set ups iniciales     */
    [TestFlight takeOff:@"6eb30449-c8c1-4a32-99e8-c142d56db41f"];
    [[Usuario instance] setUdid:[[UIDevice currentDevice] uniqueDeviceIdentifier]];
    [Filtros instance];
    /*     Set ups iniciales     */
    
    /*     View controllers      */
    MapaViewController *mapa = [[MapaViewController alloc] initWithNibName:@"MapaViewController" bundle:nil];
    UINavigationController *mapaNavController = [[UINavigationController alloc] initWithRootViewController:mapa];
    
    PerfilViewController *perfil = [[PerfilViewController alloc] initWithNibName:@"PerfilViewController" bundle:nil];
    UINavigationController *perfilNavController = [[UINavigationController alloc] initWithRootViewController:perfil];
    
    MisPuntosCulturalesViewController *misPuntos = [[MisPuntosCulturalesViewController alloc] initWithNibName:@"MisPuntosCulturalesViewController" bundle:nil];
    UINavigationController *misPuntosNavController = [[UINavigationController alloc] initWithRootViewController:misPuntos];
    /*     View controllers     */
    
     self.tabBarController = [[UITabBarController alloc] init];
     self.tabBarController.viewControllers = @[mapaNavController, misPuntosNavController, perfilNavController];
     self.window.rootViewController = self.tabBarController;

    [[FacebookController instance] trataDeAbrirSesionWithUI:NO AndHandler:^(NSError *error) { }];
     
     [self.window makeKeyAndVisible];
     return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[Usuario instance] apagarGPS];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[Usuario instance] prenderGPS];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[Usuario instance] apagarGPS];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([[url scheme] rangeOfString:@"fb355375187904342"].location!=NSNotFound){
        return [[FacebookController instance] handleOpenUrl:url];
    }else{
        return YES;
    }
}

@end
