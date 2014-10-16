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
#import "EventInfoViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface FrontPageViewController ()

@property (nonatomic) int currentPoints;
@property (nonatomic) int totalPoints;
@property (strong, nonatomic) NSMutableArray* newsArray;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UITableView *newsFeed;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadIndicator;

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
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.pointsLabel setHidden:YES];
    [DataManager GetCalendarEventsOnComplete:^{
        [DataManager getAnnouncementsOnComplete:^{
            [DataManager GetAttendedEventsOnComplete:^{
                [[UserInfo sharedInstance] saveUserToUserDefaults];
            }];
            [self reloadInfo];
            [self.pointsLabel setHidden:NO];
            [self.loadIndicator stopAnimating];
        }];
    }];
    
    self.newsFeed.delegate = self;
    self.newsFeed.dataSource = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self reloadInfo];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.newsFeed reloadData];
    });
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
    if (self.newsArray.count < 10)
    {
        return self.newsArray.count;
    }
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NewsFeedItem *item = [self.newsArray objectAtIndex:indexPath.row];
    if (item.isEvent)
    {
        cell.imageView.image = [UIImage imageNamed:@"calendar_30px.png"];
        cell.textLabel.text = item.event.eventTitle;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"h:mm a"];
        NSString *eventTime = [formatter stringFromDate:item.event.eventDate];
        NSDateFormatter *d2s = [[NSDateFormatter alloc] init];
        [d2s setDateFormat:@"MMM d"];
        NSString *eventDate = [d2s stringFromDate:item.date];
        if (item.event.eventLocation != nil)
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ at %@\n%@", eventTime, item.event.eventLocation, eventDate];
        }
        else
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@", eventTime, eventDate];
        }
    }
    else if (!item.isEvent)
    {
        cell.imageView.image = [UIImage imageNamed:@"bullhorn_30px.png"];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsFeedItem *item = [self.newsArray objectAtIndex:indexPath.row];
    if (item.isEvent)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        EventInfoViewController *infoView = [storyboard instantiateViewControllerWithIdentifier:@"infoPage"];
        infoView.currentEvent = item.event;
        [self.navigationController pushViewController:infoView animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"    News Feed";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20];
//    [label setFont:[UIFont boldSystemFontOfSize:26]];  HelveticaNeue-Thin
    label.backgroundColor = UIColorFromRGB(0x003BA6);
    return label;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}


@end
