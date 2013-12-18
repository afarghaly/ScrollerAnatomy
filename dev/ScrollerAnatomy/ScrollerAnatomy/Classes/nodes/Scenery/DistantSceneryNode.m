//
//  DistantSceneryNode.m
//  TouchBots
//
//  Created by Ahmed Farghaly on 12/3/13.
//  Copyright (c) 2013 Ahmed Farghaly. All rights reserved.
//

#import "DistantSceneryNode.h"
#import "DeviceUtils.h"
#import "ColorUtils.h"


@interface DistantSceneryNode()
{
    NSMutableDictionary *distantSceneryBlocksData;
    float sceneryBaselineY;
    SKColor *distantSceneryColor;
}

- (NSArray *)newConcavePeaksData;
- (void)renderConcavePeaks:(NSArray *)sceneryBlockData inBlock:(SKNode *)block_ forIndex:(int)index_;

@end


@implementation DistantSceneryNode


- (id)initWithSceneryColor:(SKColor *)distantSceneryColor_
{
    self = [super init];
    
    if(self)
    {
        distantSceneryColor = distantSceneryColor_;
        distantSceneryBlocksData = [NSMutableDictionary dictionaryWithCapacity:100];
        sceneryBaselineY = DeviceIsiPhone() ? 240 : 600;
        
        return self;
    }
    
    return nil;
}


- (SKNode *)newBlock
{
    SKNode *block = [super newBlock];
    
//    SKSpriteNode *spriteBlock = (SKSpriteNode *)block;
//    spriteBlock.size = CGSizeMake(BLOCK_WIDTH - 20, self.scene.frame.size.height - (DeviceIsiPhone() ? 80 : 160));
    
    SKLabelNode *blockID = (SKLabelNode *)[block childNodeWithName:@"blockID"];
    blockID.fontColor = [SKColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.2f];
    blockID.fontSize = DeviceIsiPhone() ? 20 : 45;
    blockID.position = CGPointMake(0, DeviceIsiPhone() ? 270 : 650);
    
    SKShapeNode *distantSceneryLayer = [[SKShapeNode alloc] init];
    distantSceneryLayer.fillColor = distantSceneryColor;
    distantSceneryLayer.strokeColor = [SKColor colorWithWhite:1.0f alpha:0.2f];
    distantSceneryLayer.lineWidth = 1.0f;
    distantSceneryLayer.name = @"distantSceneryLayer";
    [block addChild:distantSceneryLayer];
    distantSceneryLayer.position = CGPointMake(-(BLOCK_WIDTH / 2), 0);
    
    return block;
}


- (void)configureBlock:(SKNode *)block_ forIndex:(int)index_
{
    [super configureBlock:(SKNode *)block_ forIndex:(int)index_];
    
    SKLabelNode *blockID = (SKLabelNode *)[block_ childNodeWithName:@"blockID"];
    blockID.text = [NSString stringWithFormat:@"Distant Scenery %d", index_];
    
    SKShapeNode *distantSceneryLayer = (SKShapeNode *)[block_ childNodeWithName:@"distantSceneryLayer"];
    distantSceneryLayer.path = nil;
    
    NSArray *blockData = [distantSceneryBlocksData objectForKey:[NSNumber numberWithInt:index_]];
    if(blockData)
    {
//        NSLog(@"This block rendered before, use saved data");
        [self renderConcavePeaks:blockData inBlock:block_ forIndex:index_];
    }
    else
    {
//        NSLog(@"new distant scenery block, render (%d)", [[distantSceneryBlocksData allKeys] count]);
        blockData = [self newConcavePeaksData];
        [distantSceneryBlocksData setObject:blockData forKey:[NSNumber numberWithInt:index_]];
        [self renderConcavePeaks:blockData inBlock:block_ forIndex:index_];
    }
}



#pragma mark -
#pragma mark Scenery data points generation method

