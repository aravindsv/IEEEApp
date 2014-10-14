//
//  Announcement.m
//  UCLA IEEE
//
//  Created by Aravind Vadali on 9/6/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import "Announcement.h"

@implementation Announcement

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.datePosted forKey:@"datePosted"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self == [super init])
    {
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.datePosted = [aDecoder decodeObjectForKey:@"datePosted"];
    }
    return self;
}

@end
