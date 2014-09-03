//
//  User.h
//  LoginTest
//
//  Created by Aravind Vadali on 8/30/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

+ (UserInfo*)sharedInstance;

@property (strong, nonatomic) NSString* userName;
@property (strong, nonatomic) NSString* userMail;
@property (strong, nonatomic) NSString* userId;
@property (strong, nonatomic) NSString* userCookie;
@property (nonatomic) BOOL isLoggedIn;
@end
