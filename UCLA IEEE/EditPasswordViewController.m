//
//  EditPasswordViewController.m
//  UCLA IEEE
//
//  Created by Aravind Vadali on 9/5/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import "EditPasswordViewController.h"
#import "DataManager.h"
#import "UserInfo.h"

@interface EditPasswordViewController ()
- (IBAction)saveButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtOldPass;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPass;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPassConfirm;

@end

@implementation EditPasswordViewController

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

- (IBAction)saveButton:(id)sender {
    if (_txtNewPass.text.length > 0)
    {
        if ([_txtNewPass.text isEqualToString:_txtNewPassConfirm.text])
        {
            UserInfo *user = [UserInfo sharedInstance];
        [DataManager changePasswordWithEmail:user.userMail Cookie:user.userCookie newPassword:_txtNewPass.text oldPassword:_txtOldPass.text onComplete:^{
            [self performSegueWithIdentifier:@"SaveChange" sender:self];
        }];
        }
        else
        {
            NSString *error;
            error = @"Passwords do not match!";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to edit" message:error delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            // optional - add more buttons:
            
            [alert show];
            return;
        }
    }
}
@end
