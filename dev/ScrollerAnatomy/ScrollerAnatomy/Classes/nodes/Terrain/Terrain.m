//
//  Terrain.m
//  TouchBots
//
//  Created by Ahmed Farghaly on 12/8/13.
//  Copyright (c) 2013 Ahmed Farghaly. All rights reserved.
//

#import "Terrain.h"

@interface Terrain()
{
    NSMutableDictionary *terrainBlocksData;
    SKColor *terrainColor;
}

- (NSArray *)newTerrainData;
- (void)renderTerrain:(NSArray *)terrainBlockData inBlock:(SKNode *)block_ forIndex:(int)index_;

@end

// -

@implementation Terrain

- (id)initWithTerrainColor:(SKColor *)terrainColor_ showsBlockIndex:(BOOL)showsIndex_
{
    self = [super initShowingBlockIndex:showsIndex_];
    
    if(self)
    {
        terrainColor = terrainColor_;
        terrainBlocksData = [NSMutableDictionary dictionaryWithCapacity:100];
        
        return self;
    }
    
    return nil;
}


- (SKNode *)newBlock
{
    SKNode *block = [super newBlock];
    
    SKLabelNode *blockID = (SKLabelNode *)[block childNodeWithName:@"blockID"];
    blockID.fontColor = [SKColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.75f];
    blockID.fontSize = DeviceIsiPhone() ? 40 : 76;
    blockID.position = CGPointMake(0, DeviceIsiPhone() ? 10 : 30);
    
    SKShapeNode *terrainLayer = [[SKShapeNode alloc] init];
    terrainLayer.fillColor = terrainColor;
    terrainLayer.strokeColor = nil;
    terrainLayer.name = @"terrainLayer";
    [block addChild:terrainLayer];
    terrainLayer.position = CGPointMake(-(BLOCK_WIDTH / 2), 0);
    
    return block;
}

- (void)configureBlock:(SKNode *)block_ forIndex:(int)index_
{
    [super configureBlock:(SKNode *)block_ forIndex:(int)index_];
    
    SKLabelNode *blockID = (SKLabelNode *)[block_ childNodeWithName:@"blockID"];
    blockID.text = [NSString stringWithFormat:@"Terrain %d", index_];
    
    SKShapeNode *terrainLayer = (SKShapeNode *)[block_ childNodeWithName:@"terrainLayer"];
    terrainLayer.path = nil;
    
    NSArray *blockData = [terrainBlocksData objectForKey:[NSNumber numberWithInt:index_]];
    if(blockData)
    {
        //        NSLog(@"This block rendered before, use saved data");
        [self renderTerrain:blockData inBlock:block_ forIndex:index_];
    }
    else
    {
//        NSLog(@"new terrain block, render (%d)", [[terrainBlocksData allKeys] count]);
        blockData = [self newTerrainData];
        [terrainBlocksData setObject:blockData forKey:[NSNumber numberWithInt:index_]];
        [self renderTerrain:blockData inBlock:block_ forIndex:index_];
    }
}


#pragma mark -
#pragma mark Terrain data points generation method

- (NSArray *)newTerrainData
{
    return [NSArray array];
}

// ---------------------------------------


#pragma mark -
#pragma mark Terrain scenery rendering

- (void)renderTerrain:(NSArray *)terrainBlockData inBlock:(SKNode *)block_ forIndex:(int)index_
{
    CGPoint firstPoint = CGPointMake(15, 10);
    CGPoint lastPoint = CGPointMake(BLOCK_WIDTH - 15, 10);
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, firstPoint.x, firstPoint.y);
    CGPathAddLineToPoint(path, NULL, lastPoint.x, lastPoint.y);
    CGPathAddLineToPoint(path, NULL, lastPoint.x, 0);
    CGPathAddLineToPoint(path, NULL, firstPoint.x, 0);
    CGPathAddLineToPoint(path, NULL, firstPoint.x, firstPoint.y);
    
    SKShapeNode *terrainLayer = (SKShapeNode *)[block_ childNodeWithName:@"terrainLayer"];
    terrainLayer.path = path;
    
    terrainLayer.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:path];
    
    CGPathRelease(path);
    path = nil;
}

// --------------------------------


#pragma mark -
#pragma mark Terrain cleanup

- (void)destroyLayer
{
    for(SKNode *block in visibleBlocks)
    {
        SKShapeNode *terrainLayer = (SKShapeNode *)[block childNodeWithName:@"terrainLayer"];
        terrainLayer.path = nil;
        [terrainLayer removeFromParent];
        terrainLayer = nil;
    }
    
    for(SKNode *block in recycledBlocks)
    {
        SKShapeNode *terrainLayer = (SKShapeNode *)[block childNodeWithName:@"terrainLayer"];
        terrainLayer.path = nil;
        [terrainLayer removeFromParent];
        terrainLayer = nil;
    }
    
    [super destroyLayer];
    
    [terrainBlocksData removeAllObjects];
    terrainBlocksData = nil;
}

// -----------------------------------

@end
