//
//  MenuView.m
//  ScrollerAnatomy
//
//  Created by Ahmed Farghaly on 12/18/13.
//  Copyright (c) 2013 Ahmed Farghaly. All rights reserved.
//

#import "MenuView.h"
#import "DeviceUtils.h"
#import "ColorUtils.h"

@implementation MenuView

@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // Initialization code
        
        self.backgroundColor = [UIColor colorWithRed:0.05f green:0.05f blue:0.05f alpha:1.0f];
        
        CGPoint rootMenuPoint = CGPointMake(DeviceIsiPhone() ? 100 : 200, DeviceIsiPhone() ? 14 : 40);
        float buttonWidth = DeviceIsiPhone() ? 200 : 400;
        float buttonHeight = DeviceIsiPhone() ? 55 : 130;
        float buttonSpacing = DeviceIsiPhone() ? 3 : 10;
        UIEdgeInsets buttonInsets = UIEdgeInsetsMake(0,
                                                     (DeviceIsiPhone() ? 70 : 160),
                                                     0,
                                                     0);
        float buttonFontSize = DeviceIsiPhone() ? 20 : 40;
        float buttonImageDimension = DeviceIsiPhone() ? 50 : 120;
        // -
        
        UIButton *anatomyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        anatomyButton.frame = CGRectMake(rootMenuPoint.x,
                                         rootMenuPoint.y,
                                         buttonWidth,
                                         buttonHeight);
//        anatomyButton.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.05f];
        [anatomyButton setTitle:@"Anatomy" forState:UIControlStateNormal];
        anatomyButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:buttonFontSize];
        anatomyButton.titleEdgeInsets = buttonInsets;
        anatomyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        anatomyButton.titleLabel.backgroundColor = [UIColor darkGrayColor];
        UIImageView *anatomyButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 3, buttonImageDimension, buttonImageDimension)];
        anatomyButtonImageView.image = [UIImage imageNamed:@"anatomyButton"];
        [anatomyButton addSubview:anatomyButtonImageView];
        CALayer *anatomyButtonImageViewLayer = anatomyButtonImageView.layer;
        [anatomyButtonImageViewLayer setCornerRadius:buttonImageDimension / 2];
        [anatomyButtonImageViewLayer setMasksToBounds:YES];
        [anatomyButtonImageViewLayer setBorderColor:[SKColor whiteColor].CGColor];
        [anatomyButtonImageViewLayer setBorderWidth:buttonImageDimension / 18];
        [anatomyButton addTarget:self action:@selector(anatomyTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:anatomyButton];
        
        // -
        
        UIButton *forestButton = [UIButton buttonWithType:UIButtonTypeCustom];
        forestButton.frame = CGRectMake(rootMenuPoint.x,
                                         rootMenuPoint.y + buttonHeight + buttonSpacing,
                                         buttonWidth,
                                         buttonHeight);
//        forestButton.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.05f];
        [forestButton setTitle:@"Forest" forState:UIControlStateNormal];
        forestButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:buttonFontSize];
//        forestButton.titleLabel.backgroundColor = [UIColor darkGrayColor];
        forestButton.titleEdgeInsets = buttonInsets;
        forestButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        UIImageView *forestButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 3, buttonImageDimension, buttonImageDimension)];
        forestButtonImageView.image = [UIImage imageNamed:@"forestButton"];
        [forestButton addSubview:forestButtonImageView];
        CALayer *forestButtonImageViewLayer = forestButtonImageView.layer;
        [forestButtonImageViewLayer setCornerRadius:buttonImageDimension / 2];
        [forestButtonImageViewLayer setMasksToBounds:YES];
//        [forestButtonImageViewLayer setBorderColor:[[ColorUtils sharedColorUtils] getColorFromHexString:@"0x9fbf25"].CGColor];
        [forestButtonImageViewLayer setBorderColor:[SKColor whiteColor].CGColor];
        [forestButtonImageViewLayer setBorderWidth:buttonImageDimension / 18];
        [forestButton addTarget:self action:@selector(forestTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:forestButton];
        
        // -
        
        UIButton *desertButton = [UIButton buttonWithType:UIButtonTypeCustom];
        desertButton.frame = CGRectMake(rootMenuPoint.x,
                                        rootMenuPoint.y + (buttonHeight * 2) + (buttonSpacing * 2),
                                        buttonWidth,
                                        buttonHeight);
//        desertButton.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.05f];
        [desertButton setTitle:@"Desert" forState:UIControlStateNormal];
        desertButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:buttonFontSize];
        desertButton.titleEdgeInsets = buttonInsets;
        desertButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        desertButton.titleLabel.backgroundColor = [UIColor darkGrayColor];
        UIImageView *desertButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 3, buttonImageDimension, buttonImageDimension)];
        desertButtonImageView.image = [UIImage imageNamed:@"desertButton"];
        [desertButton addSubview:desertButtonImageView];
        CALayer *desertButtonImageViewLayer = desertButtonImageView.layer;
        [desertButtonImageViewLayer setCornerRadius:buttonImageDimension / 2];
        [desertButtonImageViewLayer setMasksToBounds:YES];
