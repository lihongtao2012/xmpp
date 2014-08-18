//
//  VCardViewController.m

//

#import "VCardViewController.h"
#import "AppDelegate.h"
#import "XMPPvCardTemp.h"
#import "LoginUser.h"

@interface VCardViewController ()

@end

@implementation VCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupvCard];
	// Do any additional setup after loading the view.
}

#pragma  mark - 电子名片处理方法;
-(void)setupvCard
{
    XMPPvCardTemp *myvCard=  [AppDelegate sharedAppdelegate].xmppVcardModule.myvCardTemp;
    if (myvCard==nil) {
        myvCard = [XMPPvCardTemp vCardTemp];
    }
    
    myvCard.nickname = [[LoginUser sharedLoginUser] userName];
    //设置XMPP JID
    if (myvCard.jid==nil) {
        myvCard.jid=[XMPPJID jidWithString:[LoginUser sharedLoginUser].myJIDName];
    }
    
    
   
    
}

#pragma mark - 注销用户登录
- (IBAction)logout:(id)sender
{
   [[AppDelegate sharedAppdelegate] logout];
}

@end
