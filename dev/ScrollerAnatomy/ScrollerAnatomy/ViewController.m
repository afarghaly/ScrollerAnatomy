//
//  ViewController.m
//  ScrollerAnatomy
//
//  Created by Ahmed Farghaly on 12/16/13.
//  Copyright (c) 2013 Ahmed Farghaly. All rights reserved.
//

#import "ViewController.h"
#import "BaseScrollerScene.h"

// ind. scenes
#import "EmptyScene.h"      // user for menu screen
#import "ForestScene.h"
#import "DesertScene.h"


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


@interface ViewController()
{
    SKView *gameSKView;
    
    UIView *overlaysView;
    
    DebugView *debugView;
    MenuView *menuView;
}

// scene loading methods
- (void)loadMenuScene;
- (void)loadBaseScrollerScene;

// overlays management methods
- (void)showDebugView;
- (void)showMenuView;
- (void)clearOverlaysView;

@end


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


@implementation ViewController


#pragma mark -
#pragma mark ViewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if(!gameSKView)
    {
        gameSKView = [[SKView alloc] initWithFrame:self.view.bounds];
        gameSKView.backgroundColor = [UIColor redColor];
        gameSKView.userInteractionEnabled = YES;
        gameSKView.showsFPS = YES;
        gameSKView.showsNodeCount = YES;
        gameSKView.showsDrawCount = YES;
    }
    [self.view addSubview:gameSKView];
    
    if(!overlaysView)
    {
        overlaysView = [[UIView alloc] initWithFrame:self.view.bounds];
    }
    [self.view addSubview:overlaysView];
    
    [self loadMenuScene];
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


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


#pragma mark -
#pragma mark Scene loading methods

- (void)loadMenuScene
{
    EmptyScene *emptyScene = [EmptyScene sceneWithSize:gameSKView.bounds.size];
    [gameSKView presentScene:emptyScene];
    
    [self showMenuView];
}


- (void)loadBaseScrollerScene
{
    BaseScrollerScene *baseScene = [BaseScrollerScene sceneWithSize:gameSKView.bounds.size];
    baseScene.scaleMode = SKSceneScaleModeAspectFill;
    [gameSKView presentScene:baseScene];
    
    [self showDebugView];
}

- (void)loadForestScene
{
    ForestScene *forestScene = [ForestScene sceneWithSize:gameSKView.bounds.size];
    forestScene.scaleMode = SKSceneScaleModeAspectFill;
    [gameSKView presentScene:forestScene];
    
    [self showDebugView];
}

- (void)loadDesertScene
{
    DesertScene *desertScene = [DesertScene sceneWithSize:gameSKView.bounds.size];
    desertScene.scaleMode = SKSceneScaleModeAspectFill;
    [gameSKView presentScene:desertScene];
    
    [self showDebugView];
}

- (void)loadMountainsScene
{
    [self showDebugView];
}

- (void)loadHoneycombScene
{
    [self showDebugView];
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


#pragma mark -
#pragma mark View management

- (void)showDebugView
{
    [self clearOverlaysView];
    
    if(!debugView)
    {
        debugView = [[DebugView alloc] initWithFrame:self.view.bounds];
        debugView.delegate = self;
    }
    
    [overlaysView addSubview:debugView];
}

- (void)showMenuView
{
    [self clearOverlaysView];
    
    if(!menuView)
    {
        menuView = [[MenuView alloc] initWithFrame:self.view.bounds];
        menuView.delegate = self;
    }
    
    [overlaysView addSubview:menuView];
}

- (void)clearOverlaysView
{
    for(UIView *view in [overlaysView subviews])
    {
        [view removeFromSuperview];
    }
    
//    menuView = nil;
//    debugView = nil;
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


#pragma mark -
#pragma mark Pause methods

- (void)pauseGame
{
//    NSLog(@"pause game");
}

- (void)unpauseGame
{
//    NSLog(@"unpause game");
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


#pragma mark -
#pragma mark DebugViewDelegate methods

- (void)zoomInTapped
{
    BaseScrollerScene *scene = (BaseScrollerScene *)gameSKView.scene;
    [scene zoomIn];
}

- (void)zoomOutTapped
{
    BaseScrollerScene *scene = (BaseScrollerScene *)gameSKView.scene;
    [scene zoomOut];
}

- (void)closeTapped
{
    BaseScrollerScene *currentScene = (BaseScrollerScene *)gameSKView.scene;
    if([currentScene isKindOfClass:[BaseScrollerScene class]])
    {
        [currentScene destroyScene];
    }
    
    [self loadMenuScene];
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


#pragma mark -
#pragma mark MenuViewDelegate methods

- (void)didSelectAnatomy
{
    [self loadBaseScrollerScene];
}

- (void)didSelectForest
{
    [self loadForestScene];
}

- (void)didSelectDesert
{
    [self loadDesertScene];
}

- (void)didSelectMountains
{
    NSLog(@"did select mountains");
}

- (void)didSelectHoneycomb
{
    NSLog(@"did select honeycomb");
}

- (void)didSelectAbout
{
    NSLog(@"did select about");
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


#pragma mark -
#pragma mark Touch Handling methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    float speedFactor =  [self getSpeedFactorFromTouches:touches];
    BaseScrollerScene *scene = (BaseScrollerScene *)gameSKView.scene;
    if([scene isKindOfClass:[BaseScrollerScene class]])
    {
        [scene updateScrollingSpeed:speedFactor];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    float speedFactor =  [self getSpeedFactorFromTouches:touches];
    BaseScrollerScene *scene = (BaseScrollerScene *)gameSKView.scene;
    if([scene isKindOfClass:[BaseScrollerScene class]])
    {
        [scene updateScrollingSpeed:speedFactor];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    float speedFactor =  [self getSpeedFactorFromTouches:touches];
    BaseScrollerScene *scene = (BaseScrollerScene *)gameSKView.scene;
    if([scene isKindOfClass:[BaseScrollerScene class]])
    {
        [scene updateScrollingSpeed:speedFactor];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"cancelled");
}

- (float)getSpeedFactorFromTouches:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:overlaysView];
    return (touchLocation.x - (self.view.bounds.size.width / 2)) / (self.view.bounds.size.width / 2);
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


- (void)updateMemoryUsage
{
//    NSLog(@"[ViewController updateMemoryUsage]");
    [debugView updateAppMemoryUsage];
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



@end





