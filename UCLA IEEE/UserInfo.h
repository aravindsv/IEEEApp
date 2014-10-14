//
//  User.h
//  LoginTest
//
//  Created by Aravind Vadali on 8/30/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarEvent.h"
#import "Announcement.h"


@interface UserInfo : NSObject

+(UserInfo*)sharedInstance;

@property (strong, nonatomic) NSString* userName;
@property (strong, nonatomic) NSString* userMail;
@property (strong, nonatomic) NSString* userId;
@property (strong, nonatomic) NSString* userCookie;
@property (strong, nonatomic) NSString* userYear;
@property (strong, nonatomic) NSString* userMajor;
@property (nonatomic) int currentPoints;
@property (nonatomic) int totalPoints;
@property (nonatomic) BOOL isLoggedIn;

@property (nonatomic, strong) NSMutableArray* announcements;
@property (nonatomic, strong) NSMutableDictionary* calendarDict;
@property (nonatomic, strong) NSMutableArray* newsFeedArray;
@property (nonatomic, strong) NSMutableArray* attendedEvents;

-(void)logOut;
-(void)addCalendarEventToNewsFeedArray:(CalendarEvent *)event;
-(void)addAnnouncementToNewsFeedArray:(Announcement *)announcement;

-(void)saveUserToUserDefaults;
-(void)getDefaultsUser;



-(void)writeArrayWithCustomObjToUserDefaults:(NSString *)keyName withArray:(NSMutableArray *)myArray;
-(NSArray *)readArrayWithCustomObjFromUserDefaults:(NSString*)keyName;

@end
