//
//  DataManager.h
//  LoginTest
//
//  Created by Aravind Vadali on 8/30/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

+(void)loginWithEmail:(NSString *)email Password:(NSString *)password onComplete:(void (^)(void))callbackBlock;
+(void)registerWithEmail:(NSString *)email Firstname:(NSString *)firstname Lastname:(NSString *)lastname Password:(NSString *)password onComplete:(void (^)(void))callbackBlock;
+(void)changePasswordWithEmail:(NSString *)email Cookie:(NSString *)cookie newPassword:(NSString *)newPass;
+(void)changeEmailWithEmail:(NSString *)email Cookie:(NSString *)cookie newEmail:(NSString *)newEmail;
+(void)changeNameWithEmail:(NSString *)email Cookie:(NSString *)cookie newName:(NSString *)newName;
+(void)changeIDWithEmail:(NSString *)email Cookie:(NSString *)cookie newID:(NSString *)newID;


@end
