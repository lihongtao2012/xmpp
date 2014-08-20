//
//  AppDelegate.m
//
//  Created by MacPro.com on 14-8-5.
//  Copyright (c) 2014年 lihongtao. All rights reserved.
//
/*
 *
 *官方推荐在Appdelegate 中处理来自服务器XMPP 服务器代理相应;
 
 *xmpp 的特点，所有的请求都是通过代理的方法实现的;
 *xmpp是经由网络服务器进行数据通讯的,因此所有的请求都交给了服务器处理;
 *服务器处理完毕之后,以代理的方式告诉客户端处理结果;
 */

#import "Login/LoginUser.h"
#import "AppDelegate.h"

//提示,此处不遵守XMppStreamDelegate协议,程序仍然可以正常运行,但是遵守了协议,可以方便编写代码;
@interface AppDelegate ()<XMPPStreamDelegate,XMPPRosterDelegate,UIAlertViewDelegate>
{
    CompletionBlock            _completionBlock;  // 成功的块代码
    CompletionBlock             _failedBlock;     //失败块代码;
    XMPPReconnect               *_xmppReconnect;  // XMPP重新连接XMPPStream
    XMPPvCardCoreDataStorage * _xmppvCardStorage; //电子名片数据储存模块;
    XMPPCapabilities          * _xmppCapabilities;//实体扩展模块;
    XMPPCapabilitiesCoreDataStorage *_xmppCapabilitiesCoreDataStorage;//数据存储模块;
}

//设置stream
-(void)setUpStream;
// 销毁XMPPStream并注销已注册的扩展模块
- (void)teardownStream;

//连接服务器;
-(void)connect;
//与服务器断开连接;
-(void)disConnet;

//通知服务器上线
-(void)goOnline;
//通知服务器下线;
-(void)goOffLine;

@end



@implementation AppDelegate

+(AppDelegate*)sharedAppdelegate;
{
    return (AppDelegate *)([UIApplication sharedApplication].delegate);
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setUpStream];
    // Override point for customization after application launch.
    return YES;
}

-(void)showStoryboardWithLogonState:(BOOL)isUserLogon

{
    UIStoryboard *storyboard=nil;
    if (isUserLogon) {
      storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    }else{
        storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    }
   dispatch_async(dispatch_get_main_queue(), ^{
    self.window.rootViewController=storyboard.instantiateInitialViewController;
});
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    [self disConnet];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // 应用程序被激活后，直接连接，使用系统偏好中的保存的用户记录登录
    // 从而实现自动登录的效果！
    [self connect];

}
- (void)dealloc
{
    // 释放XMPP相关对象及扩展模块
    [self teardownStream];
}
#pragma mark -xmpp相关
//设置stream
-(void)setUpStream
{
    
    
    NSAssert(_xmppStream == nil, @"XMPPStream被多次实例化！");
    // 1 实例化XMppstream
    
    _xmppStream=[[XMPPStream alloc]init];
    
    // 允许XMPPStream在真机运行时，支持后台网络通讯！
#if !TARGET_IPHONE_SIMULATOR
    {
        [_xmppStream setEnableBackgroundingOnSocket:YES];
    }
#endif
    
    //2 扩展模块;
    
    // 2.1 重新连接模块;
    _xmppReconnect = [[XMPPReconnect alloc] init];
    //2.2电子名片模块;
    _xmppvCardStorage =[XMPPvCardCoreDataStorage sharedInstance];
    _xmppVcardModule=[[XMPPvCardTempModule alloc]initWithvCardStorage:_xmppvCardStorage];
    _xmppvCardAvatarModule=[[XMPPvCardAvatarModule alloc]initWithvCardTempModule:_xmppVcardModule];
    
    //2.3花名册;
    _xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc]init];
    _xmppRoster = [[XMPPRoster alloc]initWithRosterStorage:_xmppRosterStorage];
    //设置自动订阅好友请求;
    [_xmppRoster  setAutoAcceptKnownPresenceSubscriptionRequests:YES];
    //自动从服务器更新记录;列如好友跟新名片了;
    [_xmppRoster setAutoFetchRoster:YES];
    //2.5 实体扩张模块;
    _xmppCapabilitiesCoreDataStorage=[[XMPPCapabilitiesCoreDataStorage alloc]init];
    _xmppCapabilities=[[XMPPCapabilities alloc]initWithCapabilitiesStorage:_xmppCapabilitiesCoreDataStorage];
    
    
    
    
    // 3.2 将重新连接模块添加到XMPPStream
    [_xmppReconnect activate:_xmppStream];
    [_xmppVcardModule activate:_xmppStream];
    [_xmppvCardAvatarModule activate:_xmppStream];//激活;
    [_xmppRoster activate:_xmppStream];//通过Stream激活
    [_xmppCapabilities activate:_xmppStream];
    

    //因为所有网络请求都是基于网络的数据处理,跟界面没有关系,因此可以代理方法在其他的域中执行;从而提高程序性能;
    
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    [_xmppRoster addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];

  }