//        [desertButtonImageViewLayer setBorderColor:[[ColorUtils sharedColorUtils] getColorFromHexString:@"0xfdc639"].CGColor];
        [desertButtonImageViewLayer setBorderColor:[SKColor whiteColor].CGColor];
        [desertButtonImageViewLayer setBorderWidth:buttonImageDimension / 18];
        [desertButton addTarget:self action:@selector(desertTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:desertButton];
        
        // -
        
        UIButton *mountainsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        mountainsButton.frame = CGRectMake(rootMenuPoint.x,
                                        rootMenuPoint.y + (buttonHeight * 3) + (buttonSpacing * 3),
                                        buttonWidth,
                                        buttonHeight);
//        mountainsButton.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.05f];
        [mountainsButton setTitle:@"Mountains" forState:UIControlStateNormal];
        mountainsButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:buttonFontSize];
        [mountainsButton addTarget:self action:@selector(mountainsTapped) forControlEvents:UIControlEventTouchUpInside];
        mountainsButton.titleEdgeInsets = buttonInsets;
        mountainsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        mountainsButton.titleLabel.backgroundColor = [UIColor darkGrayColor];
        UIImageView *mountainsButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 3, buttonImageDimension, buttonImageDimension)];
        mountainsButtonImageView.image = [UIImage imageNamed:@"mountainsButton"];
        [mountainsButton addSubview:mountainsButtonImageView];
        CALayer *mountainsButtonImageViewLayer = mountainsButtonImageView.layer;
        [mountainsButtonImageViewLayer setCornerRadius:buttonImageDimension / 2];
        [mountainsButtonImageViewLayer setMasksToBounds:YES];
        [mountainsButtonImageViewLayer setBorderColor:[SKColor whiteColor].CGColor];
        [mountainsButtonImageViewLayer setBorderWidth:buttonImageDimension / 18];
        [self addSubview:mountainsButton];
        
        // -
        
        
        UIButton *honeycombButton = [UIButton buttonWithType:UIButtonTypeCustom];
        honeycombButton.frame = CGRectMake(rootMenuPoint.x,
                                           rootMenuPoint.y + (buttonHeight * 4) + (buttonSpacing * 4),
                                           buttonWidth,
                                           buttonHeight);
//        honeycombButton.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.05f];
        [honeycombButton setTitle:@"Honeycomb" forState:UIControlStateNormal];
        honeycombButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:buttonFontSize];
        [honeycombButton addTarget:self action:@selector(honeycombTapped) forControlEvents:UIControlEventTouchUpInside];
        honeycombButton.titleEdgeInsets = buttonInsets;
        honeycombButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        honeycombButton.titleLabel.backgroundColor = [UIColor darkGrayColor];
        UIImageView *honeycombButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 3, buttonImageDimension, buttonImageDimension)];
        honeycombButtonImageView.image = [UIImage imageNamed:@"honeycombButton"];
        [honeycombButton addSubview:honeycombButtonImageView];
        CALayer *honeycombButtonImageViewLayer = honeycombButtonImageView.layer;
        [honeycombButtonImageViewLayer setCornerRadius:buttonImageDimension / 2];
        [honeycombButtonImageViewLayer setMasksToBounds:YES];
        [honeycombButtonImageViewLayer setBorderColor:[[ColorUtils sharedColorUtils] getColorFromHexString:@"0xf4b223"].CGColor];
        [honeycombButtonImageViewLayer setBorderWidth:buttonImageDimension / 18];
        [self addSubview:honeycombButton];
        
        // -
        
    }
    return self;
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


#pragma mark -
#pragma mark Button events

- (void)anatomyTapped
{
    if(delegate)
    {
        [delegate didSelectAnatomy];
    }
}

- (void)forestTapped
{
    if(delegate)
    {
        [delegate didSelectForest];
    }
}

- (void)desertTapped
{
    if(delegate)
    {
        [delegate didSelectDesert];
    }
}

- (void)mountainsTapped
{
    if(delegate)
    {
        [delegate didSelectMountains];
    }
}

- (void)honeycombTapped
{
    if(delegate)
    {
        [delegate didSelectHoneycomb];
    }
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (void)dealloc
{
    NSLog(@"MenuView dealloc");
}

@end
