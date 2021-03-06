//
//  AppDelegate.m
//  UCLA IEEE
//
//  Created by Aravind Vadali on 9/2/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import "AppDelegate.h"
#import "MNCalendarView.h"
#import "DataManager.h"
#import "UserInfo.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //Set Initial View Controller
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NSString *isLoggedIn = [[NSUserDefaults standardUserDefaults] objectForKey:@"IsLoggedIn"];
    UIViewController *viewController;
    NSString *oldUserEmail = [[NSUserDefaults standardUserDefaults] objectForKey:@"Username"];
    NSString *oldPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"Password"];
    if ([isLoggedIn isEqualToString:@"yes"] && oldUserEmail != nil)
    {
        [[UserInfo sharedInstance] getDefaultsUser];
        [DataManager loginWithEmail:oldUserEmail Password:oldPassword onComplete:^{
            
        }];
        viewController = [storyboard instantiateViewControllerWithIdentifier:@"FrontPageViewController"];
    }
    else
    {
        viewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    }
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
    
    [[MNCalendarView appearance] setSeparatorColor:UIColor.blueColor];
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x003BA6)];
    //[[UINavigationBar appearance] setTranslucent:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
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


@end
