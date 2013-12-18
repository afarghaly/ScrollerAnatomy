//
//  BaseScrollerScene.m
//  ScrollerAnatomy
//
//  Created by Ahmed Farghaly on 12/16/13.
//  Copyright (c) 2013 Ahmed Farghaly. All rights reserved.
//

#import "BaseScrollerScene.h"

// app singletons
#import "DeviceUtils.h"

// scene layers
#import "GradientNode.h"
#import "DistantSceneryNode.h"
#import "NearSceneryNode.h"
#import "Terrain.h"


// scrolling speed
#define MAX_SCROLLING_SPEED (DeviceIsiPhone() ? 100 : 240)

// zoom
#define SCENE_SCALE_DURATION 0.1f
#define MAX_ZOOM 1.0f
#define MIN_ZOOM 0.2f

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


@interface BaseScrollerScene()
{
    BOOL contentCreated;
    
    // scene layers
    GradientNode *sky;
    DistantSceneryNode *distantScenery;
    NearSceneryNode *nearScenery;
    Terrain *terrain;
}
@end


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


@implementation BaseScrollerScene


#pragma mark -
#pragma mark Scene init methods

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    
    if(self)
    {
        
        
        return self;
    }
    
    return nil;
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    rootViewController = (ViewController *)appDelegate.window.rootViewController;
    
    if(!contentCreated)
    {
        [self createScene];
        contentCreated = YES;
    }
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


#pragma mark -
#pragma mark Scene creation/destruction methods

- (void)createScene
{
    self.anchorPoint = CGPointMake(0.5f, 0.0f);
    self.backgroundColor = [SKColor blackColor];
    
    zoomLevel = 1.0f;
    scrollSpeed = 0.0f;
    
    SKColor *skyColor1 = [SKColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
    SKColor *skyColor2 = [SKColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:1.0f];
    NSArray *skyGradientColors = [NSArray arrayWithObjects:skyColor1, skyColor2, nil];
    sky = [[GradientNode alloc] initWithSize:self.frame.size gradientColors:skyGradientColors];
    sky.anchorPoint = CGPointMake(0.5f, 0.0f);
    [self addChild:sky];
    // -
    
    SKShapeNode *viewportBorder = [SKShapeNode node];
    CGPathRef viewportBorderPath = CGPathCreateWithRect(CGRectMake(-self.view.bounds.size.width / 2,
                                                                   0,
                                                                   self.view.bounds.size.width,
                                                                   self.view.bounds.size.height),
                                                        NULL);
    viewportBorder.path = viewportBorderPath;
    viewportBorder.fillColor = [SKColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
    viewportBorder.strokeColor = [SKColor colorWithWhite:1.0f alpha:0.2f];
    [self addChild:viewportBorder];
    CGPathRelease(viewportBorderPath);
    viewportBorderPath = nil;
    // -
    
    SKColor *distantSceneryVectorColor = [SKColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.1f];
    distantScenery = [[DistantSceneryNode alloc] initWithSceneryColor:distantSceneryVectorColor];
    [self addChild:distantScenery];
    // -
    
    SKColor *nearSceneryVectorColor = [SKColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.1f];
    nearScenery = [[NearSceneryNode alloc] initWithNearSceneryColor:nearSceneryVectorColor];
    [self addChild:nearScenery];
    // -
    
    world = [SKNode node];
    [self addChild:world];
    // -
    
    terrain = [[Terrain alloc] initWithTerrainColor:[SKColor colorWithWhite:1.0f alpha:0.7f]];
    [world addChild:terrain];
    // -
    
}

- (void)destroyScene
{
    [distantScenery destroyLayer];
    [nearScenery destroyLayer];
    [terrain destroyLayer];
    
    
    [self removeAllChildren];
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


#pragma mark -
#pragma mark Scene updat methods

- (void)update:(CFTimeInterval)currentTime
{
    CFTimeInterval timeSinceLastFrame = currentTime - lastUpdateTimeInterval;
     lastUpdateTimeInterval = currentTime;
    
    if(timeSinceLastFrame > 1.0)
    {
        timeSinceLastFrame = 1.0 / 60.0f;
        lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLastFrame];
}


- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast
{
    // manually set world's position
    
    CGPoint worldPosition = world.position;
    worldPosition.x -= scrollSpeed;
    world.position = worldPosition;
    
    [distantScenery scroll:distantScenery.position];
    [nearScenery scroll:nearScenery.position];
    [terrain scroll:worldPosition];
    
//    [clouds scroll:clouds.position];
    
//    [viewController processTouches];
    [rootViewController updateMemoryUsage];
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


#pragma mark -
#pragma mark Physics

- (void)didSimulatePhysics
{
    [super didSimulatePhysics];
    
    CGPoint worldPosition = world.position;
    
    distantScenery.position = CGPointMake(worldPosition.x * 0.3, 0);
    nearScenery.position = CGPointMake(worldPosition.x * 0.5, 0);
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


#pragma mark -
#pragma mark zoom methods

- (void)zoomToScale:(float)newScale_
{
    //    NSLog(@"zoomToScale:%f", newScale_);

    if(newScale_ < MIN_ZOOM)
    {
        zoomLevel = MIN_ZOOM;
    }
    else if(newScale_ > MAX_ZOOM)
    {
        zoomLevel = MAX_ZOOM;
    }
    else
    {
        zoomLevel = newScale_;
    }
    
    [self runAction:[SKAction scaleTo:zoomLevel duration:SCENE_SCALE_DURATION]];
}

- (void)zoomOut
{
    zoomLevel -= 0.1f;
    [self zoomToScale:zoomLevel];
}

- (void)zoomIn
{
    zoomLevel += 0.1f;
    [self zoomToScale:zoomLevel];
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


#pragma mark -
#pragma mark scroll speed update method

- (void)updateScrollingSpeed:(float)newSpeed_
{
//    NSLog(@"BaseScrollerSCene updateScrollingSpeed:%f", newSpeed_);
    scrollSpeed = newSpeed_ * MAX_SCROLLING_SPEED;
}

@end
