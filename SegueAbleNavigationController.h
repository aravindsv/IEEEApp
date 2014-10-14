//
//  SegueAbleNavigationController.h
//  UCLA IEEE
//
//  Created by Aravind Vadali on 10/12/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegueAbleNavigationController : UINavigationController

-(IBAction)unwindToProfile:(UIStoryboardSegue *)segue;

-(IBAction)unwindToLogin:(UIStoryboardSegue *)segue;


@end
