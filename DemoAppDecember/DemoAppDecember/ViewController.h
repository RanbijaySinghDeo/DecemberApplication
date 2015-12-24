//
//  ViewController.h
//  DemoAppDecember
//
//  Created by RanbijaySinghDeo on 23/12/15.
//  Copyright © 2015 RanbijaySinghDeo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connection.h"



@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ConnectionDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *tempratureImageView;
@property (weak, nonatomic) IBOutlet UILabel *tempratureLabel;
- (IBAction)rightBarItemTapped:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITableView *cityTable;
@property (strong,nonatomic)id responseData;
@end

