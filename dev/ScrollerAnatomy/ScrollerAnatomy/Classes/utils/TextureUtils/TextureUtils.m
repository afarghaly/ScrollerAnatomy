//
//  TextureUtils.m
//  TouchBots
//
//  Created by Ahmed Farghaly on 12/4/13.
//  Copyright (c) 2013 Ahmed Farghaly. All rights reserved.
//

#import "TextureUtils.h"
#import "DeviceUtils.h"

@interface TextureUtils()
{
    NSMutableArray *cloudTextures;
    NSMutableDictionary *buggyTextures;
}
@end




@implementation TextureUtils

static TextureUtils *_sharedTextureUtils;

+ (TextureUtils *)sharedTextureUtils
{
    @synchronized([TextureUtils class])
    {
        if(!_sharedTextureUtils)
        {
            _sharedTextureUtils = [[self alloc] init];
        }
        
        return _sharedTextureUtils;
    }
    
    return nil;
}

+ (id)alloc
{
    @synchronized([TextureUtils class])
    {
        NSAssert(_sharedTextureUtils == nil, @"Attempted to allocate a second instance of TextureUtils singleton");
        
        _sharedTextureUtils = [super alloc];
        return _sharedTextureUtils;
    }
    
    return nil;
}

- (id)init
{
    self = [super init];
    
    if(self)
    {
        NSLog(@"[TextureUtils init]");
        
        return self;
    }
    
    return nil;
}


#pragma mark -
#pragma mark Cloud Texture access

- (void)loadCloudTextures
{
    NSLog(@"[TextureUtils loadCloudTextures]");
    
    if(!cloudTextures)
    {
        cloudTextures = [[NSMutableArray alloc] initWithCapacity:10];
    }
    
    SKTextureAtlas *cloudTextureAtlas = [SKTextureAtlas atlasNamed:@"clouds"];
    
    for(int i = 0 ; i < 11 ; i++)
    {
        NSString *cloudImageName = [NSString stringWithFormat:@"cloud%d", i];
        
        SKTexture *cloudTexture = [cloudTextureAtlas textureNamed:cloudImageName];
        [cloudTextures addObject:cloudTexture];
    }
    
    [SKTexture preloadTextures:cloudTextures withCompletionHandler:^
    {
        NSLog(@"%d cloud textures preloaded", (int)[cloudTextures count]);
    }];
}

- (void)releaseCloudTextures
{
    NSLog(@"[TextureUtils releaseCloudTextures]");
    
    for(__strong SKTexture *cloudTexture in cloudTextures)
    {
        cloudTexture = nil;
    }
    
    [cloudTextures removeAllObjects];
    cloudTextures = nil;
}

- (SKTexture *)getRandomCloudTexture
{
    SKTexture *cloudTexture = nil;
    
    if(cloudTextures)
    {
        uint randomCloudIndex = arc4random() % [cloudTextures count];
        cloudTexture = [cloudTextures objectAtIndex:randomCloudIndex];
    }
    else
    {
        [[TextureUtils sharedTextureUtils] loadCloudTextures];
    }
    
    return cloudTexture;
}

// -------------------------------------------------------------------------


#pragma mark -
#pragma mark Buggy Textures

- (void)loadBuggyTextures
{
    if(!buggyTextures)
    {
        buggyTextures = [[NSMutableDictionary alloc] initWithCapacity:6];
    }
    
    SKTextureAtlas *buggyTextureAtlas = [SKTextureAtlas atlasNamed:@"buggy"];
    
    for(int i = 0 ; i < [buggyTextureAtlas.textureNames count] ; i++)
    {
        NSString *textureName = buggyTextureAtlas.textureNames[i];
        
        NSRange deviceTypeRange = [textureName rangeOfString:@"ipad"];
        if(deviceTypeRange.location == NSNotFound)
        {
            if(DeviceIsiPhone())
            {
                NSRange firstOccurrenceOfAt = [textureName rangeOfString:@"@"];
                NSString *keyString = [textureName substringToIndex:firstOccurrenceOfAt.location];
                SKTexture *buggyTexture = [buggyTextureAtlas textureNamed:textureName];
                [buggyTextures setObject:buggyTexture forKey:keyString];
            }
        }
        else
        {
            if(DeviceIsiPad())
            {
                NSRange firstOccurrenceOfAt = [textureName rangeOfString:@"@"];
                NSString *keyString = [textureName substringToIndex:firstOccurrenceOfAt.location];
                SKTexture *buggyTexture = [buggyTextureAtlas textureNamed:textureName];
                [buggyTextures setObject:buggyTexture forKey:keyString];
            }
        }
        
        
    }
    
    [SKTexture preloadTextures:[buggyTextures allValues] withCompletionHandler:^
    {
        NSLog(@"%d buggy textures preloaded", (int)[[buggyTextures allKeys] count]);
    }];
}

- (void)releaseBuggyTextures
{
    for(__strong SKTexture *buggyTexture in buggyTextures)
    {
        buggyTexture = nil;
    }
    
    [buggyTextures removeAllObjects];
    buggyTextures = nil;
}

- (SKTexture *)getBuggyTexture:(NSString *)textureName_
{
    SKTexture *buggyTexture = nil;
    
    if(buggyTextures)
    {
        buggyTexture = [buggyTextures objectForKey:textureName_];
    }
    else
    {
        [[TextureUtils sharedTextureUtils] loadBuggyTextures];
    }
    
    return buggyTexture;
}

@end
