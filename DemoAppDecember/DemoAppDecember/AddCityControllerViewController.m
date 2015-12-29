//
//  AddCityControllerViewController.m
//  DemoAppDecember
//
//  Created by RanbijaySinghDeo on 23/12/15.
//  Copyright © 2015 RanbijaySinghDeo. All rights reserved.
//

#import "AddCityControllerViewController.h"
#import "Connection.h"

@interface AddCityControllerViewController ()<UITextFieldDelegate>{
    NSArray *cityArray;
    ViewController *viewController;

}

@end

@implementation AddCityControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cityTableView.delegate = self;
    self.cityTableView.dataSource = self;
    self.searchTextField.delegate = self;
    self.cityTableView.hidden = YES;
    self.cityTableView.layer.cornerRadius = 8.;
    self.cityTableView.clipsToBounds = YES;
    self.navigationItem.title = @"";
    
    
    NSArray *viewControllerArr = [self.navigationController viewControllers];
    // get index of the previous ViewContoller
    long previousViewControllerIndex = [viewControllerArr indexOfObject:self] - 1;
    UIViewController *previous;
    if (previousViewControllerIndex >= 0) {
        previous = [viewControllerArr objectAtIndex:previousViewControllerIndex];
        previous.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                     initWithTitle:@""
                                                     style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:nil];
    }
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location >= 3) {
        Connection *placeFetchBoy = [[Connection
                                      alloc] init];
        placeFetchBoy.delegate = self;
        [placeFetchBoy fetchPlaceStartingWith:self.searchTextField.text WithServiceType:1];
        //        [placeFetchBoy fetchPlaceStartingWith:@"samb"];
    }
    [self.cityTableView reloadData];
    
    return YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return cityArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cityTableViewCell";
    
    cityTableViewCell *cell = (cityTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"cityTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    NSString *cityName=[cityArray objectAtIndex:indexPath.row];
    NSString *cityfirst=[[cityName componentsSeparatedByString:@","] firstObject];
    NSString *countryName=[[cityName componentsSeparatedByString:@","] lastObject];
    
    cell.CityNameLabel.text = cityfirst;
    cell.CountryNameLabel.text = countryName;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cityName=[cityArray objectAtIndex:indexPath.row];
    NSString *cityfirst=[[cityName componentsSeparatedByString:@","] firstObject];
    [self.delegate AddCityDataPasser:cityfirst];
    self.searchTextField.hidden = YES;
    self.searchTextField = nil;
    Connection *weatherFetcher = [[Connection
                                   alloc] init];
    weatherFetcher.delegate = self;
    [self.navigationItem setTitle:cityfirst];
    
    [weatherFetcher fetchWeatherFroCity:cityfirst withServiceType:2];
    [self.cityTableView setAlpha:0.0];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

-(void)cityData:(NSArray *)cityNamesArray{
    self.cityTableView.hidden = NO;
    cityArray = nil;
    cityArray = cityNamesArray;
    [self.cityTableView reloadData];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
