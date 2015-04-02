//
//  ALSetViewController.m
//  INSAC
//
//  Created by Dheeraj on 11/26/13.
//  Copyright (c) 2013 Insanity. All rights reserved.
//

#import "ALSetViewController.h"
#import "ALList.h"
#import "AppDelegate.h"
#import "ALSnoozeViewController.h"

@interface ALSetViewController ()

@end

@implementation ALSetViewController
@synthesize snoozeTime;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Set" style:UIBarButtonItemStyleDone target:self action:@selector(setAlarm)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss)];
    self.ALTimePicker.frame = CGRectMake(0, self.ALTimePicker.frame.origin.y, 320, 216);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:self.ALTimePicker.date];
    [components setDay:[components day]];
    [components setMonth:[components month]];
    [components setYear:[components year]];
    [components setMinute:[components minute] + 1];
    [components setHour:[components hour]];
    NSDate *ALNewDate = [calendar dateFromComponents:components];
    
    self.ALTimePicker.minimumDate = ALNewDate;
    self.snoozeTime = 5;
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.navigationItem.title = @"Set Alarm";
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [snoozeSlider setValue:(float)self.snoozeTime animated:YES];
}
-(void) dismiss {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void) setAlarm {
    ALList *newAlarm = [NSEntityDescription insertNewObjectForEntityForName:@"ALList" inManagedObjectContext:appDelegate.managedObjectContext];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:self.ALTimePicker.date];
    [components setDay:[components day]];
    [components setMonth:[components month]];
    [components setYear:[components year]];
    [components setMinute:[components minute]];
    [components setHour:[components hour]];
    NSDate *ALNewDate = [calendar dateFromComponents:components];
    
    newAlarm.alarmTime = ALNewDate;
    newAlarm.snoozeTime = [NSNumber numberWithInt:snoozeTime];
    [appDelegate saveContext];
    [self dismiss];
    
    UILocalNotification *alarmNotification = [[UILocalNotification alloc] init];
    alarmNotification.alertBody = @"Alarm";
    alarmNotification.fireDate = ALNewDate;
    alarmNotification.alertAction = @"Snooze";
    alarmNotification.soundName = @"Alarm.caf";
    alarmNotification.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:newAlarm.alarmTime,@"alarmTime", [newAlarm.snoozeTime stringValue],@"snoozeTime", nil];
    [[UIApplication sharedApplication] scheduleLocalNotification:alarmNotification];
}

-(IBAction)ALTimeSelected:(id)sender {
    UITableViewCell *ALTimeCell = [self.ALSettingsView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a dd/MM/YYYY"];
    NSString *ALdateString = [dateFormatter stringFromDate:self.ALTimePicker.date];
    ALTimeCell.detailTextLabel.text = ALdateString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.userInteractionEnabled = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"Time";
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"hh:mm a dd/MM/YYYY"];
            NSString *ALdateString = [dateFormatter stringFromDate:self.ALTimePicker.date];
            cell.detailTextLabel.text = ALdateString;
            cell.userInteractionEnabled = NO;
        }
            break;
        case 1: {
            cell.textLabel.text = @"Snooze";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d mins",self.snoozeTime];
        }
            break;
        case 2: {
            snoozeSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, 6, 280, 10)];
            snoozeSlider.minimumValue = 5;
            snoozeSlider.maximumValue = 30;
            [cell.contentView addSubview:snoozeSlider];
            [snoozeSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
        default:
            break;
    }
    return cell;
}

-(void) sliderValueChanged:(UISlider *) slider {
    self.snoozeTime = abs([slider value]);
    UITableViewCell *ALSnoozeCell = [self.ALSettingsView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    ALSnoozeCell.detailTextLabel.text = [NSString stringWithFormat:@"%d mins",self.snoozeTime];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Navigation logic may go here, for example:
 // Create the next view controller.
     
     ALSnoozeViewController *detailViewController = [[ALSnoozeViewController alloc] initWithNibName:@"ALSnoozeViewController" bundle:nil];
     // Pass the selected object to the new view controller.
     detailViewController.prevViewController = self;

     // Push the view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
 }


@end
