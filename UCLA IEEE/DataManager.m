//
//  DataManager.m
//  LoginTest
//
//  Created by Aravind Vadali on 8/30/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import "DataManager.h"
#import "UserInfo.h"
#import "Announcement.h"
#import "Event.h"
#import "Reachability.h"
#import "CalendarEvent.h"


@implementation DataManager

#pragma mark - Login/Register

+(void)loginWithEmail:(NSString *)email Password:(NSString *)password onComplete:(void (^)(void))callbackBlock
{
    
    if (![self connectedToInternet])
    {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:@"http://ieeebruins.org/membership_serve/users.php"];
    
    NSData *body = nil;
    
    NSString *contentType = @"application/x-www-form-urlencoded; charset=utf-8";
    
    
    body = [[NSString stringWithFormat:@"service=login&email=%@&password=%@", email, password] dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *putLength = [NSString stringWithFormat:@"%lu",(unsigned long)[body length]];
    
    
    NSMutableDictionary* headers = [[NSMutableDictionary alloc] init];
    [headers setValue:contentType forKey:@"Content-Type"];
    //    [headers setValue:@"mimeType" forKey:@"Accept"];
    //    [headers setValue:@"no-cache" forKey:@"Cache-Control"];
    //    [headers setValue:@"no-cache" forKey:@"Pragma"];
    //    [headers setValue:@"close" forKey:@"Connection"];
    
    
    
    
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    
    [request setAllHTTPHeaderFields:headers];
    
    
    [request setHTTPBody:body];
    [request setValue:putLength forHTTPHeaderField:@"Content-Length"];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                                               options:0
                                                                 error:NULL];
        
        int success = [[result objectForKey:@"success"] intValue];
        if (success) {
            UserInfo* userInfo  = [UserInfo sharedInstance];
            NSDictionary* userObj = [result objectForKey:@"user"];
            userInfo.userName = [userObj objectForKey:@"name"];
            userInfo.userId = [userObj objectForKey:@"ieee_id"];
            userInfo.isLoggedIn = YES;
            userInfo.userMail = [userObj objectForKey:@"email"];
            userInfo.userCookie = [result objectForKey:@"cookie"];
            userInfo.currentPoints = [[userObj objectForKey:@"points"] intValue];
            userInfo.totalPoints = [[userObj objectForKey:@"total_points"] intValue];
            userInfo.userMajor = [userObj objectForKey:@"major"];
            userInfo.userYear = [userObj objectForKey:@"year"];
            [[NSUserDefaults standardUserDefaults] setValue:email forKey:@"Username"];
            [[NSUserDefaults standardUserDefaults] setValue:password forKey:@"Password"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            callbackBlock();
        }
        else {
            [[UserInfo sharedInstance]logOut];
            NSString *error = [result objectForKey:@"error_message"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't Login!" message:error delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            // optional - add more buttons:
            [alert show];
            callbackBlock();
        }
        NSLog(@"Result %@", result);
    }];
}

+(void)registerWithEmail:(NSString *)email Firstname:(NSString *)firstname Lastname:(NSString *)lastname Password:(NSString *)password year:(NSString *)year major:(NSString *)major onComplete:(void (^)(void))callbackBlock
{
    if (![self connectedToInternet])
    {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:@"http://ieeebruins.org/membership_serve/users.php"];
    
    NSData *body = nil;
    
    NSString *contentType = @"application/x-www-form-urlencoded; charset=utf-8";
    
    
    body = [[NSString stringWithFormat:@"service=register&email=%@&password=%@&firstname=%@&lastname=%@&year=%@&major=%@", email, password, firstname, lastname, year, major] dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *putLength = [NSString stringWithFormat:@"%lu",(unsigned long)[body length]];
    
    
    NSMutableDictionary* headers = [[NSMutableDictionary alloc] init];
    [headers setValue:contentType forKey:@"Content-Type"];
    //    [headers setValue:@"mimeType" forKey:@"Accept"];
    //    [headers setValue:@"no-cache" forKey:@"Cache-Control"];
    //    [headers setValue:@"no-cache" forKey:@"Pragma"];
    //    [headers setValue:@"close" forKey:@"Connection"];
    
    
    
    
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    
    [request setAllHTTPHeaderFields:headers];
    
    
    [request setHTTPBody:body];
    [request setValue:putLength forHTTPHeaderField:@"Content-Length"];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                                               options:0
                                                                 error:NULL];
        
        int success = [[result objectForKey:@"success"] intValue];
        if (success) {
            UserInfo* userInfo  = [UserInfo sharedInstance];
            NSDictionary* userObj = [result objectForKey:@"user"];
            userInfo.userName = [userObj objectForKey:@"name"];
            userInfo.userId = [userObj objectForKey:@"ieee_id"];
            userInfo.isLoggedIn = YES;
            userInfo.userMail = [userObj objectForKey:@"email"];
            userInfo.userCookie = [userObj objectForKey:@"cookie"];
            userInfo.currentPoints = [[userObj objectForKey:@"points"] intValue];
            userInfo.totalPoints = [[userObj objectForKey:@"total_points"] intValue];
            userInfo.userMajor = [userObj objectForKey:@"major"];
            userInfo.userYear = [userObj objectForKey:@"year"];
            callbackBlock();
        }
        else {
            [[UserInfo sharedInstance] logOut];
            NSString *error = [result objectForKey:@"error_message"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't Register!" message:error delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            // optional - add more buttons:
            [alert show];
            callbackBlock();
        }
        NSLog(@"Result %@", result);
    }];
}

