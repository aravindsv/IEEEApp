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



@end
