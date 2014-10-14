//
//  NewsFeedItem.m
//  UCLA IEEE
//
//  Created by Aravind Vadali on 10/12/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import "NewsFeedItem.h"

@implementation NewsFeedItem

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self == [super init])
    {
        self.date = [aDecoder decodeObjectForKey:@"date"];
        self.isEvent = [aDecoder decodeBoolForKey:@"isEvent"];
        self.event = [aDecoder decodeObjectForKey:@"event"];
        self.announcement = [aDecoder decodeObjectForKey:@"announcement"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeBool:self.isEvent forKey:@"isEvent"];
    [aCoder encodeObject:self.event forKey:@"event"];
    [aCoder encodeObject:self.announcement forKey:@"announcement"];
}

-(NSComparisonResult)compare:(NewsFeedItem *)otherObject
{
    NSDate *date1 = self.date;
    NSDate *date2 = otherObject.date;
    NSTimeInterval interval1 = abs([date1 timeIntervalSinceNow]);
    NSTimeInterval interval2 = abs([date2 timeIntervalSinceNow]);
    if (interval1 == interval2)
    {
        return NSOrderedSame;
    }
    else if (interval1 > interval2)
    {
        return NSOrderedDescending;
    }
    else
    {
        return NSOrderedAscending;
    }
}

@end