#pragma mark - Edit Membership

+(void)changeEmailWithEmail:(NSString *)email Cookie:(NSString *)cookie newEmail:(NSString *)newEmail onComplete:(void (^)(void))callbackBlock
{
    if (![self connectedToInternet])
    {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:@"http://ieeebruins.org/membership_serve/users.php"];
    
    NSData *body = nil;
    
    NSString *contentType = @"application/x-www-form-urlencoded; charset=utf-8";
    
    
    body = [[NSString stringWithFormat:@"service=edit_member&email=%@&cookie=%@&newEmail=%@", email, cookie, newEmail] dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *putLength = [NSString stringWithFormat:@"%lu",(unsigned long)[body length]];
    
    
    NSMutableDictionary* headers = [[NSMutableDictionary alloc] init];
    [headers setValue:contentType forKey:@"Content-Type"];
    //    [headers setValue:@"mimeType" forKey:@"Accept"];
    //    [headers setValue:@"no-cache" forKey:@"Cache-Control"];
    //    [headers setValue:@"no-cache" forKey:@"Pragma"];
    //    [headers setValue:@"close" forKey:@"Connection"];
    
    
    
    
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    
    [request setAllHTTPHeaderFields:headers];
    
    
    [request setHTTPBody:body];
    [request setValue:putLength forHTTPHeaderField:@"Content-Length"];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                                               options:0
                                                                 error:NULL];
        
        int success = [[result objectForKey:@"success"] intValue];
        if (success) {
            UserInfo* userInfo  = [UserInfo sharedInstance];
            NSDictionary* userObj = [result objectForKey:@"user"];
            userInfo.userName = [userObj objectForKey:@"name"];
            userInfo.userId = [userObj objectForKey:@"ieee_id"];
            userInfo.isLoggedIn = YES;
            userInfo.userMail = [userObj objectForKey:@"email"];
            userInfo.currentPoints = [[userObj objectForKey:@"points"] intValue];
            userInfo.totalPoints = [[userObj objectForKey:@"total_points"] intValue];
            userInfo.userMajor = [userObj objectForKey:@"major"];
            userInfo.userYear = [userObj objectForKey:@"year"];
//            userInfo.userCo   okie = [result objectForKey:@"cookie"];
            callbackBlock();
        }
        else {
            NSString *error = [result objectForKey:@"error_message"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't Edit!" message:error delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            // optional - add more buttons:
            
            [alert show];
            callbackBlock();
        }
        NSLog(@"Result %@", result);
    }];
}

