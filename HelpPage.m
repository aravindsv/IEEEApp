//
//  HelpPage.m
//  UCLA IEEE
//
//  Created by Aravind Vadali on 10/13/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import "HelpPage.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation HelpPage

-(void)viewDidLoad
{
    self.attributions.delegate = self;
    self.attributions.dataSource = self;
    self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"Bullhorn icon designed by Shane Miller  from thenounproject.com";
            break;
        case 1:
            cell.textLabel.text = @"Calendar icon designed by Laurent Patain from thenounproject.com";
            break;
        case 2:
            cell.textLabel.text = @"Map Marker icon designed by Dmitry Baranovskiy from thenounproject.com";
            break;
        case 3:
            cell.textLabel.text = @"User icon designed by Richard Schumann from thenounproject.com";
            break;
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Attributions";
    label.textColor = [UIColor whiteColor];
    [label setFont:[UIFont boldSystemFontOfSize:16]];
    label.backgroundColor = UIColorFromRGB(0x003BA6);
    return label;
}



@end
