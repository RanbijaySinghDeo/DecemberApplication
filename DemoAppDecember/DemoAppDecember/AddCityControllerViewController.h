//
//  AddCityControllerViewController.h
//  DemoAppDecember
//
//  Created by RanbijaySinghDeo on 23/12/15.
//  Copyright © 2015 RanbijaySinghDeo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cityTableViewCell.h"
#import "Connection.h"
#import "ViewController.h"

@protocol AddCityProtocol <NSObject>

-(void)AddCityDataPasser :(NSString *) cityName;

@end

@interface AddCityControllerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ConnectionDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *cityTableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak,nonatomic)id <AddCityProtocol> delegate;

@end
