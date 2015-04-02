//
//  VoiceEntity.h
//  Marenba
//
//  Created by sunqichao on 14-2-12.
//  Copyright (c) 2014年 sun qichao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface VoiceEntity : NSManagedObject

@property (nonatomic, retain) NSData * voiceData;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * creatAt;
@property (nonatomic, retain) NSString * objectId;

+ (NSFetchedResultsController *)fetchedResultsController;


@end
