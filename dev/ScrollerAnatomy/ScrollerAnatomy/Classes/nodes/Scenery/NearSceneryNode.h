//
//  NearSceneryNode.h
//  TouchBots
//
//  Created by Ahmed Farghaly on 12/4/13.
//  Copyright (c) 2013 Ahmed Farghaly. All rights reserved.
//

#import "ScrollingLayer.h"


typedef enum
{
    NearSceneryTypeImage,
    NearSceneryTypeHills,
    NearSceneryTypeMountains,
    NearSceneryTypeNone
}NearSceneryType;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



@interface NearSceneryNode : ScrollingLayer

- (id)initWithNearSceneryType:(NearSceneryType)sceneryType_
                   sceneColor:(SKColor *)nearSceneryColor_
                  sceneryAlpha:(float)sceneryAlpha_
            sceneryStrokeColor:(SKColor *)nearSceneryStrokeColor_
            sceneryStrokeAlpha:(float)nearSceneryStrokeAlpha_
               showsBlockIndex:(BOOL)showsIndex_;

- (id)initWithSceneryImage:(NSString *)sceneryImageName_ showsBlockIndex:(BOOL)showsIndex_;

@end
