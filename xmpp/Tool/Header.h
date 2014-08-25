//
//  Header.h
//  nurseryManage
//
//  Created by lihongtao on 14-6-25.
//  Copyright (c) 2014年 lihongtao. All rights reserved.
//

#ifndef nurseryManage_Header_h
#define nurseryManage_Header_h

#define kIsLoginIn @"loginStatus"

#define BOUNDS_WIDTH self.view.bounds.size.width
#define BOUNDS_HEIGHT self.view.bounds.size.height
#define UISCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define UISCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define NONaviHeight   ((VersionIs7)?20:0)

//rgb颜色
#define UIColorFromRGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define CLEARCOLOR       [UIColor clearColor]

#define UITintblueColor UIColorFromRGB(23, 188, 203)
 //UIImage创建
#define UIImageWithName(_NAME)    [UIImage imageNamed:_NAME]

//iPhone5适配
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//版本
#define Version7   ([[[UIDevice currentDevice] systemVersion] floatValue]>=7)

#define VersionIs7   ([[[UIDevice currentDevice] systemVersion] intValue]>=7)
#define VersionIs6   ([[[UIDevice currentDevice] systemVersion] intValue]>=6)
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

#define PHPHOST @"http://api.miaolianwang.com"

//api.miaolianwang.com
//119.254.88.29
//10.100.8.116

#endif
