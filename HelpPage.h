//
//  HelpPage.h
//  UCLA IEEE
//
//  Created by Aravind Vadali on 10/13/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpPage : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *attributions;

@end