+(void)changeIDWithEmail:(NSString *)email Cookie:(NSString *)cookie newID:(NSString *)newID onComplete:(void (^)(void))callbackBlock
{
    if (![self connectedToInternet])
    {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:@"http://ieeebruins.org/membership_serve/users.php"];
    
    NSData *body = nil;
    
    NSString *contentType = @"application/x-www-form-urlencoded; charset=utf-8";
    
    
    body = [[NSString stringWithFormat:@"service=edit_member&email=%@&cookie=%@&newId=%@", email, cookie, newID] dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *putLength = [NSString stringWithFormat:@"%lu",(unsigned long)[body length]];
    
    
    NSMutableDictionary* headers = [[NSMutableDictionary alloc] init];
    [headers setValue:contentType forKey:@"Content-Type"];
    //    [headers setValue:@"mimeType" forKey:@"Accept"];
    //    [headers setValue:@"no-cache" forKey:@"Cache-Control"];
    //    [headers setValue:@"no-cache" forKey:@"Pragma"];
    //    [headers setValue:@"close" forKey:@"Connection"];
    
    
    
    
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    
    [request setAllHTTPHeaderFields:headers];
    
    
    [request setHTTPBody:body];
    [request setValue:putLength forHTTPHeaderField:@"Content-Length"];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                                               options:0
                                                                 error:NULL];
        
        int success = [[result objectForKey:@"success"] intValue];
        if (success) {
            UserInfo* userInfo  = [UserInfo sharedInstance];
            NSDictionary* userObj = [result objectForKey:@"user"];
            userInfo.userName = [userObj objectForKey:@"name"];
            userInfo.userId = [userObj objectForKey:@"ieee_id"];
            userInfo.isLoggedIn = YES;
            userInfo.userMail = [userObj objectForKey:@"email"];
            userInfo.currentPoints = [[userObj objectForKey:@"points"] intValue];
            userInfo.totalPoints = [[userObj objectForKey:@"total_points"] intValue];
            userInfo.userMajor = [userObj objectForKey:@"major"];
            userInfo.userYear = [userObj objectForKey:@"year"];
//            userInfo.userCookie = [result objectForKey:@"cookie"];
            callbackBlock();
        }
        else {
            NSString *error = [result objectForKey:@"error_message"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't Edit!" message:error delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            // optional - add more buttons:
            
            [alert show];
            callbackBlock();
        }
        NSLog(@"Result %@", result);
    }];
}

+(void)changeNameWithEmail:(NSString *)email Cookie:(NSString *)cookie newName:(NSString *)newName onComplete:(void (^)(void))callbackBlock
{
    if (![self connectedToInternet])
    {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:@"http://ieeebruins.org/membership_serve/users.php"];
    
    NSData *body = nil;
    
    NSString *contentType = @"application/x-www-form-urlencoded; charset=utf-8";
    
    
    body = [[NSString stringWithFormat:@"service=edit_member&email=%@&cookie=%@&newName=%@", email, cookie, newName] dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *putLength = [NSString stringWithFormat:@"%lu",(unsigned long)[body length]];
    
    
    NSMutableDictionary* headers = [[NSMutableDictionary alloc] init];
    [headers setValue:contentType forKey:@"Content-Type"];
    //    [headers setValue:@"mimeType" forKey:@"Accept"];
    //    [headers setValue:@"no-cache" forKey:@"Cache-Control"];
    //    [headers setValue:@"no-cache" forKey:@"Pragma"];
    //    [headers setValue:@"close" forKey:@"Connection"];
    
    
    
    
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    
    [request setAllHTTPHeaderFields:headers];
    
    
    [request setHTTPBody:body];
    [request setValue:putLength forHTTPHeaderField:@"Content-Length"];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                                               options:0
                                                                 error:NULL];
        
        int success = [[result objectForKey:@"success"] intValue];
        if (success) {
            UserInfo* userInfo  = [UserInfo sharedInstance];
            NSDictionary* userObj = [result objectForKey:@"user"];
            userInfo.userName = [userObj objectForKey:@"name"];
            userInfo.userId = [userObj objectForKey:@"ieee_id"];
            userInfo.isLoggedIn = YES;
            userInfo.userMail = [userObj objectForKey:@"email"];
            userInfo.currentPoints = [[userObj objectForKey:@"points"] intValue];
            userInfo.totalPoints = [[userObj objectForKey:@"total_points"] intValue];
            userInfo.userMajor = [userObj objectForKey:@"major"];
            userInfo.userYear = [userObj objectForKey:@"year"];
//            userInfo.userCookie = [result objectForKey:@"cookie"];
            callbackBlock();
        }
        else {
            NSString *error = [result objectForKey:@"error_message"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't Edit!" message:error delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            // optional - add more buttons:
            
            [alert show];
            callbackBlock();
        }
        NSLog(@"Result %@", result);
    }];
}

