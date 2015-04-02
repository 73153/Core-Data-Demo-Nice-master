//
//  SQC_StringUtility.h
//  MingPin
//
//  Created by sun qichao on 12-11-21.
//  Copyright (c) 2012年 sun qichao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQC_StringUtility : NSObject


/*
 
 福布斯专用
 
 */

//得到正确的url链接
+ (NSString *)getTheRightURL:(NSString *)str;

//判断是否为空，空就返回@""
+ (NSString *)isEmptyString:(NSString *)str;

//过滤福布斯文章内容
+ (NSString *)getTheRightContent:(NSString *)str;

//过滤html的标签
+(NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim;

//过滤掉&之类的符号
+(NSString *)flattenHTMLSecond:(NSString *)html trimWhiteSpace:(BOOL)trim;

//得到跟日历一样的日期
+ (NSDate *)getCurrentDate;

/**
 返回字符串高度
 @param str 字符串
 @param width 要显示的宽度
 @param font 要计算的字体大小
 @returns 字符串的高度
 */
+ (float)getStringHeight:(NSString *)str width:(float)width font:(float)font;

/**
 将字符串转换为MD5码
 @param str 字符串
 @returns 已转码为MD5的字符串
 */
+(NSString*)SQCMD5:(NSString*)str;

/**
 安全获取字符串
 @param str 字符串
 @returns 若字符串为nil，则返回空字符串，否则直接返回字符串
 */
+(NSString*)strOrEmpty:(NSString*)str;

/**
 去掉首尾空格
 @param str 字符串
 @returns 去掉首尾空格的字符串
 */
+(NSString*)stripWhiteSpace:(NSString*)str;

/**
 去掉首尾空格和换行符
 @param str 字符串
 @returns 去掉首尾空格和换行符的字符串
 */
+(NSString*)stripWhiteSpaceAndNewLineCharacter:(NSString*)str;

/**
 @returns 获得唯一识别码
 */
+ (NSString *)getUUID;

/**
 传过来一个名字就得到带着这个名字的目录(这个文件夹或者文件会存在Documents里面) 
 @param 传过来一个名字
 @returns 名字的目录
 */
+ (NSString *)getPath:(NSString*)name;

/**
 @returns 返回document的文件的目录路径
 */
+ (NSString *)applicationDocumentsDirectory;

/**
 传过来一个字符串，和它的字体大小就可以知道这个字符串的宽度
 @param 传过来一个字符串
 @param 字体
 @param 最大宽度限制
 @returns 字符串的宽度
 */
+ (float)getTxtLength:(NSString*)txt font:(int)f limit:(float)limit;

/**
 @returns 会返回一个日期，只是日期，可以调整输出的位置。比如2012-6-15或者是15-6－2012
 */
+ (NSString *)compilationDate;

/**
 传传过来一个string，再传一个分隔符
 @param 传过来一个string
 @param 分隔符
 @returns string的分割数组
 */
+ (NSArray *)stringChangeToArr:(NSString *)str separate:(NSString *)sep;

/**
 判断邮箱是否正确
 @returns yes or no
 */
+(BOOL)mailJudging:(NSString*)email;

/**
 判断手机号码是否正确
 @returns yes or no
 */
+(BOOL)mobileJudging:(NSString*)phone;



/**
 判断帐号是否正确 （福布斯专用）
 @returns yes or no
 */
+ (BOOL)isTheRightAccount:(NSString *)name;

/**
 判断密码是否正确 （福布斯专用）
 @returns yes or no
 */
+ (BOOL)isTheRightPassword:(NSString *)password;



/**
 传传过来一个日期的string
 @param 传过来一个日期string

 @returns 时间戳
 */
+ (NSString *)returnTimeStamp:(NSString *)date;

@end
