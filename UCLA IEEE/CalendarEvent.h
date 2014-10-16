//
//  CalendarEvent.h
//  UCLA IEEE
//
//  Created by Aravind Vadali on 10/10/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarEvent : NSObject <NSCoding>

@property (nonatomic) NSDate *eventDate;
@property (nonatomic) NSDate *eventEndTime;
@property (nonatomic) NSString *eventTitle; //key: summary
@property (nonatomic) NSString *eventLocation; //key: location
@property (nonatomic) NSString *eventDescription; //key: description
@property (nonatomic) NSString *eventCreatorName; //key Path: creator: displayName
@property (nonatomic) NSString *eventCreatorEmail; //key Path: creator: email
@property (nonatomic) NSString *eventID; //key: id

@end
