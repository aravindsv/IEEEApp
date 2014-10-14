//
//  LoginViewController.m
//  UCLA IEEE
//
//  Created by Aravind Vadali on 9/2/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import "LoginViewController.h"
#import "DataManager.h"
#import "UserInfo.h"

@interface LoginViewController ()

- (IBAction)loginButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
- (IBAction)backgroundClick:(id)sender;
-(IBAction)unwindToLogin:(UIStoryboardSegue *)segue;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
- (IBAction)forgotPassword:(id)sender;

@end

@implementation LoginViewController

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
    NSString *usrname = [[NSUserDefaults standardUserDefaults] valueForKey:@"Username"];
    NSString *password = [[NSUserDefaults standardUserDefaults] valueForKey:@"Password"];
    if (usrname != nil && password != nil)
    {
        
        [DataManager loginWithEmail:usrname Password:password onComplete:^{
            if ([UserInfo sharedInstance].isLoggedIn)
            {
                [self performSegueWithIdentifier:@"LoggedIn" sender:nil];
            }
        }];
    }
    // Do any additional setup after loading the view.
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

- (IBAction)loginButton:(id)sender {
    [_txtPassword resignFirstResponder];
    [_txtUsername resignFirstResponder];
    [self.loadingIndicator startAnimating];
    [DataManager loginWithEmail:_txtUsername.text Password:_txtPassword.text onComplete:^{
        if ([UserInfo sharedInstance].isLoggedIn)
        {
            [self.loadingIndicator stopAnimating];
            [self performSegueWithIdentifier:@"LoggedIn" sender:nil];
        }
    }];
}

- (IBAction)backgroundClick:(id)sender {
    [_txtPassword resignFirstResponder];
    [_txtUsername resignFirstResponder];
}

-(IBAction)unwindToLogin:(UIStoryboardSegue *)segue
{
    _txtPassword.text = @"";
    _txtUsername.text = @"";
}

- (IBAction)forgotPassword:(id)sender
{
    if (_txtUsername.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Forgot Your Password?" message:[NSString stringWithFormat:@"Enter your email to have a temporary password sent to you"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        // optional - add more buttons:
        [alert show];
        return;
    }
    [DataManager forgotPasswordWithEmail:_txtUsername.text onComplete:^{
        
    }];
}

@end
