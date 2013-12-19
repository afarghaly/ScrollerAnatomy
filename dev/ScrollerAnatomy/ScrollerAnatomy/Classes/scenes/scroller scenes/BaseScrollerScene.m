//
//  BaseScrollerScene.m
//  ScrollerAnatomy
//
//  Created by Ahmed Farghaly on 12/16/13.
//  Copyright (c) 2013 Ahmed Farghaly. All rights reserved.
//

#import "BaseScrollerScene.h"

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
        environmentData = [[DataUtils sharedDataManager] getEnvironmentDataForKey:@"anatomy"];
        
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
    
//    NSLog(@"env data: %@", environmentData);
    
    SKColor *skyColor1 = [[ColorUtils sharedColorUtils] getColorFromHexString:environmentData[@"skyColor1"]];
    SKColor *skyColor2 = [[ColorUtils sharedColorUtils] getColorFromHexString:environmentData[@"skyColor2"]];
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
    viewportBorder.fillColor = [SKColor clearColor];
    viewportBorder.strokeColor = [SKColor colorWithWhite:1.0f alpha:0.2f];
    [self addChild:viewportBorder];
    CGPathRelease(viewportBorderPath);
    viewportBorderPath = nil;
    
    //  distant scenery - - - - - - - - - - - - - -
    
    NSString *distantSceneryImageName = environmentData[@"distantSceneryImage"];
    if(distantSceneryImageName && ([distantSceneryImageName length] > 0))
    {
        distantScenery = [[DistantSceneryNode alloc] initWithSceneryImage:distantSceneryImageName showsBlockIndex:[environmentData[@"showsBlockIndex"] boolValue]];
    }
    else
    {
        float distantSceneryAlpha = [environmentData[@"distantSceneryAlpha"] floatValue];
        SKColor *distantSceneryColor = [[ColorUtils sharedColorUtils] getColorFromHexString:environmentData[@"distantSceneryColor"] alpha:distantSceneryAlpha];
        
        float distantSceneryStrokeAlpha = [environmentData[@"distantSceneryStrokeAlpha"] floatValue];
        SKColor *distantSceneryStrokeColor = [[ColorUtils sharedColorUtils] getColorFromHexString:environmentData[@"distantSceneryStrokeColor"] alpha:distantSceneryStrokeAlpha];
        
        distantScenery = [[DistantSceneryNode alloc] initWithSceneryType:DistantSceneryTypeConcavePeaks
                                                              sceneColor:distantSceneryColor
                                                             sceneryAlpha:distantSceneryAlpha
                                                       sceneryStrokeColor:distantSceneryStrokeColor
                                                       sceneryStrokeAlpha:distantSceneryStrokeAlpha
                                                          showsBlockIndex:[environmentData[@"showsBlockIndex"] boolValue]];
    }
    [self addChild:distantScenery];
    
    // near scenery - - - - - - - - - - - - - -
    
    NSString *sceneryImageName = environmentData[@"sceneryImage"];
    if(sceneryImageName && ([sceneryImageName length] > 0))
    {
        nearScenery = [[NearSceneryNode alloc] initWithSceneryImage:sceneryImageName showsBlockIndex:[environmentData[@"showsBlockIndex"] boolValue]];
    }
    else
    {
        float sceneryAlpha = [environmentData[@"sceneryAlpha"] floatValue];
        SKColor *sceneryColor = [[ColorUtils sharedColorUtils] getColorFromHexString:environmentData[@"sceneryColor"] alpha:sceneryAlpha];
        
        float sceneryStrokeAlpha = [environmentData[@"sceneryStrokeAlpha"] floatValue];
        SKColor *sceneryStrokeColor = [[ColorUtils sharedColorUtils] getColorFromHexString:environmentData[@"sceneryStrokeColor"] alpha:sceneryStrokeAlpha];
        
        nearScenery = [[NearSceneryNode alloc] initWithNearSceneryType:NearSceneryTypeHills
                                                            sceneColor:sceneryColor
                                                           sceneryAlpha:sceneryAlpha
                                                     sceneryStrokeColor:sceneryStrokeColor
                                                     sceneryStrokeAlpha:sceneryStrokeAlpha
                                                        showsBlockIndex:[environmentData[@"showsBlockIndex"] boolValue]];
    }
    [self addChild:nearScenery];
    
    // - - - - - - - - - - - - - -
    
    world = [SKNode node];
    [self addChild:world];
    // -
    
    terrain = [[Terrain alloc] initWithTerrainColor:[SKColor colorWithWhite:1.0f alpha:0.7f] showsBlockIndex:[environmentData[@"showsBlockIndex"] boolValue]];
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


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



@end





