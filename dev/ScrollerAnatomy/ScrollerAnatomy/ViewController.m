//
//  ViewController.m
//  ScrollerAnatomy
//
//  Created by Ahmed Farghaly on 12/16/13.
//  Copyright (c) 2013 Ahmed Farghaly. All rights reserved.
//

#import "ViewController.h"
#import "BaseScrollerScene.h"


@interface ViewController()
{
    SKView *gameSKView;
    
    UIView *overlaysView;
    
}
@end


// -


@implementation ViewController


#pragma mark -
#pragma mark ViewController methods


- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if(!gameSKView)
    {
        gameSKView = [[SKView alloc] initWithFrame:self.view.bounds];
        gameSKView.userInteractionEnabled = YES;
        gameSKView.showsFPS = YES;
        gameSKView.showsNodeCount = YES;
        gameSKView.showsDrawCount = YES;
    }
    [self.view addSubview:gameSKView];
    
    BaseScrollerScene *baseScene = [BaseScrollerScene sceneWithSize:gameSKView.bounds.size];
    baseScene.scaleMode = SKSceneScaleModeAspectFill;
    [gameSKView presentScene:baseScene];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

// --------------------

#pragma mark -
#pragma mark Pause methods

- (void)pauseGame
{
    NSLog(@"pause game");
}

- (void)unpauseGame
{
    NSLog(@"unpause game");
}

// --------------------



@end




