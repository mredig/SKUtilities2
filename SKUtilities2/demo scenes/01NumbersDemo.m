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
	
	SKUToggleButton* toggle;
	
}

@end


@implementation _1NumbersDemo

-(void)didMoveToView:(SKView *)view {
	[self setupButtonPackages];
	
	NSInteger verbosityLevelRequired = 0;
	self.name = @"numbersScene";

#if TARGET_OS_OSX_SKU
	SKUSharedUtilities.macButtonFlags = kSKUMouseButtonFlagLeft | kSKUMouseButtonFlagRight | kSKUMouseButtonFlagOther;
	self.view.window.acceptsMouseMovedEvents = YES;
#endif
//	SKUSharedUtilities.verbosityLevel = 100; // change this value to 100 to see scene deallocation, 150 to see node deallocation.
	SKULog(verbosityLevelRequired, @"01NumbersDemo: demos number interpolation, random numbers, and distance functions");
	
	
#pragma mark NUMBER INTERPOLATION

	CGFloat floatA = 50.0;
	CGFloat floatB = 104.0;
	SKULog(verbosityLevelRequired, @"interpolate: %f", linearInterpolationBetweenFloatValues(floatA, floatB, 0.25, NO));
	SKULog(verbosityLevelRequired, @"reverseInterp: %f", reverseLinearInterpolationBetweenFloatValues(floatA, floatB, 63.5, NO));

	CGFloat start = 0.0, end = 1.0;
	while (start < end) {
		start = rampToValue(end, start, 0.1);
		SKULog(verbosityLevelRequired, @"ramping to %f - currently %f", end, start);
	}
	
#pragma mark RANDOM NUMBERS
	u_int32_t lowUInt = 100;
	u_int32_t highUInt = 1000;
	SKULog(verbosityLevelRequired, @"random number between %u and %u: %u", lowUInt, highUInt, randomUnsignedIntegerBetweenTwoValues(lowUInt, highUInt));
	
	SKULog(verbosityLevelRequired, @"random float value: %f", randomFloatBetweenZeroAndHighend(102.8));

#pragma mark DISTANCE FUNCTIONS
	
	CGPoint pointA = CGPointMake(5.0, 2.5);
	CGPoint pointB = CGPointMake(10.0, 5.0);

	SKULog(verbosityLevelRequired, @"distance between: %f", distanceBetween(pointA, pointB));
	
	CGFloat comparison = 5.0;
	SKULog(verbosityLevelRequired, @"distance is closer than %f: %i", comparison, distanceBetweenIsWithinXDistance(pointA, pointB, comparison));
	comparison = 6.0;
	SKULog(verbosityLevelRequired, @"distance is closer than %f: %i", comparison, distanceBetweenIsWithinXDistancePreSquared(pointA, pointB, comparison * comparison));

	
	
	SKLabelNode* logLabel = [SKLabelNode labelNodeWithText:@"Look in the console in Xcode to see some demo functions"];
	logLabel.fontColor = [SKColor whiteColor];
	logLabel.position = midPointOfRect(self.frame);
	logLabel.name = @"logLabel";
	[self addChild:logLabel];
	
	[self setupButton];
	
}

-(void)setupButton {
	SKUButtonLabelPropertiesPackage* labelPack = SKUSharedUtilities.userData[@"buttonLabelPackage"];
	SKUButtonSpriteStatePropertiesPackage* backgroundPack = SKUSharedUtilities.userData[@"buttonBackgroundPackage"];
	SKUPushButton* nextSlide = [SKUPushButton pushButtonWithBackgroundPropertiesPackage:backgroundPack andTitleLabelPropertiesPackage:labelPack];
	nextSlide.position = pointMultiplyByPoint(midPointOfRect(self.frame), CGPointMake(1.0, 0.5));
	nextSlide.zPosition = 1.0;
	[nextSlide setUpAction:@selector(transferScene:) toPerformOnTarget:self];
	nextSlide.name = @"nextSlide";
	[self addChild:nextSlide];
	
	
#if TARGET_OS_TV

	[self addNodeToNavNodesSKU:nextSlide];
	[self setCurrentSelectedNodeSKU:nextSlide];
	
	[SKUSharedUtilities setNavFocus:self];
	
#endif
}

-(void)setupButtonPackages {
	SKUSharedUtilities.userData = [NSMutableDictionary dictionary];
	
	SKTexture* buttonBG = [SKTexture textureWithImageNamed:@"buttonBG_SKU"];

	SKUButtonSpriteStateProperties* backgroundProps = [SKUButtonSpriteStateProperties
												  propertiesWithTexture:buttonBG
												  andAlpha:1.0f
												  andColor:nil
												  andColorBlendFactor:0.0f
												  andPositionOffset:CGPointMake(0, 0)
												  andXScale:1.0f
												  andYScale:1.0f
												  andCenterRect:CGRectMake(40.0/buttonBG.size.width, 50.0/buttonBG.size.height, 40.0/buttonBG.size.width, 40.0/buttonBG.size.height)];
	
	SKUButtonSpriteStatePropertiesPackage* backgroundPackage = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:backgroundProps];
	
	SKUButtonLabelProperties* labelProps = [SKUButtonLabelProperties
											propertiesWithText:@"Next Scene"
											andColor:[SKColor blackColor]
											andSize:28
											andFontName:@"Helvetica Neue UltraLight"];
	
	SKUButtonLabelPropertiesPackage* labelPackage = [SKUButtonLabelPropertiesPackage packageWithPropertiesForDefaultState:labelProps];
	
	[SKUSharedUtilities.userData setObject:backgroundPackage forKey:@"buttonBackgroundPackage"];
	[SKUSharedUtilities.userData setObject:labelPackage forKey:@"buttonLabelPackage"];
	
}


-(void)mouseMovedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary *)eventDict {
	// you can do mouse location things here - this is OSX only
	// this will only be called if you do
	//	 self.view.window.acceptsMouseMovedEvents = YES;
	// this also activates SKUButton hovering on OSX
	// note that this setting will persist regardless of scene change
}



-(void)transferScene:(SKUButton*)button {
	
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
	SKULog(0, @"time elapsed: %f", end - start);

}

-(void)update:(CFTimeInterval)currentTime {
	/* Called before each frame is rendered */
}

@end
