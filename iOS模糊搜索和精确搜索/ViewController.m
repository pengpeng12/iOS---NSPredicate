//
//  ViewController.m
//  iOS模糊搜索和精确搜索
//
//  Created by apple  on 2016/12/6.
//  Copyright © 2016年 apple . All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //过滤NSArray
    NSArray *array = [[NSArray alloc]initWithObjects:@"beijing",@"shanghai",@"guangzou",@"wuhan", nil];
    NSString *string = @"ang";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",string];
    NSLog(@"%@",[array filteredArrayUsingPredicate:pred]);
    //判断字符串首字母是否为字母
    NSString *regex = @"[A-Za-z]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([predicate evaluateWithObject:@"a"]) {
        NSLog(@"YES");
    }
    //字符串替换
    NSError *error = NULL;
    NSRegularExpression *regexs = [NSRegularExpression regularExpressionWithPattern:@"(encoding=\")[^\"]+(\")" options:0 error:&error];
    NSString *sample = @"<xml encoding=\"abc\"></xml><xml encoding=\"def\"></xml><xml encoding=\"ttt\"></xml>";
    NSLog(@"Start:%@",sample);
    NSString *result = [regexs stringByReplacingMatchesInString:sample options:0 range:NSMakeRange(0, sample.length) withTemplate:@"$1utf-8$2"];
    NSLog(@"Result:%@",result);
    
    //字符串截取
    //组装一个字付串，需要把里面的网址解析出来
    NSString *urlString = @"<meta/><link/><title>1Q84 BOOK1</title></head><body>";
    //http+:[^\\s]*这个表达式是检测一个网址的。(?<=title\>).*(?=</title)截取html中的<title><title>内文子的正则表达式
    NSRegularExpression *regexjq = [NSRegularExpression regularExpressionWithPattern:@"(?<=title\\>).*(?=</title>)" options:0 error:&error];
    if (regexjq != nil) {
        NSTextCheckingResult *firstMatch = [regexjq firstMatchInString:urlString options:0 range:NSMakeRange(0, [urlString length])];
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            
            //从urlString中截取数据
            NSString *result = [urlString substringWithRange:resultRange];
            NSLog(@"--截取结果：%@",result);
        }
    }
}

    //判断手机号码，电话号码函数
//正则判断手机号码地址格式
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        if([regextestcm evaluateWithObject:mobileNum] == YES) {
            NSLog(@"China Mobile");
        } else if([regextestct evaluateWithObject:mobileNum] == YES) {
            NSLog(@"China Telecom");
        } else if ([regextestcu evaluateWithObject:mobileNum] == YES) {
            NSLog(@"China Unicom");
        } else {
            NSLog(@"Unknow");
        }
        
        return YES;
    }
    else
    {
        return NO;
    }
}
//邮箱验证、电话号码验证:
//是否是有效的正则表达式

+(BOOL)isValidateRegularExpression:(NSString *)strDestination byExpression:(NSString *)strExpression

{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strExpression];
    
    return [predicate evaluateWithObject:strDestination];
    
}

//验证email
+(BOOL)isValidateEmail:(NSString *)email {
    
    NSString *strRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,5}";
    
    BOOL rt = [self isValidateRegularExpression:email byExpression:strRegex];
    
    return rt;
    
}

//验证电话号码
+(BOOL)isValidateTelNumber:(NSString *)number {
    
    NSString *strRegex = @"[0-9]{1,20}";
    
    BOOL rt = [self isValidateRegularExpression:number byExpression:strRegex];
    
    return rt;
    
}

//NSDate进行筛选
- (void)dateShaiXuan{
//日期在十天之内:
    NSDate *endDate = [NSDate date];
    NSTimeInterval timeInterval= [endDate timeIntervalSinceReferenceDate];
    timeInterval -=3600*24*10;
    NSDate *beginDate = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
    //对coredata进行筛选(假设有fetchRequest)
    NSPredicate *predicate_date =
    [NSPredicate predicateWithFormat:@"date >= %@ AND date <= %@", beginDate,endDate];

   // [fetchRequest setPredicate:predicate_date];
   
}



















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
