//
//  SQC_StringUtility.m
//  MingPin
//
//  Created by sun qichao on 12-11-21.
//  Copyright (c) 2012年 sun qichao. All rights reserved.
//

#import "SQC_StringUtility.h"
#import "NSString_RegEx.h"
#import <CommonCrypto/CommonDigest.h>
#define REG_ICASE 0002
const NSString* REG_EMAIL = @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
const NSString* REG_MOBILE = @"^(13[0-9]|15[0-9]|18[0-9])\\d{8}$";
const NSString* REG_PHONE = @"^(([0\\+]\\d{2,3}-?)?(0\\d{2,3})-?)?(\\d{7,8})";//(-(\\d{3,}))?$";

@implementation SQC_StringUtility

+(NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim
{
    NSScanner *theScanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [ NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    
    return trim ? [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : html;
}

+(NSString *)flattenHTMLSecond:(NSString *)html trimWhiteSpace:(BOOL)trim
{
    NSScanner *theScanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"&" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@";" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [ NSString stringWithFormat:@"%@;", text]
                                               withString:@""];
    }
    
    return trim ? [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : html;
}


+ (NSString *)getTheRightContent:(NSString *)str
{
    NSString *content = [SQC_StringUtility flattenHTML:str trimWhiteSpace:YES];
    
    NSString *result = [SQC_StringUtility flattenHTMLSecond:content trimWhiteSpace:YES];
    
    return result;
}

+ (NSString *)isEmptyString:(NSString *)str
{
    NSString *resultStr = str?str:@"";
    
    return resultStr;
}

/*
 
 福布斯专用
 
 */
+ (NSString *)getTheRightURL:(NSString *)str
{
    NSString *url = [NSString stringWithFormat:@"http://www.forbeschina.com%@",str];
    
    return url;
}

//得到跟日历一样的日期
+ (NSDate *)getCurrentDate
{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //calendar是基于当前时区的，date是GMT，comps是返回date+8的当前时区的时间
    NSDateComponents *comps = [calendar components:(NSYearCalendarUnit |
                                                    NSMonthCalendarUnit |
                                                    NSDayCalendarUnit |
                                                    NSHourCalendarUnit |
                                                    NSMinuteCalendarUnit |
                                                    NSSecondCalendarUnit)
                                          fromDate:date];
    comps.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    
    return [calendar dateFromComponents:comps];
}

/**
 返回字符串高度
 @param str 字符串
 @param width 要显示的宽度
 @param font 要计算的字体大小
 @returns 字符串的高度
 */
+ (float)getStringHeight:(NSString *)str width:(float)width font:(float)font{
    CGSize size = CGSizeMake(width,3000);
    CGSize contentSize = [str sizeWithFont:[UIFont systemFontOfSize:font] constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    return contentSize.height;
    
}

/**
 将字符串转换为MD5码
 @param str 字符串
 @returns 已转码为MD5的字符串
 */
+(NSString*)SQCMD5:(NSString*)str
{
	const char *cStr = [str UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	
	CC_MD5( cStr, strlen(cStr), result );
	
	return [[NSString
			 stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			 result[0], result[1],
			 result[2], result[3],
			 result[4], result[5],
			 result[6], result[7],
			 result[8], result[9],
			 result[10], result[11],
			 result[12], result[13],
			 result[14], result[15]
			 ] lowercaseString];
}


/**
 安全获取字符串
 @param str 字符串
 @returns 若字符串为nil，则返回空字符串，否则直接返回字符串
 */
+(NSString*)strOrEmpty:(NSString*)str{
	return (str==nil?@"":str);
}

/**
 去掉首尾空格
 @param str 字符串
 @returns 去掉首尾空格的字符串
 */
+(NSString*)stripWhiteSpace:(NSString*)str{
	return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
}

/**
 去掉首尾空格和换行符
 @param str 字符串
 @returns 去掉首尾空格和换行符的字符串
 */
+(NSString*)stripWhiteSpaceAndNewLineCharacter:(NSString*)str{
	return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

/**
 @returns 获得唯一识别码
 */
+ (NSString *)getUUID
{
	CFUUIDRef theUUID = CFUUIDCreate(NULL);
	CFStringRef string = CFUUIDCreateString(NULL, theUUID);
	CFRelease(theUUID);
    NSString *str_uid = [NSString stringWithFormat:@"%@",string];
	return str_uid;
}

/**
 传过来一个名字就得到带着这个名字的目录(这个文件夹或者文件会存在Documents里面)
 @param 传过来一个名字
 @returns 名字的目录
 */
+ (NSString *)getPath:(NSString*)name
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	return [basePath stringByAppendingPathComponent:name];
}

/**
 @returns 返回document的文件的目录路径
 */
+ (NSString *)applicationDocumentsDirectory
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	return basePath;
}

/**
 传过来一个字符串，和它的字体大小就可以知道这个字符串的宽度
 @param 传过来一个字符串
 @param 字体
 @param 最大宽度限制
 @returns 字符串的宽度
 */
+ (float)getTxtLength:(NSString*)txt font:(int)f limit:(float)limit
{
    if(!txt || [txt length]<=0)
        return 0;
    
    CGSize temp = {900000, 30};
    CGSize txtSize = [txt sizeWithFont:[UIFont systemFontOfSize:f] constrainedToSize:temp];
    
    if(limit>0 && txtSize.width>limit)
        return limit;
    
    return txtSize.width;
}

/**
 @returns 会返回一个日期，只是日期，可以调整输出的位置。比如2012-6-15或者是15-6－2012
 */
+ (NSString *)compilationDate
{
    static const char *months[] = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug",
        "Sep", "Oct", "Nov", "Dec"};
    
    char gccDate[] = __DATE__;
    char outDate[11];
    char day[3] = { '\0' };
    char month[3] = { '\0' };
    char year[5] = { '\0' };
    int i;
    int index;
    
    index = strlen(gccDate) - 4;
    strncpy(year, &gccDate[index], 4);
    gccDate[strlen(gccDate) - 5] = '\0';
    
    strcpy(day, &gccDate[4]);
    gccDate[3] = '\0';
    
    for (i = 0; i < 12; i++)
    {
        if (!strcmp(gccDate, months[i]))
        {
            sprintf(month, "%i", i + 1);
        }
    }
    //year, month, day改变这三个的位置就能控制出处的格式是年月日还是日月年
    sprintf(outDate, "%s-%s-%s", year, month, day);
    
    NSString *compDate = [[NSString alloc] initWithCString:outDate encoding:NSASCIIStringEncoding];
    return compDate;
}

/**
 传传过来一个string，再传一个分隔符
 @param 传过来一个string
 @param 分隔符
 @returns string的分割数组
 */
+ (NSArray *)stringChangeToArr:(NSString *)str separate:(NSString *)sep{
    
    NSArray *arr_temp = [[NSArray alloc] init];
    
    arr_temp = [str componentsSeparatedByString:sep];
    
    return arr_temp;
}

/**
 判断邮箱是否正确
 @returns yes or no
 */
+(BOOL)mailJudging:(NSString*)email {
	
	NSString*  emailExpression=[NSString stringWithUTF8String:"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$"];
	
	if ([email grep:emailExpression options:REG_ICASE]) {
		return YES;
	}else {
		return NO;
	}
}

/**
 判断手机号码是否正确
 @returns yes or no
 */
+(BOOL)mobileJudging:(NSString*)phone {
	NSString*  phoneExpression=[NSString stringWithUTF8String:"^1[358][0-9]{9}$"];
	if ([phone grep:phoneExpression options:REG_ICASE]) {
		return YES;
	}else {
		return NO;
	}
}

/**
 判断帐号是否正确 （福布斯专用）
 @returns yes or no
 */
+ (BOOL)isTheRightAccount:(NSString *)name
{
    BOOL isRight = YES;

    
    
    return isRight;
}



/**
 判断密码是否正确 （福布斯专用）
 @returns yes or no
 */
+ (BOOL)isTheRightPassword:(NSString *)password
{
    BOOL isRight = YES;
    
    
    
    return isRight;

}

/**
 传传过来一个日期的string
 @param 传过来一个日期string
 
 @returns 时间戳
 */
+ (NSString *)returnTimeStamp:(NSString *)date
{
    NSString *timeStamp = @"";
    
    timeStamp = date;
    
    return timeStamp;
}


@end
