//
//  CalendarEvent.m
//  UCLA IEEE
//
//  Created by Aravind Vadali on 10/10/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import "CalendarEvent.h"

@implementation CalendarEvent

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self == [super init])
    {
        self.eventCreatorEmail = [aDecoder decodeObjectForKey:@"eventCreatorEmail"];
        self.eventCreatorName = [aDecoder decodeObjectForKey:@"eventCreatorName"];
        self.eventDate = [aDecoder decodeObjectForKey:@"eventDate"];
        self.eventDescription = [aDecoder decodeObjectForKey:@"eventDescription"];
        self.eventID = [aDecoder decodeObjectForKey:@"eventID"];
        self.eventLocation = [aDecoder decodeObjectForKey:@"eventLocation"];
        self.eventTitle = [aDecoder decodeObjectForKey:@"eventTitle"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.eventCreatorEmail forKey:@"eventCreatorEmail"];
    [aCoder encodeObject:self.eventCreatorName forKey:@"eventCreatorName"];
    [aCoder encodeObject:self.eventDate forKey:@"eventDate"];
    [aCoder encodeObject:self.eventDescription forKey:@"eventDescription"];
    [aCoder encodeObject:self.eventID forKey:@"eventID"];
    [aCoder encodeObject:self.eventLocation forKey:@"eventLocation"];
    [aCoder encodeObject:self.eventTitle forKey:@"eventTitle"];
    
}

@end
