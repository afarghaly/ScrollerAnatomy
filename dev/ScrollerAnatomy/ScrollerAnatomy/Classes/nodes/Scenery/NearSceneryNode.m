//
//  NearSceneryNode.m
//  TouchBots
//
//  Created by Ahmed Farghaly on 12/4/13.
//  Copyright (c) 2013 Ahmed Farghaly. All rights reserved.
//

#import "NearSceneryNode.h"
#import "ColorUtils.h"
#import "DeviceUtils.h"


@interface NearSceneryNode()
{
    NSMutableDictionary *nearSceneryBlocksData;
    SKColor *nearSceneryColor;
    float sceneryBaselineY;
}

- (NSArray *)newOvalTreesData;
- (void)renderOvalTrees:(NSArray *)sceneryBlockData inBlock:(SKNode *)block_;

@end

// -

@implementation NearSceneryNode


- (id)initWithNearSceneryColor:(SKColor *)nearSceneryColor_
{
    self = [super init];
    
    if(self)
    {
//        BLOCK_WIDTH *= 1.5f;
        nearSceneryColor = nearSceneryColor_;
        nearSceneryBlocksData = [NSMutableDictionary dictionaryWithCapacity:100];
        sceneryBaselineY = DeviceIsiPhone() ? 100 : 280;
        
        return self;
    }
    
    return nil;
}


- (SKNode *)newBlock
{
    SKNode *block = [super newBlock];
    
//    SKSpriteNode *spriteBlock = (SKSpriteNode *)block;
//    spriteBlock.size = CGSizeMake(BLOCK_WIDTH - 20, self.scene.frame.size.height - (DeviceIsiPhone() ? 160 : 320));
    
    SKLabelNode *blockID = (SKLabelNode *)[block childNodeWithName:@"blockID"];
    blockID.fontColor = [SKColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.3f];
    blockID.fontSize = DeviceIsiPhone() ? 30 : 60;
    blockID.position = CGPointMake(0, DeviceIsiPhone() ? 180 : 400);
    
    SKShapeNode *nearSceneryLayer = [[SKShapeNode alloc] init];
    nearSceneryLayer.fillColor = nearSceneryColor;
    nearSceneryLayer.strokeColor = [SKColor colorWithWhite:1.0f alpha:0.2f];
    nearSceneryLayer.name = @"nearSceneryLayer";
    [block addChild:nearSceneryLayer];
    nearSceneryLayer.position = CGPointMake(-(BLOCK_WIDTH / 2), 0);
    
    return block;
}


- (void)configureBlock:(SKNode *)block_ forIndex:(int)index_
{
    [super configureBlock:(SKNode *)block_ forIndex:(int)index_];
    
    SKLabelNode *blockID = (SKLabelNode *)[block_ childNodeWithName:@"blockID"];
    blockID.text = [NSString stringWithFormat:@"Near Scenery %d", index_];
    
    SKShapeNode *nearSceneryLayer = (SKShapeNode *)[block_ childNodeWithName:@"nearSceneryLayer"];
    nearSceneryLayer.path = nil;
    
    NSArray *blockData = [nearSceneryBlocksData objectForKey:[NSNumber numberWithInt:index_]];
    if(blockData)
    {
        [self renderOvalTrees:blockData inBlock:block_];
    }
    else
    {
//        NSLog(@"new near scenery block, render (%d)", [[nearSceneryBlocksData allKeys] count]);
        blockData = [self newOvalTreesData];
        [nearSceneryBlocksData setObject:blockData forKey:[NSNumber numberWithInt:index_]];
        [self renderOvalTrees:blockData inBlock:block_];
    }
}



#pragma mark -
#pragma mark Near Scenery data points generation

