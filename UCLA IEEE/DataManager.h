//
//  DataManager.h
//  LoginTest
//
//  Created by Aravind Vadali on 8/30/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

//Server Interaces

//Login/Register
+(void)loginWithEmail:(NSString *)email Password:(NSString *)password onComplete:(void (^)(void))callbackBlock;
+(void)registerWithEmail:(NSString *)email Firstname:(NSString *)firstname Lastname:(NSString *)lastname Password:(NSString *)password year:(NSString *)year major:(NSString *)major onComplete:(void (^)(void))callbackBlock;

//Edit Membership
+(void)changePasswordWithEmail:(NSString *)email Cookie:(NSString *)cookie newPassword:(NSString *)newPass oldPassword:(NSString *)oldPass onComplete:(void (^)(void))callbackBlock;
+(void)changeEmailWithEmail:(NSString *)email Cookie:(NSString *)cookie newEmail:(NSString *)newEmail onComplete:(void (^)(void))callbackBlock;
+(void)changeNameWithEmail:(NSString *)email Cookie:(NSString *)cookie newName:(NSString *)newName onComplete:(void (^)(void))callbackBlock;
+(void)changeIDWithEmail:(NSString *)email Cookie:(NSString *)cookie newID:(NSString *)newID onComplete:(void (^)(void))callbackBlock;
+(void)changeMajorWithEmail:(NSString *)email Cookie:(NSString *)cookie newMajor:(NSString *)newMajor onComplete:(void (^)(void))callbackBlock;
+(void)changeYearWithEmail:(NSString *)email Cookie:(NSString *)cookie newYear:(NSString *)newYear onComplete:(void (^)(void))callbackBlock;

//Get Information
+(void)getAnnouncementsOnComplete:(void (^)(void))callbackBlock;
+(void)checkInToEvent:(NSString *)eventCode withEmail:(NSString *)email andCookie:(NSString *)cookie onComplete:(void (^)(void))callbackBlock;
+(void)GetCalendarEventsOnComplete:(void (^)(void))callbackBlock;
+(void)GetAttendedEventsOnComplete:(void (^)(void))callbackBlock;

//Helper Functions
+(NSMutableArray *)getEventsForDate:(NSDate*)date;

@end
