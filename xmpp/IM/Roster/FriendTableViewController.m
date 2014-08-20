//
//  FriendTableViewController.m
//
//  Created by MacPro.com on 14-8-15.
//  Copyright (c) 2014年 lihongtao. All rights reserved.
//

#import "FriendTableViewController.h"

@interface FriendTableViewController ()<NSFetchedResultsControllerDelegate,UIAlertViewDelegate>
{
    NSFetchedResultsController *_fetchedResultController;//设置查询
    NSIndexPath *_removedIndexPath;                      //删除的IndexPath
}
@end

@implementation FriendTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupFetchResultsController];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
#pragma mark  实例化NSFetchedResultsController
-(void)setupFetchResultsController
{
    NSManagedObjectContext *managedObjectContext=[AppDelegate sharedAppdelegate].xmppRosterStorage.mainThreadManagedObjectContext;

    NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    NSSortDescriptor *sortDescrptor=[NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    NSSortDescriptor *sort2 = [NSSortDescriptor sortDescriptorWithKey:@"jidStr" ascending:YES];


    fetchRequest.sortDescriptors=@[sortDescrptor,sort2];

 _fetchedResultController=  [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"sectionNum" cacheName:nil];
    _fetchedResultController.delegate=self;
    NSError *error=nil;
    if (![_fetchedResultController performFetch:&error]) {
        NSLog(@"  %@",error);
    }

}
#pragma mark - NSFetchedResultsController代理方法
#pragma mark 控制器数据发生改变（因为Roster是添加了代理的）
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller;
{
    
    [self.tableView reloadData];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_fetchedResultController sections].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[_fetchedResultController  sections] objectAtIndex:section] numberOfObjects];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *array=[_fetchedResultController sections];
  id< NSFetchedResultsSectionInfo >info= [array objectAtIndex:section];
  NSInteger state=[[info name]integerValue];
    switch (state) {
        case 0:
            return @"在线";
            break;
        case 1:
            return @"离开";
            break;
        case 2:
            return @"下线";
            break;
        default:
            break;
    }
    return @"";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier" forIndexPath:indexPath];
   XMPPUserCoreDataStorageObject *managedObject=  [_fetchedResultController objectAtIndexPath:indexPath];
    cell.textLabel.text=managedObject.displayName;
    cell.imageView.image=[self loadImageWith:managedObject];
    
    return cell;
}
-(UIImage *)loadImageWith:(XMPPUserCoreDataStorageObject *)userCoreDataStoreageObject;
{
    // 1. 判断user中是否包含头像，如果有，直接返回

    if (userCoreDataStoreageObject.photo) {
        return userCoreDataStoreageObject.photo;
    }
    // 2. 如果没有头像，从用户的头像模块中提取用户头像
    NSData *data=[[AppDelegate sharedAppdelegate].xmppvCardAvatarModule photoDataForJID:userCoreDataStoreageObject.jid];
    if (data) {
        return [UIImage imageWithData:data];
    }

    return [UIImage imageNamed:@"tabbar_contacts"];
    
}
#pragma mark 允许表格编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark 提交表格编辑
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 提示，如果没有另行执行，editingStyle就是删除
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        /*
         在OC开发中，是MVC架构的，数据绑定到表格，如果要删除表格中的数据，应该：
         1. 删除数据
         2. 刷新表格
         
         注意不要直接删除表格行，而不删除数据。
         */
        // 删除数据
        // 1. 取出当前的用户数据
        XMPPUserCoreDataStorageObject *user = [_fetchedResultController objectAtIndexPath:indexPath];
        
        // 发现问题，删除太快，没有任何提示，不允许用户后悔
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否删除好友" message:user.jidStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        // 记录住要删除的表格行索引
        _removedIndexPath = indexPath;
        
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        
     XMPPUserCoreDataStorageObject *manage=   [_fetchedResultController objectAtIndexPath:_removedIndexPath];
        [[AppDelegate sharedAppdelegate].xmppRoster removeUser:manage.jid];
        
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"ChartMessage" sender:indexPath];
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
