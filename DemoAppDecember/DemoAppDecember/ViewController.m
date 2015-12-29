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
#import "MBProgressHUD.h"
#import "AddCityControllerViewController.h"

@interface ViewController ()<UITextFieldDelegate,AddCityProtocol>{
    UITextField *searchTextField;
    NSArray *cityArray;
    
    BOOL flag;
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
    flag = YES;
    
//    NSString*path =[[NSBundle mainBundle] pathForResource:@"cloud-moon" ofType:@"svg"];
//    NSURL *fileURL =[[NSURL alloc] initFileURLWithPath:path];
//    NSURLRequest*req =[NSURLRequest requestWithURL:fileURL];
//    [self.imageWebView setScalesPageToFit:YES];
//    [self.imageWebView loadRequest:req];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self initialRequest];
    self.dataPasser = [[NSString alloc]init];
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
        
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
    if(!flag){
        NSLog(@"City ---> %@",self.dataPasser);
        flag = YES;
    }
    
}
-(void)initialRequest{
    self.navigationItem.title = @"Hyderabad";
    Connection *weatherFetcher = [[Connection
                                   alloc] init];
    weatherFetcher.delegate = self;
    [weatherFetcher fetchWeatherFroCity:@"Hyderabad" withServiceType:2];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    [textField resignFirstResponder];
    return YES;
}

-(void)uiSetUp{
    searchTextField  = [[UITextField alloc]initWithFrame:CGRectMake(50, 0, self.navigationController.navigationBar.frame.size.width, 21.0)];
    searchTextField.textAlignment = NSTextAlignmentCenter;
    searchTextField.textColor = [UIColor whiteColor];
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
    flag = NO;
    ViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"storyBoardIdentifier"];
    AddCityControllerViewController *addcity = [[AddCityControllerViewController alloc]init];
    addcity.delegate = self;
    [self.navigationController pushViewController:newView animated:YES];

//    [self uiSetUp];
//    searchTextField.hidden = NO;
    
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location >= 3) {
        Connection *placeFetchBoy = [[Connection
                                      alloc] init];
        placeFetchBoy.delegate = self;
        [placeFetchBoy fetchPlaceStartingWith:searchTextField.text WithServiceType:1];
//        [placeFetchBoy fetchPlaceStartingWith:@"samb"];
    }
    [self.cityTable reloadData];

    return YES;
}


-(void)weatherData:(id)jsonData{
    self.responseData  = jsonData;
    [self dataPasser];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
      NSLog(@" JSON data ----> %@ ",jsonData);
}

-(void)dataPasser{
    
    NSString *imageString = [[[self.responseData objectForKey:@"weather"]objectAtIndex:0]objectForKey:@"icon"];
//    NSString *ImageURL =  [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",imageString];  //@"YourURLHere";
//    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
//    self.tempratureImageView.image = [UIImage imageWithData:imageData];
    
    if([imageString isEqualToString:@"01d"]){
        self.tempratureImageView.image = [UIImage imageNamed:@"Sunny-128.png"];
    }else if([imageString isEqualToString:@"02d"]){
        self.tempratureImageView.image = [UIImage imageNamed:@"Sunny-Period.png"];

    }else if([imageString isEqualToString:@"03d"]){
        self.tempratureImageView.image = [UIImage imageNamed:@"Overcast-128.png"];

    }else if([imageString isEqualToString:@"04d"]){
        self.tempratureImageView.image = [UIImage imageNamed:@"hail.png"];

    }else if([imageString isEqualToString:@"09d"]){
        self.tempratureImageView.image = [UIImage imageNamed:@"Showers.png"];

    }else if([imageString isEqualToString:@"10d"]){
        self.tempratureImageView.image = [UIImage imageNamed:@"rain.png"];

    }else if([imageString isEqualToString:@"11d"]){
        self.tempratureImageView.image = [UIImage imageNamed:@"Thunderstorms.png"];
    }else if([imageString isEqualToString:@"13d"]){
        self.tempratureImageView.image = [UIImage imageNamed:@"snow.png"];
    }else{
        self.tempratureImageView.image = [UIImage imageNamed:@"fog-128.png"];
    }
    
    
    
    NSString *initialTemprature = [[self.responseData objectForKey:@"main"]objectForKey:@"temp"];
//    NSString *finalTemp = [[initialTemprature componentsSeparatedByString:@"."] firstObject];
    self.tempratureLabel.text = [NSString stringWithFormat:@"%d°",(int)ceil([initialTemprature intValue])];
    
    NSString *weatherCondition = [[[self.responseData objectForKey:@"weather"]objectAtIndex:0]objectForKey:@"description"];
    self.weatherConditionLabel.text = weatherCondition;
    
    NSString *locationName = [NSString stringWithFormat:@"%@,%@",[self.responseData objectForKey:@"name"],[[self.responseData objectForKey:@"sys"]objectForKey:@"country"]];
    self.locationLabel.text = locationName;
    
    NSString *humidity = [NSString stringWithFormat:@"%@H",[[self.responseData objectForKey:@"main"]objectForKey:@"humidity"]];
    
    self.humidityTopLabel.text = humidity;
    self.highLabel.text = humidity;
    [self weekdaysWeatherForcast];
    [self topBarDataForcast];
}

