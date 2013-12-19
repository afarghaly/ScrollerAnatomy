//
//  DistantSceneryNode.h
//  TouchBots
//
//  Created by Ahmed Farghaly on 12/3/13.
//  Copyright (c) 2013 Ahmed Farghaly. All rights reserved.
//

#import "ScrollingLayer.h"


typedef enum
{
    DistantSceneryTypeImage,
    DistantSceneryTypeConcavePeaks,
    DistantSceneryTypeMountains,
    DistantSceneryTypeNone
}DistantSceneryType;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


@interface DistantSceneryNode : ScrollingLayer

- (id)initWithSceneryType:(DistantSceneryType)sceneryType_
               sceneColor:(SKColor *)distantSceneryColor_
              sceneryAlpha:(float)distantSceneryAlpha_
        sceneryStrokeColor:(SKColor *)distantSceneryStrokeColor_
        sceneryStrokeAlpha:(float)distantSceneryStrokeAlpha_
           showsBlockIndex:(BOOL)showsIndex_;

- (id)initWithSceneryImage:(NSString *)sceneryImageName_ showsBlockIndex:(BOOL)showsIndex_;

@end
