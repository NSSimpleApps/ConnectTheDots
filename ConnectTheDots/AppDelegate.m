//
//  AppDelegate.m
//  ConnectTheDots
//
//  Created by NSSimpleApps on 15.05.15.
//  Copyright (c) 2015 NSSimpleApps. All rights reserved.
//

#import "AppDelegate.h"
#import "TableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[TableViewController alloc] initWithStyle:UITableViewStylePlain]];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
