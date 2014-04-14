//
//  MyScene.m
//  Penguin Hop
//
//  Created by G Edward Gonzalez on 4/13/14.
//  Copyright (c) 2014 Gerard Edward Gonzalez. All rights reserved.
//

#import "PenguinScene.h"

@implementation PenguinScene

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
    self.backgroundColor = [SKColor whiteColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    SKSpriteNode *penguin = [self newPenguin];
    penguin.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)-150);
    [self addChild:penguin];
}

- (SKSpriteNode *)newPenguin {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"penguin_run"];
    SKTexture *p1 = [atlas textureNamed:@"penguin_run1.png"];
    SKTexture *p2 = [atlas textureNamed:@"penguin_run2.png"];
    SKTexture *p3 = [atlas textureNamed:@"penguin_run3.png"];
    NSArray *penguinRunTextures = @[p1,p2,p3];
    SKAction *runAnimation = [SKAction animateWithTextures:penguinRunTextures timePerFrame:.1];
    
    SKSpriteNode *penguin = [SKSpriteNode spriteNodeWithImageNamed:@"penguin_idle"];
    [penguin runAction:[SKAction repeatActionForever:runAnimation]];
    
//    penguin.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:30];
//    penguin.physicsBody.dynamic = NO;
    
//    penguin.color = [SKColor redColor];
//    penguin.colorBlendFactor = .5;
    
    SKAction *run_action = [SKAction moveByX:100 y:0 duration:1.0];
    [penguin runAction:[SKAction repeatActionForever:run_action]];
    
    return penguin;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"penguin_idle"];
        
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
