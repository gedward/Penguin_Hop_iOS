//
//  MyScene.h
//  Penguin Hop
//

//  Copyright (c) 2014 Gerard Edward Gonzalez. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PenguinScene : SKScene <UIGestureRecognizerDelegate>

@property BOOL contentCreated;
@property (retain) SKSpriteNode *penguin;

@property (retain) UISwipeGestureRecognizer *swipeDownGesture;
@property (retain) UITapGestureRecognizer *tapGesture; 

@end