+(void)changePasswordWithEmail:(NSString *)email Cookie:(NSString *)cookie newPassword:(NSString *)newPass oldPassword:(NSString *)oldPass onComplete:(void (^)(void))callbackBlock
{
    if (![self connectedToInternet])
    {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:@"http://ieeebruins.org/membership_serve/users.php"];
    
    NSData *body = nil;
    
    NSString *contentType = @"application/x-www-form-urlencoded; charset=utf-8";
    
    
    body = [[NSString stringWithFormat:@"service=edit_member&email=%@&cookie=%@&newPassword=%@&password=%@", email, cookie, newPass, oldPass] dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *putLength = [NSString stringWithFormat:@"%lu",(unsigned long)[body length]];
    
    
    NSMutableDictionary* headers = [[NSMutableDictionary alloc] init];
    [headers setValue:contentType forKey:@"Content-Type"];
    //    [headers setValue:@"mimeType" forKey:@"Accept"];
    //    [headers setValue:@"no-cache" forKey:@"Cache-Control"];
    //    [headers setValue:@"no-cache" forKey:@"Pragma"];
    //    [headers setValue:@"close" forKey:@"Connection"];
    
    
    
    
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    
    [request setAllHTTPHeaderFields:headers];
    
    
    [request setHTTPBody:body];
    [request setValue:putLength forHTTPHeaderField:@"Content-Length"];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                                               options:0
                                                                 error:NULL];
        
        int success = [[result objectForKey:@"success"] intValue];
        if (success) {
            UserInfo* userInfo  = [UserInfo sharedInstance];
            NSDictionary* userObj = [result objectForKey:@"user"];
            userInfo.userName = [userObj objectForKey:@"name"];
            userInfo.userId = [userObj objectForKey:@"ieee_id"];
            userInfo.isLoggedIn = YES;
            userInfo.userMail = [userObj objectForKey:@"email"];
            userInfo.currentPoints = [[userObj objectForKey:@"points"] intValue];
            userInfo.totalPoints = [[userObj objectForKey:@"total_points"] intValue];
            userInfo.userMajor = [userObj objectForKey:@"major"];
            userInfo.userYear = [userObj objectForKey:@"year"];
//            userInfo.userCookie = [result objectForKey:@"cookie"];
            callbackBlock();
        }
        else {
            NSString *error = [result objectForKey:@"error_message"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't Edit!" message:error delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            // optional - add more buttons:
            
            [alert show];
            callbackBlock();
        }
        NSLog(@"Result %@", result);
    }];
}

+(void)changeMajorWithEmail:(NSString *)email Cookie:(NSString *)cookie newMajor:(NSString *)newMajor onComplete:(void (^)(void))callbackBlock
{
    if (![self connectedToInternet])
    {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:@"http://ieeebruins.org/membership_serve/users.php"];
    
    NSData *body = nil;
    
    NSString *contentType = @"application/x-www-form-urlencoded; charset=utf-8";
    
    
    body = [[NSString stringWithFormat:@"service=edit_member&email=%@&cookie=%@&newMajor=%@", email, cookie, newMajor] dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *putLength = [NSString stringWithFormat:@"%lu",(unsigned long)[body length]];
    
    
    NSMutableDictionary* headers = [[NSMutableDictionary alloc] init];
    [headers setValue:contentType forKey:@"Content-Type"];
    //    [headers setValue:@"mimeType" forKey:@"Accept"];
    //    [headers setValue:@"no-cache" forKey:@"Cache-Control"];
    //    [headers setValue:@"no-cache" forKey:@"Pragma"];
    //    [headers setValue:@"close" forKey:@"Connection"];
    
    
    
    
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    
    [request setAllHTTPHeaderFields:headers];
    
    
    [request setHTTPBody:body];
    [request setValue:putLength forHTTPHeaderField:@"Content-Length"];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                                               options:0
                                                                 error:NULL];
        
        int success = [[result objectForKey:@"success"] intValue];
        if (success) {
            UserInfo* userInfo  = [UserInfo sharedInstance];
            NSDictionary* userObj = [result objectForKey:@"user"];
            userInfo.userName = [userObj objectForKey:@"name"];
            userInfo.userId = [userObj objectForKey:@"ieee_id"];
            userInfo.isLoggedIn = YES;
            userInfo.userMail = [userObj objectForKey:@"email"];
            userInfo.currentPoints = [[userObj objectForKey:@"points"] intValue];
            userInfo.totalPoints = [[userObj objectForKey:@"total_points"] intValue];
            userInfo.userMajor = [userObj objectForKey:@"major"];
            userInfo.userYear = [userObj objectForKey:@"year"];
            //            userInfo.userCookie = [result objectForKey:@"cookie"];
            callbackBlock();
        }
        else {
            NSString *error = [result objectForKey:@"error_message"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't Edit!" message:error delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            // optional - add more buttons:
            
            [alert show];
            callbackBlock();
        }
        NSLog(@"Result %@", result);
    }];
}

