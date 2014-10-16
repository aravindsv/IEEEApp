//
//  EventInfoViewController.m
//  UCLA IEEE
//
//  Created by Aravind Vadali on 10/15/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import "EventInfoViewController.h"
#import "CalendarEvent.h"

@interface EventInfoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *eventTitle;
@property (weak, nonatomic) IBOutlet UITextView *eventDescription;
@property (weak, nonatomic) IBOutlet UILabel *eventDate;
@property (weak, nonatomic) IBOutlet UILabel *eventTimings;
@property (weak, nonatomic) IBOutlet UILabel *eventLocation;
@property (weak, nonatomic) IBOutlet UITextView *contactInfo;



@end

@implementation EventInfoViewController

+(EventInfoViewController *)createInfoPageForEvent:(CalendarEvent *)event
{
    EventInfoViewController *view = [[EventInfoViewController alloc] init];
    view.currentEvent = event;
    return view;
}

-(void)viewDidLoad
{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.eventTitle.text = self.currentEvent.eventTitle;
    if ([self.currentEvent.eventDescription length] > 0)
    {
        self.eventDescription.text = self.currentEvent.eventDescription;
    }
    else
    {
        self.eventDescription.text = @"No description available";
    }
    self.eventLocation.text = self.currentEvent.eventLocation;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, yyyy"];
    self.eventDate.text = [formatter stringFromDate:self.currentEvent.eventDate];
    [formatter setDateFormat:@"h:mm a"];
    self.eventTimings.text = [NSString stringWithFormat:@"From %@ to %@", [formatter stringFromDate:self.currentEvent.eventDate], [formatter stringFromDate:self.currentEvent.eventEndTime]];
    self.contactInfo.text = [NSString stringWithFormat:@"For more information, please contact %@ at %@",self.currentEvent.eventCreatorName, self.currentEvent.eventCreatorEmail];
}

@end