//销毁XMPPStream并注销已注册的扩展模块
- (void)teardownStream
{
   // 1 删除代理;
    [_xmppStream removeDelegate:self];
    
    // 2. 取消激活在setupStream方法中激活的扩展模块
    [_xmppReconnect deactivate];
    [_xmppVcardModule deactivate];
    [_xmppvCardAvatarModule deactivate];
    [_xmppRoster deactivate];
    [_xmppCapabilities deactivate];

    
    // 3. 断开XMPPStream的连接
    [_xmppStream disconnect];
    

    // 4. 内存清理
    _xmppStream = nil;
    _xmppReconnect = nil;
    _xmppVcardModule = nil;
    _xmppvCardAvatarModule=nil;
    _xmppvCardStorage=nil;
    _xmppRoster=nil;
    _xmppRosterStorage=nil;
    _xmppCapabilities=nil;
    _xmppCapabilitiesCoreDataStorage=nil;

}

#pragma mark 通知服务器 上线
-(void)goOnline
{
    // 1 实例化一个展现 上线报告
    XMPPPresence *presence=[XMPPPresence presence];
    // 2. 发送presence 给服务器 ;
    //服务器知道我上线后,只需通知我的好友; 无需通知我;
    [_xmppStream sendElement:presence];

}
#pragma mark 通知服务器 下线
-(void)goOffLine
{
    // 1 实例化一个展现  下线报告;
    XMPPPresence *presence =[XMPPPresence  presenceWithType:@"unavailable"];
    [_xmppStream sendElement:presence];
}

#pragma  mark 连接
-(void)connect
{
    //1.设置 如果XmppStream 连接上了直接 直接返回就行;
    if ([_xmppStream isConnected]) {
        return;
    }
    //2.指定用户,密码,主机(服务器)
    
    NSString *hostName=[LoginUser sharedLoginUser].hostName;//@"abc.local";

    NSString *myJIDName=[LoginUser sharedLoginUser].myJIDName;//@"zhangsan@abc.local";
    
    // 如果没有主机名或用户名（通常第一次运行时会出现），直接显示登录窗口
    if ([hostName isEmptyString] || [myJIDName isEmptyString]) {
        [self showStoryboardWithLogonState:NO];
        return;
    }
    //3,设置XMPPStream 的JID 和主机;
    [_xmppStream setMyJID:[XMPPJID jidWithString:myJIDName]];
    [_xmppStream setHostName:hostName];
    //4.开始连接;
    NSError *error=nil;
    [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    //提示.如果没有指定 JID 和HostName 才会出错;
    if (error) {
        NSLog(@"连接出错,- %@",error.localizedDescription);
    }else{
        NSLog(@"连接成功");
    }
}

#pragma mark 断开连接;
-(void)disConnet
{
    //1 通知服务器下线;
    [self goOffLine];
    
    // 2 xmppStream 断开连接;
    [_xmppStream disconnect];
}
#pragma mark -连接到服务器;
-(void)connectWithCompletion:(CompletionBlock)completion failed:(CompletionBlock)failed
{
    _completionBlock=completion;
    _failedBlock=failed;
    
    //如果连接了,先断开连接;
    if ([_xmppStream isConnected]) {
        [_xmppStream disconnect];
    }
    [self connect];
}

#pragma mark - 代理方法
#pragma mark 连接完成（如果服务器地址不对，就不会调用此方法）
-(void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"连接建立");
    //开始发送身份验证;
    NSString *passWord=[LoginUser sharedLoginUser].password;
    if (_isRegisterUser) {
        // 用户注册，发送注册请求
        [_xmppStream registerWithPassword:passWord error:nil];
    }else{
        // 用户登录，发送身份验证请求
        [_xmppStream authenticateWithPassword:passWord error:nil];
    }
    
}

