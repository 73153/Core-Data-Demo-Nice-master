//
//  ALSetViewController.h
//  INSAC
//
//  Created by Dheeraj on 11/26/13.
//  Copyright (c) 2013 Insanity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ALSetViewController : UIViewController {
    AppDelegate *appDelegate;
    UISlider *snoozeSlider;
}

@property (strong, nonatomic) IBOutlet UIDatePicker *ALTimePicker;
@property (strong, nonatomic) IBOutlet UITableView  *ALSettingsView;
@property (nonatomic) int snoozeTime;

-(IBAction)ALTimeSelected:(id)sender;

@end
