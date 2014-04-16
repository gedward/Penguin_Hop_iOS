//
//  PenguinNode.m
//  Penguin Hop
//
//  Created by G Edward Gonzalez on 4/16/14.
//  Copyright (c) 2014 Gerard Edward Gonzalez. All rights reserved.
//

#import "PenguinSprite.h"


#pragma mark - Private Variables

@interface PenguinSprite()

@property(assign) int jumps;

@end

#pragma mark - Initialization

@implementation PenguinSprite

- (id) init {
    if (self = [super init]) {
        self = [PenguinSprite spriteNodeWithImageNamed:@"penguin_idle"];
        self.jumps = 0;
        [self setupPenguin];
    }
    return self;
}

- (void)setupPenguin {
    SKTextureAtlas *run_atlas = [SKTextureAtlas atlasNamed:@"penguin_run"];
    SKTexture *pr1 = [run_atlas textureNamed:@"penguin_run1.png"];
    SKTexture *pr2 = [run_atlas textureNamed:@"penguin_run2.png"];
    SKTexture *pr3 = [run_atlas textureNamed:@"penguin_run3.png"];
    NSArray *penguinRunTextures = @[pr1,pr2,pr3];
    SKAction *runAnimation = [SKAction animateWithTextures:penguinRunTextures timePerFrame:.1];
    
    SKTextureAtlas *slide_atlas = [SKTextureAtlas atlasNamed:@"penguin_slide"];
    SKTexture *ps1 = [slide_atlas textureNamed:@"penguin_slide1.png"];
    SKTexture *ps2 = [slide_atlas textureNamed:@"penguin_slide2.png"];
    NSArray *penguinSlideTextures = @[ps1,ps2];
    SKAction *slideAnimation = [SKAction animateWithTextures:penguinSlideTextures timePerFrame:.3];
    SKAction *leanForward = [SKAction rotateByAngle:-.1 duration:.05];
    SKAction *leanBackward = [SKAction rotateByAngle:.1 duration:.05];
    SKAction *slideSequence = [SKAction sequence:@[leanForward, slideAnimation, leanBackward]];
    
    SKAction *jump = [SKAction moveByX:0 y:200 duration:.3];
    
    self.name = @"penguin";
    self.userData = [NSMutableDictionary dictionary];
    [self.userData setObject:runAnimation forKey:@"run_action"];
    [self.userData setObject:slideSequence forKey:@"slide_action"];
    [self.userData setObject:jump forKey:@"jump_action"];
    
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
    self.physicsBody.dynamic = YES;
}

#pragma mark - Methods

#pragma mark Jump Methods 

- (int)getJumps {
    return self.jumps;
}

- (void)didJump {
    self.jumps+=1;
}

- (void)resetJumps {
    
}

@end
