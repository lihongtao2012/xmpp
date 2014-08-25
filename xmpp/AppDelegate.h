//
//  AppDelegate.h
//
//  Created by MacPro.com on 14-8-5.
//  Copyright (c) 2014年 lihongtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"XMPPFramework.h"

typedef void(^CompletionBlock)();
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 *
 *全局的Xmpp 只读属性;
 */
@property(nonatomic,readonly,strong)XMPPStream *xmppStream;
/**
 *  花名册 只读属性;
 */
@property (nonatomic,strong,readonly) XMPPRoster *xmppRoster;//xmpp好友列表
/**
 *  全局的XMPPRosterCoreDataStorage模块，只读属性
 */
@property (strong, nonatomic, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
/**
 *  vcar模块;只读属性;
 */
@property(nonatomic,strong,readonly)XMPPvCardTempModule *xmppVcardModule;

/**
 *  全局的XMPPvCardAvatar模块，只读属性
 */
@property (strong, nonatomic, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
/**
 *  XMPPMessageArchiving 好友消息;
 */
@property(nonatomic,strong,readonly)XMPPMessageArchiving *xmppMessageArchiving;
/**
 *  xmpp 消息存储;
 */
@property(nonatomic,strong,readonly)XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;


/**
 *  是否注册用户标示
 */
@property (assign, nonatomic) BOOL isRegisterUser;

/**
 *  设置Appdelegate单利
 *
 *  @return Appdelegate;
 */

+(AppDelegate*)sharedAppdelegate;
/**
 *  连接服务器
 *
 *  @param completion 连接成功
 *  @param failed     连接失败;
 */
-(void)connectWithCompletion:(CompletionBlock)completion failed:(CompletionBlock)failed;
/**
 *  注销用户登录;
 */
- (void)logout;


@end
