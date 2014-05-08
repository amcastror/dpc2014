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
#import "NSString+MD5Addition.h"
#import "Usuario.h"
#import "Filtros.h"
#import "GAI.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
     self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    /*     Set ups iniciales     */
    [TestFlight takeOff:@"6eb30449-c8c1-4a32-99e8-c142d56db41f"];
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        [[Usuario instance] setUdid:[[[[UIDevice currentDevice] identifierForVendor] UUIDString] stringFromMD5]];
    }else{
        [[Usuario instance] setUdid:[[UIDevice currentDevice] uniqueDeviceIdentifier]];
    }
    [Filtros instance];
    /*     Set ups iniciales     */
    
    /*     View controllers      */
    MapaViewController *mapa = [[MapaViewController alloc] initWithNibName:@"MapaViewController" bundle:nil];
    UINavigationController *mapaNavController = [[UINavigationController alloc] initWithRootViewController:mapa];
    UITabBarItem *item_mapa = [[UITabBarItem alloc] initWithTitle:@"Mapa" image:[UIImage imageNamed:@"dpc-tab-bar-mapa-icon-"] tag:0];
    [mapaNavController setTabBarItem:item_mapa];
    
    MisPuntosCulturalesViewController *misPuntos = [[MisPuntosCulturalesViewController alloc] initWithNibName:@"MisPuntosCulturalesViewController" bundle:nil];
    UINavigationController *misPuntosNavController = [[UINavigationController alloc] initWithRootViewController:misPuntos];
    UITabBarItem *item_mis_puntos = [[UITabBarItem alloc] initWithTitle:@"Mi ruta" image:[UIImage imageNamed:@"dpc-tab-bar-miruta-icon-"] tag:1];
    [misPuntosNavController setTabBarItem:item_mis_puntos];
    
    PerfilViewController *perfil = [[PerfilViewController alloc] initWithNibName:@"PerfilViewController" bundle:nil];
    UINavigationController *perfilNavController = [[UINavigationController alloc] initWithRootViewController:perfil];
    UITabBarItem *item_perfil = [[UITabBarItem alloc] initWithTitle:@"Perfil" image:[UIImage imageNamed:@"dpc-tab-bar-perfil-icon-"] tag:2];
    [perfilNavController setTabBarItem:item_perfil];
    
    /*
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    }
    */
    /*     View controllers     */
    
     self.tabBarController = [[UITabBarController alloc] init];
    if ([self.tabBarController.tabBar respondsToSelector:@selector(setBarStyle:)]) {
        self.tabBarController.tabBar.barStyle = UIBarStyleDefault;
    }
    if ([self.tabBarController.tabBar respondsToSelector:@selector(setTranslucent:)]) {
        self.tabBarController.tabBar.translucent = NO;
    }
    
     self.tabBarController.viewControllers = @[mapaNavController, misPuntosNavController, perfilNavController];
     self.window.rootViewController = self.tabBarController;

    [[FacebookController instance] trataDeAbrirSesionWithUI:NO AndHandler:^(NSError *error) { }];
    if ([[UINavigationBar class]respondsToSelector:@selector(appearance)]) {
        //[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav-var-"] forBarMetrics:UIBarMetricsDefault];

    }
    /* GAI */
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    // Optional: set debug to YES for extra debugging information.
    [GAI sharedInstance].debug = NO;
    // Create tracker instance.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-40739633-1"];
    [tracker setAnonymize:NO];
    
    /* GAI */
    
    mapa.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dpc-nav-bar-logos"]];
    misPuntos.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dpc-nav-bar-logos"]];
    perfil.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dpc-nav-bar-logos"]];
    
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor whiteColor]];
    self.window.backgroundColor = [UIColor whiteColor];
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
    [[FacebookController instance] handleDidBecomeActive];
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
