//
//  SKUtilities2.m
//  SKUtilities2
//
//  Created by Michael Redig on 9/26/15.
//  Copyright © 2015 Michael Redig. All rights reserved.
//

#import "SKUtilities2.h"

#pragma mark CONSTANTS


#pragma mark NUMBER INTERPOLATION

CGFloat linearInterpolationBetweenFloatValues (CGFloat valueA, CGFloat valueB, CGFloat pointBetween, bool clipped ) {
	
	if (clipped) {
		pointBetween = MAX(0.0, pointBetween);
		pointBetween = MIN(1.0, pointBetween);
	}
	return valueA + (valueB - valueA)* pointBetween;
}

CGFloat reverseLinearInterpolationBetweenFloatValues (CGFloat valueA, CGFloat valueB, CGFloat valueBetween, bool clipped) {
	
	CGFloat diff = valueBetween - valueA;
	CGFloat xFactor = 1.0 / (valueB - valueA);
	CGFloat rFloat = diff * xFactor;
	
	if (clipped) {
		rFloat = MAX(0.0, rFloat);
		rFloat = MIN(1.0, rFloat);
	}
	
	return rFloat;
}

#pragma mark RANDOM NUMBERS

u_int32_t randomUnsignedIntegerBetweenTwoValues (u_int32_t lowend, u_int32_t highend) {
	u_int32_t range = highend - lowend;
	u_int32_t random = arc4random_uniform(range);
	return random + lowend;
}

CGFloat randomFloatBetweenZeroAndHighend (CGFloat highend) {
	
	CGFloat divFactor = 1000000.0f;
	//2,147,483,647
	if (highend > 99999999 ) {
		divFactor = 10.0f;
	} else if (highend > 9999999 ) {
		divFactor = 100.0f;
	} else if (highend > 999999 ) {
		divFactor = 1000.0f;
	} else if (highend > 99999 ) {
		divFactor = 10000.0f;
	} else if (highend > 9999 ) {
		divFactor = 100000.0f;
	} else if (highend > 999 ) {
		divFactor = 1000000.0f;
	} else {
		divFactor = 10000000.0f;
	}
	
	CGFloat floatRange = highend * (divFactor);
	u_int32_t intRange = floatRange;
	u_int32_t random = arc4random_uniform(intRange);
	CGFloat floatRandom = (CGFloat)random / divFactor;
	
	return floatRandom;
}

#pragma mark DISTANCE FUNCTIONS

CGFloat distanceBetween (CGPoint pointA, CGPoint pointB) {
	return sqrt((pointB.x - pointA.x) * (pointB.x - pointA.x) + (pointB.y - pointA.y) * (pointB.y - pointA.y)); //fastest - see the old SKUtilities to see less efficient versions
}

bool distanceBetweenIsWithinXDistance (CGPoint pointA, CGPoint pointB, CGFloat xDistance) {
	CGFloat deltaX = pointA.x - pointB.x;
	CGFloat deltaY = pointA.y - pointB.y;
	
	return (deltaX * deltaX) + (deltaY * deltaY) <= xDistance * xDistance;
}

bool distanceBetweenIsWithinXDistancePreSquared (CGPoint pointA, CGPoint pointB, CGFloat xDistanceSquared) {
	CGFloat deltaX = pointA.x - pointB.x;
	CGFloat deltaY = pointA.y - pointB.y;
	
	return (deltaX * deltaX) + (deltaY * deltaY) <= xDistanceSquared;
}

#pragma mark ORIENTATION

CGFloat orientToFromRightFace (CGPoint facing, CGPoint from) {
	CGFloat deltaX = facing.x - from.x;
	CGFloat deltaY = facing.y - from.y;
	return atan2f(deltaY, deltaX);
}

CGFloat orientToFromUpFace (CGPoint facing, CGPoint from) {
	CGFloat deltaX = facing.x - from.x;
	CGFloat deltaY = facing.y - from.y;
	return atan2f(deltaY, deltaX) - (90 * kSKUDegToRadConvFactor);
}

CGFloat orientToFromLeftFace (CGPoint facing, CGPoint from) {
	CGFloat deltaX = facing.x - from.x;
	CGFloat deltaY = facing.y - from.y;
	return atan2f(deltaY, deltaX) - (180 * kSKUDegToRadConvFactor);
}

CGFloat orientToFromDownFace (CGPoint facing, CGPoint from) {
	CGFloat deltaX = facing.x - from.x;
	CGFloat deltaY = facing.y - from.y;
	return atan2f(deltaY, deltaX) + (90 * kSKUDegToRadConvFactor);
}





#pragma mark CGVector HELPERS

#pragma mark CGPoint HELPERS

CGPoint midPointOfRect (CGRect rect) {
	CGPoint rPoint = CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0);
	rPoint = CGPointMake(rect.origin.x + rPoint.x, rect.origin.y + rPoint.y);
	return rPoint;
}

CGPoint midPointOfSize (CGSize size) {
	return midPointOfRect(CGRectMake(0.0, 0.0, size.width, size.height));
}

#pragma mark COORDINATE CONVERSIONS




CGPoint pointAdd (CGPoint pointA, CGPoint pointB) {
	return CGPointMake(pointA.x + pointB.x, pointA.y + pointB.y);
}

@implementation SKUtilities2

static SKUtilities2* sharedUtilities = Nil;

+(SKUtilities2*) sharedUtilities {
	if (sharedUtilities == nil) {
		sharedUtilities = [[SKUtilities2 alloc] init];
	}
	return sharedUtilities;
}

-(id) init {
	if (self = [super init]) {
		//		NSLog(@"initialized");
	}
	[self initialSetup];
	return self;
}

-(void)initialSetup {
	
	//	_radiansToDegreesConversionFactor = (180 / M_PI);
	//	_degreesToRadiansConversionFactor = (M_PI / 180);
	
	_deltaMaxTime = 1.0f;
}




@end
