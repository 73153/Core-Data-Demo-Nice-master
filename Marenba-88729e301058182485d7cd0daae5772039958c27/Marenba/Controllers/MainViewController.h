//
//  MainViewController.h
//  Marenba
//
//  Created by sun qichao on 14-2-8.
//  Copyright (c) 2014年 sun qichao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQCFetchedResultsController.h"

@interface MainViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate,SQCFetchedResultsDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;



/*
 
 切换骂人列表
 
 */
- (IBAction)SegmentChange:(id)sender;

/*
 
 开始录音三个相关方法，开始，结束，取消
 
 */
- (IBAction)start:(id)sender;

- (IBAction)touchEnd:(id)sender;

- (IBAction)touchCancel:(id)sender;













@end
