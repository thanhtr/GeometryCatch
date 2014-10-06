//
//  AppDelegate.m
//  GeometryCatch
//
//  Created by iosdev on 23/07/14.
//  Copyright (c) 2014 c63. All rights reserved.
//

#import "AppDelegate.h"
#import <RevMobAds/RevMobAds.h>
#import "ViewController.h"
#import <GameKit/GameKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate() <GKGameCenterControllerDelegate>

@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [RevMobAds startSessionWithAppID:@"540ad85a409ac5d10635e515"];
    [self authenticateLocalUser];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil]];
    }
#endif
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Pause" object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Pause2" object:self];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self setUpPushNotification];
    NSLog(@"Really?");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Resume" object:self];
    [[RevMobAds session] showFullscreen];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Local push notification
-(void)setUpPushNotification{
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:86400];
    localNotification.alertBody = @"We miss you!";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
}

#pragma mark - Game Center
- (void)authenticateLocalUser {
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    if (!localPlayer.authenticated) {
        localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
            if (viewController != nil) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Pause2" object:self];
                
                [self.window.rootViewController presentViewController:viewController animated:YES completion:nil];
            } else if (error){
                NSLog(@"%@",[error localizedDescription]);
            }
        };
    }
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController{
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
