//
//  AddFriendViewController.m
//  xmpp
//
//  Created by MacPro.com on 14-8-19.
//  Copyright (c) 2014年 lihongtao. All rights reserved.
//

#import "AddFriendViewController.h"
#import "LoginUser.h"
@interface AddFriendViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
/**
 *  添加朋友账号
 */
@property (strong, nonatomic) IBOutlet UITextField *friendAccount;


@end

@implementation AddFriendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [_friendAccount becomeFirstResponder];
    
    // Do any additional setup after loading the view.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![textField.text isEmptyString]) {
        [self addFriendItem:nil];
        [textField resignFirstResponder];
    }
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addFriendItem:(UIBarButtonItem *)sender {
    
    NSRange range=[_friendAccount.text rangeOfString:@"@"];
    if (range.location == NSNotFound) {
        _friendAccount.text=[_friendAccount.text stringByAppendingFormat:@"@%@",[LoginUser sharedLoginUser].hostName];
    }
    //  好友名字不能跟用户名字相同
    if ([_friendAccount.text isEqualToString:[LoginUser sharedLoginUser].myJIDName]) {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"好友名字不能跟用户名字相同" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    //好友如果已经在用户信息中,直接提示不用再次邀请了;
    if ([[AppDelegate sharedAppdelegate].xmppRosterStorage userExistsWithJID:[XMPPJID jidWithString:_friendAccount.text] xmppStream:[AppDelegate sharedAppdelegate].xmppStream] ) {
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"好友名字已经在用户当中了..." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;

    }
    //发送添加好友请求;
    [[AppDelegate sharedAppdelegate].xmppRoster subscribePresenceToUser:[XMPPJID jidWithString:_friendAccount.text]];
    
    //  提示用户发送成功
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加好友请求已发送" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];

}
#pragma mark - UIAlertView代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 返回上级页面
    [self.navigationController popViewControllerAnimated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
