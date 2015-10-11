//
//  GameViewController.m
//  SKUtilitiestvOSdemo
//
//  Created by Michael Redig on 9/29/15.
//  Copyright (c) 2015 Michael Redig. All rights reserved.
//

#import "GameViewController.h"
#import "01NumbersDemo.h"

@implementation GameViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	// Configure the view.
	SKView * skView = (SKView *)self.view;
	skView.showsFPS = YES;
	skView.showsNodeCount = YES;
	/* Sprite Kit applies additional optimizations to improve rendering performance */
	skView.ignoresSiblingOrder = YES;
	
	// Create and configure the scene.
	_1NumbersDemo *scene = [[_1NumbersDemo alloc] initWithSize:skView.frame.size];
	scene.scaleMode = SKSceneScaleModeAspectFill;
	
	// Present the scene.
	[skView presentScene:scene];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

@end
