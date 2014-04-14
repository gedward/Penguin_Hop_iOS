//
//  ViewController.m
//  Penguin Hop
//
//  Created by G Edward Gonzalez on 4/13/14.
//  Copyright (c) 2014 Gerard Edward Gonzalez. All rights reserved.
//

#import "ViewController.h"
#import "TitleScene.h"
#import "PenguinScene.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
//    SKScene *scene = [TitleScene sceneWithSize:skView.bounds.size];
    SKScene *scene = [PenguinScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    // preload textures- this is temporary as we are doing this in the title scene (but skipping the title scene for testing purposes
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"penguin_run"];
    SKTexture *p1 = [atlas textureNamed:@"penguin_run1.png"];
    SKTexture *p2 = [atlas textureNamed:@"penguin_run2.png"];
    SKTexture *p3 = [atlas textureNamed:@"penguin_run3.png"];
    NSArray *penguinRunTextures = @[p1,p2,p3];
    
    [SKTexture preloadTextures:penguinRunTextures withCompletionHandler:^ {
        
        [skView presentScene:scene];
        
    }];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
