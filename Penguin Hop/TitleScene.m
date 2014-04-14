//
//  TitleScene.m
//  Penguin Hop
//
//  Created by G Edward Gonzalez on 4/14/14.
//  Copyright (c) 2014 Gerard Edward Gonzalez. All rights reserved.
//

#import "TitleScene.h"
#import "PenguinScene.h"

@implementation TitleScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
    }
    return self;
}

- (void)didMoveToView: (SKView *) view {
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents {
    self.backgroundColor = [SKColor colorWithRed:0.05 green:0.05 blue:0.05 alpha:1.0];
    self.scaleMode = SKSceneScaleModeAspectFit;
    [self addChild: [self newTitleNode]];
}

- (SKLabelNode *)newTitleNode {
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Thin"];
    
    myLabel.text = @"Title Scene!";
    myLabel.fontSize = 30;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    myLabel.name = @"title_node";
    
    return myLabel;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    SKNode *title_node = [self childNodeWithName:@"title_node"];
    if (title_node != nil)
    {
        title_node.name = nil;
        SKAction *moveUp = [SKAction moveByX: 0 y: 100.0 duration: 0.5];
        SKAction *zoom = [SKAction scaleTo: 2.0 duration: 0.25];
        SKAction *pause = [SKAction waitForDuration: 0.5];
        SKAction *fadeAway = [SKAction fadeOutWithDuration: 0.25];
        SKAction *remove = [SKAction removeFromParent];
        SKAction *moveSequence = [SKAction sequence:@[moveUp, zoom, pause, fadeAway, remove]];
        
        [title_node runAction: moveSequence completion:^{
            SKScene *penguinScene  = [[PenguinScene alloc] initWithSize:self.size];
            SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
            [self.view presentScene:penguinScene transition:doors];
        }];    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}


@end
