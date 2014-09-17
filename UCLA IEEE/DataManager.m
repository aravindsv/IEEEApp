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


@implementation DataManager

+(void)loginWithEmail:(NSString *)email Password:(NSString *)password onComplete:(void (^)(void))callbackBlock
{
    NSURL *url = [NSURL URLWithString:@"http://ieeebruins.org/membership_serve/users.php"];
    
    NSData *body = nil;
    
    NSString *contentType = @"application/x-www-form-urlencoded; charset=utf-8";
    
    
    body = [[NSString stringWithFormat:@"service=login&email=%@&password=%@", email, password] dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *putLength = [NSString stringWithFormat:@"%d",[body length]];
    
    
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

+(void)registerWithEmail:(NSString *)email Firstname:(NSString *)firstname Lastname:(NSString *)lastname Password:(NSString *)password onComplete:(void (^)(void))callbackBlock
{
    NSURL *url = [NSURL URLWithString:@"http://ieeebruins.org/membership_serve/users.php"];
    
    NSData *body = nil;
    
    NSString *contentType = @"application/x-www-form-urlencoded; charset=utf-8";
    
    
    body = [[NSString stringWithFormat:@"service=register&email=%@&password=%@&firstname=%@&lastname=%@&", email, password, firstname, lastname] dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *putLength = [NSString stringWithFormat:@"%d",[body length]];
    
    
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

+(void)changeEmailWithEmail:(NSString *)email Cookie:(NSString *)cookie newEmail:(NSString *)newEmail onComplete:(void (^)(void))callbackBlock
{
    NSURL *url = [NSURL URLWithString:@"http://ieeebruins.org/membership_serve/users.php"];
    
    NSData *body = nil;
    
    NSString *contentType = @"application/x-www-form-urlencoded; charset=utf-8";
    
    
    body = [[NSString stringWithFormat:@"service=edit_member&email=%@&cookie=%@&newEmail=%@", email, cookie, newEmail] dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *putLength = [NSString stringWithFormat:@"%d",[body length]];
    
    
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
    NSURL *url = [NSURL URLWithString:@"http://ieeebruins.org/membership_serve/users.php"];
    
    NSData *body = nil;
    
    NSString *contentType = @"application/x-www-form-urlencoded; charset=utf-8";
    
    
    body = [[NSString stringWithFormat:@"service=edit_member&email=%@&cookie=%@&newId=%@", email, cookie, newID] dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *putLength = [NSString stringWithFormat:@"%d",[body length]];
    
    
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
    NSURL *url = [NSURL URLWithString:@"http://ieeebruins.org/membership_serve/users.php"];
    
    NSData *body = nil;
    
    NSString *contentType = @"application/x-www-form-urlencoded; charset=utf-8";
    
    
    body = [[NSString stringWithFormat:@"service=edit_member&email=%@&cookie=%@&newName=%@", email, cookie, newName] dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *putLength = [NSString stringWithFormat:@"%d",[body length]];
    
    
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
    NSURL *url = [NSURL URLWithString:@"http://ieeebruins.org/membership_serve/users.php"];
    
    NSData *body = nil;
    
    NSString *contentType = @"application/x-www-form-urlencoded; charset=utf-8";
    
    
    body = [[NSString stringWithFormat:@"service=edit_member&email=%@&cookie=%@&newPassword=%@&password=%@", email, cookie, newPass, oldPass] dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *putLength = [NSString stringWithFormat:@"%d",[body length]];
    
    
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

+(void)getAnnouncementsOnComplete:(void (^)(void))callbackBlock
{    
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
        }
        callbackBlock();
        NSLog(@"Result %@", result);
    }];
}

+(void)checkInToEvent:(NSString *)eventCode withEmail:(NSString *)email andCookie:(NSString *)cookie onComplete:(void (^)(void))callbackBlock
{
    NSURL *url = [NSURL URLWithString:@"http://ieeebruins.org/membership_serve/users.php"];
    
    NSData *body = nil;
    
    NSString *contentType = @"application/x-www-form-urlencoded; charset=utf-8";
    
    
    body = [[NSString stringWithFormat:@"service=check_in&email=%@&cookie=%@&eventId=%@", email, cookie, eventCode] dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *putLength = [NSString stringWithFormat:@"%d",[body length]];
    
    
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
            Event *newEvent = [Event currentEvent];
            newEvent.summary = [dict valueForKey:@"summary"];
            newEvent.contact = [dict valueForKey:@"contact"];
            newEvent.location = [dict valueForKey:@"location"];
            newEvent.eventID = [dict valueForKey:@"eventId"];
            newEvent.startTime = [dict valueForKey:@"start"];
            newEvent.endTime = [dict valueForKey:@"end"];
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

@end
