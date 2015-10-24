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
#import "shapeBenchmark.h"

@interface _1NumbersDemo() {
	SKSpriteNode* indicator;
	SKNode* currentSelectedNode;
	
	SKUPushButton* testButton;
}

@end


@implementation _1NumbersDemo

-(void)didMoveToView:(SKView *)view {
	
//	shapeBenchmark* shapeTestScene = [shapeBenchmark sceneWithSize:self.size];
//	shapeTestScene.scaleMode = self.scaleMode;
//	[self.view presentScene:shapeTestScene];
	
//	SKUSharedUtilities.macButtonFlags = kSKUMouseButtonFlagLeft | kSKUMouseButtonFlagRight | kSKUMouseButtonFlagOther;
	
	NSLog(@"01NumbersDemo: demos number interpolation, random numbers, and distance functions");
	
//	self.view.window.acceptsMouseMovedEvents = YES;
	
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

-(void)testButtonDown:(SKUButton*)button {
}

-(void)testButtonUp:(SKUButton*)button {
	SKUButton* but2 = (SKUButton*)[self childNodeWithName:@"buttonTwo"];
	if (but2.isEnabled) {
		[but2 disableButton];
	} else {
		[but2 enableButton];
	}
}

-(void)buttonTwoUp:(SKUButton*)button {
	if (testButton.isEnabled) {
		[testButton disableButton];
	} else {
		[testButton enableButton];
	}
}


-(void)setupButton {
	
	SKLabelNode* logLabel = [SKLabelNode labelNodeWithText:@"Look in the console in Xcode to see some demo functions"];
	logLabel.fontColor = [SKColor whiteColor];
	logLabel.position = midPointOfRect(self.frame);
	[self addChild:logLabel];
	

	
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
	
	SKTexture* ship = [SKTexture textureWithImageNamed:@"Spaceship"];
	SKTexture* shipSmall = [SKTexture textureWithImageNamed:@"Spaceship_small"];
	SKTexture* shipSmallBlur = [SKTexture textureWithImageNamed:@"Spaceship_sm_bl"];
	
	SKUButtonSpriteStateProperties* backgroundDefState = [SKUButtonSpriteStateProperties propertiesWithTexture:ship andAlpha:1.0];
	SKUButtonSpriteStateProperties* backgroundPresState = [SKUButtonSpriteStateProperties propertiesWithTexture:ship andAlpha:1.0 andColor:[SKColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0] andColorBlendFactor:1.0];
	SKUButtonSpriteStateProperties* backgroundDisState = [SKUButtonSpriteStateProperties propertiesWithTexture:ship andAlpha:0.2 andColor:[SKColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0] andColorBlendFactor:0.5];
	
	SKUButtonSpriteStatePropertiesPackage* backgroundPackage = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:backgroundDefState andPressedState:backgroundPresState andDisabledState:backgroundDisState];
	
	SKUButtonLabelProperties* labelPropsDef = [SKUButtonLabelProperties propertiesWithText:@"Button" andColor:[SKColor whiteColor] andSize:50.0 andFontName:@"Helvetica Neue UltraLight"];
	SKUButtonLabelProperties* labelPropsPres = [SKUButtonLabelProperties propertiesWithText:@"ButtonPressed" andColor:[SKColor redColor] andSize:45.0 andFontName:@"Arial"];
	SKUButtonLabelProperties* labelPropsDis = [SKUButtonLabelProperties propertiesWithText:@"ButtonDisabled" andColor:[SKColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0] andSize:45.0 andFontName:@"Arial"];
	
	SKUButtonLabelPropertiesPackage* labelPack = [SKUButtonLabelPropertiesPackage packageWithPropertiesForDefaultState:labelPropsDef andPressedState:labelPropsPres andDisabledState:labelPropsDis];
	
	SKUButtonSpriteStateProperties* foregroundDefState = [SKUButtonSpriteStateProperties propertiesWithTexture:shipSmall andAlpha:1.0];
	SKUButtonSpriteStateProperties* foregroundPresState = [SKUButtonSpriteStateProperties propertiesWithTexture:shipSmall andAlpha:1.0 andColor:[SKColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0] andColorBlendFactor:1.0];
	SKUButtonSpriteStateProperties* foregroundDisState = [SKUButtonSpriteStateProperties propertiesWithTexture:shipSmallBlur andAlpha:1.0 andColor:[SKColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0] andColorBlendFactor:0.5];
	
	SKUButtonSpriteStatePropertiesPackage* foregroundPackage = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:foregroundDefState andPressedState:foregroundPresState andDisabledState:foregroundDisState];
	
	testButton = [SKUPushButton pushButtonWithBackgroundPropertiesPackage:backgroundPackage andForeGroundSpritePropertiesPackage:foregroundPackage andTitleLabelPropertiesPackage:labelPack];
	testButton.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(0.25, 0.65));
	[testButton setDownAction:@selector(testButtonDown:) toPerformOnTarget:self];
	[testButton setUpAction:@selector(testButtonUp:) toPerformOnTarget:self];
	testButton.anchorPoint = CGPointMake(1.0, 1.0);
	testButton.zPosition = 0.2;
	
	[self addChild:testButton];
	
	SKUButtonSpriteStateProperties* defaultProps = [SKUButtonSpriteStateProperties propertiesWithTexture:shipSmall andAlpha:1.0];
	SKUButtonSpriteStateProperties* pressedProperties = [SKUButtonSpriteStateProperties propertiesWithTexture:shipSmallBlur andAlpha:1.0 andColor:[SKColor greenColor] andColorBlendFactor:0.5];
	SKUButtonSpriteStateProperties* disabledProperties = [SKUButtonSpriteStateProperties propertiesWithTexture:shipSmall andAlpha:0.25];
	SKUButtonSpriteStatePropertiesPackage* basePackage = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:defaultProps andPressedState:pressedProperties andDisabledState:disabledProperties];
	
