//
//  Event.h
//  UCLA IEEE
//
//  Created by Aravind Vadali on 9/10/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

+(Event *)currentEvent;

@property (strong, nonatomic) NSString *summary;
@property (strong, nonatomic) NSString *contact;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *eventID;
@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *endTime;

@end
