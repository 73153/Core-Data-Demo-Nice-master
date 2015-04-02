//
//  SQCDefine.h
//  SQC
//
//  Created by sunqichao on 13-12-22.
//  Copyright (c) 2013年 sun qichao. All rights reserved.
//

#ifndef SQC_SQCDefine_h
#define SQC_SQCDefine_h

#import "AppDelegate.h"
#define settingCornerRadius 40.0f

#define SQCDEBUG

#ifdef SQCDEBUG
#define DLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif

#define defaultImage @"zhifubaoBack.jpg"

#define refreshBackgroundColor [UIColor colorWithRed:94.0f/255.0f green:103.0f/255.0f blue:122.0f/255.0f alpha:1.0f]

#define DefaultHeaderImage @"u=3112382559,2562752001&fm=21&gp=0.jpg"
#define SQC_appdelegate ((AppDelegate*)[UIApplication sharedApplication].delegate)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define UMAPPKEY @"5268c06b56240b7a6f01668f"        //友盟appkey

#define WXAPPKEY @"wx80750afdd2cf7b69"        //微信appkey

#define MangGuoAppKey @"143503981a9b4ce4851f65a45f704271"       //芒果广告的ID

#pragma mark - 零花钱

#define exchangepointsToMoney 300           //测试时设置为1   测试完成后改回300

#pragma mark - 骂人吧

#define LimtCount 10

#define DefaultCafPath [NSString stringWithFormat:@"%@/Documents/MySound.caf", NSHomeDirectory()]

#define DefaultCafPathMp3 [NSString stringWithFormat:@"%@/Documents/MySound.mp3", NSHomeDirectory()]

#pragma mark - 内涵漫画
/**
 
 三人行必有我师    ：       ThreePeopleAndTeacher
 请叫我小清新    ：       SmallWhite
 节操笑话         ：       JieCaoXiaoHua
 
 **/

#define parseClassKeyword @"JieCaoXiaoHua"

#define kPAPUserProfilePicMediumKey @"avatar"

#define kPAPInstallationChannelsKey @"channels"

#define kPAPUserPrivateChannelKey @"channel"

#define sqcSaveNotification @"sqcSaveNotification"

#define sqcSaveNotificationDataKey @"sqcSaveNotificationDataKey"

#define sqcShareNotification @"sqcShareNotification"

#define sqcShareNotificationDataKey @"sqcShareNotificationDataKey"

#define jiazaizhongyaoxianshide @"正在加载中，男淫。。。"      //SQCViewController 里用的等候语

#define jiazaiwanchengyaoxianshide @"好了，看吧，男淫。。。"   //SQCViewController 里用的

#define yaoyiyaoAlertMessage @"亲爱的，你已经获取%@个积分，坚持哦。"      //摇一摇用到的提示语

#define yaoyiyaoAlertMessageFailed @"亲爱的，你已经今天摇过了，明天再来吧。"      //摇一摇用到的提示语

#define rechargeSuccess @"亲，话费充值进行中，最晚第二天到账。"      //充值成功的提示语

#define pointsNotEnough @"亲，你的积分不够哦，赶快去挣积分吧!"      //积分不够的提示语

#define FengyunKeyName @"userName"

#define FengyunKeyPoints @"currentPoints"

typedef void (^writeArticleFinished)(id writedata,BOOL isRight);
typedef void (^readArticleFinished)(id readdata,BOOL isRight);
typedef void (^saveDataFinished)(id saveData,BOOL isRight);
typedef void (^feedbackDone)(BOOL isRight);

#endif
