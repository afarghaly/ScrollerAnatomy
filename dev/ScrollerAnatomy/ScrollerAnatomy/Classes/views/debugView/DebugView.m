//
//  DebugView.m
//  TouchBots
//
//  Created by Ahmed Farghaly on 12/4/13.
//  Copyright (c) 2013 Ahmed Farghaly. All rights reserved.
//

#import "DebugView.h"
#import "DeviceUtils.h"
#import "UIDeviceAdditions.h"


@interface DebugView()
{
    UILabel *memoryUsageDataLabel;
}
@end



@implementation DebugView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // Initialization code
        
        UIButton *zoomOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        zoomOutButton.frame = CGRectMake(0,
                                        0,
                                        DeviceIsiPhone() ? 50 : 100,
                                        DeviceIsiPhone() ? 50 : 100);
        [zoomOutButton setImage:[UIImage imageNamed:@"zoomOutButton"] forState:UIControlStateNormal];
        [zoomOutButton addTarget:self action:@selector(zoomOutTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:zoomOutButton];
        
        // -
        
        UIButton *zoomInButton = [UIButton buttonWithType:UIButtonTypeCustom];
        zoomInButton.frame = CGRectMake(DeviceIsiPhone() ? 50 : 100,
                                         0,
                                         DeviceIsiPhone() ? 50 : 100,
                                         DeviceIsiPhone() ? 50 : 100);
        [zoomInButton setImage:[UIImage imageNamed:@"zoomInButton"] forState:UIControlStateNormal];
        [zoomInButton addTarget:self action:@selector(zoomInTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:zoomInButton];
        
        // -
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = CGRectMake(DeviceIsiPhone() ? (DeviceIs4Inch() ? 520 : 430) : 920,
                                        0,
                                        DeviceIsiPhone() ? 50 : 100,
                                        DeviceIsiPhone() ? 50 : 100);
        [closeButton setImage:[UIImage imageNamed:@"CloseButton"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        
        /*
        UILabel *memoryUsageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                              DeviceIsiPhone() ? 60 : 120,
                                                                              DeviceIsiPhone() ? 80 : 190,
                                                                              DeviceIsiPhone() ? 20 : 40)];
        memoryUsageLabel.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.1f];
        memoryUsageLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:DeviceIsiPhone() ? 15 : 35];
        memoryUsageLabel.textColor = [UIColor darkGrayColor];
        memoryUsageLabel.text = @"MEMORY:";
        [self addSubview:memoryUsageLabel];
        // -
        
        memoryUsageDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(DeviceIsiPhone() ? 100 : 220,
                                                                         DeviceIsiPhone() ? 60 : 120,
                                                                         DeviceIsiPhone() ? 100 : 200,
                                                                         DeviceIsiPhone() ? 20 : 40)];
        memoryUsageDataLabel.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.1f];
        memoryUsageDataLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:DeviceIsiPhone() ? 15 : 35];
        memoryUsageDataLabel.textColor = [UIColor lightGrayColor];
        memoryUsageDataLabel.text = @"0 MB";
        [self addSubview:memoryUsageDataLabel];
        */
    }
    return self;
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


- (void)zoomOutTapped
{
    if(delegate)
    {
        [delegate zoomOutTapped];
    }
}

- (void)zoomInTapped
{
    if(delegate)
    {
        [delegate zoomInTapped];
    }
}

- (void)closeTapped
{
    if(delegate)
    {
        [delegate closeTapped];
    }
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


- (void)updateAppMemoryUsage
{
    float memoryUsage = [[UIDevice currentDevice] currentMemoryUsage];
    memoryUsageDataLabel.text = [NSString stringWithFormat:@"%.2f MB", memoryUsage];
}

@end
