//
//  Connection.m
//  DemoAppDecember
//
//  Created by RanbijaySinghDeo on 23/12/15.
//  Copyright © 2015 RanbijaySinghDeo. All rights reserved.
//

#import "Connection.h"

@implementation Connection{
    NSMutableArray *possibleCities;

}

-(void)fetchPlaceStartingWith:(NSString *) startingLetter WithServiceType:(int)serviceType{
    
    self.serviceType = serviceType;
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=(cities)&language=en&key=AIzaSyDrsMapnQzV2nHMRcqMx09AoylSrlORVjs",startingLetter];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)fetchWeatherFroCity:(NSString *)city withServiceType:(int)serviceType{
    self.serviceType = serviceType;
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@&units=metric&APPID=15b38c0a31ad6c7a7ba70254cba6928f",city] ;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
    
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    id json = [NSJSONSerialization JSONObjectWithData:_responseData options:0 error:nil];
    
    switch (self.serviceType) {
        case 1:
            possibleCities = [[NSMutableArray alloc] init];
            for (NSDictionary *cities in [json objectForKey:@"predictions"]) {
                [possibleCities addObject:[cities objectForKey:@"description"]];
            }
            [self.delegate cityData:possibleCities];
            break;
        case 2:
            if([self.delegate respondsToSelector:@selector(weatherData:)]){
                [self.delegate weatherData:json];
            }
            
            break;
            
        default:
            break;
    }
    
    
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"placeFound" object:self userInfo:@{@"placesArray":possibleCities}];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  
    NSLog(@"Connection Failed");
}

   


@end
