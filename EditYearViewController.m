//
//  EditYearViewController.m
//  UCLA IEEE
//
//  Created by Aravind Vadali on 10/14/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import "EditYearViewController.h"
#import "DataManager.h"
#import "UserInfo.h"

@interface EditYearViewController ()
{
    NSArray *_pickerData;
}

@property (weak, nonatomic) IBOutlet UIPickerView *yearPicker;
@property (strong, nonatomic) NSString *txtYear;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
- (IBAction)saveEdit:(id)sender;

@end

@implementation EditYearViewController

-(void)viewDidLoad
{
    _pickerData = @[@"1st", @"2nd", @"3rd", @"4th", @"5th", @"Other"];
    _txtYear = @"1st";
    self.yearPicker.delegate = self;
    self.yearPicker.dataSource = self;
}

- (IBAction)saveEdit:(id)sender {
    [self.loadingIndicator startAnimating];
    [DataManager changeYearWithEmail:[UserInfo sharedInstance].userMail Cookie:[UserInfo sharedInstance].userCookie newYear:_txtYear onComplete:^{
        [self performSegueWithIdentifier:@"SaveChanges" sender:self];
        [self.loadingIndicator stopAnimating];
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



@end