#pragma  mark 注册通过;
-(void)xmppStreamDidRegister:(XMPPStream *)sender
{
    _isRegisterUser = NO;

    // 提示：以为紧接着会再次发送验证请求，验证用户登录
    // 而在验证通过后，会执行_completionBlock块代码，
    // 因此，此处不应该执行_completionBlock
    //    if (_completionBlock != nil) {
    //        _completionBlock();
    //    }
    // 注册成功，直接发送验证身份请求，从而触发后续的操作
    [_xmppStream authenticateWithPassword:[LoginUser sharedLoginUser].password error:nil];
}
#pragma mark 注册失败(用户名已经存在)
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    _isRegisterUser = NO;
    if (_failedBlock != nil) {
        _failedBlock();
    }
}

#pragma  mark 验证通过;
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    if (_completionBlock!=nil) {
        _completionBlock();
    }
    [self goOnline];
    NSLog(@"验证成功");
    // 显示主Storyboard
    [self showStoryboardWithLogonState:YES];

}
#pragma mark 密码错误;

-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"密码错误")
    if (_failedBlock!=nil) {
        _failedBlock();
    }
}
#pragma mark - XMPPRoster Delegate Methods -
-(void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(DDXMLElement *)item
{
    NSXMLElement *xmlItem = item;
    NSLog(@"item  == %@",item); //<item jid="wangwu@abc.local" subscription="none"/>    里面没有状态
    NSString *jid = [xmlItem attributeStringValueForName:@"jid"];
    NSString *subscription = [xmlItem attributeStringValueForName:@"subscription"];
    if ([subscription isEqualToString:@"remove"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:jid message:@"将你从好友中删除" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            alert.tag = 100;
            [alert show];
        });
      
    }

}

-(void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    
    NSLog(@"接收到用户展现数据 - %@", presence);
    
    // 1. 判断接收到的presence类型是否为subscribe
    if ([presence.type isEqualToString:@"subscribe"]) {
        // 2. 取出presence中的from的jid
        XMPPJID *from = [presence from];
        
        // 3. 接受来自from添加好友的订阅请求
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:from.full message:@"请求添加好友" delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"同意", nil];
            alert.tag = 101;
            [alert show];
            return ;
        });

    }

}
#pragma mark - XMPPRoster代理
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    NSLog(@"接收到其他用户的请求 %@", presence);
    
}

//- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message;
//{
//    NSLog(@" MESSAGE MESSAGE MESSAGE %@",message);
//    
//}
- (void)logout
{
    // 1. 通知服务器下线，并断开连接
    [self disConnet];
    
    // 2. 显示用户登录Storyboard
    [self showStoryboardWithLogonState:NO];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex  %ld", buttonIndex);
    switch (alertView.tag) {
        case 100:
        {
            
            
        }
            break;
        case 101:
        {
            XMPPJID *jid = [XMPPJID jidWithString:alertView.title];
            if (buttonIndex == 1) {//接受请求
                [self.xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
             }else if (buttonIndex == 0){//拒绝请求
                [self.xmppRoster rejectPresenceSubscriptionRequestFrom:jid];
            }
            
        }
            break;

            
        default:
            break;
    }
}
@end
