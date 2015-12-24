//
//  Connection.h
//  DemoAppDecember
//
//  Created by RanbijaySinghDeo on 23/12/15.
//  Copyright © 2015 RanbijaySinghDeo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ConnectionDelegate <NSObject>
@optional
-(void)cityData:(NSArray *) cityNamesArray;
-(void)weatherData:(id) jsonData;

@end
@interface Connection : NSObject<NSURLConnectionDelegate>{
    NSMutableData *_responseData;
}
-(void)fetchPlaceStartingWith:(NSString *) startingLetter WithServiceType:(int)serviceType;
-(void)fetchWeatherFroCity:(NSString *) city withServiceType:(int)serviceType;
@property (weak,nonatomic)id <ConnectionDelegate> delegate;
@property (nonatomic,assign) int serviceType;

@end
