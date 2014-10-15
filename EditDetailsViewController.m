//
//  EditDetailsViewController.m
//  UCLA IEEE
//
//  Created by Aravind Vadali on 9/4/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import "EditDetailsViewController.h"
#import "UserInfo.h"
#import "DataManager.h"

@interface EditDetailsViewController ()

@property (weak, nonatomic) IBOutlet UINavigationItem *NavigationBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelbutton;
- (IBAction)saveEdit:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtDetail;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end

@implementation EditDetailsViewController

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
    _NavigationBar.title = [NSString stringWithFormat:@"Edit %@", _detail];
    _txtDetail.placeholder = [NSString stringWithFormat:@"New %@", _detail];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Nothing
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

- (IBAction)saveEdit:(id)sender {
    if (_txtDetail.text.length > 0)
    {
        [self.loadingIndicator startAnimating];
        UserInfo *user = [UserInfo sharedInstance];
        if ([_detail isEqualToString:@"Name"])
        {
            [DataManager changeNameWithEmail:user.userMail Cookie:user.userCookie newName:_txtDetail.text onComplete:^{
                [self performSegueWithIdentifier:@"SaveChanges" sender:self];
                [self.loadingIndicator stopAnimating];
            }];
        }
        else if ([_detail isEqualToString:@"IEEE ID"])
        {
            [DataManager changeIDWithEmail:user.userMail Cookie:user.userCookie newID:_txtDetail.text onComplete:^{
                [self performSegueWithIdentifier:@"SaveChanges" sender:self];
                [self.loadingIndicator stopAnimating];
            }];
        }
        else if ([_detail isEqualToString:@"Email"])
        {
            [DataManager changeEmailWithEmail:user.userMail Cookie:user.userCookie newEmail:_txtDetail.text onComplete:^{
                [self performSegueWithIdentifier:@"SaveChanges" sender:self];
                [self.loadingIndicator stopAnimating];
            }];
        }
        else if ([self.detail isEqualToString:@"Major"])
        {
            [DataManager changeMajorWithEmail:user.userMail Cookie:user.userCookie newMajor:_txtDetail.text onComplete:^{
                [self performSegueWithIdentifier:@"SaveChanges" sender:self];
                [self.loadingIndicator stopAnimating];
            }];
        }
        else if ([self.detail isEqualToString:@"Year"])
        {
            [DataManager changeYearWithEmail:user.userMail Cookie:user.userCookie newYear:_txtDetail.text onComplete:^{
                [self performSegueWithIdentifier:@"SaveChanges" sender:self];
                [self.loadingIndicator stopAnimating];
            }];
        }
    }
    else if (_txtDetail.text.length > 0)
    {
        NSString *error;
        error = @"Fields do not match!";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to edit" message:error delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        // optional - add more buttons:
        
        [alert show];
        return;
    }
}

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
    
    
}
@end
