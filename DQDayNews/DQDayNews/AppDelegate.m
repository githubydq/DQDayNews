//
//  AppDelegate.m
//  DQDayNews
//
//  Created by youdingquan on 16/5/13.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import "AppDelegate.h"
#import <AFNetworkReachabilityManager.h>

#import "DQMainViewController.h"
#import "DQCollectHelper.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


#pragma mark -
#pragma mark into Main
-(void)intoMain{
    DQMainViewController * main = [[DQMainViewController alloc] init];
    self.window.rootViewController = main;
}

#pragma mark -
#pragma mark app delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //打印documents地址
    NSLog(@"%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject);
    //创建收藏plist文件
    [DQCollectHelper createCollectionPlist];
    
    //设置跟视图
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self intoMain];
    [self.window makeKeyAndVisible];
    // 监控网络状态
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@",path);
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
