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
//#import "FacebookSingleton.h"
#import "FacebookController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
     self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    /*
     View controllers 
     */
    MapaViewController *mapa = [[MapaViewController alloc] initWithNibName:@"MapaViewController" bundle:nil];
    UINavigationController *mapaNavController = [[UINavigationController alloc] initWithRootViewController:mapa];
    
    PerfilViewController *perfil = [[PerfilViewController alloc] initWithNibName:@"PerfilViewController" bundle:nil];
    UINavigationController *perfilNavController = [[UINavigationController alloc] initWithRootViewController:perfil];
    /*
     View controllers
     */
    
     self.tabBarController = [[UITabBarController alloc] init];
     self.tabBarController.viewControllers = @[mapaNavController, perfilNavController];
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([[url scheme] rangeOfString:@"fb355375187904342"].location!=NSNotFound){
        //return [FBSession.activeSession handleOpenURL:url];
        return [[FacebookController instance] handleOpenUrl:url];
    }else{
        return YES;
    }
}

@end
