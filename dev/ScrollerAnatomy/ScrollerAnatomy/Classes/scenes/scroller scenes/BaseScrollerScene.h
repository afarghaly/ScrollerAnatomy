//
//  BaseScrollerScene.h
//  ScrollerAnatomy
//
//  Created by Ahmed Farghaly on 12/16/13.
//  Copyright (c) 2013 Ahmed Farghaly. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "AppDelegate.h"
#import "ViewController.h"

@interface BaseScrollerScene : SKScene
{
    AppDelegate *appDelegate;
    ViewController *rootViewController;
    
    // zoom level
    float zoomLevel;
    
    // scroll speed
    float scrollSpeed;
    
    // update vars
    CFTimeInterval lastUpdateTimeInterval;
    
    // world
    SKNode *world;
    
    // environment data
    NSDictionary *environmentData;
}


- (void)createScene;
- (void)destroyScene;

- (void)zoomToScale:(float)newScale_;
- (void)zoomIn;
- (void)zoomOut;

- (void)updateScrollingSpeed:(float)newSpeed_;
@end
