//
//  EventInfoViewController.h
//  UCLA IEEE
//
//  Created by Aravind Vadali on 10/15/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalendarEvent;

@interface EventInfoViewController : UIViewController

@property (strong, nonatomic) CalendarEvent *currentEvent;

+(EventInfoViewController *)createInfoPageForEvent:(CalendarEvent *)event;

@end
