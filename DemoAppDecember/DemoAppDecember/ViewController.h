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
@property (weak, nonatomic) IBOutlet UIWebView *imageWebView;
@property (weak, nonatomic) IBOutlet UILabel *weatherConditionLabel;
@property (strong,nonatomic)id responseData;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *highLabel;

@property (weak, nonatomic) IBOutlet UILabel *set;
@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UILabel *todaysDate;
@property (weak, nonatomic) IBOutlet UILabel *rise;
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;
@property (weak, nonatomic) IBOutlet UILabel *humidityTopLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImage;
@property (weak, nonatomic) IBOutlet UIImageView *fourthImage;

@property (weak, nonatomic) IBOutlet UIImageView *fifthImage;
@property (strong,nonatomic) NSString *dataPasser;


@end

