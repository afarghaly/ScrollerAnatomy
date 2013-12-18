//
//  ScrollingLayer.m
//  ScrollerAnatomy
//
//  Created by Ahmed Farghaly on 12/17/13.
//  Copyright (c) 2013 Ahmed Farghaly. All rights reserved.
//

#import "ScrollingLayer.h"


#define DEFAULT_BLOCK_COUNT 2


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


@interface ScrollingLayer()
{
    CGRect visibleBounds;
}

- (BOOL)isDisplayingBlockForIndex:(int)index_;
- (SKNode *)dequeueRecycledBlock;

@end


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


@implementation ScrollingLayer


#pragma mark -
#pragma mark init


- (id)init
{
    self = [super init];
    
    if(self)
    {
        BLOCK_WIDTH = DeviceIsiPhone() ? (DeviceIs4Inch() ? 568.0f : 480.0f) : 1024.0f;
        additionalBlocksToRender = 0;
        
        visibleBlocks = [NSMutableSet setWithCapacity:DEFAULT_BLOCK_COUNT + additionalBlocksToRender];
        recycledBlocks = [NSMutableSet setWithCapacity:DEFAULT_BLOCK_COUNT + additionalBlocksToRender];
        
        return self;
    }
    
    return nil;
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


#pragma mark -
#pragma mark Scrolling logic

- (void)scroll:(CGPoint)scrollPosition_
{
    visibleBounds = CGRectMake(-scrollPosition_.x, 0, BLOCK_WIDTH, 1);
    
//    NSLog(@"visibleBounds: %@", NSStringFromCGRect(visibleBounds));
    
    int firstNeededBlockIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    int lastNeededBlockIndex = floorf(CGRectGetMaxX(visibleBounds) / CGRectGetWidth(visibleBounds));
    
//    NSLog(@"%d - %d", firstNeededBlockIndex, lastNeededBlockIndex);
    
    // remove offscreen blocks
    NSMutableSet *blocksToRemove = [NSMutableSet set];
    for(SKNode *block in visibleBlocks)
    {
        int blockIndex = [block.name intValue];
        if(blockIndex < (firstNeededBlockIndex - additionalBlocksToRender) || blockIndex > (lastNeededBlockIndex + additionalBlocksToRender))
        {
            [blocksToRemove addObject:block];
            block.name = nil;
            [block removeFromParent];
        }
    }
    
    for(SKNode *blockToRemove in blocksToRemove)
    {
        [visibleBlocks removeObject:blockToRemove];
        [recycledBlocks addObject:blockToRemove];
    }
    
    [blocksToRemove removeAllObjects];
//    blocksToRemove = nil;
    
    // add missing blocks
    for(int index = (firstNeededBlockIndex - additionalBlocksToRender) ; index <= (lastNeededBlockIndex + additionalBlocksToRender) ; index++)
    {
        if(![self isDisplayingBlockForIndex:index])
        {
            SKNode *block = (SKNode *)[self dequeueRecycledBlock];
            
            if(block == nil)
            {
                block = [self newBlock];
            }
            
            CGPoint blockPosition = block.position;
            blockPosition.x = BLOCK_WIDTH * index;
            block.position = blockPosition;
            
            [self configureBlock:block forIndex:index];
            
            [self addChild:block];
            [visibleBlocks addObject:block];
        }
    }
}


- (BOOL)isDisplayingBlockForIndex:(int)index_
{
    BOOL isDisplaying = NO;
    
    for(SKNode *block in visibleBlocks)
    {
        if([block.name intValue] == index_)
        {
            isDisplaying = YES;
            break;
        }
    }
    
    return isDisplaying;
}

- (SKNode *)dequeueRecycledBlock
{
    SKNode *block = (SKNode *)[recycledBlocks anyObject];
    
    if(block)
    {
        [recycledBlocks removeObject:block];
    }
    
    return block;
}



// public methods  - - - - - - - - - - - - - - - - - - - - - - - - -



#pragma mark -
#pragma mark block creation / modification

- (SKNode *)newBlock
{
    SKNode *block = [SKNode node];
//    block.anchorPoint = CGPointMake(0.5f, 0.0f);
    
    SKLabelNode *blockID = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Bold"];
    blockID.fontColor = [SKColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.2f];
    blockID.fontSize = 100;
    blockID.position = CGPointMake(0, 70);
    blockID.name = @"blockID";
    blockID.text = @"0";
    [block addChild:blockID];
    
    return block;
}

- (void)configureBlock:(SKNode *)block_ forIndex:(int)index_
{
    block_.name = [NSString stringWithFormat:@"%d", index_];
    
    SKLabelNode *blockID = (SKLabelNode *)[block_ childNodeWithName:@"blockID"];
    blockID.text = [NSString stringWithFormat:@"%d", index_];
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


#pragma mark -
#pragma mark release layer

- (void)destroyLayer
{
    [recycledBlocks removeAllObjects];
    recycledBlocks = nil;
    
    [visibleBlocks removeAllObjects];
    visibleBlocks = nil;
    
    [self removeAllChildren];
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



@end




