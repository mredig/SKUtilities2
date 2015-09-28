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

CGFloat rampToValue (CGFloat idealValue, CGFloat currentValue, CGFloat stepValue) {
	
	//check if you're already there
	if (currentValue == idealValue) {
		return currentValue;
	}
	
	//check that step is valid
	if (stepValue < 0) {
		stepValue = -stepValue;
	} else if (stepValue == 0) {
		NSLog(@"uh, you need to assign a step value for a ramp to work!");
	}
	
	//apply the step
	CGFloat newValue;
	if (currentValue < idealValue) {
		newValue = currentValue + stepValue;
	} else if (currentValue > idealValue) {
		newValue = currentValue - stepValue;
	} else {
		newValue = idealValue;
	}
	
	//check if you are at your target value
	if (fabs(newValue - idealValue) < stepValue) {
		newValue = idealValue;
	}
	return newValue;
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




#pragma mark COORDINATE FORMAT CONVERSIONS

CGPoint getCGPointFromString (NSString* string) {
#if TARGET_OS_IPHONE
	return CGPointFromString(string);
#else
	return NSPointFromString(string);
#endif
}

NSString* getStringFromPoint (CGPoint location) {
#if TARGET_OS_IPHONE
	return NSStringFromCGPoint(location);
#else
	return NSStringFromPoint(location);
#endif
}


#pragma mark BEZIER

//-(CGPoint)calculateBezierPoint:(CGFloat)t andPoint0:(CGPoint)p0 andPoint1:(CGPoint)p1 andPoint2:(CGPoint)p2 andPoint3:(CGPoint)p3 {
CGPoint calculateBezierPoint (CGFloat t, CGPoint point0, CGPoint point1, CGPoint point2, CGPoint point3) {

	CGFloat u = 1 - t;
	CGFloat tt = t * t;
	CGFloat uu = u * u;
	CGFloat uuu = uu * u;
	CGFloat ttt = tt * t;
	
	
	CGPoint finalPoint = CGPointMake(point0.x * uuu, point0.y * uuu);
	finalPoint = CGPointMake(finalPoint.x + (3 * uu * t * point1.x), finalPoint.y + (3 * uu * t * point1.y));
	finalPoint = CGPointMake(finalPoint.x + (3 * u * tt * point2.x), finalPoint.y + (3 * u * tt * point2.y));
	finalPoint = CGPointMake(finalPoint.x + (ttt * point3.x), finalPoint.y + (ttt * point3.y));
	
	
	return finalPoint;
}

//following algorithm sourced from this page: http://stackoverflow.com/a/17546429/2985369
//start x bezier algorithm
//
//-(NSArray*)solveQuadraticEquationWithA:(double)a andB:(double)b andC:(double)c {
//	
//	double discriminant = b * b - 4 * a * c;
//	
//	if (discriminant < 0) {
//		NSLog(@"1");
//		return nil;
//	} else {
//		double possibleA = (-b + sqrt(discriminant) / (2 * a));
//		double possibleB = (-b - sqrt(discriminant) / (2 * a));
//		NSLog(@"2");
//		return @[[NSNumber numberWithDouble:possibleA], [NSNumber numberWithDouble:possibleB]];
//	}
//}
//
//-(NSArray*)solveCubicEquationWithA:(double)a andB:(double)b andC:(double)c andD:(double)d {
//	
//	//used http://www.1728.org/cubic.htm as source for formula instead of the one included with the overall algorithm
//	
//	double f = ((3 * c / a) - ((b * b) / (a * a))) / 3;
//	double g = (((2 * b * b * b) / (a * a * a)) - ((9 * b * c) / (a * a)) + ((27 * d) / a)) / 27;
//	double h = (g * g / 4) + ((f * f * f) / 27);
//	
//	if (h == 0 && g == 0 && h == 0) {
//		//3 real roots and all equal
//		
//		double x = (d / a);
//		x = pow(x, 0.3333333333333333) * -1;
//		
//		
//		NSArray* roots = @[[NSNumber numberWithDouble:x]];
//		return roots;
//		
//	} else if (h > 0) {
//		// 1 real root
//		double R = -(g / 2) + sqrt(h);
//		double S = pow(R, 0.3333333333333333); //may need to do 0.3333333333
//		double T = -(g / 2) - sqrt(h);
//		double U;
//		if (T < 0) {
//			U = pow(-T, 0.3333333333333333);
//			U *= -1;
//		} else {
//			U = pow(T, 0.3333333333333333);
//		}
//		double x = (S + U) - (b / (3 * a));
//		
//		NSArray* roots = @[[NSNumber numberWithDouble:x]];
//		
//		
//		return roots;
//	} else if (h <= 0) {
//		//all three real
//		double i = sqrt(( (g * g) / 4) - h);
//		double j = pow(i, 0.333333333333);
//		double k = acos(-(g / (2 * i)));
//		double L = -j;
//		double M = cos(k / 3);
//		double N = (sqrt(3) * sin(k /3));
//		double P = (b / (3 * a)) * -1;
//		
//		double xOne = 2 * j * cos(k / 3) - (b / (3 * a));
//		double xTwo = L * (M + N) + P;
//		double xThree = L * (M - N) + P;
//		
//		NSArray* roots = @[[NSNumber numberWithDouble:xOne], [NSNumber numberWithDouble:xTwo], [NSNumber numberWithDouble:xThree]];
//		
//		return roots;
//	} else {
//		NSLog(@"I've made a huge mistake: Cubic equation seemingly impossible.");
//	}
//	return nil;
//}
//
//
//-(double)getBezierPercentAtXValue:(double)x withXValuesFromPoint0:(double)p0x point1:(double)p1x point2:(double)p2x andPoint3:(double)p3x {
//	
//	if (x == 0 || x == 1) {
//		return x;
//	}
//	
//	p0x -= x;
//	p1x -= x;
//	p2x -= x;
//	p3x -= x;
//	
//	double a = p3x - 3 * p2x + 3 * p1x - p0x;
//	double b = 3 * p2x - 6 * p1x + 3 * p0x;
//	double c = 3 * p1x - 3 * p0x;
//	double d = p0x;
//	
//	
//	NSArray* roots = [self solveCubicEquationWithA:a andB:b andC:c andD:d];
//	
//	
//	double closest;
//	
//	for (int i = 0; i < roots.count; i++) {
//		double root = [roots[i] doubleValue];
//		
//		if (root >= 0 && root <= 1) {
//			return root;
//		} else {
//			if (fabs(root) < 0.5) {
//				closest = 0;
//			} else {
//				closest = 1;
//			}
//		}
//	}
//	
//	
//	
//	return fabs(closest);
//}
//
////end x bezier algorithm

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
	}
	[self initialSetup];
	return self;
}

-(void)initialSetup {
	_deltaMaxTime = 1.0f;
	_deltaFrameTime = 1.0f/60.0f;
	_deltaFrameTimeUncapped = 1.0f/60.0f;
}

-(void)updateCurrentTime:(CFTimeInterval)timeUpdate {
	_deltaFrameTimeUncapped = timeUpdate - _currentTime;
	
	if (_deltaFrameTimeUncapped > _deltaMaxTime) {
		_deltaFrameTime = _deltaMaxTime;
	} else {
		_deltaFrameTime = _deltaFrameTimeUncapped;
	}
	_currentTime = timeUpdate;
}




@end
