//
//  ColorUtils.m
//  BattleBots
//
//  Created by Ahmed Farghaly on 10/4/13.
//  Copyright (c) 2013 Ahmed Farghaly. All rights reserved.
//

#import "ColorUtils.h"

@implementation ColorUtils


static ColorUtils *_sharedColorUtils = nil;

#pragma mark -
#pragma mark Singleton setup methods

+ (ColorUtils *)sharedColorUtils
{
    @synchronized([ColorUtils class])
    {
        if(!_sharedColorUtils)
        {
            _sharedColorUtils = [[self alloc] init];
        }
        
        return _sharedColorUtils;
    }
    
    return nil;
}

+ (id)alloc
{
    @synchronized([ColorUtils class])
    {
        NSAssert(_sharedColorUtils == nil, @"Attempted to allocate a second instance of Color Utils singleton");
        
        _sharedColorUtils = [super alloc];
        return _sharedColorUtils;
    }
    
    return nil;
}

- (id)init
{
    self = [super init];
    
    if(self)
    {
        NSLog(@"[ColorUtils init]");
//        NSLog(@" ");
        
        return self;
    }
    
    return nil;
}

// -----------------------------------


- (SKColor *)getRandomColor
{
    CGFloat red =  (CGFloat)((arc4random() % 100) / 100.0f);
    CGFloat blue = (CGFloat)((arc4random() % 100) / 100.0f);
    CGFloat green = (CGFloat)((arc4random() % 100) / 100.0f);
    
    return [SKColor colorWithRed:red green:green blue:blue alpha:1.0];
}

// -

- (SKColor *)getColorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:2]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
@end
