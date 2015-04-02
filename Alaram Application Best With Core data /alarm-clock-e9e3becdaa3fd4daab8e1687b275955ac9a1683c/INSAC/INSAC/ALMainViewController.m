//
//  ALMainViewController.m
//  INSAC
//
//  Created by Dheeraj on 11/26/13.
//  Copyright (c) 2013 Insanity. All rights reserved.
//

#import "ALMainViewController.h"
#import "ALListViewController.h"
#import "ALList.h"
#import "ALSnoozeViewController.h"

@interface ALMainViewController ()

@end

@implementation ALMainViewController

@synthesize alarmInfo,timeLabel,dateLabel,snoozeLabel,alListViewController;
@synthesize snoozeTime,snoozeButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.alarmInfo = [[NSMutableDictionary alloc] init];
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *ALdateString = [dateFormatter stringFromDate:[self.alarmInfo objectForKey:@"alarmTime"]];
    self.timeLabel.text = ALdateString;
    
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    ALdateString = [dateFormatter stringFromDate:[self.alarmInfo objectForKey:@"alarmTime"]];
    self.dateLabel.text = ALdateString;
    self.snoozeLabel.text = [NSString stringWithFormat:@"Snooze Interval : %@ mins",[self.alarmInfo objectForKey:@"snoozeTime"]];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (([(NSDate *)[self.alarmInfo objectForKey:@"alarmTime"] compare:[NSDate date]] == NSOrderedAscending) && self.alListViewController != nil) {
        snoozeButton.enabled = NO;
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button functions

-(IBAction)cancelAlarm:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(IBAction)snoozeAlarm:(id)sender {
    if (self.alListViewController != nil) {
        ALSnoozeViewController *detailViewController = [[ALSnoozeViewController alloc] initWithNibName:@"ALSnoozeViewController" bundle:nil];
        // Pass the selected object to the new view controller.
        detailViewController.prevViewController = self;
        
        // Push the view controller.
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:[NSDate date]];
        [components setDay:[components day]];
        [components setMonth:[components month]];
        [components setYear:[components year]];
        [components setMinute:[components minute] + [[self.alarmInfo objectForKey:@"snoozeTime"] intValue]];
        [components setHour:[components hour]];
        NSDate *ALNewDate = [calendar dateFromComponents:components];
        
        UILocalNotification *alarmNotification = [[UILocalNotification alloc] init];
        alarmNotification.alertBody = @"Alarm";
        alarmNotification.fireDate = ALNewDate;
        alarmNotification.alertAction = @"Snooze";
        alarmNotification.soundName = @"Alarm.caf";
        alarmNotification.userInfo = [NSDictionary dictionaryWithDictionary:self.alarmInfo];
        [[UIApplication sharedApplication] scheduleLocalNotification:alarmNotification];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

-(IBAction)deleteAlarm:(id)sender {
    if (self.alListViewController != nil) {
        [self.alListViewController deleteAlarm];
    }
    else {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ALList" inManagedObjectContext:appDelegate.managedObjectContext];
        
        NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"%K == %@ ", @"alarmTime",[self.alarmInfo objectForKey:@"alarmTime"]];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:aPredicate];
        NSError *error = nil;
        NSArray *items = nil;
        @try {
            items = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        }
        @catch (NSException *exception) {
            NSLog(@"exception is thrown from fetch result controller");
        }
        
        [appDelegate.managedObjectContext deleteObject:[items objectAtIndex:0]];
        [appDelegate saveContext];
    }

    UILocalNotification *notificationToDelete = nil;
    for (UILocalNotification *aNotif in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if ([[aNotif.userInfo objectForKey:@"alarmTime"] compare:[self.alarmInfo objectForKey:@"alarmTime"]] == NSOrderedSame) {
            notificationToDelete = aNotif;
            break;
        }
    }
    if (notificationToDelete) {
        [[UIApplication sharedApplication] cancelLocalNotification:notificationToDelete];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        [self snoozeAlarm:nil];
    }
}

-(void) changeSnoozeTime {
   
    // change DB
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ALList" inManagedObjectContext:appDelegate.managedObjectContext];
    
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"%K == %@ ", @"alarmTime",[self.alarmInfo objectForKey:@"alarmTime"]];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:aPredicate];
    NSError *error = nil;
    NSArray *items = nil;
    @try {
        items = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }
    @catch (NSException *exception) {
        NSLog(@"exception is thrown from fetch result controller");
    }
    
    [(ALList *)[items objectAtIndex:0]  setSnoozeTime:[NSNumber numberWithInt:self.snoozeTime]];
    [appDelegate saveContext];
    
    // change local alarmInfo
    [self.alarmInfo setValue:[NSString stringWithFormat:@"%d",self.snoozeTime] forKey:@"snoozeTime"];
    
    //change label
    self.snoozeLabel.text = [NSString stringWithFormat:@"Snooze Interval : %d mins",self.snoozeTime];
    
    //delete old notification
    UILocalNotification *notificationToChange = nil;
    for (UILocalNotification *aLocalNotif in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if ([[aLocalNotif.userInfo objectForKey:@"alarmTime"] compare:[self.alarmInfo objectForKey:@"alarmTime"]] == NSOrderedSame) {
            notificationToChange = aLocalNotif;
            break;
        }
    }
    if (notificationToChange) {
        [[UIApplication sharedApplication] cancelLocalNotification:notificationToChange];
    }
    
    //create new notification
    {
        UILocalNotification *alarmNotification = [[UILocalNotification alloc] init];
        alarmNotification.alertBody = @"Alarm";
        alarmNotification.fireDate = [self.alarmInfo objectForKey:@"alarmTime"];
        alarmNotification.alertAction = @"Snooze";
        alarmNotification.soundName = @"Alarm.caf";
        alarmNotification.userInfo = self.alarmInfo;
        [[UIApplication sharedApplication] scheduleLocalNotification:alarmNotification];
    }
}

@end
