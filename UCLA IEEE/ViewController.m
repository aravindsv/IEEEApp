//
//  ViewController.m
//  UCLA IEEE
//
//  Created by Aravind Vadali on 9/2/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import "ViewController.h"
#import "UserInfo.h"
#import "DataManager.h"

@interface ViewController ()
- (IBAction)loginButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
- (IBAction)backgroundClick:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButton:(id)sender {
    [DataManager loginWithEmail:_txtUsername.text Password:_txtPassword.text];
    if ([UserInfo sharedInstance].isLoggedIn)
    {
        //Move to Main Screen
    }
}

- (IBAction)backgroundClick:(id)sender {
    [_txtPassword resignFirstResponder];
    [_txtUsername resignFirstResponder];
}
@end
