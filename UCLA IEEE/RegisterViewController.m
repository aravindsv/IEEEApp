//
//  RegisterViewController.m
//  UCLA IEEE
//
//  Created by Aravind Vadali on 9/2/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import "RegisterViewController.h"
#import "DataManager.h"
#import "UserInfo.h"

@interface RegisterViewController ()
{
    NSArray *_pickerData;
}

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtPasswordConfirm;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
- (IBAction)AttemptRegistration:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtMajor;
@property (strong, nonatomic) NSString *txtYear;
@property (weak, nonatomic) IBOutlet UIPickerView *yearPicker;

@end

@implementation RegisterViewController

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
    
    _pickerData = @[@"1st", @"2nd", @"3rd", @"4th", @"5th", @"Other"];
    _txtYear = @"1st";
    self.yearPicker.dataSource = self;
    self.yearPicker.delegate = self;
    
    self.yearPicker.transform = CGAffineTransformMakeScale(1, 1);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)AttemptRegistration:(id)sender
{
    NSString *password = _txtPassword.text;
    NSString *rePassword = _txtPasswordConfirm.text;
    NSString *error;
    if (![password isEqualToString:rePassword])
    {
        error = @"Passwords do not match!";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to register" message:error delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        // optional - add more buttons:
        
        [alert show];
        return;
    }
    if (_txtEmail.text.length == 0 || _txtFirstName.text.length == 0 || _txtLastName.text.length == 0 || _txtMajor.text.length == 0 || _txtPassword.text.length == 0 || _txtPasswordConfirm.text.length == 0)
    {
        error = @"Some fields were left empty!";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to register" message:error delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        // optional - add more buttons:
        
        [alert show];
        return;
    }
    [DataManager registerWithEmail:_txtEmail.text Firstname:_txtFirstName.text Lastname:_txtLastName.text Password:password year:_txtYear major:_txtMajor.text onComplete:^{
        if ([UserInfo sharedInstance].isLoggedIn)
        {
            [self performSegueWithIdentifier:@"Registered" sender:nil];
        }
    }];
}

#pragma mark - UIPickerView Delegate Methods

-(int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_pickerData objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _txtYear = [_pickerData objectAtIndex:row];
}

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
    
    
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
