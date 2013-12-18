//
//  DebugView.h
//  TouchBots
//
//  Created by Ahmed Farghaly on 12/4/13.
//  Copyright (c) 2013 Ahmed Farghaly. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DebugViewDlegate

- (void)zoomOutTapped;
- (void)zoomInTapped;
- (void)closeTapped;

@end

@interface DebugView : UIView

@property (nonatomic, weak) id <DebugViewDlegate> delegate;

- (void)updateAppMemoryUsage;

@end
