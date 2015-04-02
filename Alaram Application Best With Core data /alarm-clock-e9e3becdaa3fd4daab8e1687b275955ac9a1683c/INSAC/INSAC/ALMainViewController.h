//
//  ALMainViewController.h
//  INSAC
//
//  Created by Dheeraj on 11/26/13.
//  Copyright (c) 2013 Insanity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@class ALListViewController;

@interface ALMainViewController : UIViewController {
    AppDelegate *appDelegate;
}

@property (strong,nonatomic) NSMutableDictionary *alarmInfo;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel,*dateLabel,*snoozeLabel;
@property (strong, nonatomic) IBOutlet UIButton *snoozeButton;
@property (strong,nonatomic) ALListViewController *alListViewController;//to identify if this view is launched from the listviewcontroller
@property (nonatomic) int snoozeTime;

-(IBAction)cancelAlarm:(id)sender;
-(IBAction)snoozeAlarm:(id)sender;
-(IBAction)deleteAlarm:(id)sender;

-(void) changeSnoozeTime;

@end
