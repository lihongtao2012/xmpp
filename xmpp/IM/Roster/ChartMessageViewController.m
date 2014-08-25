//
//  ChartMessageViewController.m
//  xmpp
//
//  Created by MacPro.com on 14-8-20.
//  Copyright (c) 2014年 lihongtao. All rights reserved.
//

#import "ChartMessageViewController.h"
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WEITH [UIScreen mainScreen].bounds.size.width
#import "LoginUser.h"
#import<CoreData/CoreData.h>
#import "XMPPMessageArchiving_Message_CoreDataObject.h"
#import "ChatMessageCell.h"

@interface ChartMessageViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,NSFetchedResultsControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    /**
     *  查询结果控制器;
     */
    NSFetchedResultsController *_fetchedResultsController;
    
}
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nomalConstraint;


@property (strong, nonatomic) IBOutlet UIView *KeyBoardView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *voice;//语音
@property (strong, nonatomic) IBOutlet UIButton *expression;//表情;

@property (strong, nonatomic) IBOutlet UIButton *addFunction;//增加新功能;
@property (strong, nonatomic) IBOutlet UIView *placedFaceView;//放置表情的uiview

@property (strong, nonatomic) IBOutlet UITextField *textFT;


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
/**
 *  显示表情
 *
 *  @param sender button
 */
- (IBAction)showExpression:(UIButton *)sender {
    
    NSLog(@"  show Expression");
    _placedFaceView.hidden=NO;
    _nomalConstraint.constant=250;
    [_textFT resignFirstResponder];
}
/**
 *  增加新功能;
 *
 *  @param sender
 */
- (IBAction)addFunction:(UIButton *)sender {

    NSLog(@"  show addFunction");
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(KeyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //查询结果控制器;
    [self setupfetchedResultsController];
}

-(void)setupfetchedResultsController
{
    NSManagedObjectContext *managedContext=[AppDelegate sharedAppdelegate].xmppMessageArchivingCoreDataStorage.mainThreadManagedObjectContext;
    NSFetchRequest *fetchRequest=  [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"bareJidStr = %@ AND streamBareJidStr = %@",_bareJidStr,[ LoginUser sharedLoginUser].myJIDName];
    fetchRequest.sortDescriptors=@[sort];
    fetchRequest.predicate=predicate;
    
    _fetchedResultsController= [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:managedContext sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate=self;
    NSError *error=nil;
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@" error = %@",error);
    }else{
        [self scrollToTableBottom];//滚动到底部;
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return 50;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"collectioncell" forIndexPath:indexPath];
    return cell;
    
}
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView  reloadData];
    NSLog(@"tableView frame  %@",NSStringFromCGRect(self.tableView.frame));
    [self scrollToTableBottom];//滚到底部;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" collection.indexpath==  %@",indexPath);
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    XMPPMessage *message=[XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithString:_bareJidStr]];
    [message addBody:textField.text];
    [[AppDelegate sharedAppdelegate].xmppStream sendElement:message];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _placedFaceView.hidden=YES;
    return YES;
}
-(void)KeyboardWillChangeFrameNotification:(NSNotification *)not
{
    
    NSDictionary *info=not.userInfo;
    CGRect rect=[info[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGFloat durtion=[info[UIKeyboardAnimationDurationUserInfoKey]floatValue];
    
    if (rect.origin.y==[UIScreen mainScreen].bounds.size.height) {
        //键盘隐藏;
        
    }else{
        _nomalConstraint.constant=rect.size.height;
    }
    [UIView animateWithDuration:durtion animations:^{
        [self.view layoutIfNeeded];
    }completion:^(BOOL finished) {
        [self scrollToTableBottom];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)scrollToTableBottom
{
    id<NSFetchedResultsSectionInfo>info=_fetchedResultsController.sections[0];
    int numberCount=(int)[info numberOfObjects];
    if (numberCount<=0) {
        return;
    }
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:numberCount-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> info = _fetchedResultsController.sections[section];
    return  [info numberOfObjects];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPMessageArchiving_Message_CoreDataObject *coredateObject=[_fetchedResultsController objectAtIndexPath:indexPath];
    ChatMessageCell  *cell = nil;
    if (coredateObject.isOutgoing) {
        cell=[tableView dequeueReusableCellWithIdentifier:@"charToJIDCell" forIndexPath:indexPath];
        cell.headImageView.image=_myImage;
    }else{
        cell=[tableView dequeueReusableCellWithIdentifier:@"charFromJIDCell" forIndexPath:indexPath];
        cell.headImageView.image=_bareImage;
    }
    [cell setMessage:coredateObject.body isOutgoing:coredateObject.isOutgoing];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _nomalConstraint.constant=0;
    [_textFT resignFirstResponder];
    
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
