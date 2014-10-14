//
//  NewsFeedItem.h
//  UCLA IEEE
//
//  Created by Aravind Vadali on 10/12/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CalendarEvent;
@class Announcement;

@interface NewsFeedItem : NSObject <NSCoding>

@property (nonatomic)NSDate *date;
@property (nonatomic)BOOL isEvent;
@property (nonatomic)CalendarEvent *event;
@property (nonatomic)Announcement *announcement;

@end
