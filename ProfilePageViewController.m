//
//  ProfilePageViewController.m
//  UCLA IEEE
//
//  Created by Aravind Vadali on 9/4/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import "ProfilePageViewController.h"
#import "UserInfo.h"
#import "EditDetailsViewController.h"
#import "EventInfoViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ProfilePageViewController ()

@property (nonatomic, strong) NSMutableArray *eventsAttended;

@property (weak, nonatomic) NSString* detailToEdit;

@property (weak, nonatomic) IBOutlet UILabel *txtNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *txtEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *txtIDLabel;
@property (weak, nonatomic) IBOutlet UITableView *infoTable;


@end

@implementation ProfilePageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _txtNameLabel.text = [UserInfo sharedInstance].userName;
    _txtEmailLabel.text = [UserInfo sharedInstance].userMail;
    _txtIDLabel.text = [UserInfo sharedInstance].userId;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.infoTable.delegate = self;
    self.infoTable.dataSource = self;
    
    self.eventsAttended = [UserInfo sharedInstance].attendedEvents;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"EditDetails"])
    {
        EditDetailsViewController *view = (EditDetailsViewController *)[[segue destinationViewController] topViewController];
        view.detail = _detailToEdit;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    self.eventsAttended = [UserInfo sharedInstance].attendedEvents;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.infoTable reloadData];
    });
}


#pragma mark - UITableViewDelegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 7;
    else if (section == 1)
    {
        return self.eventsAttended.count;
    }
    else
        return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0)
    {
        static NSString *cellIdentifier = @"Info";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.textLabel.font = [UIFont systemFontOfSize:20];
        //cell.detailTextLabel.font = [UIFont systemFontOfSize:20];
    
        switch (indexPath.row)
        {
            case 0:
                cell.detailTextLabel.text = @"Email";
                cell.textLabel.text = [UserInfo sharedInstance].userMail;
                break;
            case 1:
                cell.detailTextLabel.text = @"Name";
                cell.textLabel.text = [UserInfo sharedInstance].userName;
                break;
            case 2:
                cell.detailTextLabel.text = @"Major";
                cell.textLabel.text = [UserInfo sharedInstance].userMajor;
                break;
            case 3:
                cell.detailTextLabel.text = @"Year";
                cell.textLabel.text = [UserInfo sharedInstance].userYear;
                
                break;
            case 4:
                cell.detailTextLabel.text = @"IEEE ID";
                cell.textLabel.text = [UserInfo sharedInstance].userId;
                break;
            case 5:
                cell.detailTextLabel.text = @"Points";
                cell.textLabel.text = [NSString stringWithFormat:@"%d/%d", [UserInfo sharedInstance].currentPoints, [UserInfo sharedInstance].totalPoints];
                break;
            case 6:
                cell.detailTextLabel.text = @"Password";
                cell.textLabel.text = @"";
                break;
        }
    }
    
    else if (indexPath.section == 1)
    {
        static NSString *cellIdentifier = @"pastEvents";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        CalendarEvent *event = [self.eventsAttended objectAtIndex:indexPath.row];
        cell.textLabel.text = event.eventTitle;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"h:mm a"];
        NSString *eventTime = [formatter stringFromDate:event.eventDate];
        [formatter setDateFormat:@"MMM d"];
        NSString *eventDay = [formatter stringFromDate:event.eventDate];
        if (event.eventLocation != nil)
        {
            NSString *eventLocation = event.eventLocation;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ at %@\n%@", eventTime, eventLocation, eventDay];
        }
        else
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@", eventTime, eventDay];
        }
    }
    
    else
    {
        static NSString *cellIdentifier = @"About";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = @"Help";
                cell.detailTextLabel.text = @"";
                break;
            case 1:
                cell.textLabel.text = @"Logout";
                cell.detailTextLabel.text = @"";
                break;
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
                _detailToEdit = @"Email";
                [self performSegueWithIdentifier:@"EditDetails" sender:self];
                break;
            case 1:
                _detailToEdit = @"Name";
                [self performSegueWithIdentifier:@"EditDetails" sender:self];
                break;
            case 2:
                _detailToEdit = @"Major";
                [self performSegueWithIdentifier:@"EditDetails" sender:self];
                break;
            case 3:
                _detailToEdit = @"Year";
                [self performSegueWithIdentifier:@"EditYear" sender:self];
                break;
            case 4:
                _detailToEdit = @"IEEE ID";
                [self performSegueWithIdentifier:@"EditDetails" sender:self];
                break;
            case 5:
                //Insert Segue to Info about points
                [self performSegueWithIdentifier:@"pointsInfo" sender:self];
                break;
            case 6:
                [self performSegueWithIdentifier:@"changePassword" sender:self];
                break;
                
        }
        
    }
    
    else if (indexPath.section == 1)
    {
        CalendarEvent *event = [self.eventsAttended objectAtIndex:indexPath.row];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        EventInfoViewController *infoView = [storyboard instantiateViewControllerWithIdentifier:@"infoPage"];
        infoView.currentEvent = event;
        [self.navigationController pushViewController:infoView animated:YES];
    }
    
    else
    {
        switch (indexPath.row)
        {
            case 0:
                //Segue to About Page
                [self performSegueWithIdentifier:@"AboutPage" sender:self];
                break;
            case 1:
                [[UserInfo sharedInstance] logOut];
                [self performSegueWithIdentifier:@"loggedOut" sender:self];
                break;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *header = [[UILabel alloc] init];
    header.textColor = [UIColor whiteColor];
    header.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20];
//    [header setFont:[UIFont boldSystemFontOfSize:16]];
    header.backgroundColor = UIColorFromRGB(0x00539E);
    if (section == 0)
    {
        header.text = @"    Membership Details";
    }
    else if (section == 1)
    {
        header.text = @"    Events Attended";
    }
    else if (section == 2)
    {
        header.text = @"    Options";
    }
    
    return header;
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
