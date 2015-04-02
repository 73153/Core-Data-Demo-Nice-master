//
//  WashingtonsViewController.m
//  Washington's Rules
//
//  Created by John Hayes on 4/1/14.
//  Copyright (c) 2014 SoftWhatever. All rights reserved.
//

#import "WashingtonsViewController.h"
#import "WashingtonsAppDelegate.h"

@interface WashingtonsViewController ()
@end

@implementation WashingtonsViewController

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
    
    CGFloat cardCornerRadius = 15.0;
    
    // Register to notify the view controller whenever the app becomes active again
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // Give the Rule Card rounded corners. The Right Way™ to do this is probably to create a Card class that inherits from UIView and make that the class that self.ruleCardRule uses.
    [self.ruleCardRule.layer setCornerRadius:cardCornerRadius];
    
    // Get the current rule from app delegate. Delegate will update the rule when appropriate.
    WashingtonsAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    // Set the quote
    [self.ruleCardRule setSelectable:YES];
    [self.ruleCardRule setText:[appDelegate currentRule]];
    [self.ruleCardRule setSelectable:NO];

}

#pragma mark - Application Notification Handlers

- (void)didBecomeActive:(NSNotification *)notification
{
    // Set the quote
    WashingtonsAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    [self.ruleCardRule setSelectable:YES];
    [self.ruleCardRule setText:[appDelegate currentRule]];
    [self.ruleCardRule setSelectable:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
