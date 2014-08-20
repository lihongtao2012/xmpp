//
//  EditVCadViewController.h
//  xmpp
//
//  Created by MacPro.com on 14-8-19.
//  Copyright (c) 2014年 lihongtao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EditVCadViewController;
@protocol editVCadViewControllerDelegate<NSObject>

-(void)editVCadViewControllerDidFinsh;

@end


@interface EditVCadViewController : UIViewController

/**
 *  editVCadViewControllerDelegate;
 */
@property(nonatomic,weak)id<editVCadViewControllerDelegate>delegate;


/**
 *  设置VC title ;
 */
@property(nonatomic,strong)NSString *titleString;
/**
 *  设置 文本框中的值;
 */
@property(nonatomic,weak)UILabel *label;


@end
