//
//  DataUtils
//  ScrollerAnatomy
//
//  Created by Ahmed Farghaly on 12/18/13.
//  Copyright (c) 2013 Ahmed Farghaly. All rights reserved.
//

#import "DataUtils.h"


@interface DataUtils()
{
    NSBundle *appBundle;
    
    NSDictionary *environmentsData;
    NSDictionary *testVehiclesData;
}
@end


@implementation DataUtils

static DataUtils *_sharedDataManager = nil;

#pragma mark -
#pragma mark Singleton setup methods

+ (DataUtils *)sharedDataManager
{
    @synchronized([DataUtils class])
    {
        if(!_sharedDataManager)
        {
            _sharedDataManager = [[self alloc] init];
        }
        
        return _sharedDataManager;
    }
    
    return nil;
}

+ (id)alloc
{
    @synchronized([DataUtils class])
    {
        NSAssert(_sharedDataManager == nil, @"Attempted to allocate a second instance of TBDataManager singleton");
        
        _sharedDataManager = [super alloc];
        return _sharedDataManager;
    }
    
    return nil;
}

- (id)init
{
    self = [super init];
    
    if(self)
    {
        NSLog(@"[TBDataManager init]");
        
        appBundle = [NSBundle mainBundle];
        
        NSString *environmentsDataPath = [appBundle pathForResource:@"Environments" ofType:@"plist"];
        environmentsData = [NSDictionary dictionaryWithContentsOfFile:environmentsDataPath];
        
        NSString *testVehiclesDatapath = [appBundle pathForResource:@"TestVehicles" ofType:@"plist"];
        testVehiclesData = [[NSDictionary alloc] initWithContentsOfFile:testVehiclesDatapath];
        
        return self;
    }
    
    return nil;
}

// ---------------------------------------------------

#pragma mark -
#pragma mark Environment access methods

- (NSDictionary *)getRandomEnvironmentData
{
//    uint randomIndex = arc4random() % [[environmentsData allKeys] count];
//    NSString *randomKey = [[environmentsData allKeys] objectAtIndex:randomIndex];
    NSDictionary *randomEnvironmentData = [environmentsData objectForKey:@"greenMeadows"];
    return randomEnvironmentData;
}

- (NSDictionary *)getEnvironmentDataForKey:(NSString *)key
{
    NSDictionary *requestedEnvironmentData = [environmentsData objectForKey:key];
    return requestedEnvironmentData;
}

- (NSDictionary *)getEnvironmentDataForIndex:(int)index_
{
    NSString *indexedKey = [[environmentsData allKeys] objectAtIndex:(index_ % [environmentsData count])];
    NSDictionary *requestedEnvironmentData = [environmentsData objectForKey:indexedKey];
    return requestedEnvironmentData;
}

- (NSDictionary *)getBackupEnvironmentData
{
    NSDictionary *backupEnvironmentData = [NSDictionary dictionaryWithObjectsAndKeys:
                                           @"Backup Environment", @"environmentName",
                                           @"rocky", @"terrainType",
                                           @"0xFFFFFF", @"terrainColor",
                                           @"snowTerrainTexture", @"terrainTexture",
                                           [NSNumber numberWithInt:0], @"sceneryType",
                                           @"0x555555", @"sceneryColor",
                                           [NSNumber numberWithInt:0], @"distantSceneryType",
                                           @"0x333333", @"distnatSceneryColor",
                                           @"0x000000", @"skyColor1",
                                           @"0x111111", @"skyColor2",
                                           nil];
    return backupEnvironmentData;
}

// --------------------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Test Vehicle Access

- (NSDictionary *)getRandomTestVehicleData
{
//    uint randomIndex = arc4random() % [[testVehiclesData allKeys] count];
//    NSString *randomKey = [[testVehiclesData allKeys] objectAtIndex:randomIndex];
    NSDictionary *randomTestVehicleData = [testVehiclesData objectForKey:@"0"];
    
    return randomTestVehicleData;
}

- (NSDictionary *)getTestVehicleForKey:(NSString *)vehicleKey_
{
    NSDictionary *requestedTestVehicleData = [testVehiclesData objectForKey:vehicleKey_];
    return requestedTestVehicleData;
}



@end
