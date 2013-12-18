//
//  ViewController.h
//  ScrollerAnatomy
//

//  Copyright (c) 2013 Ahmed Farghaly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "DebugView.h"
#import "MenuView.h"

@interface ViewController : UIViewController <DebugViewDlegate, MenuViewDelegate>

- (void)pauseGame;
- (void)unpauseGame;
- (void)updateMemoryUsage;

@end
