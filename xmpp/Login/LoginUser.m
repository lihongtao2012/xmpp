
//
//  LoginUser.m
//
//  Created by MacPro.com on 14-8-18.
//  Copyright (c) 2014年 lihongtao. All rights reserved.
//

#import "LoginUser.h"
#import "NSString+Helper.h"

#define kXMPPUserNameKey  @"xmppUserName"
#define kXMPPPasswordKey  @"xmppPassWord"
#define kXMPPHostNameKey  @"xmppHostName"
#define kNotificationUserLogonState @"NotificationUserLogon"

@implementation LoginUser
single_implementation(LoginUser)

-(NSString *)loadStandUserDefaultObjectForKey:(NSString *)key
{
    NSString *str=[[NSUserDefaults standardUserDefaults]objectForKey:key];
    return str ? str:@"";
}
-(void)setUserName:(NSString *)userName
{
    [userName saveToNSDefaultsWithKey:kXMPPUserNameKey];
}
-(NSString *)userName
{
    return [self loadStandUserDefaultObjectForKey:kXMPPUserNameKey];
}
-(void)setPassword:(NSString *)password
{
    [password saveToNSDefaultsWithKey:kXMPPPasswordKey];
}
-(NSString *)password
{
    return [self loadStandUserDefaultObjectForKey:kXMPPPasswordKey];
}
-(void)setHostName:(NSString *)hostName
{
    [hostName saveToNSDefaultsWithKey:kXMPPHostNameKey];
}
-(NSString *)hostName
{
    return [self loadStandUserDefaultObjectForKey:kXMPPHostNameKey];
}
-(NSString *)myJIDName
{
    return [NSString stringWithFormat:@"%@@%@",self.userName,self.hostName];
}

@end
