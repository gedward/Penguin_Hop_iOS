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

static const float BG_VELOCITY = 150.0;
NSTimeInterval _lastUpdateTime;
NSTimeInterval _dt;
float floor_position;

@implementation PenguinScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        NSLog(@"Size: %@", NSStringFromCGSize(size));
        floor_position = CGRectGetMidY(self.frame)/1.8;;
    }
    return self;
}

- (void)didMoveToView: (SKView *) view {
    if (!self.contentCreated)
    {
        self.view.userInteractionEnabled = NO;

        self.swipeDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeDown)];
        [self.swipeDownGesture setDirection: UISwipeGestureRecognizerDirectionDown];
        [view addGestureRecognizer: self.swipeDownGesture];
        
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap)];
        [view addGestureRecognizer:self.tapGesture];
        
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents {
    self.backgroundColor = [SKColor whiteColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(self.frame.origin.x, floor_position, self.frame.size.width, self.frame.size.height)];

    [self initalizingScrollingBackground];

    self.penguin = [self newPenguin];
    self.penguin.position = CGPointMake(CGRectGetMidX(self.frame)/2,floor_position);
    [self addChild:self.penguin];
    
    [self initializeStartLabel];
    
    [self.penguin runAction:[SKAction repeatActionForever:[self.penguin.userData objectForKey:@"run_action"]]];
}

#pragma mark - Background Methods

-(void)initializeStartLabel {
    SKLabelNode *startNode = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Thin"];
    
    startNode.text = @"Start!";
    startNode.fontSize = 75;
    startNode.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    startNode.color = [SKColor blueColor];
    startNode.colorBlendFactor = .75;
    [self addChild:startNode];
    
    SKAction *pause = [SKAction waitForDuration: 1.0];
    SKAction *fadeAway = [SKAction fadeOutWithDuration: 0.25];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *startSequence = [SKAction sequence:@[pause, fadeAway, remove]];
    
    [startNode runAction:startSequence completion:^ {
        self.view.userInteractionEnabled = YES;
    }];
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

#pragma mark - Penguin Methods

- (SKSpriteNode *)newPenguin {
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

    SKSpriteNode *penguin = [SKSpriteNode spriteNodeWithImageNamed:@"penguin_idle"];
    penguin.name = @"penguin";
    penguin.userData = [NSMutableDictionary dictionary];
    [penguin.userData setObject:runAnimation forKey:@"run_action"];
    [penguin.userData setObject:slideSequence forKey:@"slide_action"];
    [penguin.userData setObject:jump forKey:@"jump_action"];

    penguin.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:penguin.size.width/2];
    penguin.physicsBody.dynamic = YES;
    
    return penguin;
}

#pragma mark - Gameplay Methods

#pragma mark Gestures

-(void)didSwipeDown {
    if(self.penguin) {
        [self.penguin runAction:[self.penguin.userData objectForKey:@"slide_action"]];
    }
}

-(void)didTap {
    if(self.penguin) {
        [self.penguin runAction:[self.penguin.userData objectForKey:@"jump_action"]];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    //update time interval for background
    _dt = (_lastUpdateTime) ? (currentTime - _lastUpdateTime) : 0;
    _lastUpdateTime = currentTime;
    [self moveBg];
}

#pragma mark - dealloc 

- (void)willMoveFromView: (SKView *)view {
    [view removeGestureRecognizer:self.swipeDownGesture];
    [view removeGestureRecognizer:self.tapGesture];
}

@end






