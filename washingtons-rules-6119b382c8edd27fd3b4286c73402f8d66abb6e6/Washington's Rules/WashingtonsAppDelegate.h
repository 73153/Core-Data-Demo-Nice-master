//
//  WashingtonsAppDelegate.h
//  Washington's Rules
//
//  Created by John Hayes on 4/1/14.
//  Copyright (c) 2014 SoftWhatever. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WashingtonsAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property (readonly, strong, nonatomic) NSString *currentRule;
@property (readonly, strong, nonatomic) NSDictionary *appSettings;

@end
