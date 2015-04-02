//
//  CoreDataManager.m
//  Marenba
//
//  Created by sunqichao on 14-2-13.
//  Copyright (c) 2014年 sun qichao. All rights reserved.
//

#import "CoreDataManager.h"
#import "VoiceEntity.h"
@implementation CoreDataManager

+ (void)saveVoiceDataToCoreData:(id)data withBlock:(feedbackDone)block
{
    BOOL isSuccess = YES;
    
    NSArray *array = (NSArray *)data;
    
    for (PFObject *dic in array) {
        
        if (![self isSameVoiceData:[dic.objectId description]]) {
            
            NSManagedObjectContext *context = [SQC_appdelegate managedObjectContext];
            VoiceEntity *atlas = [NSEntityDescription
                              insertNewObjectForEntityForName:@"VoiceEntity"
                              inManagedObjectContext:context];
            
            atlas.objectId = [dic.objectId description];
            atlas.time = [dic objectForKey:@"title"];
            atlas.name = [dic objectForKey:@"shortArticle"];
            atlas.voiceData = [dic objectForKey:@"article"];
            atlas.creatAt = [dic.createdAt description];
            
            NSError *error;
            if (![context save:&error]) {
                isSuccess = NO;
                
            }else{
                isSuccess = YES;
                
            }
            
        }
    }
    
    block(isSuccess);
    
}


+ (BOOL)isSameVoiceData:(NSString *)objectID
{
    BOOL isSame = NO;
    
    NSManagedObjectContext *context = [SQC_appdelegate managedObjectContext];
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"VoiceEntity"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId = %@",objectID];
    [fetchRequest setPredicate:predicate];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if ([fetchedObjects count]>0) {
        isSame = YES;
    }else
    {
        isSame = NO;
    }
    
    return isSame;
    
}

+ (void)readVoiceFromCoreDataWithCount:(int)pageCount block:(writeArticleFinished)block
{
    
    NSManagedObjectContext *context = [SQC_appdelegate managedObjectContext];
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"VoiceEntity"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creatAt" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSUInteger index = pageCount * 10;
    [fetchRequest setFetchLimit:index];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if ([fetchedObjects count]==0) {
        
        block(fetchedObjects,NO);
        
    }else
    {
        
        block(fetchedObjects,YES);
        
    }
    
    
    
    
    
}


@end
