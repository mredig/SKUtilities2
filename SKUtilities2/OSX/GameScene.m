//
//  GameScene.m
//  SKUtilities2
//
//  Created by Michael Redig on 9/26/15.
//  Copyright (c) 2015 Michael Redig. All rights reserved.
//

#import "GameScene.h"
#import "SKUtilities2.h"

@interface GameScene() {
	SKUtilities2* sharedUtilities;
}

@end


@implementation GameScene

-(void)didMoveToView:(SKView *)view {
	
	sharedUtilities = [SKUtilities2 sharedUtilities];
	
#pragma mark NUMBER INTERPOLATION

	CGFloat floatA = 50.0;
	CGFloat floatB = 104.0;
	NSLog(@"interpolate: %f", linearInterpolationBetweenFloatValues(floatA, floatB, 0.25, NO));
	NSLog(@"reverseInterp: %f", reverseLinearInterpolationBetweenFloatValues(floatA, floatB, 63.5, NO));
	
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

	
#pragma mark ORIENTATION
	
#pragma mark CGVector HELPERS
	
#pragma mark CGPoint HELPERS
	
	CGPoint pointC = pointAdd(pointA, pointB);
//	NSLog(@"newPoint: %f %f", pointC.x, pointC.y);
	
#pragma mark COORDINATE CONVERSIONS

	[self setupButton];
	
}

-(void)setupButton {
	
	SKNode* tempButton = [SKNode node];
	tempButton.position = CGPointMake(self.size.width / 2, self.size.height / 2); //// make a "midpoint of" method
	
}

-(void)mouseDown:(NSEvent *)theEvent {
	

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
