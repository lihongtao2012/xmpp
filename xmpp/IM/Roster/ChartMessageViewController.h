//
//  ChartMessageViewController.h
//  xmpp
//
//  Created by MacPro.com on 14-8-20.
//  Copyright (c) 2014年 lihongtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartMessageViewController : UIViewController
/**
 *  跟谁聊天的那个人 jid;
 */
@property(nonatomic,strong)NSString *bareJidStr;
/**
 * 跟谁聊天的那个人 头像;
 */
@property(nonatomic,strong)UIImage *bareImage;
@property(nonatomic,strong)UIImage *myImage;

@end