+(void)changeYearWithEmail:(NSString *)email Cookie:(NSString *)cookie newYear:(NSString *)newYear onComplete:(void (^)(void))callbackBlock
{
    if (![self connectedToInternet])
    {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:@"http://ieeebruins.org/membership_serve/users.php"];
    
    NSData *body = nil;
    
    NSString *contentType = @"application/x-www-form-urlencoded; charset=utf-8";
    
    
    body = [[NSString stringWithFormat:@"service=edit_member&email=%@&cookie=%@&newYear=%@", email, cookie, newYear] dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *putLength = [NSString stringWithFormat:@"%lu",(unsigned long)[body length]];
    
    
    NSMutableDictionary* headers = [[NSMutableDictionary alloc] init];
    [headers setValue:contentType forKey:@"Content-Type"];
    //    [headers setValue:@"mimeType" forKey:@"Accept"];
    //    [headers setValue:@"no-cache" forKey:@"Cache-Control"];
    //    [headers setValue:@"no-cache" forKey:@"Pragma"];
    //    [headers setValue:@"close" forKey:@"Connection"];
    
    
    
    
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    
    [request setAllHTTPHeaderFields:headers];
    
    
    [request setHTTPBody:body];
    [request setValue:putLength forHTTPHeaderField:@"Content-Length"];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                                               options:0
                                                                 error:NULL];
        
        int success = [[result objectForKey:@"success"] intValue];
        if (success) {
            UserInfo* userInfo  = [UserInfo sharedInstance];
            NSDictionary* userObj = [result objectForKey:@"user"];
            userInfo.userName = [userObj objectForKey:@"name"];
            userInfo.userId = [userObj objectForKey:@"ieee_id"];
            userInfo.isLoggedIn = YES;
            userInfo.userMail = [userObj objectForKey:@"email"];
            userInfo.currentPoints = [[userObj objectForKey:@"points"] intValue];
            userInfo.totalPoints = [[userObj objectForKey:@"total_points"] intValue];
            userInfo.userMajor = [userObj objectForKey:@"major"];
            userInfo.userYear = [userObj objectForKey:@"year"];
            //            userInfo.userCookie = [result objectForKey:@"cookie"];
            callbackBlock();
        }
        else {
            NSString *error = [result objectForKey:@"error_message"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't Edit!" message:error delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            // optional - add more buttons:
            
            [alert show];
            callbackBlock();
        }
        NSLog(@"Result %@", result);
    }];
}

#pragma mark - Get Information

+(void)getAnnouncementsOnComplete:(void (^)(void))callbackBlock
{
    if (![self connectedToInternet])
    {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:@"http://ieeebruins.org/membership_serve/announcements.php"];
    
    NSString *contentType = @"text/plain; charset=utf-8";
    
    NSMutableDictionary* headers = [[NSMutableDictionary alloc] init];
    [headers setValue:contentType forKey:@"Content-Type"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"GET"];

    [request setAllHTTPHeaderFields:headers];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                                               options:0
                                                                 error:NULL];

        for (NSDictionary *dict in result)
        {
            Announcement *newAnnouncement = [[Announcement alloc] init];
            newAnnouncement.content = [dict valueForKey:@"content"];
            newAnnouncement.datePosted = [dict valueForKey:@"datePosted"];
            [[UserInfo sharedInstance].announcements addObject:newAnnouncement];
            [[UserInfo sharedInstance] addAnnouncementToNewsFeedArray:newAnnouncement];
        }
        callbackBlock();
        NSLog(@"Result %@", result);
    }];
}

