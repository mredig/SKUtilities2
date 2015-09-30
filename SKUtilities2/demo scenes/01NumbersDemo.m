//
//  01NumbersDemo.m
//  SKUtilities2
//
//  Created by Michael Redig on 9/26/15.
//  Copyright (c) 2015 Michael Redig. All rights reserved.
//

#import "01NumbersDemo.h"
#import "SKUtilities2.h"
#import "02rotationScene.h"

@interface _1NumbersDemo() {
	SKUtilities2* sharedUtilities;
	SKSpriteNode* indicator;
}

@end


@implementation _1NumbersDemo

-(void)didMoveToView:(SKView *)view {
	
	sharedUtilities = [SKUtilities2 sharedUtilities];
	
	NSLog(@"01NumbersDemo: demos number interpolation, random numbers, and distance functions");
	
#pragma mark NUMBER INTERPOLATION

	CGFloat floatA = 50.0;
	CGFloat floatB = 104.0;
	NSLog(@"interpolate: %f", linearInterpolationBetweenFloatValues(floatA, floatB, 0.25, NO));
	NSLog(@"reverseInterp: %f", reverseLinearInterpolationBetweenFloatValues(floatA, floatB, 63.5, NO));
	
	CGFloat start = 0.0, end = 1.0;
	while (start < end) {
		start = rampToValue(end, start, 0.1);
		NSLog(@"ramping to %f - currently %f", end, start);
	}
	
#pragma mark RANDOM NUMBERS
	u_int32_t lowUInt = 100;
	u_int32_t highUInt = 1000;
	NSLog(@"random number between %u and %u: %u", lowUInt, highUInt, randomUnsignedIntegerBetweenTwoValues(lowUInt, highUInt));
	
	NSLog(@"random float value: %f", randomFloatBetweenZeroAndHighend(102.8));

#pragma mark DISTANCE FUNCTIONS
	
	CGPoint pointA = CGPointMake(5.0, 2.5);
	CGPoint pointB = CGPointMake(10.0, 5.0);

	NSLog(@"distance between: %f", distanceBetween(pointA, pointB));
	
	CGFloat comparison = 5.0;
	NSLog(@"distance is closer than %f: %i", comparison, distanceBetweenIsWithinXDistance(pointA, pointB, comparison));
	comparison = 6.0;
	NSLog(@"distance is closer than %f: %i", comparison, distanceBetweenIsWithinXDistancePreSquared(pointA, pointB, comparison * comparison));

	

	[self setupButton];
	
}

-(void)setupButton {
	
	SKNode* tempButton = [SKNode node];
	tempButton.position = midPointOfRect(self.frame);
	tempButton.position = CGPointMake(tempButton.position.x, tempButton.position.y * 0.5);
	tempButton.zPosition = 1.0;
	tempButton.name = @"tempButton";
	[self addChild:tempButton];
	
	SKSpriteNode* buttonBG = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:CGSizeMake(200, 50)];
	[tempButton addChild:buttonBG];
	
	SKLabelNode* buttonLabel = [SKLabelNode labelNodeWithText:@"Next Scene"];
	buttonLabel.fontColor = [SKColor blackColor];
	buttonLabel.fontSize = 28;
	buttonLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
	buttonLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
	buttonLabel.zPosition = 1.0;
	[tempButton addChild:buttonLabel];
	
	[self addNodeToNavNodes:tempButton];
	
	SKSpriteNode* otherButton = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(200, 50)];
	otherButton.position = pointAdd(CGPointMake(0, 100.0), tempButton.position);
	[self addChild:otherButton];
	[self addNodeToNavNodes:otherButton];
	
	indicator = [SKSpriteNode spriteNodeWithColor:[SKColor greenColor] size:CGSizeMake(10, 10)];
	indicator.zPosition = 20.0;
	[self addChild:indicator];
	
	[self setCurrentSelectedNode:tempButton];
	
	[[SKUtilities2 sharedUtilities] setNavFocus:self];
	
}

-(void)currentSelectedNodeUpdated:(SKNode *)node {
	indicator.position = node.position;
}

-(void)inputEnded:(CGPoint)location withEventDictionary:(NSDictionary *)eventDict {

	NSArray* nodes = [self nodesAtPoint:location];
	for (SKNode* node in nodes) {
		if ([node.name isEqualToString:@"tempButton"]) {
			//next scene
			[self transferScene];
			break;
		}
	}
}



-(void)transferScene {
	
	_2rotationScene* scene = [[_2rotationScene alloc] initWithSize:self.size];
	scene.scaleMode = self.scaleMode;
	
	SKView* view = (SKView*)self.view;
	[view presentScene:scene];
	
}

-(void)distanceBenchmark {
	CGPoint pointA = CGPointMake(50.0, -20.5);
	CGPoint pointB = CGPointMake(-100.0, 50.0);
	
	NSTimeInterval start = CFAbsoluteTimeGetCurrent();
	
	u_int32_t iters = 10000;
	
	for (u_int32_t i = 0; i < iters; i++) {
		distanceBetween(pointA, pointB);
	}
	
	NSTimeInterval end = CFAbsoluteTimeGetCurrent();
	NSLog(@"time elapsed: %f", end - start);

}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
