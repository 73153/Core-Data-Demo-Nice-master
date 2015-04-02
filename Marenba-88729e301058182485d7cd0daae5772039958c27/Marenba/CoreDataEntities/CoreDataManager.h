//
//  CoreDataManager.h
//  Marenba
//
//  Created by sunqichao on 14-2-13.
//  Copyright (c) 2014年 sun qichao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQCDefine.h"
@interface CoreDataManager : NSObject

+ (void)saveVoiceDataToCoreData:(id)data withBlock:(feedbackDone)block;

+ (void)readVoiceFromCoreDataWithCount:(int)pageCount block:(writeArticleFinished)block;

@end