- (NSArray *)newConcavePeaksData//ForIndex:(NSNumber *)index_
{
    NSMutableArray *pointsArray = [NSMutableArray arrayWithCapacity:5];
    
    uint concavePeakCount = 3 + (arc4random() % 2);
    float concavePeakWidth = BLOCK_WIDTH / concavePeakCount;
    
    for(int i = 0 ; i < concavePeakCount ; i++)
    {
        CGPoint concavePeakStartingPoint = CGPointMake(i * concavePeakWidth, sceneryBaselineY + (i == 0 ? 0 : (arc4random() % (DeviceIsiPhone() ? 20 : 40))));
        CGPoint concavePeakEndingPoint = CGPointMake((i + 1) * concavePeakWidth, sceneryBaselineY + (i == (concavePeakCount - 1) ? 0 : arc4random() % (DeviceIsiPhone() ? 20 : 40)));
        int controlPointXDeviation = (arc4random() % (DeviceIsiPhone() ? 20 : 40)) - (DeviceIsiPhone() ? 10 : 20);
        
        CGPoint controlPoint = CGPointMake(concavePeakStartingPoint.x +
                                           ((concavePeakEndingPoint.x - concavePeakStartingPoint.x) / 2) +
                                           controlPointXDeviation,
                                           sceneryBaselineY - ((DeviceIsiPhone() ? 10 : 20) + (arc4random() % (DeviceIsiPhone() ? 60 : 120))));
        
        NSValue *peakStartPointValue = [NSValue valueWithCGPoint:concavePeakStartingPoint];
        NSValue *peakEndingPointValue = [NSValue valueWithCGPoint:concavePeakEndingPoint];
        NSValue *controlPointValue = [NSValue valueWithCGPoint:controlPoint];
        
        NSDictionary *peakData = [NSDictionary dictionaryWithObjectsAndKeys:
                                  peakStartPointValue, @"startingPoint",
                                  peakEndingPointValue, @"endingPoint",
                                  controlPointValue, @"controlPoint",
                                  nil];
        
        [pointsArray addObject:peakData];
    }
    
    return pointsArray;
}

// ------------------------------------------------------------------------

#pragma mark -
#pragma mark Distant Scenery rendering

- (void)renderConcavePeaks:(NSArray *)sceneryBlockData inBlock:(SKNode *)block_ forIndex:(int)index_
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0.0f, 0.0f);
    
    NSDictionary *firstPointData = [sceneryBlockData objectAtIndex:0];
    NSValue *firstPointValue = [firstPointData objectForKey:@"startingPoint"];
    CGPoint firstPoint = [firstPointValue CGPointValue];
    CGPathAddLineToPoint(path, NULL, 0, firstPoint.y);
    
    for(NSDictionary *peakData in sceneryBlockData)
    {
        NSValue *endingPointValue = [peakData objectForKey:@"endingPoint"];
        CGPoint endingPoint = [endingPointValue CGPointValue];
        
        NSValue *controlPointValue = [peakData objectForKey:@"controlPoint"];
        CGPoint controlPoint = [controlPointValue CGPointValue];
        
        CGPathAddQuadCurveToPoint(path, NULL, controlPoint.x, controlPoint.y, endingPoint.x, endingPoint.y);
    }
    
    CGPathAddLineToPoint(path, NULL, BLOCK_WIDTH, 0);
    CGPathAddLineToPoint(path, NULL, 0.0f, 0.0f);
    
    SKShapeNode *sceneryShapeNode = (SKShapeNode *)[block_ childNodeWithName:@"distantSceneryLayer"];
    sceneryShapeNode.path = path;
    CGPathRelease(path);
    path = nil;
}

// ------------------------------------------------------------------------

#pragma mark -
#pragma mark Distant Scenery cleanup

- (void)destroyLayer
{
    for(SKNode *block in visibleBlocks)
    {
        SKShapeNode *distantSceneryLayer = (SKShapeNode *)[block childNodeWithName:@"distantSceneryLayer"];
        distantSceneryLayer.path = nil;
        [distantSceneryLayer removeFromParent];
        distantSceneryLayer = nil;
    }
    
    for(SKNode *block in recycledBlocks)
    {
        SKShapeNode *distantSceneryLayer = (SKShapeNode *)[block childNodeWithName:@"distantSceneryLayer"];
        distantSceneryLayer.path = nil;
        [distantSceneryLayer removeFromParent];
        distantSceneryLayer = nil;
    }
    
    [super destroyLayer];
    
    [distantSceneryBlocksData removeAllObjects];
    distantSceneryBlocksData = nil;
}


@end


