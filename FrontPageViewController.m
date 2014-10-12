//
//  FrontPageViewController.m
//  UCLA IEEE
//
//  Created by Aravind Vadali on 10/11/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import "FrontPageViewController.h"
#import "UserInfo.h"
#import "DataManager.h"
#import "Announcement.h"
#import "CalendarEvent.h"
#import "NewsFeedItem.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface FrontPageViewController ()

@property (nonatomic) int currentPoints;
@property (nonatomic) int totalPoints;
@property (strong, nonatomic) NSMutableArray* newsArray;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UITableView *newsFeed;

@end

@implementation FrontPageViewController


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [DataManager GetCalendarEventsOnComplete:^{
        [DataManager getAnnouncementsOnComplete:^{
            NSLog(@"==========================\n%@\n=================================", [UserInfo sharedInstance].newsFeedArray);
            [self reloadInfo];
        }];
    }];
    
    self.newsFeed.delegate = self;
    self.newsFeed.dataSource = self;
}

-(void)reloadInfo
{
    //Update Internal Info
    self.currentPoints = [UserInfo sharedInstance].currentPoints;
    self.totalPoints = [UserInfo sharedInstance].totalPoints;
    self.newsArray = [UserInfo sharedInstance].newsFeedArray;
    
    //Update Visual Info
    self.pointsLabel.text = [NSString stringWithFormat:@"%d/%d", self.currentPoints, self.totalPoints];
    [self.newsFeed reloadData];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NewsFeedItem *item = [self.newsArray objectAtIndex:indexPath.row];
    if (item.isEvent)
    {
        cell.imageView.image = [UIImage imageNamed:@"30pxCalendarIcon.png"];
        cell.textLabel.text = item.event.eventTitle;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"h:mm a"];
        NSString *eventTime = [formatter stringFromDate:item.event.eventDate];
        NSDateFormatter *d2s = [[NSDateFormatter alloc] init];
        [d2s setDateFormat:@"MMM d"];
        NSString *eventDate = [d2s stringFromDate:item.date];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ at %@\n%@", eventTime, item.event.eventLocation, eventDate];
    }
    else if (!item.isEvent)
    {
        cell.imageView.image = [UIImage imageNamed:@"30pxBellIcon.png"];
        cell.textLabel.text = item.announcement.content;
        NSDateFormatter *d2s = [[NSDateFormatter alloc] init];
        [d2s setDateFormat:@"MMM d"];
        cell.detailTextLabel.text = [d2s stringFromDate:item.date];
    }
    else
    {
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
    }
    
    [cell.textLabel setNumberOfLines:0];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [cell.detailTextLabel setNumberOfLines:0];
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"News Feed";
    label.textColor = [UIColor whiteColor];
    [label setFont:[UIFont boldSystemFontOfSize:26]];
    label.backgroundColor = UIColorFromRGB(0x2D8CEB);
    return label;
}


@end
