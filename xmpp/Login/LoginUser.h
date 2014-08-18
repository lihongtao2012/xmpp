//
//  LoginUser.h
//  o2用户登录注册
//
//  Created by MacPro.com on 14-8-18.
//  Copyright (c) 2014年 lihongtao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@interface LoginUser : NSObject
single_interface(LoginUser)

@property(nonatomic,strong)NSString *userName;//用户名
@property(nonatomic,strong)NSString *password;//密码
@property(nonatomic,strong)NSString *hostName;

@property(nonatomic,strong,readonly)NSString *myJIDName;

@end
