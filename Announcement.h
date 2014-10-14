//
//  Announcement.h
//  UCLA IEEE
//
//  Created by Aravind Vadali on 9/6/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Announcement : NSObject <NSCoding>

@property (strong, nonatomic) NSString* content;
@property (strong, nonatomic) NSString* datePosted;

@end
