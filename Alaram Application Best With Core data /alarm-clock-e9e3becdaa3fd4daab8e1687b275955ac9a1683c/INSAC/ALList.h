//
//  ALList.h
//  INSAC
//
//  Created by Dheeraj on 11/26/13.
//  Copyright (c) 2013 Insanity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ALList : NSManagedObject

@property (nonatomic, retain) NSDate * alarmTime;
@property (nonatomic, retain) NSNumber * snoozeTime;

@end
