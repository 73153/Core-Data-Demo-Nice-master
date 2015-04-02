//
//  SQCAPI.m
//  Marenba
//
//  Created by sunqichao on 14-2-9.
//  Copyright (c) 2014年 sun qichao. All rights reserved.
//

#import "SQCAPI.h"

@implementation SQCAPI

+ (void)setPlistObject:(id)object withKey:(id)key
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"userInfo" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    [data setObject:object forKey:@"name"];
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"user.plist"];
    //输入写入
    [data writeToFile:filename atomically:YES];
}

+ (BOOL)isFirstLogin
{
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"user.plist"];
    NSMutableDictionary *data1 = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    NSLog(@"%@", data1);
    
    //判断是否是第一次登录
    if ([data1 objectForKey:@"name"]) {
        return NO;
    }else
    {
        return YES;
    }
}

+ (void)setUserToParse
{
    PFUser *user = [PFUser user];
    user.username = userName;
    user.password = @"123456";
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            DLog(@"zhu ce cheng gong");
        }else
        {
            DLog(@"zhu ce shi bai error %@",error);
        }
        
    }];

}

static NSString *userName = nil;
 
+ (NSString *)getCurrentUserName
{
    if (userName==nil) {
        NSString *name = [NSString stringWithFormat:@"小猪猪_%d",arc4random() % 900000];
        userName = name;
        [SQCAPI setUserToParse];
        
        [SQCAPI setPlistObject:name withKey:@"name"];
        
        
    }
    return userName;
}


+ (void)saveTheVoiceToParse:(NSString *)voicePath withTime:(float)time done:(feedbackDone)block
{
    NSString *cafPath = voicePath;
    NSData *cafData = [NSData dataWithContentsOfFile:cafPath];

    PFFile *cafFile = [PFFile fileWithName:@"voice.caf" data:cafData];
    [cafFile saveInBackground];
    
    PFObject *cafObj = [PFObject objectWithClassName:@"VoiceList"];
    cafObj[@"Voice"] = cafFile;
    cafObj[@"name"] = [SQCAPI getCurrentUserName];
    cafObj[@"voiceTime"] = [NSString stringWithFormat:@"%f",time];
    cafObj[@"user"] = [PFUser currentUser];
    [cafObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        DLog(@"upload succeed");
        block(succeeded);
    }];
    
}

+ (id)getCafList:(int)page
{
    PFQuery *query = [PFQuery queryWithClassName:@"VoiceList"];
    query.limit = LimtCount;
    query.skip = page*LimtCount;
    [query orderByDescending:@"createdAt"];
    return [query findObjects];
}

+ (id)getCurrentUserCafList:(int)page
{
    PFQuery *query = [PFQuery queryWithClassName:@"VoiceList"];
    query.limit = LimtCount;
    query.skip = page*LimtCount;
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    return [query findObjects];

}

+ (id)getCafDataFormParseObject:(id)PFobject
{
    PFObject *target = (PFObject *)PFobject;
    PFFile *file = target[@"Voice"];
    NSData *data = [file getData];
    return data;
}


@end
