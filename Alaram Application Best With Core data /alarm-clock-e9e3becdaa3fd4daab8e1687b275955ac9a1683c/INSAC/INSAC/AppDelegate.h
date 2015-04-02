//
//  AppDelegate.h
//  INSAC
//
//  Created by Dheeraj on 11/26/13.
//  Copyright (c) 2013 Insanity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALListViewController;
@class ALMainViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    ALListViewController *listViewController;
    ALMainViewController *alarmViewController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) ALMainViewController *alarmViewController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