+(void)checkInToEvent:(NSString *)eventCode withEmail:(NSString *)email andCookie:(NSString *)cookie onComplete:(void (^)(void))callbackBlock
{
    if (![self connectedToInternet])
    {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:@"http://ieeebruins.org/membership_serve/users.php"];
    
    NSData *body = nil;
    
    NSString *contentType = @"application/x-www-form-urlencoded; charset=utf-8";
    
    
    body = [[NSString stringWithFormat:@"service=check_in&email=%@&cookie=%@&eventId=%@", email, cookie, eventCode] dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *putLength = [NSString stringWithFormat:@"%lu",(unsigned long)[body length]];
    
    
    NSMutableDictionary* headers = [[NSMutableDictionary alloc] init];
    [headers setValue:contentType forKey:@"Content-Type"];
    //    [headers setValue:@"mimeType" forKey:@"Accept"];
    //    [headers setValue:@"no-cache" forKey:@"Cache-Control"];
    //    [headers setValue:@"no-cache" forKey:@"Pragma"];
    //    [headers setValue:@"close" forKey:@"Connection"];
    
    
    
    
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    
    [request setAllHTTPHeaderFields:headers];
    
    
    [request setHTTPBody:body];
    [request setValue:putLength forHTTPHeaderField:@"Content-Length"];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                                               options:0
                                                                 error:NULL];
        
        int success = [[result objectForKey:@"success"] intValue];
        if (success) {
            NSDictionary *dict = [result objectForKey:@"event"];
            UserInfo *userInfo = [UserInfo sharedInstance];
            Event *newEvent = [Event currentEvent];
            newEvent.summary = [dict valueForKey:@"summary"];
            newEvent.contact = [dict valueForKey:@"contact"];
            newEvent.location = [dict valueForKey:@"location"];
            newEvent.eventID = [dict valueForKey:@"eventId"];
            newEvent.startTime = [dict valueForKey:@"start"];
            newEvent.endTime = [dict valueForKey:@"end"];
            NSDictionary *user = [result objectForKey:@"user"];
            userInfo.currentPoints = [[user objectForKey:@"points"] intValue];
            userInfo.totalPoints = [[user objectForKey:@"total_points"] intValue];
            callbackBlock();
            NSLog(@"Result %@", result);
        }
        else {
            NSString *error = [result objectForKey:@"error_message"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't Check In!" message:error delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            // optional - add more buttons:
            
            [alert show];
            callbackBlock();
            NSLog(@"Result %@", result);
        }
        
    }];
}

+(void)GetCalendarEventsOnComplete:(void (^)(void))callbackBlock
{
    if (![self connectedToInternet])
    {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:@"https://www.googleapis.com/calendar/v3/calendars/umh1upatck4qihkji9k6ntpc9k@group.calendar.google.com/events?key=AIzaSyAgLz-5vEBqTeJtCv_eiW0zQjKMlJqcztI"];
    
    NSString *contentType = @"text/plain; charset=utf-8";
    
    NSMutableDictionary* headers = [[NSMutableDictionary alloc] init];
    [headers setValue:contentType forKey:@"Content-Type"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"GET"];
    
    [request setAllHTTPHeaderFields:headers];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                                               options:0
                                                                 error:NULL];
        NSDictionary *eventsList = [result valueForKey:@"items"];
        for (NSDictionary *event in eventsList)
        {
            CalendarEvent *newEvent = [[CalendarEvent alloc] init];
            //Use NSDateFormatter to get the date of the event, put that into newEvent.eventDate
            //Google Calendar date format is 2014-10-13T10:00:00.000-07:00
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
            NSDictionary *eventDateDict = [event valueForKey:@"start"];
            NSString *eventDateString = [eventDateDict valueForKey:@"dateTime"];
            NSDate *eventDate = [formatter dateFromString:eventDateString];
            newEvent.eventDate = eventDate;
            newEvent.eventTitle = [event valueForKey:@"summary"];
            newEvent.eventLocation = [event valueForKey:@"location"];
            newEvent.eventCreatorName = [event valueForKeyPath:@"creator.displayName"];
            newEvent.eventCreatorEmail = [event valueForKeyPath:@"creator.email"];
            newEvent.eventID = [event valueForKey:@"id"];
            newEvent.eventDescription = [event valueForKey:@"description"];
            
            if ([newEvent.eventDate timeIntervalSinceNow] > 0)
            {
                [[UserInfo sharedInstance] addCalendarEventToNewsFeedArray:newEvent];
            }
            
            NSString *dateString = [self stringForDate:newEvent.eventDate];
            
            if ([[UserInfo sharedInstance].calendarDict valueForKey:dateString]) //An event already is on that date, add next event for date to the array
            {
                NSMutableArray *eventsArray = [[UserInfo sharedInstance].calendarDict objectForKey:dateString];
                [eventsArray addObject:newEvent];
            }
            else //first event for this date, create an array and add the event to the array, set the array as the object
            {
                NSMutableArray *eventsArray = [[NSMutableArray alloc] init];
                [eventsArray addObject:newEvent];
                if (!dateString)
                {
                    NSLog(@"Event has nil date! %@", newEvent);
                }
                else
                {
                    [[UserInfo sharedInstance].calendarDict setObject:eventsArray forKey:dateString];
                }
            }
        }
        callbackBlock();
    }];
}

