//
//  ChatMessageCell.m
//  xmpp
//
//  Created by MacPro.com on 14-8-22.
//  Copyright (c) 2014年 lihongtao. All rights reserved.
//


#import "ChatMessageCell.h"

@interface ChatMessageCell()

{
    UIImage *_receiveImage;
    UIImage *_receiveImageHL;
    UIImage *_senderImage;
    UIImage *_senderImageHL;
}

@end

@implementation ChatMessageCell
-(UIImage *)strecheImage:(UIImage *)image
{
    return [image stretchableImageWithLeftCapWidth:image.size.width *0.5 topCapHeight:image.size.height*0.6];
}
- (void)awakeFromNib
{
//    _receiveImage=[self strecheImage:[UIImage imageNamed:@"ReceiverTextNodeBkg"]];;
//    _receiveImageHL=[self strecheImage:[UIImage imageNamed:@"ReceiverTextNodeBkgHL"]];
//    _senderImage=[self strecheImage:[UIImage imageNamed:@"SenderTextNodeBkg"]];
//    _senderImageHL=[self strecheImage:[UIImage imageNamed:@"SenderTextNodeBkgHL"]];;
    
    // Initialization code
}
-(void)setMessage:(NSString *)message isOutgoing:(BOOL)isOutgoing
{
//    if (isOutgoing) {
//        [_bodyButton setBackgroundImage:_senderImage forState:UIControlStateNormal];
//        [_bodyButton setBackgroundImage:_senderImageHL forState:UIControlStateSelected];
//    }else{
//        [_bodyButton setBackgroundImage:_receiveImage forState:UIControlStateNormal];
//        [_bodyButton setBackgroundImage:_receiveImageHL forState:UIControlStateSelected];
//    }
    if (Version7) {
        CGRect rect= [message boundingRectWithSize:CGSizeMake(200, 10000) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin   attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil]  context:nil];
        _messageHeightContraint.constant = rect.size.height + 30;
        _messageWidthContraint.constant =  rect.size.width + 35;
    }else{
        CGSize size= [message sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 10000)];
        _messageHeightContraint.constant = size.height + 30;
        _messageWidthContraint.constant = size.width + 35;
    }
    [_bodyButton setTitle:message forState:UIControlStateNormal];
    [self setNeedsLayout];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
