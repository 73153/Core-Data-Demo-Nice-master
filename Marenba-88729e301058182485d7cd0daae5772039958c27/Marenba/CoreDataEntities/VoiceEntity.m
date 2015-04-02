//
//  VoiceEntity.m
//  Marenba
//
//  Created by sunqichao on 14-2-12.
//  Copyright (c) 2014年 sun qichao. All rights reserved.
//

#import "VoiceEntity.h"


@implementation VoiceEntity

@dynamic voiceData;
@dynamic time;
@dynamic name;
@dynamic creatAt;
@dynamic objectId;
+ (NSString*)entityName
{
    return @"VoiceEntity";
}
+ (NSFetchedResultsController *)fetchedResultsController
{
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    //创建一个查询请求
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //查询条件
    NSEntityDescription *entity = [NSEntityDescription entityForName:[self.class entityName] inManagedObjectContext:delegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    //查询排序，必须的
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    //设置查询的个数
    [fetchRequest setFetchBatchSize:20];
    //创建一个赋给全局的，然后就可以自动运作了，霍霍
    NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:delegate.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    return theFetchedResultsController;
    
}

@end