+(void)GetAttendedEventsOnComplete:(void (^)(void))callbackBlock
{
    if (![self connectedToInternet])
    {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:@"http://ieeebruins.org/membership_serve/users.php"];
    
    NSData *body = nil;
    
    NSString *contentType = @"application/x-www-form-urlencoded; charset=utf-8";
    
    NSString *email = [UserInfo sharedInstance].userMail;
    
    body = [[NSString stringWithFormat:@"service=get_attended_events&email=%@", email] dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *putLength = [NSString stringWithFormat:@"%lu",(unsigned long)[body length]];
    
    
    NSMutableDictionary* headers = [[NSMutableDictionary alloc] init];
    [headers setValue:contentType forKey:@"Content-Type"];
    //    [headers setValue:@"mimeType" forKey:@"Accept"];
    //    [headers setValue:@"no-cache" forKey:@"Cache-Control"];
    //    [headers setValue:@"no-cache" forKey:@"Pragma"];
    //    [headers setValue:@"close" forKey:@"Connection"];
    
    
    
    
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    
    [request setAllHTTPHeaderFields:headers];
    
    
    [request setHTTPBody:body];
    [request setValue:putLength forHTTPHeaderField:@"Content-Length"];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                                               options:0
                                                                 error:NULL];
        
        int success = [[result objectForKey:@"success"] intValue];
        if (success) {
            NSDictionary *events = [result objectForKey:@"events"];
            for (NSDictionary *event in events)
            {
                CalendarEvent *newEvent = [[CalendarEvent alloc] init];
                newEvent.eventTitle = [event objectForKey:@"summary"];
                newEvent.eventLocation = [event objectForKey:@"location"];
                newEvent.eventID = [event objectForKey:@"event_id"];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                newEvent.eventDate = [formatter dateFromString:[event valueForKey:@"start"]];
                [[UserInfo sharedInstance].attendedEvents addObject:newEvent];
            }
            callbackBlock();
        }
        else {
            [[UserInfo sharedInstance]logOut];
            NSString *error = [result objectForKey:@"error_message"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't Get Events!" message:error delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            // optional - add more buttons:
            [alert show];
            callbackBlock();
        }
        NSLog(@"Result %@", result);
    }];

}

#pragma mark - Helper Functions

+(NSMutableArray *)getEventsForDate:(NSDate *)date
{
    return [[UserInfo sharedInstance].calendarDict objectForKey:[self stringForDate:date]];
}

+ (BOOL)isSameDayWithDate1:(NSDate*)date1 date2:(NSDate*)date2 {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

+(NSString *)stringForDate:(NSDate *)date
{
    NSString *dateString = [[NSString alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    dateString = [formatter stringFromDate:date];
    
    return dateString;
}

+(BOOL)connectedToInternet
{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reach currentReachabilityStatus];
    if (internetStatus == NotReachable)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't connect to internet!" message:@"Please check your connection and try again" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        // optional - add more buttons:
        
        [alert show];
        return NO;
    }
    else
    {
        return YES;
    }
}


@end
