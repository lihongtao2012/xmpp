//
//  EditVCadViewController.m
//  xmpp
//
//  Created by MacPro.com on 14-8-19.
//  Copyright (c) 2014年 lihongtao. All rights reserved.
//

#import "EditVCadViewController.h"

@interface EditVCadViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *vCardMessage;

@end

@implementation EditVCadViewController

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
    self.title=_titleString;
    self.vCardMessage.text=_label.text;
    [_vCardMessage becomeFirstResponder];
    // Do any additional setup after loading the view.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self save:nil];
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)save:(UIBarButtonItem *)sender {
    _label.text = [_vCardMessage.text trimString];
    if (_delegate&& [_delegate respondsToSelector:@selector(editVCadViewControllerDidFinsh)]) {
        [_delegate editVCadViewControllerDidFinsh];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dealloc
{
    NSLog(@"dealloc");
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
