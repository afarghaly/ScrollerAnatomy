//
//  DataUtils
//  ScrollerAnatomy
//
//  Created by Ahmed Farghaly on 12/18/13.
//  Copyright (c) 2013 Ahmed Farghaly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataUtils : NSObject

+ (DataUtils *)sharedDataManager;


// environment access
- (NSDictionary *)getRandomEnvironmentData;
- (NSDictionary *)getEnvironmentDataForKey:(NSString *)key;
- (NSDictionary *)getEnvironmentDataForIndex:(int)index_;
- (NSDictionary *)getBackupEnvironmentData;

// test vehicle access
- (NSDictionary *)getRandomTestVehicleData;
- (NSDictionary *)getTestVehicleForKey:(NSString *)vehicleKey_;


@end
