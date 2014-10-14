//
//  User.m
//  LoginTest
//
//  Created by Aravind Vadali on 8/30/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import "UserInfo.h"
#import "DataManager.h"
#import "NewsFeedItem.h"

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
    _calendarDict = [[NSMutableDictionary alloc] init];
    _newsFeedArray = [[NSMutableArray alloc] init];
    _attendedEvents = [[NSMutableArray alloc] init];
}

-(void)logOut
{
    _isLoggedIn = NO;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Username"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Password"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"IsLoggedIn"];
    [_announcements removeAllObjects];
    [_calendarDict removeAllObjects];
    [_newsFeedArray removeAllObjects];
    [_attendedEvents removeAllObjects];
}

-(void)addCalendarEventToNewsFeedArray:(CalendarEvent *)event
{
    NewsFeedItem *newItem = [[NewsFeedItem alloc] init];
    newItem.date = event.eventDate;
    newItem.isEvent = YES;
    newItem.event = event;
    [self.newsFeedArray addObject:newItem];
    NSArray *sorter = [[NSArray alloc] initWithArray:self.newsFeedArray];
    NSArray *sorted = [sorter sortedArrayUsingSelector:@selector(compare:)];
    [self.newsFeedArray removeAllObjects];
    [self.newsFeedArray addObjectsFromArray:sorted];
}

-(void)addAnnouncementToNewsFeedArray:(Announcement *)announcement
{
    NewsFeedItem *newItem = [[NewsFeedItem alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    newItem.date = [formatter dateFromString:announcement.datePosted];
    newItem.isEvent = NO;
    newItem.announcement = announcement;
    [self.newsFeedArray addObject:newItem];
    NSArray *sorter = [[NSArray alloc] initWithArray:self.newsFeedArray];
    NSArray *sorted = [sorter sortedArrayUsingSelector:@selector(compare:)];
    [self.newsFeedArray removeAllObjects];
    [self.newsFeedArray addObjectsFromArray:sorted];
}

-(void)saveUserToUserDefaults
{
    [[NSUserDefaults standardUserDefaults] setValue:self.userMail forKey:@"Username"];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.userName forKey:@"UsersName"];
    [[NSUserDefaults standardUserDefaults] setObject:self.userId forKey:@"UserId"];
    [[NSUserDefaults standardUserDefaults] setObject:self.userYear forKey:@"UserYear"];
    [[NSUserDefaults standardUserDefaults] setObject:self.userMajor forKey:@"UserMajor"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:self.currentPoints] forKey:@"UserCurrentPoints"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:self.totalPoints] forKey:@"UserTotalPoints"];
    [self writeArrayWithCustomObjToUserDefaults:@"AnnouncementsArray" withArray:self.announcements];
//    [[NSUserDefaults standardUserDefaults] setObject:self.calendarDict forKey:@"CalendarDict"];
    [self writeDictionaryWithCustomObjToUserDefaults:@"CalendarDict" withDictionary:self.calendarDict];
    [self writeArrayWithCustomObjToUserDefaults:@"NewsFeedArray" withArray:self.newsFeedArray];
    [self writeArrayWithCustomObjToUserDefaults:@"AttendedEvents" withArray:self.attendedEvents];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)getDefaultsUser
{
    [self.announcements removeAllObjects];
    [self.calendarDict removeAllObjects];
    [self.newsFeedArray removeAllObjects];
    [self.attendedEvents removeAllObjects];
    self.userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"UsersName"];
    self.userMail = [[NSUserDefaults standardUserDefaults] objectForKey:@"Username"];
    self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"];
    self.userYear = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserYear"];
    self.userMajor = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserMajor"];
    self.currentPoints = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserCurrentPoints"] intValue];
    self.totalPoints = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserTotalPoints"] intValue];
    self.announcements = [[self readArrayWithCustomObjFromUserDefaults:@"AnnouncementsArray"] mutableCopy];
    self.calendarDict = [[self readDictionaryWithCustomObjFromUserDefaults:@"CalendarDict"] mutableCopy];
    self.newsFeedArray = [[self readArrayWithCustomObjFromUserDefaults:@"NewsFeedArray"] mutableCopy];
    self.attendedEvents = [[self readArrayWithCustomObjFromUserDefaults:@"AttendedEvents"] mutableCopy];
}


-(void)writeArrayWithCustomObjToUserDefaults:(NSString *)keyName withArray:(NSMutableArray *)myArray
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:myArray];
    [defaults setObject:data forKey:keyName];
    [defaults synchronize];
}

-(NSArray *)readArrayWithCustomObjFromUserDefaults:(NSString*)keyName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:keyName];
    NSArray *myArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [defaults synchronize];
    return myArray;
}

-(void)writeDictionaryWithCustomObjToUserDefaults:(NSString *)keyName withDictionary:(NSMutableDictionary *)myDict
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:myDict];
    [defaults setObject:data forKey:keyName];
    [defaults synchronize];
}

-(NSDictionary *)readDictionaryWithCustomObjFromUserDefaults:(NSString*)keyName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:keyName];
    NSDictionary *myDict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [defaults synchronize];
    return myDict;
}


@end
