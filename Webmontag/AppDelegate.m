//
//  AppDelegate.m
//  Webmontag
//
//  Erstellt von Johannes Jakob am 15.03.2015
//  ©2015 Johannes Jakob
//

#import "AppDelegate.h"

// Definiere Vergleiche von Betriebssystem-Versionen

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UITabBarController *TabBarController = (UITabBarController *)self.window.rootViewController;  // TabBarController = Start-ViewController
    UITabBar *TabBar = TabBarController.tabBar;  // TabBar = TabBar von TabBarController
    
    // TabBar-Items = Items von TabBar an entsprechender Stelle
    
    UITabBarItem *NewsTabBarItem = [TabBar.items objectAtIndex:0];
    UITabBarItem *VideosTabBarItem = [TabBar.items objectAtIndex:1];
    UITabBarItem *JobsTabBarItem = [TabBar.items objectAtIndex:2];
    UITabBarItem *MehrTabBarItem = [TabBar.items objectAtIndex:3];
    
    // Zuweísung von Icons zu den TabBar-Items (Tab ausgewählt + Tab nicht ausgewählt)
    
    [NewsTabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"NewsSelected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"News.png"]];
    [VideosTabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"VideosSelected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Videos.png"]];
    [JobsTabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"JobsSelected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Jobs.png"]];
    [MehrTabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"MehrSelected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Mehr.png"]];
    
    // Aussehen der TabBar anpassen (Farbe + Schriftfarbe für ausgewählten Tab + Schriftfarbe für nicht ausgewählten Tab)
    
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0 green:0.75 blue:0.474 alpha:1]];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.572 green:0.572 blue:0.572 alpha:1], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0 green:0.75 blue:0.474 alpha:1], UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    
    // Aussehen der TabBar für Geräte mit iOS < 7 anpassen
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0 green:0.75 blue:0.474 alpha:1]];
        [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0.968 green:0.968 blue:0.968 alpha:1]];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
