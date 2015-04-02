//
//  SQCAPI.h
//  Marenba
//
//  Created by sunqichao on 14-2-9.
//  Copyright (c) 2014年 sun qichao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQCAPI : NSObject

//向user.plist写入数据
+ (void)setPlistObject:(id)object withKey:(id)key;

//判断是否是第一次登录
+ (BOOL)isFirstLogin;

//向parse注册用户
+ (void)setUserToParse;

//获取当前用户名
+ (NSString *)getCurrentUserName;

//把录音发到服务器
+ (void)saveTheVoiceToParse:(NSString *)voicePath withTime:(float)time done:(feedbackDone)block;

//获取所有录音列表
+ (id)getCafList:(int)page;

//获取当前用户的录音列表
+ (id)getCurrentUserCafList:(int)page;

//根据pfobject来获取录音的二进制数据
+ (id)getCafDataFormParseObject:(id)PFobject;

@end
