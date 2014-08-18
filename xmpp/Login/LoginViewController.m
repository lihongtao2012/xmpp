//
//  ViewController.m
//
//  Created by MacPro.com on 14-8-5.
//  Copyright (c) 2014年 lihongtao. All rights reserved.
//

#import "LoginViewController.h"
#import "NSString+Helper.h"
#import "LoginUser.h"
@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _userNameText.text=[LoginUser sharedLoginUser].userName;
    _passWordText.text=[LoginUser sharedLoginUser].password;
    _hostNameText.text=[LoginUser sharedLoginUser].hostName;
    //设置文本焦点;
    if ([_userNameText.text isEmptyString]) {
        [_userNameText becomeFirstResponder];
    }else{
        [_passWordText becomeFirstResponder];
    }
	// Do any additional setup after loading the view, typically from a nib.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==_userNameText) {
    [_passWordText becomeFirstResponder];
    }else if (textField==_passWordText && [_hostNameText.text isEmptyString])
    {
    [_hostNameText becomeFirstResponder];
    }else{
        [self loginAndRegister:nil];
    }
    return YES;
    
}

/**
 *  用户登陆;
 
 */
- (IBAction)loginAndRegister:(id)sender {
    
    //检查用户输入是否完整;
    NSString *userName=[_userNameText.text trimString];
    NSString *passWord=_passWordText.text;
    NSString *hostName=[_hostNameText.text trimString];
    
    if ([userName isEmptyString]||[passWord isEmptyString]||[hostName isEmptyString]) {
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"登陆信息不完整" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    //储存;
    [LoginUser sharedLoginUser].userName=userName;
    [LoginUser sharedLoginUser].password=passWord;
    [LoginUser sharedLoginUser].hostName=hostName;

    UIButton *button =(UIButton *)sender;
    NSString *errorMessage=nil;
    if (button.tag==100) {
        [AppDelegate sharedAppdelegate].isRegisterUser=YES;
        errorMessage=@"注册用户失败";
    }else{
        errorMessage=@"用户登录失败";
    }
  
    //让appDelegate开始连接;
    
    [[AppDelegate sharedAppdelegate]connectWithCompletion:nil failed:^{
        
        UIAlertView *alertVie=[[UIAlertView alloc]initWithTitle:@"提示:" message:errorMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertVie show];
        if (button.tag==100) {
            //通常是用户名重复;
            [_userNameText becomeFirstResponder];
        }else{
            //登陆失败是密码错误;
            _passWordText.text=@"";
            [_passWordText becomeFirstResponder];
        }
        
    }];
    
}
-(void)dealloc
{
    NSLog(@"dealloc");
 
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
