//
//  ChatMessageCell.h
//  xmpp
//
//  Created by MacPro.com on 14-8-22.
//  Copyright (c) 2014年 lihongtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatMessageCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *headImageView;

@property(strong,nonatomic)IBOutlet UIButton *bodyButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *messageWidthContraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *messageHeightContraint;



/**
 *  设置文本显示内容
 *
 *  @param message    文本内容
 *  @param isOutgoing  发送还是接受信息;
 */
-(void)setMessage:(NSString *)message isOutgoing:(BOOL)isOutgoing;

@end
