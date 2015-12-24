//
//  ViewController.m
//  DemoAppDecember
//
//  Created by RanbijaySinghDeo on 23/12/15.
//  Copyright © 2015 RanbijaySinghDeo. All rights reserved.
//

#import "ViewController.h"
#import "cityTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()<UITextFieldDelegate>{
    UITextField *searchTextField;
    NSArray *cityArray;
}



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cityTable.hidden = YES;
    self.cityTable.delegate = self;
    self.cityTable.dataSource = self;
    
    self.cityTable.layer.cornerRadius = 8.;
    self.cityTable.clipsToBounds = YES;
    
    // Do any additional setup after loading the view, typically from a nib.
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    [textField resignFirstResponder];
    return YES;
}

-(void)uiSetUp{
    searchTextField  = [[UITextField alloc]initWithFrame:CGRectMake(50, 0, self.navigationController.navigationBar.frame.size.width, 21.0)];
    self.navigationItem.titleView = searchTextField;
    searchTextField.delegate = self;

    [searchTextField becomeFirstResponder];
//    searchTextField.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)rightBarItemTapped:(UIBarButtonItem *)sender {
    [self uiSetUp];
    searchTextField.hidden = NO;

}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location >= 3) {
        Connection *placeFetchBoy = [[Connection
                                      alloc] init];
        placeFetchBoy.delegate = self;
        [placeFetchBoy fetchPlaceStartingWith:searchTextField.text WithServiceType:1];
//        [placeFetchBoy fetchPlaceStartingWith:@"samb"];
    }
    
    return YES;
}

-(void)cityData:(NSArray *)cityNamesArray{
    self.cityTable.hidden = NO;
    cityArray = nil;
    cityArray = cityNamesArray;
    [self.cityTable reloadData];
    
}

-(void)weatherData:(id)jsonData{
    self.responseData  = jsonData;
    [self dataPasser];
      NSLog(@" JSON data ----> %@ ",jsonData);
}

-(void)dataPasser{
    
    NSString *imageString = [[[self.responseData objectForKey:@"weather"]objectAtIndex:0]objectForKey:@"icon"];
    NSString *ImageURL =  [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",imageString];  //@"YourURLHere";
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
    self.tempratureImageView.image = [UIImage imageWithData:imageData];
    
    NSString *initialTemprature = [[self.responseData objectForKey:@"main"]objectForKey:@"temp"];
//    int finalTempratureInF = [initialTemprature intValue];
//    int finalTempratureInC = (finalTempratureInF - 32) *(5/9);
    
    self.tempratureLabel.text = [NSString stringWithFormat:@"%@°",initialTemprature];
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
    searchTextField.text = cityfirst;
    Connection *weatherFetcher = [[Connection
                                  alloc] init];
    weatherFetcher.delegate = self;
    [weatherFetcher fetchWeatherFroCity:cityfirst withServiceType:2];
    [self.cityTable setAlpha:0.0];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

@end
