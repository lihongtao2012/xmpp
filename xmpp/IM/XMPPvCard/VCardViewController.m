//
//  VCardViewController.m

//

#import "VCardViewController.h"
#import "AppDelegate.h"
#import "XMPPvCardTemp.h"
#import "LoginUser.h"

@interface VCardViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *userName;

@property (strong, nonatomic) IBOutlet UILabel *jiDText;

//公司名字;
@property (strong, nonatomic) IBOutlet UILabel *company;
//部门
@property (strong, nonatomic) IBOutlet UILabel *department;
//职务;
@property (strong, nonatomic) IBOutlet UILabel *job;
//电话;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumber;


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
    
    [[[AppDelegate sharedAppdelegate]xmppVcardModule]updateMyvCardTemp:myvCard];
    NSData *photo=[[AppDelegate sharedAppdelegate].xmppvCardAvatarModule photoDataForJID:myvCard.jid];
    if (photo) {
        _headImageView.image=[UIImage imageWithData:photo];
    }
    
    //用户名字;
    _userName.text=myvCard.nickname;
    _jiDText.text=[myvCard.jid full];
    _company.text=myvCard.orgName;
    if (myvCard.orgUnits) {
        _department.text=myvCard.orgUnits[0];
    }
    _job.text=myvCard.title;
    _phoneNumber.text=myvCard.note;
    
}

#pragma mark - 注销用户登录
- (IBAction)logout:(id)sender
{
   [[AppDelegate sharedAppdelegate] logout];
}

@end
