    //
//  ColorUtils.h
//  BattleBots
//
//  Created by Ahmed Farghaly on 10/4/13.
//  Copyright (c) 2013 Ahmed Farghaly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface ColorUtils : NSObject

+ (ColorUtils *)sharedColorUtils;

- (SKColor *)getRandomColor;
- (SKColor *)getColorFromHexString:(NSString *)hexString;
- (SKColor *)getColorFromHexString:(NSString *)hexString alpha:(float)alpha_;

@end
