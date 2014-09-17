//
//  Event.m
//  UCLA IEEE
//
//  Created by Aravind Vadali on 9/10/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import "Event.h"

@implementation Event

+(Event *)currentEvent
{
    static dispatch_once_t onceToken;
    static Event *shared = nil;
    dispatch_once(&onceToken, ^{
        shared = [[Event alloc] init];
    });
    return shared;
}

@end
