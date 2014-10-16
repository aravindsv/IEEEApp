//
//  CalendarViewController.m
//  UCLA IEEE
//
//  Created by Aravind Vadali on 9/7/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import "CalendarViewController.h"
#import "MNCalendarView.h"
#import "DataManager.h"
#import "UserInfo.h"
#import "CalendarEvent.h"
#import "EventInfoViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface CalendarViewController () <MNCalendarViewDelegate>

@property(nonatomic,strong) NSCalendar     *calendar;
@property(nonatomic,strong) MNCalendarView *calendarView;
@property(nonatomic,strong) NSDate         *currentDate;
@property(nonatomic,strong) NSDate         *selectedDate;
@property(nonatomic) NSMutableDictionary    *eventsDict;
@property(nonatomic) NSMutableArray         *chosenDayEvents;
@property (weak, nonatomic) IBOutlet UITableView *eventListing;

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
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //Set Up Calendar
    self.currentDate = [NSDate date];
    self.selectedDate = [NSDate date];
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    self.calendarView = [[MNCalendarView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+65, self.view.bounds.size.width, self.view.bounds.size.height-230)];
    self.calendarView.calendar = self.calendar;
    self.calendarView.selectedDate = [NSDate date];
    self.calendarView.delegate = self;
    self.calendarView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.calendarView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.calendarView];
    
    //Set up event Listing table
    self.eventListing.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    self.eventListing.delegate = self;
    self.eventListing.dataSource = self;
    self.chosenDayEvents = [[NSMutableArray alloc] init];
    
    NSMutableArray *events = [DataManager getEventsForDate:self.currentDate];
    self.chosenDayEvents = events;
    
    [self.calendarView reloadData];
    [self.eventListing reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.calendarView reloadData];
    [self.eventListing reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.eventListing reloadData];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MNCalendar setup

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.calendarView.collectionView.collectionViewLayout invalidateLayout];
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.calendarView reloadData];
}

#pragma mark - MNCalendarViewDelegate

- (void)calendarView:(MNCalendarView *)calendarView didSelectDate:(NSDate *)date {
    NSLog(@"Events for date:");
    self.selectedDate = date;
    NSMutableArray *events = [DataManager getEventsForDate:date];
    for (CalendarEvent *event in events)
    {
        NSLog(@"%@\n%@ at %@", event.eventTitle, event.eventDate, event.eventLocation);
    }
    self.chosenDayEvents = events;
    [self.eventListing reloadData];
}

- (BOOL)calendarView:(MNCalendarView *)calendarView shouldSelectDate:(NSDate *)date {
    
    NSMutableArray *eventsForDate = [DataManager getEventsForDate:date];
    if ([eventsForDate count] == 0)
    {
        return NO;
    }
    else
    {
        return YES;
    }    
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int num = [self.chosenDayEvents count];
    if (num <= 1)
    {
        self.eventListing.separatorStyle=UITableViewCellSeparatorStyleNone;
        return 1;
    }
    else
    {
        self.eventListing.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        return num;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if ([self.chosenDayEvents count] != 0)
    {
        CalendarEvent *event = [self.chosenDayEvents objectAtIndex:indexPath.row];
        NSString *title = event.eventTitle;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"h:mm a"];
        NSString *eventTime = [formatter stringFromDate:event.eventDate];
        NSString *detail;
        if (event.eventLocation != nil)
        {
            detail = [NSString stringWithFormat:@"%@ at %@", eventTime, event.eventLocation];
        }
        else
        {
            detail = [NSString stringWithFormat:@"%@", eventTime];
        }
        cell.textLabel.text = title;
        cell.detailTextLabel.text = detail;
    }
    else
    {
        cell.textLabel.text = @"There are no events today";
        cell.detailTextLabel.text = @"";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.chosenDayEvents.count > 0)
    {
        CalendarEvent *event = [self.chosenDayEvents objectAtIndex:indexPath.row];
//        EventInfoViewController *infoView = [EventInfoViewController createInfoPageForEvent:event];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        EventInfoViewController *infoView = [storyboard instantiateViewControllerWithIdentifier:@"infoPage"];
        infoView.currentEvent = event;
        [self.navigationController pushViewController:infoView animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM d, yyyy"];
    NSString *dateString = [formatter stringFromDate:self.selectedDate];
    label.text = [NSString stringWithFormat:@"    Events for %@", dateString];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20];
//    [label setFont:[UIFont boldSystemFontOfSize:16]];
    label.backgroundColor = UIColorFromRGB(0x003BA6);
    return label;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
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
