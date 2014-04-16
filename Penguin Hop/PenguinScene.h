//
//  MyScene.h
//  Penguin Hop
//

//  Copyright (c) 2014 Gerard Edward Gonzalez. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "PenguinSprite.h"

@interface PenguinScene : SKScene <UIGestureRecognizerDelegate>

@property BOOL contentCreated;
@property (retain) PenguinSprite *penguin;

@property (retain) UISwipeGestureRecognizer *swipeDownGesture;
@property (retain) UITapGestureRecognizer *tapGesture; 

@end