//	SKULog(0, @"basePackage: %@", basePackage);
	
	
	SKUButton* buttonTwo = [SKUButton buttonWithPropertiesPackage:basePackage];
	buttonTwo.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(0.75, 0.65));
	[buttonTwo setUpAction:@selector(buttonTwoUp:) toPerformOnTarget:self];
	buttonTwo.name = @"buttonTwo";
	[self addChild:buttonTwo];
	

	
	NSLog(@"buttonType: %i", testButton.buttonType);
	
#if TARGET_OS_TV
	
	[self addNodeToNavNodesSKU:testButton];
	[self addNodeToNavNodesSKU:buttonTwo];
	
	[self addNodeToNavNodesSKU:tempButton];
	
	SKSpriteNode* otherButton = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(200, 50)];
	otherButton.position = pointAdd(CGPointMake(0, 100.0), tempButton.position);
	[self addChild:otherButton];
	[self addNodeToNavNodesSKU:otherButton];
	
	indicator = [SKSpriteNode spriteNodeWithColor:[SKColor greenColor] size:CGSizeMake(10, 10)];
	indicator.zPosition = 20.0;
	[self addChild:indicator];
	
	[self setCurrentSelectedNodeSKU:tempButton];
	
	[SKUSharedUtilities setNavFocus:self];
	

#endif

}

-(void)currentSelectedNodeUpdatedSKU:(SKNode *)node {
	indicator.position = node.position;
	currentSelectedNode = node;
	SKUButton* testButton = (SKUButton*)[self childNodeWithName:@"buttonTwo"];
//	SKULog(0, @"button: %@", testButton);
}

-(void)absoluteInputMovedSKU:(CGPoint)location withEventDictionary:(NSDictionary *)eventDict {
	NSArray* nodes = [self nodesAtPoint:location];
	for (SKNode* node in nodes) {
		if ([node.name isEqualToString:@"tempButton"]) {
			//next scene
			[self transferScene];
			break;
		}
	}
	[super absoluteInputMovedSKU:location withEventDictionary:eventDict];
}

-(void)inputEndedSKU:(CGPoint)location withEventDictionary:(NSDictionary *)eventDict {

}

-(void)mouseMovedSKU:(CGPoint)location withEventDictionary:(NSDictionary*)eventDict {
//	SKULog(0, @"adsf");
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
