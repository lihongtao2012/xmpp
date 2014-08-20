//
//  ChartMessageViewController.m
//  xmpp
//
//  Created by MacPro.com on 14-8-20.
//  Copyright (c) 2014年 lihongtao. All rights reserved.
//

#import "ChartMessageViewController.h"

@interface ChartMessageViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nomalConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *englishConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pinyinConstrain;

@end

@implementation ChartMessageViewController

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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(KeyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // Do any additional setup after loading the view.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)KeyboardWillChangeFrameNotification:(NSNotification *)not
{
    NSLog(@"  %@",[not userInfo]);
    NSDictionary *info=not.userInfo;
    CGRect rect=[info[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGFloat durtion=[info[UIKeyboardAnimationDurationUserInfoKey]floatValue];
    
    if (rect.origin.y==[UIScreen mainScreen].bounds.size.height) {
        //键盘隐藏;
        if (! [self.view.constraints containsObject:_englishConstraint]) {
            [self.view addConstraint:self.englishConstraint];
        }
        if (! [self.view.constraints containsObject:_nomalConstraint]) {
            [self.view addConstraint:self.nomalConstraint];
        }

        
    }else{
        //
        if (rect.size.height==216) {
            //删除没有键盘时的约束;
            [self.view removeConstraint:self.nomalConstraint];
            if (! [self.view.constraints containsObject:_englishConstraint]) {
                [self.view addConstraint:self.englishConstraint];
            }
            ;
            
        }else if (rect.size.height==252)
        {
            //删除英文约束;
            [self.view removeConstraint:_englishConstraint];
        
        }
 
    }
    
    [UIView animateWithDuration:durtion animations:^{
        [self.view layoutIfNeeded];
    }];

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cellIdentfier" forIndexPath:indexPath];
    
    cell.textLabel.text=[NSString stringWithFormat:@"%ld",indexPath.row];
    
    
    return cell;
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
