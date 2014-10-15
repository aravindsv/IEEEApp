//
//  LoginNavController.m
//  UCLA IEEE
//
//  Created by Aravind Vadali on 10/14/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import "LoginNavController.h"

@implementation LoginNavController

-(IBAction)unwindToLogin:(UIStoryboardSegue *)segue
{
    NSLog(@"Segue-ing to login with custom controller");
}

@end
