//
//  ALListViewController.m
//  INSAC
//
//  Created by Dheeraj on 11/26/13.
//  Copyright (c) 2013 Insanity. All rights reserved.
//

#import "ALListViewController.h"
#import "ALSetViewController.h"
#import "AppDelegate.h"
#import "ALList.h"
#import "ALMainViewController.h"

@interface ALListViewController ()

@end

@implementation ALListViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAlarm)];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.navigationItem.title = @"Alarms";
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}

    if (self.fetchedResultsController.fetchedObjects.count > 0) {
        [self.tableView reloadData];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - functions

-(void) addAlarm {
    ALSetViewController *saViewController = [[ALSetViewController alloc] initWithNibName:@"ALSetViewController" bundle:nil];
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:saViewController] animated:YES completion:^{
        
    }];
}

-(void) deleteAlarm {
    [appDelegate.managedObjectContext deleteObject:[self.fetchedResultsController.fetchedObjects objectAtIndex:viewingAlarmIndexPath.row]];
    [appDelegate saveContext];
}

#pragma mark - fetchedresulsts controller 

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ALList" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"alarmTime" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                  managedObjectContext:appDelegate.managedObjectContext sectionNameKeyPath:nil
                                                                                                             cacheName:@"Root"];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}


#pragma mark - fetchedresults controller delegates

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
    if([self.fetchedResultsController.fetchedObjects count] > 0) {
        [self.tableView reloadData];
    }
    else {
        
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	switch(type) {
        case NSFetchedResultsChangeInsert:
			[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
        case NSFetchedResultsChangeUpdate: {
            [[self tableView] reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeMove:
            break;
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            break;
        case NSFetchedResultsChangeDelete:
            break;
        case NSFetchedResultsChangeMove:
            break;
        case NSFetchedResultsChangeUpdate:
            break;
        default:
            break;
    }
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
    return self.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    ALList *alarmInfo = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
    
    if ([alarmInfo.alarmTime compare:[NSDate date]] == NSOrderedAscending) {//past alarms displayed in normal font
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    }
    // Configure the cell...
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *ALdateString = [dateFormatter stringFromDate:alarmInfo.alarmTime];
    cell.textLabel.text = ALdateString;
    
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    ALdateString = [dateFormatter stringFromDate:alarmInfo.alarmTime];
    cell.detailTextLabel.text = ALdateString;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];

        UILocalNotification *notificationToDelete = nil;
        for (UILocalNotification *aNotif in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
            if ([(NSDate *)[aNotif.userInfo objectForKey:@"alarmTime"] compare:[[self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row] alarmTime]] == NSOrderedSame) {
                notificationToDelete = aNotif;
                break;
            }
        }
        if (notificationToDelete) {
            [[UIApplication sharedApplication] cancelLocalNotification:notificationToDelete];
        }
        [appDelegate.managedObjectContext deleteObject:[self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row]];
        [appDelegate saveContext];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

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
    /*<#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    */
    ALList *alarmInfo = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
    if (appDelegate.alarmViewController == nil) {
        appDelegate.alarmViewController = [[ALMainViewController alloc] initWithNibName:@"ALMainViewController" bundle:nil];
    }
    appDelegate.alarmViewController.alListViewController = self;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:alarmInfo.alarmTime,@"alarmTime",alarmInfo.snoozeTime,@"snoozeTime", nil];
    appDelegate.alarmViewController.alarmInfo = dict;
    appDelegate.alarmViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UINavigationController *navCtr = [[UINavigationController alloc] initWithRootViewController:appDelegate.alarmViewController];
    [self.navigationController presentViewController:navCtr animated:YES completion:^{
        viewingAlarmIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    }];
}

@end
