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
	return orientToFromRightFace(facing, from) - (90 * kSKUDegToRadConvFactor);
}

CGFloat orientToFromLeftFace (CGPoint facing, CGPoint from) {
	return orientToFromRightFace(facing, from) - (180 * kSKUDegToRadConvFactor);
}

CGFloat orientToFromDownFace (CGPoint facing, CGPoint from) {
	return orientToFromRightFace(facing, from) + (90 * kSKUDegToRadConvFactor);
}

#pragma mark CGVector HELPERS

CGVector vectorFromCGPoint (CGPoint point) {
	return CGVectorMake(point.x, point.y);
}

CGVector vectorFromCGSize (CGSize size) {
	return CGVectorMake(size.width, size.height);
}

CGVector vectorInverse (CGVector vector) {
	return CGVectorMake(-vector.dx, -vector.dy);
}

CGVector vectorNormalize (CGVector vector) {
	CGFloat distance = sqrt(vector.dx * vector.dx + vector.dy * vector.dy);
	return CGVectorMake(vector.dx / distance, vector.dy / distance);
}

CGVector vectorAdd (CGVector vectorA, CGVector vectorB) {
	return CGVectorMake(vectorA.dx + vectorB.dx, vectorA.dy + vectorB.dy);
}

CGVector vectorMultiplyByVector (CGVector vectorA, CGVector vectorB) {
	return CGVectorMake(vectorA.dx * vectorB.dx, vectorA.dy * vectorB.dy);
}

CGVector vectorMultiplyByFactor (CGVector vector, CGFloat factor) {
	return CGVectorMake(vector.dx * factor, vector.dy * factor);
}

CGVector vectorFacingPoint (CGPoint destination, CGPoint origin, bool normalize) { //test more carefully
	CGVector destVect = vectorFromCGPoint(destination);
	CGVector origVect = vectorFromCGPoint(origin);
	CGVector directionVect = vectorAdd(vectorInverse(origVect), destVect);
	if (normalize) directionVect = vectorNormalize(directionVect);
	return directionVect;
}

CGVector vectorFromRadian (CGFloat radianAngle) {
	return CGVectorMake(-sinf(radianAngle),cosf(radianAngle));
}

CGVector vectorFromDegree (CGFloat degreeAngle) {
	CGFloat radian = degreeAngle * kSKUDegToRadConvFactor;
	return vectorFromRadian(radian);
}

#pragma mark CGPoint HELPERS

CGPoint pointFromCGVector (CGVector vector) {
	return CGPointMake(vector.dx, vector.dy);
}

CGPoint pointFromCGSize (CGSize size) {
	return CGPointMake(size.width, size.height);
}

CGPoint pointInverse (CGPoint point) {
	return CGPointMake(-point.x, -point.y);
}

CGPoint pointAdd (CGPoint pointA, CGPoint pointB) {
	return CGPointMake(pointA.x + pointB.x, pointA.y + pointB.y);
}

CGPoint pointAddValue (CGPoint point, CGFloat value) {
	return CGPointMake(point.x + value, point.y + value);
}

CGPoint pointStepVectorFromPointWithInterval (CGPoint origin, CGVector normalVector, CFTimeInterval interval, CFTimeInterval maxInterval, CGFloat speed, CGFloat speedModifiers) {
	
	if (interval == 0) {
		NSLog(@"Please provide a time interval to calculate how far your node has moved in the time alotted. Assuming interval of 0.016666666666666666");
		interval = 0.016666666666666666;
	}
	if (maxInterval <= 0) {
		maxInterval = 0.05;
	}
	if (interval > maxInterval) {
		interval = maxInterval;
	}
	
	CGFloat adjustedSpeed = speed * speedModifiers * interval;
	CGPoint destination = CGPointMake(origin.x + normalVector.dx * adjustedSpeed,
									  origin.y + normalVector.dy * adjustedSpeed);
	return destination;
}

CGPoint pointStepVectorFromPoint (CGPoint origin, CGVector normalVector, CGFloat distance) {
	CGVector vector = vectorMultiplyByFactor(normalVector, distance);
	return CGPointMake(vector.dx + origin.x, vector.dy + origin.y);
}

CGPoint pointStepTowardsPointWithInterval (CGPoint origin, CGPoint destination, CFTimeInterval interval, CFTimeInterval maxInterval, CGFloat speed, CGFloat speedModifiers) {
	if (interval == 0) {
		NSLog(@"Please provide a time interval to calculate how far your node has moved in the time alotted. Assuming interval of 0.016666666666666666");
		interval = 0.016666666666666666;
	}
	if (maxInterval <= 0) {
		maxInterval = 0.05;
	}
	if (interval > maxInterval) {
		interval = maxInterval;
	}
	
	CGFloat adjustedSpeed = speed * speedModifiers * interval;
	
	CGVector vectorBetweenPoints = vectorFacingPoint(destination, origin, YES);
	
	CGPoint newDestination = CGPointMake(origin.x + vectorBetweenPoints.dx * adjustedSpeed,
										 origin.y + vectorBetweenPoints.dy * adjustedSpeed);
	return newDestination;
}

CGPoint pointInterpolationLinearBetweenTwoPoints (CGPoint pointA, CGPoint pointB, CGFloat factorBetween) {
	return CGPointMake(pointA.x + (pointB.x-pointA.x)*factorBetween, pointA.y + (pointB.y-pointA.y)*factorBetween);
}

CGPoint midPointOfRect (CGRect rect) {
	CGPoint rPoint = CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0);
	rPoint = CGPointMake(rect.origin.x + rPoint.x, rect.origin.y + rPoint.y);
	return rPoint;
}

CGPoint midPointOfSize (CGSize size) {
	return midPointOfRect(CGRectMake(0.0, 0.0, size.width, size.height));
}


bool pointIsBehindVictim (CGPoint origin, CGPoint victim, CGVector normalVictimFacingVector, CGFloat latitude) {

	CGVector normalOriginFacingVector = vectorFacingPoint(origin, victim, YES);
	
	//calculate dotProduct
	//values > 0 means murderer is infront of victim, value == 0 means murderer is DIRECTLY beside victim (left OR right), value < 0 means murderer is behind victim, -1 is EXACTLY DIRECTLY behind victim. Range of -1 to 1;
	//see http://www.youtube.com/watch?v=Q9FZllr6-wY for more info
	
	CGFloat dotProduct = normalOriginFacingVector.dx * normalVictimFacingVector.dx + normalOriginFacingVector.dy * normalVictimFacingVector.dy;
	
	//check if angles match up
	if (dotProduct < -latitude) {
		return YES; //angles match
	} else {
		return NO; //angles dont match
	}
}




#pragma mark COORDINATE CONVERSIONS






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
