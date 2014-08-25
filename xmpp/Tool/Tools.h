//
//  NHTools.h
//  NurseryHousekeeper
//
//  Created by lihongtao on 14-6-3.
//  Copyright (c) 2014年 Beijing Orient Landscape Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject
+ (NSString *)md5:(NSString *)str ;

+(NSString *)toJSONData:(id)theData;

+(void)call:(NSString *)phoneNumber;
//取消键盘第一响应;
+(void)resignKeyBoardInView:(UIView *)view;
//判断手机号;
+(BOOL)isMobileNumber:(NSString *)mobileNum;

+(CGFloat)heightForWithNSSting:(NSString *)string stringWidth:(CGFloat )stringWidth fontSize:(CGFloat)fontSize;
+(CGFloat)widthForWithNSSting:(NSString *)string stringHeight:(CGFloat )stringHeight fontSize:(CGFloat)fontSize;

//隐藏tabview多余线
+(void)setExtraCellLineHidden: (UITableView *)tableView;
+ (BOOL)isLoginIn; //是否登录;

+(NSString *)getLocalTimeStamp;//获取本地时间戳;

+(NSString *)creatLocalImageFiledPath:(NSString *)imageName
; //创建本地image文件夹;

+(NSString *)getLocalTime;

+(NSString *)getLocalToday;

+(NSString *)getPlishSR;
+(NSString *)getPlishSP;

+ (void)saveUserKeyedArchiverLocaData:(NSDictionary *)dic withSaveNmae:(NSString *)name;

+ (NSDictionary *)getUserKeyedArchiverFromLocalData:(NSString *)name;
+(void)showAlertViewWithTitle:(NSString *)title;


+(NSString *)currentNetState;

+(NSString *)getMpbh;
+(NSString *)getNurseryName;

+(NSString *)getHybh;

@end
