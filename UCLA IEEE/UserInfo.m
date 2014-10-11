//
//  User.m
//  LoginTest
//
//  Created by Aravind Vadali on 8/30/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import "UserInfo.h"
#import "DataManager.h"

@implementation UserInfo
+(UserInfo*)sharedInstance {
    static dispatch_once_t onceToken;
    static id sharedInstance;
    
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        sharedInstance = [[class alloc] init];
        [sharedInstance initData];
    });
    return sharedInstance;
}

-(void)initData
{
    _announcements = [[NSMutableArray alloc] init];
    _calendarArray = [[NSMutableArray alloc] init];
//    [DataManager GetCalendarEventsOnComplete:^{
//        NSLog(@"%@", [UserInfo sharedInstance].calendarArray);
//    }];
}

-(void)logOut
{
    _isLoggedIn = NO;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Username"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Password"];
}
@end
