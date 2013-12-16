//
//  BaseScrollerScene.m
//  ScrollerAnatomy
//
//  Created by Ahmed Farghaly on 12/16/13.
//  Copyright (c) 2013 Ahmed Farghaly. All rights reserved.
//

#import "BaseScrollerScene.h"

@implementation BaseScrollerScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    
    if(self)
    {
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.0f];
        
        
        return self;
    }
    
    return nil;
}


@end
