//
//  ALListViewController.h
//  INSAC
//
//  Created by Dheeraj on 11/26/13.
//  Copyright (c) 2013 Insanity. All rights reserved.
//
	
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

/*Shows the list of alarms that have been set*/
@interface ALListViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    AppDelegate *appDelegate;
    NSIndexPath *viewingAlarmIndexPath; //store indexpath for delete case.
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

-(void) deleteAlarm;

@end
