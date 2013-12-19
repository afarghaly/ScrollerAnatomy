//
//  DesertScene.m
//  ScrollerAnatomy
//
//  Created by Ahmed Farghaly on 12/18/13.
//  Copyright (c) 2013 Ahmed Farghaly. All rights reserved.
//

#import "DesertScene.h"

@implementation DesertScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    
    if(self)
    {
        environmentData = [[DataUtils sharedDataManager] getEnvironmentDataForKey:@"arizonaDesert"];
        
        return self;
    }
    
    return nil;
}

@end
