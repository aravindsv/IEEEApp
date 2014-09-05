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

@interface ProfilePageViewController ()

@property (weak, nonatomic) NSString* detailToEdit;

@property (weak, nonatomic) IBOutlet UILabel *txtNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *txtEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *txtIDLabel;

- (IBAction)logoutPressed:(id)sender;
- (IBAction)nameEdit:(id)sender;
- (IBAction)emailEdit:(id)sender;
- (IBAction)IDEdit:(id)sender;

-(IBAction)unwindToProfile:(UIStoryboardSegue *)segue;

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

-(IBAction)logoutPressed:(id)sender
{
    [UserInfo sharedInstance].isLoggedIn = NO;
}

- (IBAction)nameEdit:(id)sender {
    _detailToEdit = @"Name";
    [self performSegueWithIdentifier:@"EditDetails" sender:self];
}

- (IBAction)emailEdit:(id)sender {
    _detailToEdit = @"Email";
    [self performSegueWithIdentifier:@"EditDetails" sender:self];
}

- (IBAction)IDEdit:(id)sender {
    _detailToEdit = @"IEEE ID";
    [self performSegueWithIdentifier:@"EditDetails" sender:self];
}

-(IBAction)unwindToProfile:(UIStoryboardSegue *)segue
{
    _txtNameLabel.text = [UserInfo sharedInstance].userName;
    _txtEmailLabel.text = [UserInfo sharedInstance].userMail;
    _txtIDLabel.text = [UserInfo sharedInstance].userId;
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
