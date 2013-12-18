//
//  MenuView.h
//  ScrollerAnatomy
//
//  Created by Ahmed Farghaly on 12/18/13.
//  Copyright (c) 2013 Ahmed Farghaly. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuViewDelegate

- (void)didSelectAnatomy;
- (void)didSelectDesert;
- (void)didSelectForest;
- (void)didSelectMountains;
- (void)didSelectHoneycomb;
- (void)didSelectAbout;

@end

@interface MenuView : UIView

@property (nonatomic, weak) id <MenuViewDelegate> delegate;

@end
