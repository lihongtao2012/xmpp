//
//  NHTools.m
//  NurseryHousekeeper
//
//  Created by lihongtao on 14-6-3.
//  Copyright (c) 2014年 Beijing Orient Landscape Co.,Ltd. All rights reserved.
//

#import "Tools.h"
#import <CommonCrypto/CommonDigest.h>  

@implementation Tools


+ (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (int)strlen(cStr), result);
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0],result[1],result[2],result[3],
             result[4],result[5],result[6],result[7],
             result[8],result[9],result[10],result[11],
             result[12],result[13],result[14],result[15]] lowercaseString];
}

+(NSString *)toJSONData:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error== nil){
        return [[NSString  alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        return nil;
    }
}

//隐藏tabview多余线
+(void)setExtraCellLineHidden: (UITableView *)tableView
{
    
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    
}
//打电话

+(void)call:(NSString *)phoneNumber
{
    NSString *phoneNum=[NSString stringWithFormat:@"telprompt://%@",phoneNumber];
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:phoneNum]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNum]]; //拨号
    }else{
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"您的设备不支持打电话" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}
//取消键盘第一响应;
+(void)resignKeyBoardInView:(UIView *)view
{
    for (UIView *v in view.subviews) {
        if ([v.subviews count] > 0) {
            [self resignKeyBoardInView:v];
        }
        
        if ([v isKindOfClass:[UITextView class]] || [v isKindOfClass:[UITextField class]]) {
            [v resignFirstResponder];
        }
    }
    
}
//判断手机号;
+(BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSLog(@"手机号");
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobileNum];
}


+(CGFloat)widthForWithNSSting:(NSString *)string stringHeight:(CGFloat )stringHeight fontSize:(CGFloat)fontSize
{
    if (VersionIs7) {
        CGRect rect=  [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, stringHeight) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin  attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil] context:nil];
        return rect.size.width;
        
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGSize sizeToFit = [string sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(CGFLOAT_MAX, stringHeight) lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
        return sizeToFit.width;
    }
    
    
}

+(CGFloat)heightForWithNSSting:(NSString *)string stringWidth:(CGFloat )stringWidth fontSize:(CGFloat)fontSize;
{
    if (VersionIs7) {
        CGRect rect=  [string boundingRectWithSize:CGSizeMake(stringWidth, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin  attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil] context:nil];
        return rect.size.height;
        
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGSize sizeToFit = [string sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(stringWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
        return sizeToFit.height;
    }
    
}
+ (BOOL)isLoginIn
{
    BOOL loginIn= [[[NSUserDefaults standardUserDefaults] valueForKey: kIsLoginIn] boolValue];
    return loginIn;
}

+(NSString *)returnImagePath
{
    NSString *libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    return [libraryDirectory stringByAppendingPathComponent:@"Caches/image"];
    
}
+(NSString *)getLocalTimeStamp
{
    NSDate* dat = [NSDate date];
    NSString *timeSp =[NSString stringWithFormat:@"%ld", (long)[dat timeIntervalSince1970]+8*60*60];
    NSLog(@"时间戳 %@",timeSp);
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeSp longLongValue]];
    NSLog(@" 时间戳 返回的时间 = %@",confromTimesp);
    return timeSp;
}

+(NSString *)getLocalTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *nowtimeStr = [formatter stringFromDate:datenow];//----------将nsdate按formatter格式转成nsstring
    NSLog(@" 系统时间  %@",nowtimeStr );
    return nowtimeStr;
}
+(NSString *)getLocalToday
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *nowtimeStr = [formatter stringFromDate:datenow];//----------将nsdate按formatter格式转成nsstring
    NSLog(@" 系统时间  %@",nowtimeStr );
    return nowtimeStr;
}
+(NSString *)creatLocalImageFiledPath:(NSString *)imageName
{

    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *DirectoryPath=[Tools returnImagePath];
    NSString *path=[DirectoryPath stringByAppendingFormat:@"/%@",imageName];
    if (![fileManager fileExistsAtPath:DirectoryPath]) {
      BOOL isRight =[fileManager createDirectoryAtPath:DirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (isRight) {
            NSLog(@"创建成功");
        }else{
            NSLog(@"创建失败");
 
        }
        
    }else{
        NSLog(@"文件已存在");
    }
    return path;
}

+(NSString *)getPlishSR
{ //现在数据库文件地址
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"PropertyListSR" ofType:@"plist"];
    //拷贝的目的地址
    //NSLibraryDirectory
    NSString *libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //目的地址
    NSString *PropertyListSR = [libraryDirectory stringByAppendingPathComponent:@"Caches/PropertyListSR.plist"];
    NSLog(@" PropertyListSR.plist %@",PropertyListSR);
    //拷贝
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:PropertyListSR])
    {
        [fileManager copyItemAtPath:filePath toPath:PropertyListSR error:nil];
        
    }

    return PropertyListSR;
}
+(NSString *)getPlishSP
{ //现在数据库文件地址
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"PropertyListSP" ofType:@"plist"];
    //拷贝的目的地址
    //NSLibraryDirectory
    NSString *libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //目的地址
    NSString *PropertyListSP = [libraryDirectory stringByAppendingPathComponent:@"Caches/PropertyListSP.plist"];
    NSLog(@" PropertyListSP.plist %@",PropertyListSP);
    //拷贝
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:PropertyListSP])
    {
        [fileManager copyItemAtPath:filePath toPath:PropertyListSP error:nil];
        
    }
    
    return PropertyListSP;
}

+ (void)saveUserKeyedArchiverLocaData:(NSDictionary *)dic withSaveNmae:(NSString *)name
{
     //NSLibraryDirectory
    NSString *libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //目的地址
    NSString *path = [libraryDirectory stringByAppendingFormat:@"/Caches/%@",name];
    
    [NSKeyedArchiver archiveRootObject:dic toFile:path];
}

+ (NSDictionary *)getUserKeyedArchiverFromLocalData:(NSString *)name
{
    NSString *libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //目的地址
    NSString *fileName = [libraryDirectory stringByAppendingFormat:@"/Caches/%@",name];
        NSDictionary *reportIcoDic = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    return reportIcoDic;
}
+(void)showAlertViewWithTitle:(NSString *)title
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:title delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}
+(NSString *)getMpbh;
{
    NSUserDefaults * userDefault=[NSUserDefaults standardUserDefaults];
    NSArray * nurseryDataArray=[userDefault objectForKey:@"list"];
    int index=[[userDefault objectForKey:@"didSelectIndex"] intValue];
    NSDictionary *dic=[nurseryDataArray objectAtIndex:index];
    NSString *mpbh=dic[@"mpbh"];
    return mpbh;
}
+(NSString *)getNurseryName
{
    NSUserDefaults * userDefault=[NSUserDefaults standardUserDefaults];
    NSArray * nurseryDataArray=[userDefault objectForKey:@"list"];
    int index=[[userDefault objectForKey:@"didSelectIndex"] intValue];
    NSDictionary *dic=[nurseryDataArray objectAtIndex:index];
    NSString *nurseryName=dic[@"mpmc"];
    return nurseryName;
}
+(NSString *)getHybh
{    NSUserDefaults * userDefault=[NSUserDefaults standardUserDefaults];
    NSString *hybh=[userDefault objectForKey:@"hybh"];
    return hybh;
}
@end
