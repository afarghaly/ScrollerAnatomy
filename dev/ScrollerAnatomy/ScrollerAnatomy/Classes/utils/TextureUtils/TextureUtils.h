//
//  TextureUtils.h
//  TouchBots
//
//  Created by Ahmed Farghaly on 12/4/13.
//  Copyright (c) 2013 Ahmed Farghaly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>


@interface TextureUtils : NSObject

+ (TextureUtils *)sharedTextureUtils;


- (void)loadCloudTextures;
- (void)releaseCloudTextures;
- (SKTexture *)getRandomCloudTexture;

- (void)loadBuggyTextures;
- (void)releaseBuggyTextures;
- (SKTexture *)getBuggyTexture:(NSString *)textureName_;
@end
