//
//  ScrollingLayer.h
//  ScrollerAnatomy
//
//  Created by Ahmed Farghaly on 12/17/13.
//  Copyright (c) 2013 Ahmed Farghaly. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "DeviceUtils.h"


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


@interface ScrollingLayer : SKNode
{
    // declared in .h so overriding subclasses have access
    float BLOCK_WIDTH;
    NSMutableSet *visibleBlocks;
    NSMutableSet *recycledBlocks;
    int additionalBlocksToRender;
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


// public method
- (void)scroll:(CGPoint)scrollPosition_;

// declared in .h so overriding subclasses have access
- (SKNode *)newBlock;
- (void)configureBlock:(SKNode *)block_ forIndex:(int)index_;
- (void)destroyLayer;
// -




@end