-(void)topBarDataForcast{
//    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[self.responseData objectForKey:@"dt"]];
    NSTimeInterval seconds = [[self.responseData objectForKey:@"dt"] doubleValue];
    NSDate *epochNSDate = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    
    [dateFormatter setDateFormat:@"MMMM dd"];
    
    self.todaysDate.text = [dateFormatter stringFromDate:epochNSDate];
    
    NSTimeInterval risetime = [[[self.responseData objectForKey:@"sys"]objectForKey:@"sunrise" ] doubleValue];
    NSDate *sunrise = [[NSDate alloc] initWithTimeIntervalSince1970:risetime];
    
    NSTimeInterval settime = [[[self.responseData objectForKey:@"sys"]objectForKey:@"sunset" ] doubleValue];
    NSDate *sunset = [[NSDate alloc] initWithTimeIntervalSince1970:settime];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"hh:mm a"];
    self.rise.text = [dateFormatter stringFromDate:sunrise];
    
    self.set.text = [dateFormatter stringFromDate:sunset];
    
    
    NSLog(@"Test %@",[dateFormatter stringFromDate:epochNSDate]);

}

-(void)weekdaysWeatherForcast{
    
    NSString *ImageURL;
    NSData *imageData;
     ImageURL =  [NSString stringWithFormat:@"http://openweathermap.org/img/w/09d.png"];  //@"YourURLHere";
     imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
    self.firstImage.image = [UIImage imageWithData:imageData];
    
    ImageURL =  [NSString stringWithFormat:@"http://openweathermap.org/img/w/13d.png"];  //@"YourURLHere";
    imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
    self.secondImage.image = [UIImage imageWithData:imageData];
    
    ImageURL =  [NSString stringWithFormat:@"http://openweathermap.org/img/w/03d.png"];  //@"YourURLHere";
    imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
    self.thirdImage.image = [UIImage imageWithData:imageData];
    
    ImageURL =  [NSString stringWithFormat:@"http://openweathermap.org/img/w/02n.png"];  //@"YourURLHere";
    imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
    self.fourthImage.image = [UIImage imageWithData:imageData];
    
    ImageURL =  [NSString stringWithFormat:@"http://openweathermap.org/img/w/10d.png"];  //@"YourURLHere";
    imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
    self.fifthImage.image = [UIImage imageWithData:imageData];
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
//    searchTextField.text = cityfirst;
    searchTextField.hidden = YES;
    searchTextField = nil;
    Connection *weatherFetcher = [[Connection
                                  alloc] init];
    weatherFetcher.delegate = self;
    [self.navigationItem setTitle:cityfirst];
    flag = NO;
    [weatherFetcher fetchWeatherFroCity:cityfirst withServiceType:2];
    [self.cityTable setAlpha:0.0];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

-(void)AddCityDataPasser:(NSString *)cityName{
    self.dataPasser = cityName;
}

@end
