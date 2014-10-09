//
//  CalendarViewController.m
//  UCLA IEEE
//
//  Created by Aravind Vadali on 9/7/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import "CalendarViewController.h"
#import "MNCalendarView.h"

@interface CalendarViewController () <MNCalendarViewDelegate>

@property(nonatomic,strong) NSCalendar     *calendar;
@property(nonatomic,strong) MNCalendarView *calendarView;
@property(nonatomic,strong) NSDate         *currentDate;

@end

@implementation CalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentDate = [NSDate date];
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    self.calendarView = [[MNCalendarView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+50, self.view.bounds.size.width, self.view.bounds.size.height-200)];
    self.calendarView.calendar = self.calendar;
    self.calendarView.selectedDate = [NSDate date];
    self.calendarView.delegate = self;
    self.calendarView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.calendarView.backgroundColor = UIColor.whiteColor;
    
    [self.view addSubview:self.calendarView];
    // Do any additional setup after loading the view.
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.calendarView.collectionView.collectionViewLayout invalidateLayout];
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.calendarView reloadData];
}

#pragma mark - MNCalendarViewDelegate

- (void)calendarView:(MNCalendarView *)calendarView didSelectDate:(NSDate *)date {
    NSLog(@"date selected: %@", date);
}

- (BOOL)calendarView:(MNCalendarView *)calendarView shouldSelectDate:(NSDate *)date {
    NSTimeInterval timeInterval = [date timeIntervalSinceDate:self.currentDate];
    
    if (timeInterval > MN_WEEK && timeInterval < (MN_WEEK * 2)) {
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
