//
//  User.m
//  LoginTest
//
//  Created by Aravind Vadali on 8/30/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
+ (UserInfo*)sharedInstance {
    static dispatch_once_t onceToken;
    static id sharedInstance;
    
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        sharedInstance = [[class alloc] init];
    });
    return sharedInstance;
}
@end
