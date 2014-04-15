//
//  MyScene.m
//  Penguin Hop
//
//  Created by G Edward Gonzalez on 4/13/14.
//  Copyright (c) 2014 Gerard Edward Gonzalez. All rights reserved.
//

#import "PenguinScene.h"

static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint CGPointMultiplyScalar(const CGPoint a, const CGFloat b)
{
    return CGPointMake(a.x * b, a.y * b);
}

static const float BG_VELOCITY = 100.0;
NSTimeInterval _lastUpdateTime;
NSTimeInterval _dt;

@implementation PenguinScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        NSLog(@"Size: %@", NSStringFromCGSize(size));
        self.scaleMode = SKSceneScaleModeAspectFill;
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
    [self initalizingScrollingBackground];
    
    self.penguin = [self newPenguin];
    self.penguin.position = CGPointMake(CGRectGetMidX(self.frame)/2,CGRectGetMidY(self.frame)/1.8);
    [self addChild:self.penguin];
    
    [self.penguin runAction:[SKAction repeatActionForever:[self.penguin.userData objectForKey:@"run_action"]]];
}

-(void)initalizingScrollingBackground
{
    for (int i = 0; i < 2; i++) {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"penguinbackground.jpg"];
        bg.position = CGPointMake(i * bg.size.width, 0);
        bg.anchorPoint = CGPointZero;
        bg.name = @"bg";
        [self addChild:bg];
    }
}

- (void)moveBg
{
    [self enumerateChildNodesWithName:@"bg" usingBlock: ^(SKNode *node, BOOL *stop)
     {
         SKSpriteNode * bg = (SKSpriteNode *) node;
         CGPoint bgVelocity = CGPointMake(-BG_VELOCITY, 0);
         CGPoint amtToMove = CGPointMultiplyScalar(bgVelocity,_dt);
         bg.position = CGPointAdd(bg.position, amtToMove);
         
         //Checks if bg node is completely scrolled of the screen, if yes then put it at the end of the other node
         if (bg.position.x <= -bg.size.width)
         {
             bg.position = CGPointMake(bg.position.x + bg.size.width*2,
                                       bg.position.y);
         }
     }];
}

- (SKSpriteNode *)newPenguin {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"penguin_run"];
    SKTexture *p1 = [atlas textureNamed:@"penguin_run1.png"];
    SKTexture *p2 = [atlas textureNamed:@"penguin_run2.png"];
    SKTexture *p3 = [atlas textureNamed:@"penguin_run3.png"];
    NSArray *penguinRunTextures = @[p1,p2,p3];
    SKAction *runAnimation = [SKAction animateWithTextures:penguinRunTextures timePerFrame:.1];
    
    SKSpriteNode *penguin = [SKSpriteNode spriteNodeWithImageNamed:@"penguin_idle"];
    penguin.name = @"penguin";
    penguin.userData = [NSMutableDictionary dictionary];
    [penguin.userData setObject:runAnimation forKey:@"run_action"];

    
//    penguin.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:30];
//    penguin.physicsBody.dynamic = NO;
    
//    penguin.color = [SKColor redColor];
//    penguin.colorBlendFactor = .5;
    
//    SKAction *run_action = [SKAction moveByX:150 y:0 duration:1.0];
//    [penguin runAction:[SKAction repeatActionForever:run_action]];
    
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
    if (_lastUpdateTime)
        _dt = currentTime - _lastUpdateTime;
    else
        _dt = 0;
    _lastUpdateTime = currentTime;
    
    [self moveBg];
}


@end






