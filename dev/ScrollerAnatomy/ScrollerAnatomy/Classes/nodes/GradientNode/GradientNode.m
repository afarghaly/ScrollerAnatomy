//
//  GradientNode.m
//  TouchBots
//
//  Created by Ahmed Farghaly on 12/4/13.
//  Copyright (c) 2013 Ahmed Farghaly. All rights reserved.
//

#import "GradientNode.h"
#import "ColorUtils.h"

@implementation GradientNode

- (id)init
{
    self = [super init];
    
    if(self)
    {
        
        return self;
    }
    
    return nil;
}

- (id)initWithSize:(CGSize)gradientSize_ gradientColors:(NSArray *)gradientColors_
{
    if([gradientColors_ count] < 2)
    {
        return nil;
    }
    
    self = [super init];
    
    if(self)
    {
        // draw gradient
        
        CGSize calculatedGradientSize = CGSizeMake(1, 1);   // make a really small gradient (for performance) then stretch it out
        
        UIGraphicsBeginImageContextWithOptions(calculatedGradientSize, YES, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
        
        size_t gradientNumberOfLocations = [gradientColors_ count];
        CGFloat gradientLocations[2] = {0.0, 1.0};
        
        SKColor *color1 = gradientColors_[0];
        const CGFloat* colors1 = CGColorGetComponents(color1.CGColor);
        
        SKColor *color2 = gradientColors_[1];
        const CGFloat *colors2 = CGColorGetComponents(color2.CGColor);
        
        CGFloat gradientComponents[8] = {colors1[0], colors1[1], colors1[2], colors1[3],
            colors2[0], colors2[1], colors2[2], colors2[3]};
        
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace, gradientComponents, gradientLocations, gradientNumberOfLocations);
        CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, calculatedGradientSize.height), 0);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        
        SKTexture *skyGradientTexture = [SKTexture textureWithCGImage:image.CGImage];
        image = nil;
        self.texture = skyGradientTexture;
        self.size = gradientSize_;
        skyGradientTexture = nil;
        
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorspace);
        UIGraphicsEndImageContext();
        
        // ------------------------------------------------------------------------------
        
        
        
        // load tiny gradient image: results in 2-3 MB additional memory overhead (unrecoverable)
        
        /*
         UIImage *skyImage = [UIImage imageNamed:@"tinyTestSky"];
         SKTexture *skyTexture = [SKTexture textureWithCGImage:skyImage.CGImage];
         self.texture = skyTexture
         self.size = gradientSize_;
         skyImage = nil;
         skyTexture = nil;
         */
        
        
        // ------------------------------------------------------------------------------
        
        return self;
    }
    
    return nil;
}



@end