- (NSArray *)newOvalTreesData
{
    NSMutableArray *pointsArray = [NSMutableArray arrayWithCapacity:10];
    
    uint treeCount = 5 + (arc4random() % 3);
    float treeWidth = BLOCK_WIDTH / treeCount;
    //    float curentBlockWidth = 0;
    
    for(int i = 0 ; i < treeCount ; i++)
    {
        CGPoint treeStartingPoint = CGPointMake(i * treeWidth, sceneryBaselineY + arc4random() % (DeviceIsiPhone() ? 20 : 40));
        CGPoint treeEndingPoint = CGPointMake((i + 1) * treeWidth, sceneryBaselineY);// + arc4random() % 20);
        int controlPointXDeviation = (arc4random() % (DeviceIsiPhone() ? 40 : 80)) - (DeviceIsiPhone() ? 20 : 40);
        //        NSLog(@"controlPointXDeviation: %d", controlPointXDeviation);
        CGPoint controlPoint = CGPointMake(treeStartingPoint.x +
                                           ((treeEndingPoint.x - treeStartingPoint.x) / 2) +
                                           controlPointXDeviation,
                                           sceneryBaselineY + (DeviceIsiPhone() ? 50 : 100) + (arc4random() % (DeviceIsiPhone() ? 50 : 100)));
        
        NSValue *treeStartingPointValue = [NSValue valueWithCGPoint:treeStartingPoint];
        NSValue *treeEndingPointValue = [NSValue valueWithCGPoint:treeEndingPoint];
        NSValue *controlPointValue = [NSValue valueWithCGPoint:controlPoint];
        
        NSDictionary *ovalTreeData = [NSDictionary dictionaryWithObjectsAndKeys:
                                      treeStartingPointValue, @"startingPoint",
                                      treeEndingPointValue, @"endingPoint",
                                      controlPointValue, @"controlPoint",
                                      nil];
        
        //        CGPoint randomPoint = CGPointMake(i * treeWidth, 0);
        //        NSValue *pointValue = [NSValue valueWithCGPoint:randomPoint];
        [pointsArray addObject:ovalTreeData];
    }
    return pointsArray;
}

// ------------------------------------------------------------------------

#pragma mark -
#pragma mark Near Scenery rendering

- (void)renderOvalTrees:(NSArray *)sceneryBlockData inBlock:(SKNode *)block_
{
    //    NSLog(@"render oval trees: %@", sceneryBlockData);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0.0f, 0.0f);
    CGPathAddLineToPoint(path, NULL, 0.0f, sceneryBaselineY);
    
    for(NSDictionary *ovalTreeData in sceneryBlockData)
    {
        NSValue *endingValue = [ovalTreeData objectForKey:@"endingPoint"];
        CGPoint endingPoint = [endingValue CGPointValue];
        
        NSValue *controlPointValue = [ovalTreeData objectForKey:@"controlPoint"];
        CGPoint controlPoint = [controlPointValue CGPointValue];
        
        CGPathAddQuadCurveToPoint(path, NULL, controlPoint.x, controlPoint.y, endingPoint.x, endingPoint.y);
    }
    
    CGPathAddLineToPoint(path, NULL, BLOCK_WIDTH, 0);
    CGPathAddLineToPoint(path, NULL, 0.0f, 0.0f);
    
    SKShapeNode *sceneryShapeNode = (SKShapeNode *)[block_ childNodeWithName:@"nearSceneryLayer"];
    sceneryShapeNode.path = path;
    CGPathRelease(path);
    path = nil;
}

// ------------------------------------------------------------------------

#pragma mark -
#pragma mark Near Scenery cleanup

- (void)destroyLayer
{
    for(SKNode *block in visibleBlocks)
    {
        SKShapeNode *nearSceneryLayer = (SKShapeNode *)[block childNodeWithName:@"nearSceneryLayer"];
        nearSceneryLayer.path = nil;
        [nearSceneryLayer removeFromParent];
        nearSceneryLayer = nil;
    }
    
    for(SKNode *block in recycledBlocks)
    {
        SKShapeNode *nearSceneryLayer = (SKShapeNode *)[block childNodeWithName:@"nearSceneryLayer"];
        nearSceneryLayer.path = nil;
        [nearSceneryLayer removeFromParent];
        nearSceneryLayer = nil;
    }
    
    [super destroyLayer];
    
    [nearSceneryBlocksData removeAllObjects];
    nearSceneryBlocksData = nil;
}

@end
