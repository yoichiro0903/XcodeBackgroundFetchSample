//
//  AppDelegate.m
//  BackgroundFetchSample
//
//  Created by WatanabeYoichiro on 2016/03/13.
//  Copyright © 2016年 YoichiroWatanabe. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    // iOS8 ローカル通知を動作させる許可を得る必要
    if ([UIApplication
         instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil]];
    }
    return YES;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Increment Badge Count.
    [UIApplication sharedApplication].applicationIconBadgeNumber++;
    
    // Local Notification.
    UILocalNotification *localNotification = [UILocalNotification new];
    localNotification.alertAction = @"OK";
    localNotification.alertBody = @"Called application:performFetchWithCompletionHandler:";
    localNotification.fireDate = [NSDate date];
    localNotification.timeZone = [NSTimeZone localTimeZone];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    NSLog(@"nslog");
    NSURL *openWetherURL = [NSURL URLWithString:@"http://api.openweathermap.org/data/2.5/weather?q=Tokyo&APPID=a71f77b53f68fbe5c78e63aaa19a338d"];
    NSError * error = nil;
    NSData *wetherJsonData = [NSData dataWithContentsOfURL:openWetherURL options:kNilOptions error:&error];
    NSArray *wetherJsonResponse = [NSJSONSerialization JSONObjectWithData:wetherJsonData options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"%@", wetherJsonResponse);
    NSString *city = [wetherJsonResponse valueForKeyPath:@"name"];
    NSArray *condition = [wetherJsonResponse valueForKeyPath:@"weather.main"];
    NSArray *conditionId = [wetherJsonResponse valueForKeyPath:@"weather.id"];
    NSLog(@"%@", city);
    NSLog(@"%@", condition[0]);
    NSArray *weatherConditionArray = @[city, condition[0], conditionId[0]];
    NSLog(@"%@",weatherConditionArray);
    
    // Download complete.
    completionHandler(UIBackgroundFetchResultNoData);
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
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
