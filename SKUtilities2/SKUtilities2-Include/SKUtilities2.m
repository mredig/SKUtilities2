//
//  SKUtilities2.m
//  SKUtilities2
//
//  Created by Michael Redig on 9/26/15.
//  Copyright © 2015 Michael Redig. All rights reserved.
//

//// You can use this code to test whether an object is being retained

//	if (object) {
//		CFIndex rc = CFGetRetainCount((__bridge CFTypeRef)object);
//		SKULog(0,@"retain count: %li", rc);
//	} else {
//		SKULog(0,@"no object provided");
//	}


#import "SKUtilities2.h"

#pragma mark CONSTANTS

NSString* const kSKURemoteInteractionOn = @"remoteInteractionOn";
NSString* const kSKURemoteInteractionOff = @"remoteInteractionOff";

NSString* const kSKUNavConstantCurrentFocusedNode = @"sku_currentFocusedNode";
NSString* const kSKUNavConstantRightMouseDown = @"sku_rightMouseDown";
NSString* const kSKUNavConstantOtherMouseDown = @"sku_otherMouseDown";
NSString* const kSKUNavConstantNavNodes = @"sku_navNodes";
NSString* const kSKUNavConstantHoverArray = @"sku_hoverArray";

NSInteger const kSKUNavConstantUserDictCapacity = 5;





#pragma mark NUMBER INTERPOLATION

CGFloat linearInterpolationBetweenFloatValues (CGFloat valueA, CGFloat valueB, CGFloat pointBetween, bool clipped ) {
	CGFloat tPointBetween = pointBetween;
	if (clipped) {
		tPointBetween = clipFloatWithinRange(tPointBetween, 0.0, 1.0);
	}
	return valueA + (valueB - valueA)* tPointBetween;
}

CGFloat reverseLinearInterpolationBetweenFloatValues (CGFloat valueA, CGFloat valueB, CGFloat valueBetween, bool clipped) {
	
	CGFloat diff = valueBetween - valueA;
	CGFloat xFactor = 1.0 / (valueB - valueA);
	CGFloat rFloat = diff * xFactor;
	
	if (clipped) {
		rFloat = clipFloatWithinRange(rFloat, 0.0, 1.0);
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
		SKULog(0,@"uh, you need to assign a step value for a ramp to work!");
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

CGFloat clipFloatWithinRange (CGFloat value, CGFloat minimum, CGFloat maximum) {
	CGFloat rValue = value;
	rValue = fmin(rValue, maximum);
	rValue = fmax(rValue, minimum);
	return rValue;
}

NSInteger clipIntegerWithinRange (NSInteger value, NSInteger minimum, NSInteger maximum) {
	NSInteger rValue = value;
	rValue = MIN(rValue, maximum);
	rValue = MAX(rValue, minimum);
	return rValue;
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

BOOL vectorIsZero (CGVector vector) {
	BOOL zero = NO;
	if (vector.dx == 0.0 && vector.dy == 0.0) {
		zero = YES;
	}
	return zero;
}

CGFloat vectorDistance (CGVector vector) {
	return distanceBetween(pointFromCGVector(vector), CGPointZero);
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

CGPoint pointMultiplyByPoint (CGPoint pointA, CGPoint pointB){
	return CGPointMake(pointA.x * pointB.x, pointA.y * pointB.y);
}

CGPoint pointMultiplyByFactor (CGPoint point, CGFloat factor){
	return CGPointMake(point.x * factor, point.y * factor);
}

BOOL pointIsZero (CGPoint point) {
	BOOL zero = NO;
	if (point.x == 0.0 && point.y == 0.0) {
		zero = YES;
	}
	return zero;
}

CGPoint pointRelativeToScene (SKScene* scene, CGPoint point) {
	return pointMultiplyByPoint(pointFromCGSize(scene.size), point);
}

CGFloat processIntervals(CGFloat pInterval, CGFloat pMaxInterval) {
	
	double rInterval = pInterval;
	double rMaxInterval = pMaxInterval;
	
	if (rInterval == 0) {
		rInterval = SKUSharedUtilities.deltaFrameTime;
		if (SKUSharedUtilities.deltaFrameTime == 0) {
			rInterval = 0.016666666666666666;
			SKULog(0,@"Please either set the interval in the point step call, or properly set [SKUSharedUtilities updateCurrentTime] in your update method. Assuming interval of 0.016666666666666666.");
		}
	}
	if (rMaxInterval <= 0) {
		rMaxInterval = 0.05;
	}
	if (rInterval > rMaxInterval) {
		rInterval = rMaxInterval;
	}
	return rInterval;
}

CGPoint pointStepVectorFromPointWithInterval (CGPoint origin, CGVector normalVector, CFTimeInterval pInterval, CFTimeInterval pMaxInterval, CGFloat speed, CGFloat speedModifiers) {
	
	CGFloat interval = processIntervals(pInterval, pMaxInterval);
	
	CGFloat adjustedSpeed = speed * speedModifiers * interval;
	CGPoint destination = CGPointMake(origin.x + normalVector.dx * adjustedSpeed,
									  origin.y + normalVector.dy * adjustedSpeed);
	return destination;
}

CGPoint pointStepVectorFromPoint (CGPoint origin, CGVector normalVector, CGFloat distance) {
	CGVector vector = vectorMultiplyByFactor(normalVector, distance);
	return CGPointMake(vector.dx + origin.x, vector.dy + origin.y);
}

CGPoint pointStepTowardsPointWithInterval (CGPoint origin, CGPoint destination, CFTimeInterval pInterval, CFTimeInterval pMaxInterval, CGFloat speed, CGFloat speedModifiers) {

	CGFloat interval = processIntervals(pInterval, pMaxInterval);
	
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


#pragma mark BEZIER CALCUATIONS

CGPoint bezierPoint (CGFloat t, CGPoint point0, CGPoint point1, CGPoint point2, CGPoint point3) {

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

struct BezierStruct {
	u_int8_t c;
	double values[3];
};
typedef struct BezierStruct BezierStruct;


BezierStruct solveQuadraticEquation (double a, double b, double c) {
	
	double discriminant = b * b - 4 * a * c;

	BezierStruct rValue;
	
	if (discriminant < 0) {
		rValue.c = 0;
		rValue.values[0] = 0;
		return rValue;
	} else {
		double possibleA = (-b + sqrt(discriminant) / (2 * a));
		double possibleB = (-b - sqrt(discriminant) / (2 * a));
		
		rValue.c = 2;
		rValue.values[0] = possibleA;
		rValue.values[1] = possibleB;
		return rValue;
	}
}

BezierStruct solveCubicEquation (double a, double b, double c, double d) {
	
	BezierStruct rValue;
	
	rValue.c = 0;
	
	//used http://www.1728.org/cubic.htm as source for formula instead of the one included with the overall algorithm

	double f = ((3 * c / a) - ((b * b) / (a * a))) / 3;
	double g = (((2 * b * b * b) / (a * a * a)) - ((9 * b * c) / (a * a)) + ((27 * d) / a)) / 27;
	double h = (g * g / 4) + ((f * f * f) / 27);

	if (h == 0 && g == 0 && h == 0) {
		//3 real roots and all equal
		double x = (d / a);
		x = pow(x, 0.3333333333333333) * -1;

		rValue.c = 1;
		rValue.values[0] = x;
		return rValue;

	} else if (h > 0) {
		// 1 real root
		double R = -(g / 2) + sqrt(h);
		double S = pow(R, 0.3333333333333333); //may need to do 0.3333333333
		double T = -(g / 2) - sqrt(h);
		double U;
		if (T < 0) {
			U = pow(-T, 0.3333333333333333);
			U *= -1;
		} else {
			U = pow(T, 0.3333333333333333);
		}
		double x = (S + U) - (b / (3 * a));

		rValue.c = 1;
		rValue.values[0] = x;
		return rValue;

	} else if (h <= 0) {
		//all three real
		double i = sqrt(( (g * g) / 4) - h);
		double j = pow(i, 0.333333333333);
		double k = acos(-(g / (2 * i)));
		double L = -j;
		double M = cos(k / 3);
		double N = (sqrt(3) * sin(k /3));
		double P = (b / (3 * a)) * -1;

		double xOne = 2 * j * cos(k / 3) - (b / (3 * a));
		double xTwo = L * (M + N) + P;
		double xThree = L * (M - N) + P;

		rValue.c = 3;
		rValue.values[0] = xOne;
		rValue.values[1] = xTwo;
		rValue.values[2] = xThree;
		return rValue;

	} else {
		SKULog(0,@"I've made a huge mistake: Cubic equation seemingly impossible.");
	}
	
	return rValue;
}


double bezierTValueAtXValue (double x, double p0x, double p1x, double p2x, double p3x) {
	
	if (x == 0 || x == 1) {
		return x;
	}

	p0x -= x;
	p1x -= x;
	p2x -= x;
	p3x -= x;

	double a = p3x - 3 * p2x + 3 * p1x - p0x;
	double b = 3 * p2x - 6 * p1x + 3 * p0x;
	double c = 3 * p1x - 3 * p0x;
	double d = p0x;

	BezierStruct roots = solveCubicEquation(a, b, c, d);

	double closest = 0.0;

	for (int i = 0; i < roots.c; i++) {
		double root = roots.values[i];

		if (root >= 0 && root <= 1) {
			return root;
		} else {
			if (fabs(root) < 0.5) {
				closest = 0;
			} else {
				closest = 1;
			}
		}
	}

	return fabs(closest);
}


////end x bezier algorithm


#pragma mark Mac Cursor Handling


void hideOSCursor(BOOL hide) {
#if TARGET_OS_OSX_SKU
	if (hide) {
		[NSCursor hide];
	} else {
		[NSCursor unhide];
	}
#endif
}

void centerOSCursorInWindow() {
#if TARGET_OS_OSX_SKU

	CGDirectDisplayID displayID = CGMainDisplayID();
	CGRect bounds = CGDisplayBounds(displayID);
	CGFloat mainHeight = -bounds.size.height;
	
	NSWindow* window = [NSApplication sharedApplication].mainWindow;
	
	if (!window) {
		window = [NSApplication sharedApplication].windows[0];
	}
	
	CGPoint globalCenterPoint = midPointOfRect(window.frame);
	// invert y value
	globalCenterPoint.y += mainHeight;
	globalCenterPoint.y *= -1.0;
	
	CGWarpMouseCursorPosition(globalCenterPoint);
#endif
}


#pragma mark LOGGING

void SKULog(const NSInteger verbosityLevel, NSString* format, ...) {
#ifdef DEBUG
	if (SKUSharedUtilities.verbosityLevel < verbosityLevel) return;
	va_list args;
	va_start(args, format);
	NSLogv(format, args);
	va_end(args);
#endif
}

void SKULogBinary(uint32_t value) {
	uint32_t tValue = value;
	uint32_t one = 1;
	NSString* string = @"";
	for (uint8_t i = 1; i <= 32; i++) {
		BOOL bit = (one & tValue) == 1;
		string = [NSString stringWithFormat:@"%i%@", bit, string];
		tValue = tValue >> 1;
		if (i % 4 == 0 && i != 1) {
			string = [NSString stringWithFormat:@" %@", string];
		}
		if (i % 8 == 0 && i != 1) {
			string = [NSString stringWithFormat:@" %@", string];
		}
	}
	NSLog(@"\n%@", string);
}



#pragma mark SKUTILITES SINGLETON

@interface SKUtilities2() {
	CGPoint selectLocation;
}

@end


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
	_verbosityLevel = 0;
	_deltaMaxTime = 1.0f;
	_deltaFrameTime = 1.0f/60.0f;
	_deltaFrameTimeUncapped = 1.0f/60.0f;
	

#if TARGET_OS_OSX_SKU
	_macButtonFlags = 0;
	_macButtonFlags = _macButtonFlags | kSKUMouseButtonFlagLeft;
#endif
	_touchTracker = [NSMutableSet set];
	_navThresholdDistance = 125.0;
	selectLocation = CGPointMake(NAN, NAN);
	_navMode = kSKUNavModeOn;
	
	[self idleTimerEnable:NO];

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

-(void)idleTimerEnable:(BOOL)enableIdleTimer {
#if TARGET_OS_IPHONE
	[UIApplication sharedApplication].idleTimerDisabled = !enableIdleTimer;
#endif
}

-(void)setNavFocus:(SKNode *)navFocus {
	_navFocus = navFocus;
	[_touchTracker removeAllObjects];
	
	if ([navFocus isKindOfClass:[SKUScene class]]) {
		SKUScene* scene = (SKUScene*)navFocus;
		_gcController.view = scene.view;
	}
}

-(SKNode*)handleSubNodeMovement:(CGPoint)location withCurrentFocus:(SKNode *)currentFocusedNode inSet:(NSSet *)navNodeSet inScene:(SKScene*)scene {
	
	SKNode* rNode;
	
	if (isnan(selectLocation.x) && isnan(selectLocation.y)) {
		selectLocation = midPointOfRect(scene.frame); // might need to change to view's frame - then again, it uses the scene's coordinate system to do the calculation so probably not
	}
	
	CGFloat distance = distanceBetween(location, selectLocation);
	if (distance > _navThresholdDistance) {
		CGPoint diff = pointAdd(pointInverse(selectLocation), location);
		
		CGFloat absX, absY;
		absX = fabs(diff.x);
		absY = fabs(diff.y);
		
		if (absX > absY) { // horizontal movement
			if (diff.x > 0) {
				rNode = [self selectDirection:kSKUSwipeDirectionRight withNodes:navNodeSet fromCurrentNode:currentFocusedNode inScene:scene];
			} else {
				rNode = [self selectDirection:kSKUSwipeDirectionLeft withNodes:navNodeSet fromCurrentNode:currentFocusedNode inScene:scene];
			}
		} else { // vertical movement
			if (diff.y > 0) {
				rNode = [self selectDirection:kSKUSwipeDirectionUp withNodes:navNodeSet fromCurrentNode:currentFocusedNode inScene:scene];
			} else {
				rNode = [self selectDirection:kSKUSwipeDirectionDown withNodes:navNodeSet fromCurrentNode:currentFocusedNode inScene:scene];
			}
		}
		selectLocation = location;
	} else {
		rNode = currentFocusedNode;
	}
	
	return rNode;
	
}

-(void)resetSelectLocation {
	selectLocation = CGPointMake(NAN, NAN);
}

-(SKNode*)selectDirection:(kSKUSwipeDirections)direction withNodes:(NSSet*)pNavNodes fromCurrentNode:(SKNode*)pCurrentNode inScene:(SKScene*)scene {
	
	if (!pCurrentNode.parent) {
		return nil;
	}
	
	CGPoint focusedWorldSpace = [pCurrentNode.parent convertPoint:pCurrentNode.position toNode:scene];
	
	NSMutableSet* directionCandidates = [NSMutableSet set];
	
	for (SKNode* focusCandidate in pNavNodes) {
		CGPoint newNodeWorldSpace = [focusCandidate.parent convertPoint:focusCandidate.position toNode:scene];
		
		switch (direction) {
			case kSKUSwipeDirectionUp:
				if (newNodeWorldSpace.y > focusedWorldSpace.y) {
					[directionCandidates addObject:focusCandidate];
				}
				break;
			case kSKUSwipeDirectionDown:
				if (newNodeWorldSpace.y < focusedWorldSpace.y) {
					[directionCandidates addObject:focusCandidate];
				}
				break;
			case kSKUSwipeDirectionLeft:
				if (newNodeWorldSpace.x < focusedWorldSpace.x) {
					[directionCandidates addObject:focusCandidate];
				}
				break;
			case kSKUSwipeDirectionRight:
				if (newNodeWorldSpace.x > focusedWorldSpace.x) {
					[directionCandidates addObject:focusCandidate];
				}
				break;
			default:
				break;
		}
	}
	
	SKNode* newNode;
	CGFloat lowestDistance = MAXFLOAT;
	for (SKNode* directionCand in directionCandidates) {
		CGPoint newNodeWorldSpace = [directionCand.parent convertPoint:directionCand.position toNode:scene];
		CGFloat distance = distanceBetween(focusedWorldSpace, newNodeWorldSpace);
		if (distance < lowestDistance) {
			newNode = directionCand;
			lowestDistance = distance;
		}
	}
	return newNode;
}

-(void)gestureTapDown {
	if (_navMode == kSKUNavModeOn) {
		_navMode = kSKUNavModePressed;
		SKNode* currentFocusedNode = SKUSharedUtilities.navFocus.userData[kSKUNavConstantCurrentFocusedNode];
		if ([currentFocusedNode isKindOfClass:[SKUButton class]]) {
			[(SKUButton*)currentFocusedNode buttonPressed:CGPointZero];
		} else {
			[SKUSharedUtilities.navFocus nodePressedDownSKU:currentFocusedNode];
		}
	}
}

-(void)gestureTapUp {
	if (_navMode == kSKUNavModeOn || _navMode == kSKUNavModePressed) {
		SKNode* currentFocusedNode = SKUSharedUtilities.navFocus.userData[kSKUNavConstantCurrentFocusedNode];
		if ([currentFocusedNode isKindOfClass:[SKUButton class]]) {
			SKUButton* button = (SKUButton*)currentFocusedNode;
			switch (button.buttonType) {
				case kSKUButtonTypeSlider:
					//sliders set nav mode themselves
					[button buttonReleased:CGPointZero];
					break;
					
				default:
					_navMode = kSKUNavModeOn;
					[button buttonReleased:CGPointZero];
					break;
			}
		} else {
			_navMode = kSKUNavModeOn;
			[SKUSharedUtilities.navFocus nodePressedUpSKU:currentFocusedNode];
		}
	}
}

@end


#pragma mark SKUGCControllerController

@implementation SKUGCControllerController

-(instancetype)init {
	if (self = [super init]) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkForChangedControllerState) name:GCControllerDidConnectNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkForChangedControllerState) name:GCControllerDidDisconnectNotification object:nil];
		
		_validPlayerNav = kSKUGamePadPlayerFlag1 | kSKUGamePadPlayerFlag2 | kSKUGamePadPlayerFlag3 | kSKUGamePadPlayerFlag4;
		_playerControllers = [NSMutableArray array];
		
		_controllerStates = @[[SKUGameControllerState controllerState], [SKUGameControllerState controllerState], [SKUGameControllerState controllerState], [SKUGameControllerState controllerState], [SKUGameControllerState controllerState]];
	}
	return self;
}
#pragma mark gamepad setups

-(void)checkForChangedControllerState {
	
	BOOL controllerConnected;
	
	NSArray* controllers = [GCController controllers];
	if (controllers.count > 0) {
		controllerConnected = YES;
	} else {
		controllerConnected = NO;
	}
	
	SKULog(100, @"controllers connected: %i", controllerConnected);
	SKULog(100, @"controllers: %@", controllers);
	
	for (int i = 0; i < SKUSharedUtilities.gcController.playerControllers.count; i++) {
		GCController* controller = SKUSharedUtilities.gcController.playerControllers[i];
		if (![controllers containsObject:controller] || !controller) {
			[SKUSharedUtilities.gcController.playerControllers removeObject:controller];
		}
	}
	
	[self assignControllerInputsWithControllersArray:controllers];
}

-(void)assignControllerInputsWithControllersArray:(NSArray*)controllers {
	
	for (int i = 0; i < controllers.count; i++) {
		GCController* controller = controllers[i];
		
#if TARGET_OS_TV
		if (controller.microGamepad) {
			SKULog(100, @"at least micro gamepad: %@", controller.vendorName);
			GCMicroGamepad* microPadProfile = controller.microGamepad;
			[self registerMicroGamepadButtonsOnController:(GCGamepad*)microPadProfile];
		}
#endif
		if (controller.extendedGamepad) {
			SKULog(100, @"extended gamepad: %@", controller.vendorName);
			GCExtendedGamepad* extendedPadProfile = controller.extendedGamepad;
			[self registerGamepadButtonsOnController:(GCGamepad*)extendedPadProfile];
			[self registerExtendedGamepadButtonsOnController:extendedPadProfile];
			
		} else if (controller.gamepad) {
			SKULog(100, @"gamepad: %@", controller.vendorName);
			GCGamepad* padProfile = controller.gamepad;
			[self registerGamepadButtonsOnController:padProfile];
		}
		if (controller.motion) {
			SKULog(100, @"motion supported: %@", controller.vendorName);
			GCMotion* motionProfile = controller.motion;
			motionProfile.valueChangedHandler = ^(GCMotion* motionGamepad) {
				SKUAcceleration accel;
				accel.x = motionGamepad.gravity.x;
				accel.y = motionGamepad.gravity.y;
				accel.z = motionGamepad.gravity.z;
				NSDictionary* theDict = [NSDictionary dictionaryWithObject:motionGamepad forKey:@"gamepadProfile"];
				[SKUSharedUtilities.gcController.view gamepadMotionInputChangedForPlayer:motionGamepad.controller.playerIndex withAcceleration:accel andEventDictionary:theDict];
			};
		}
	}
	[self setControllerPlayerIndices];
}

-(void)setControllerPlayerIndices {
	for (GCController* controller in [GCController controllers]) {
		if (![SKUSharedUtilities.gcController.playerControllers containsObject:controller]) {
			[SKUSharedUtilities.gcController.playerControllers addObject:controller];
		}
	}
	
	for (int i = 0; i < SKUSharedUtilities.gcController.playerControllers.count; i++) {
		GCController* controller = SKUSharedUtilities.gcController.playerControllers[i];
		switch (i) {
			case 0:
				controller.playerIndex = GCControllerPlayerIndex1;
				break;
			case 1:
				controller.playerIndex = GCControllerPlayerIndex2;
				break;
			case 2:
				controller.playerIndex = GCControllerPlayerIndex3;
				break;
			case 3:
				controller.playerIndex = GCControllerPlayerIndex4;
				break;
				
			default:
				controller.playerIndex = GCControllerPlayerIndexUnset;
				break;
		}
	}
	
}


-(void)registerMicroGamepadButtonsOnController:(GCGamepad*)microGamepad {
	
	microGamepad.buttonA.valueChangedHandler = ^(GCControllerButtonInput* button, float value, BOOL pressed) {
		NSDictionary* eventDict = [NSDictionary dictionaryWithObjects:@[button, microGamepad.controller] forKeys:@[@"button", @"controller"]];
		[self gamepadInputChangedInternalForPlayer:microGamepad.controller.playerIndex withInput:kSKUGamePadInputButtonA andXValue:value andYValue:value isPressed:pressed andEventDictionary:eventDict];
	};
	
	microGamepad.buttonX.valueChangedHandler = ^(GCControllerButtonInput* button, float value, BOOL pressed) {
		NSDictionary* eventDict = [NSDictionary dictionaryWithObjects:@[button, microGamepad.controller] forKeys:@[@"button", @"controller"]];
		[self gamepadInputChangedInternalForPlayer:microGamepad.controller.playerIndex withInput:kSKUGamePadInputButtonX andXValue:value andYValue:value isPressed:pressed andEventDictionary:eventDict];
	};
	
	//axes
	microGamepad.dpad.valueChangedHandler = ^(GCControllerDirectionPad* dpad, float xValue, float yValue) {
		NSDictionary* eventDict = [NSDictionary dictionaryWithObjects:@[dpad, microGamepad.controller] forKeys:@[@"button", @"controller"]];
		[self gamepadInputChangedInternalForPlayer:microGamepad.controller.playerIndex withInput:kSKUGamePadInputDirectionalPad andXValue:xValue andYValue:yValue isPressed:YES andEventDictionary:eventDict];
	};
	
	microGamepad.controller.controllerPausedHandler = ^(GCController* controller) {
		NSDictionary* eventDict = [NSDictionary dictionaryWithObject:controller forKey:@"controller"];
		[self gamepadInputChangedInternalForPlayer:controller.playerIndex withInput:kSKUGamePadInputButtonPause andXValue:0.0 andYValue:0.0 isPressed:NO andEventDictionary:eventDict];
	};
}

-(void)registerGamepadButtonsOnController:(GCGamepad*)gamepad {
	//buttons
	gamepad.leftShoulder.valueChangedHandler = ^(GCControllerButtonInput* button, float value, BOOL pressed) {
		NSDictionary* eventDict = [NSDictionary dictionaryWithObjects:@[button, gamepad.controller] forKeys:@[@"button", @"controller"]];
		[self gamepadInputChangedInternalForPlayer:gamepad.controller.playerIndex withInput:kSKUGamePadInputLeftShoulder andXValue:value andYValue:value isPressed:pressed andEventDictionary:eventDict];
	};
	gamepad.buttonA.valueChangedHandler = ^(GCControllerButtonInput* button, float value, BOOL pressed) {
		NSDictionary* eventDict = [NSDictionary dictionaryWithObjects:@[button, gamepad.controller] forKeys:@[@"button", @"controller"]];
		[self gamepadInputChangedInternalForPlayer:gamepad.controller.playerIndex withInput:kSKUGamePadInputButtonA andXValue:value andYValue:value isPressed:pressed andEventDictionary:eventDict];
	};
	gamepad.buttonB.valueChangedHandler = ^(GCControllerButtonInput* button, float value, BOOL pressed) {
		NSDictionary* eventDict = [NSDictionary dictionaryWithObjects:@[button, gamepad.controller] forKeys:@[@"button", @"controller"]];
		[self gamepadInputChangedInternalForPlayer:gamepad.controller.playerIndex withInput:kSKUGamePadInputButtonB andXValue:value andYValue:value isPressed:pressed andEventDictionary:eventDict];
	};
	gamepad.buttonX.valueChangedHandler = ^(GCControllerButtonInput* button, float value, BOOL pressed) {
		NSDictionary* eventDict = [NSDictionary dictionaryWithObjects:@[button, gamepad.controller] forKeys:@[@"button", @"controller"]];
		[self gamepadInputChangedInternalForPlayer:gamepad.controller.playerIndex withInput:kSKUGamePadInputButtonX andXValue:value andYValue:value isPressed:pressed andEventDictionary:eventDict];
	};
	gamepad.buttonY.valueChangedHandler = ^(GCControllerButtonInput* button, float value, BOOL pressed) {
		NSDictionary* eventDict = [NSDictionary dictionaryWithObjects:@[button, gamepad.controller] forKeys:@[@"button", @"controller"]];
		[self gamepadInputChangedInternalForPlayer:gamepad.controller.playerIndex withInput:kSKUGamePadInputButtonY andXValue:value andYValue:value isPressed:pressed andEventDictionary:eventDict];
	};
	gamepad.rightShoulder.valueChangedHandler = ^(GCControllerButtonInput* button, float value, BOOL pressed) {
		NSDictionary* eventDict = [NSDictionary dictionaryWithObjects:@[button, gamepad.controller] forKeys:@[@"button", @"controller"]];
		[self gamepadInputChangedInternalForPlayer:gamepad.controller.playerIndex withInput:kSKUGamePadInputRightShoulder andXValue:value andYValue:value isPressed:pressed andEventDictionary:eventDict];
	};
	
	gamepad.controller.controllerPausedHandler = ^(GCController* controller) {
		NSDictionary* eventDict = [NSDictionary dictionaryWithObject:controller forKey:@"controller"];
		[self gamepadInputChangedInternalForPlayer:controller.playerIndex withInput:kSKUGamePadInputButtonPause andXValue:0.0 andYValue:0.0 isPressed:NO andEventDictionary:eventDict];
	};
	
	//axes
	gamepad.dpad.valueChangedHandler = ^(GCControllerDirectionPad* dpad, float xValue, float yValue) {
		NSDictionary* eventDict = [NSDictionary dictionaryWithObjects:@[dpad, gamepad.controller] forKeys:@[@"button", @"controller"]];
		[self gamepadInputChangedInternalForPlayer:gamepad.controller.playerIndex withInput:kSKUGamePadInputDirectionalPad andXValue:xValue andYValue:yValue isPressed:YES andEventDictionary:eventDict];
	};
}

-(void)registerExtendedGamepadButtonsOnController:(GCExtendedGamepad*)extendedGamepad {
	//buttons
	extendedGamepad.leftTrigger.valueChangedHandler = ^(GCControllerButtonInput* button, float value, BOOL pressed) {
		NSDictionary* eventDict = [NSDictionary dictionaryWithObjects:@[button, extendedGamepad.controller] forKeys:@[@"button", @"controller"]];
		[self gamepadInputChangedInternalForPlayer:extendedGamepad.controller.playerIndex withInput:kSKUGamePadInputLeftTrigger andXValue:value andYValue:value isPressed:pressed andEventDictionary:eventDict];
	};
	extendedGamepad.rightTrigger.valueChangedHandler = ^(GCControllerButtonInput* button, float value, BOOL pressed) {
		NSDictionary* eventDict = [NSDictionary dictionaryWithObjects:@[button, extendedGamepad.controller] forKeys:@[@"button", @"controller"]];
		[self gamepadInputChangedInternalForPlayer:extendedGamepad.controller.playerIndex withInput:kSKUGamePadInputRightTrigger andXValue:value andYValue:value isPressed:pressed andEventDictionary:eventDict];
	};
	
	//axes
	extendedGamepad.leftThumbstick.valueChangedHandler = ^(GCControllerDirectionPad* dpad, float xValue, float yValue) {
		NSDictionary* eventDict = [NSDictionary dictionaryWithObjects:@[dpad, extendedGamepad.controller] forKeys:@[@"button", @"controller"]];
		[self gamepadInputChangedInternalForPlayer:extendedGamepad.controller.playerIndex withInput:kSKUGamePadInputLeftThumbstick andXValue:xValue andYValue:yValue isPressed:YES andEventDictionary:eventDict];
	};
	extendedGamepad.rightThumbstick.valueChangedHandler = ^(GCControllerDirectionPad* dpad, float xValue, float yValue) {
		NSDictionary* eventDict = [NSDictionary dictionaryWithObjects:@[dpad, extendedGamepad.controller] forKeys:@[@"button", @"controller"]];
		[self gamepadInputChangedInternalForPlayer:extendedGamepad.controller.playerIndex withInput:kSKUGamePadInputRightThumbstick andXValue:xValue andYValue:yValue isPressed:YES andEventDictionary:eventDict];
	};
	
}

#pragma mark setting or getting controllers

-(void)setPlayerOne:(GCController*)controller {
	NSMutableArray* playerControllers = SKUSharedUtilities.gcController.playerControllers;
	if ([playerControllers containsObject:controller]) {
		NSUInteger indexToSwap = [playerControllers indexOfObject:controller];
		[playerControllers exchangeObjectAtIndex:0 withObjectAtIndex:indexToSwap];
	} else if (![playerControllers containsObject:controller] && playerControllers.count > 1) {
		GCController* oldP1 = playerControllers[0];
		[playerControllers removeObject:oldP1];
		[playerControllers insertObject:controller atIndex:0];
		[playerControllers addObject:oldP1];
	} else {
		[playerControllers insertObject:controller atIndex:0];
	}
	
	[self setControllerPlayerIndices];
	
}

-(GCController*)gamepadForPlayer:(GCControllerPlayerIndex)player {
	NSArray* controllers = [GCController controllers];
	for (GCController* controller in controllers) {
		if (controller.playerIndex == player) {
			return controller;
		}
	}
	return nil;
}

-(GCController*)gamepadForVendor:(NSString*)vendor {
	NSArray* controllers = [GCController controllers];
	for (GCController* controller in controllers) {
		if ([controller.vendorName isEqualToString:vendor]) {
			return controller;
		}
	}
	return nil;
}

#pragma mark gamepad vague executes


-(BOOL)canPlayerControlNav:(GCControllerPlayerIndex)player {
	
	BOOL player1IsValid = SKUSharedUtilities.gcController.validPlayerNav & kSKUGamePadPlayerFlag1;
	BOOL player2IsValid = SKUSharedUtilities.gcController.validPlayerNav & kSKUGamePadPlayerFlag2;
	BOOL player3IsValid = SKUSharedUtilities.gcController.validPlayerNav & kSKUGamePadPlayerFlag3;
	BOOL player4IsValid = SKUSharedUtilities.gcController.validPlayerNav & kSKUGamePadPlayerFlag4;
	BOOL playerCanControl = NO;
	
	if (player == GCControllerPlayerIndex1 && player1IsValid) {
		playerCanControl = YES;
	} else if (player == GCControllerPlayerIndex2 && player2IsValid) {
		playerCanControl = YES;
	} else if (player == GCControllerPlayerIndex3 && player3IsValid) {
		playerCanControl = YES;
	} else if (player == GCControllerPlayerIndex4 && player4IsValid) {
		playerCanControl = YES;
	}
	
	return playerCanControl;
}


-(void)gamepadInputChangedInternalForPlayer:(GCControllerPlayerIndex)player withInput:(kSKUGamePadInputs)input andXValue:(float)xValue andYValue:(float)yValue isPressed:(BOOL)pressed andEventDictionary:(NSDictionary*)eventDictionary {
	GCController* controller = eventDictionary[@"controller"];
	
	BOOL playerCanControl = [self canPlayerControlNav:player];
	
	if ((SKUSharedUtilities.navMode == kSKUNavModeOn || SKUSharedUtilities.navMode == kSKUNavModePressed) && ![controller.vendorName isEqualToString:@"Remote"] && playerCanControl) {
		if (!_navControllerState) {
			_navControllerState = [SKUGameControllerState controllerStateWithCenterPosition:midPointOfRect(_view.scene.frame)];
		}
		
		// NAV ONLY
		switch (input) {
			case kSKUGamePadInputDirectionalPad:
			{
				[self gamepadNavDpadWithControllerState:_navControllerState andXValue:xValue andYValue:yValue];
			}
				break;
			case kSKUGamePadInputLeftThumbstick:
			{
				[self gamepadNavDpadWithControllerState:_navControllerState andXValue:xValue andYValue:yValue];
			}
				break;
			case kSKUGamePadInputButtonA:
			{
#if TARGET_OS_TV // if tvOS, check the state of gamepad user interaction being enabled or not
				GCEventViewController* evc = (GCEventViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
				BOOL vcNavOn = evc.controllerUserInteractionEnabled;
				if (!vcNavOn) {
#endif
					if (pressed) {
						[SKUSharedUtilities gestureTapDown];
					} else {
						[SKUSharedUtilities gestureTapUp];
					}
#if TARGET_OS_TV
				}
#endif
			}
				break;
				
			default:
				break;
		}
	}
	
	if (!_view) {
		NSLog(@"No view set on SKUSharedUtilities.gcController.view. Please set it properly to use controllers.");
	}

	kSKUGamepadButtonStates buttonState = [self updateControllerStateForPlayer:player withInput:input andXValue:xValue andYValue:yValue isPressed:pressed andEventDictionary:eventDictionary]; // serves dual purpose: updates controller state and generates button state
	[_view gamepadInputChangedForPlayer:player withInput:input andXValue:xValue andYValue:yValue pressedState:buttonState andEventDictionary:eventDictionary];
}

-(void)gamepadNavDpadWithControllerState:(SKUGameControllerState*)controllerState andXValue:(CGFloat)xValue andYValue:(CGFloat)yValue {
	BOOL wasPressed = controllerState.buttonsPressed & kSKUGamePadInputDirectionalPad;
	CGFloat multiplier;
	if (wasPressed) {
		multiplier = 0.0;
	} else {
		multiplier = 100.0;
	}
	
	if (!(xValue == 0.0 && yValue == 0.0)) {
		controllerState.buttonsPressed |= kSKUGamePadInputDirectionalPad;
	} else {
		controllerState.buttonsPressed &= ~kSKUGamePadInputDirectionalPad;
		controllerState.location = midPointOfRect(_view.scene.frame);
		[SKUSharedUtilities resetSelectLocation];
	}
	controllerState.vectorDPad = CGVectorMake(xValue, yValue);
	controllerState.location = pointAdd(controllerState.location, pointMultiplyByFactor(pointFromCGVector(controllerState.vectorDPad), SKUSharedUtilities.navThresholdDistance * multiplier));
}

-(kSKUGamepadButtonStates)updateControllerStateForPlayer:(GCControllerPlayerIndex)player withInput:(kSKUGamePadInputs)input andXValue:(float)xValue andYValue:(float)yValue isPressed:(BOOL)pressed andEventDictionary:(NSDictionary*)eventDictionary {
	
	SKUGameControllerState* controllerState;
	SKUGameControllerState* metaState = _controllerStates[4];
	switch (player) {
		case GCControllerPlayerIndex1:
			controllerState = _controllerStates[0];
			break;
		case GCControllerPlayerIndex2:
			controllerState = _controllerStates[1];
			break;
		case GCControllerPlayerIndex3:
			controllerState = _controllerStates[2];
			break;
		case GCControllerPlayerIndex4:
			controllerState = _controllerStates[3];
			break;
		default:
			break;
	}
	CGVector inputVector = CGVectorMake(xValue, yValue);
	static const kSKUGamePadInputs buttons = kSKUGamePadInputButtonA | kSKUGamePadInputButtonB | kSKUGamePadInputButtonX | kSKUGamePadInputButtonY | kSKUGamePadInputLeftShoulder | kSKUGamePadInputLeftTrigger | kSKUGamePadInputRightShoulder | kSKUGamePadInputRightTrigger;
	static const kSKUGamePadInputs directions = kSKUGamePadInputLeftThumbstick | kSKUGamePadInputDirectionalPad | kSKUGamePadInputRightThumbstick;
	
	BOOL isButtons = (input & buttons) > 0;
	BOOL isDirections = (input & directions) > 0;
	BOOL isPause = (input & kSKUGamePadInputButtonPause) > 0;
	
	if (isButtons) {
		[self setStateForButton:input pressed:pressed withControllerState:controllerState];
		[self setStateForButton:input pressed:pressed withControllerState:metaState];
	} else if (isDirections) {
		[self setStateForDirection:input withVector:inputVector andControllerState:controllerState];
		[self setStateForDirection:input withVector:inputVector andControllerState:metaState];
	} else if (isPause) {
		BOOL alreadyPaused = controllerState.buttonsPressed & kSKUGamePadInputButtonPause;
		[self setStateForButton:input pressed:!alreadyPaused withControllerState:controllerState];
		[self setStateForButton:input pressed:!alreadyPaused withControllerState:metaState];
	}
	
	BOOL wasPressed = (controllerState.buttonsPressedPrevious & input) > 0;
	kSKUGamepadButtonStates buttonState;
	if (!wasPressed && pressed) {
		buttonState = kSKUGamepadButtonStateBegan;
//		SKULog(0, @"began");
	} else if (wasPressed && !pressed) {
		buttonState = kSKUGamepadButtonStateEnded;
//		SKULog(0, @"ended");
	} else if (wasPressed && xValue == 0.0 && yValue == 0.0 && isDirections) {
		buttonState = kSKUGamepadButtonStateEnded;
//		SKULog(0, @"ended");
	} else {
		buttonState = kSKUGamepadButtonStateChanged;
//		SKULog(0, @"changed");
	}
	
//	SKULogBinary(controllerState.buttonsPressed);
	return buttonState;
}

-(void)setStateForButton:(kSKUGamePadInputs)button pressed:(BOOL)pressed withControllerState:(SKUGameControllerState*)controllerState {
	controllerState.buttonsPressedPrevious = controllerState.buttonsPressed;
	if (pressed) {
		controllerState.buttonsPressed |= button;
	} else {
		controllerState.buttonsPressed &= ~button;
	}
}
-(void)setStateForDirection:(kSKUGamePadInputs)directionPad withVector:(CGVector)vector andControllerState:(SKUGameControllerState*)controllerState {
	controllerState.buttonsPressedPrevious = controllerState.buttonsPressed;
	if (!vectorIsZero(vector)) {
		controllerState.buttonsPressed |= directionPad;
	} else {
		controllerState.buttonsPressed &= ~directionPad;
	}
	switch (directionPad) {
		case kSKUGamePadInputDirectionalPad:
			controllerState.vectorDPad = vector;
			controllerState.speedModDPad = fmin(vectorDistance(vector), 1.0);
			break;
		case kSKUGamePadInputLeftThumbstick:
			controllerState.vectorLThumbstick = vector;
			controllerState.speedModLThumbstick = fmin(vectorDistance(vector), 1.0);
			break;
		case kSKUGamePadInputRightThumbstick:
			controllerState.vectorRThumbstick= vector;
			controllerState.speedModRThumbstick = fmin(vectorDistance(vector), 1.0);
			break;
			
		default:
			break;
	}
}

@end



@implementation SKUGameControllerState

-(instancetype)init {
	if (self = [super init]) {
		_buttonsPressed = 0;
		_vectorDPad = CGVectorMake(0.0, 0.0);
		_normalVectorDPad = CGVectorMake(0.0, 0.0);
		_vectorLThumbstick = CGVectorMake(0.0, 0.0);
		_normalVectorLThumbstick = CGVectorMake(0.0, 0.0);
		_vectorRThumbstick = CGVectorMake(0.0, 0.0);
		_normalVectorRThumbstick = CGVectorMake(0.0, 0.0);
		_speed = 0.0;
		_speedModDPad = 0.0;
		_speedModLThumbstick = 0.0;
		_speedModRThumbstick = 0.0;
	}
	return self;
}

+(SKUGameControllerState*)controllerState {
	return [[SKUGameControllerState alloc] init];
}

+(SKUGameControllerState*)controllerStateWithCenterPosition:(CGPoint)location {
	SKUGameControllerState* state = [[SKUGameControllerState alloc] init];
	state.location = location;
	return state;
}

-(void)setVectorDPad:(CGVector)vectorDPad {
	_normalVectorDPad = vectorNormalize(vectorDPad);
	_vectorDPad = vectorDPad;
	
	_normalVectorDPad = [self checkVectorIsntNaN:_normalVectorDPad];
}

-(void)setNormalVectorDPad:(CGVector)normalVectorDPad {
	_normalVectorDPad = vectorNormalize(normalVectorDPad);
	_vectorDPad = normalVectorDPad;
	
	_normalVectorDPad = [self checkVectorIsntNaN:_normalVectorDPad];
}

-(void)setVectorLThumbstick:(CGVector)vectorLThumbstick {
	_normalVectorLThumbstick = vectorNormalize(vectorLThumbstick);
	_vectorLThumbstick = vectorLThumbstick;
	
	_normalVectorLThumbstick = [self checkVectorIsntNaN:_normalVectorLThumbstick];
}

-(void)setNormalVectorLThumbstick:(CGVector)normalVectorLThumbstick {
	_normalVectorLThumbstick = vectorNormalize(normalVectorLThumbstick);
	_vectorLThumbstick = normalVectorLThumbstick;
	
	_normalVectorLThumbstick = [self checkVectorIsntNaN:_normalVectorLThumbstick];
}

-(void)setVectorRThumbstick:(CGVector)vectorRThumbstick {
	_normalVectorRThumbstick = vectorNormalize(vectorRThumbstick);
	_vectorRThumbstick = vectorRThumbstick;
	
	_normalVectorRThumbstick = [self checkVectorIsntNaN:_normalVectorRThumbstick];

}

-(void)setNormalVectorRThumbstick:(CGVector)normalVectorRThumbstick {
	_normalVectorRThumbstick = vectorNormalize(normalVectorRThumbstick);
	_vectorRThumbstick = normalVectorRThumbstick;
	
	_normalVectorRThumbstick = [self checkVectorIsntNaN:_normalVectorRThumbstick];
}

-(CGVector)checkVectorIsntNaN:(CGVector)vector {
	CGVector rVector = vector;
	if (isnan(rVector.dx)) {
		rVector = CGVectorMake(0.0, rVector.dy);
	}
	if (isnan(rVector.dy)) {
		rVector = CGVectorMake(rVector.dx, 0.0);
	}
	return rVector;
}

@end


#pragma mark SKUPositionObject

@implementation SKUPositionObject

-(id)copyWithZone:(NSZone *)zone {
	return [SKUPositionObject rect:_rect];
}

-(id)init {
	if (self = [super init]) {
		
	}
	return self;
}

-(id)initWithPosition:(CGPoint)position {
	if (self = [super init]) {
		self.position = position;
	}
	return self;
}

-(id)initWithVector:(CGVector)vector {
	if (self = [super init]) {
		self.vector = vector;
	}
	return self;
}

-(id)initWithSize:(CGSize)size {
	if (self = [super init]) {
		self.size = size;
	}
	return self;
}

-(id)initWithRect:(CGRect)rect {
	if (self = [super init]) {
		self.rect = rect;
	}
	return self;
}


+(SKUPositionObject*)position:(CGPoint)location {
	return [[SKUPositionObject alloc]initWithPosition:location];
}

+(SKUPositionObject*)vector:(CGVector)vector {
	return [[SKUPositionObject alloc]initWithVector:vector];
}

+(SKUPositionObject*)size:(CGSize)size {
	return [[SKUPositionObject alloc]initWithSize:size];
}

+(SKUPositionObject*)rect:(CGRect)rect {
	return [[SKUPositionObject alloc]initWithRect:rect];
}


-(void)setPosition:(CGPoint)position {
	_position = position;
	_vector = CGVectorMake(position.x, position.y);
	_rect = CGRectMake(position.x, position.y, _size.width, _size.height);
}

-(void)setVector:(CGVector)vector {
	_vector = vector;
	_position = CGPointMake(vector.dx, vector.dy);
	_rect = CGRectMake(vector.dx, vector.dy, _size.width, _size.height);
	
}

-(void)setSize:(CGSize)size {
	_size = size;
	_rect = CGRectMake(_position.x, _position.y, size.width, size.height);
}

-(void)setRect:(CGRect)rect {
	_rect = rect;
	_position = CGPointMake(rect.origin.x, rect.origin.y);
	_vector = CGVectorMake(rect.origin.x, rect.origin.y);
	_size = CGSizeMake(rect.size.width, rect.size.height);
}

-(CGSize)getSizeFromPosition {
	return CGSizeMake(_position.x, _position.y);
}

-(CGPoint)getPositionFromSize {
	return CGPointMake(_size.width, _size.height);
}

-(CGVector)getVectorFromSize {
	return CGVectorMake(_size.width, _size.height);
}

@end

#pragma mark SKUShapeNode

@interface SKUShapeNode() {
	
	CAShapeLayer* shapeLayer;
	CAShapeLayer* outlineLayer;
	
	CGSize boundingSize;
	
	SKSpriteNode* drawSprite;
	CGPoint defaultPosition;
	
	SKNode* null;
}

@end


@implementation SKUShapeNode

-(id)copyWithZone:(NSZone *)zone {
	SKUShapeNode* shape = [SKUShapeNode node];
	shape.strokeColor = _strokeColor.copy;
	shape.fillColor = _fillColor.copy;
	shape.lineWidth = _lineWidth;
	shape.fillRule = _fillRule;
	shape.lineCap = _lineCap;
	shape.lineDashPattern = _lineDashPattern;
	shape.lineDashPhase = _lineDashPhase;
	shape.lineJoin = _lineJoin;
	shape.miterLimit = _miterLimit;
	shape.anchorPoint = _anchorPoint;
	shape.path = _path;
	return shape;
}

+(SKUShapeNode*)circleWithRadius:(CGFloat)radius andColor:(SKColor*)color{
	CGRect rect = CGRectMake(-radius, -radius, radius*2.0, radius*2.0);
	CGPathRef circle = CGPathCreateWithEllipseInRect(rect, NULL);
	
	SKUShapeNode* shapeNode = [SKUShapeNode node];
	shapeNode.fillColor = color;
	shapeNode.path = circle;
	
	CGPathRelease(circle);
	
	return shapeNode;
}

+(SKUShapeNode*)squareWithWidth:(CGFloat)width andColor:(SKColor*)color{
	CGRect rect = CGRectMake(-width / 2.0, -width / 2.0, width, width);
	CGPathRef square = CGPathCreateWithRect(rect, NULL);
	
	SKUShapeNode* shapeNode = [SKUShapeNode node];
	shapeNode.fillColor = color;
	shapeNode.path = square;
	
	CGPathRelease(square);
	
	return shapeNode;
}

+(SKUShapeNode*)rectangleWithSize:(CGSize)size andColor:(SKColor*)color{
	CGRect rect = CGRectMake(-size.width / 2.0, -size.height / 2.0, size.width, size.height);
	CGPathRef rectPath = CGPathCreateWithRect(rect, NULL);
	
	SKUShapeNode* shapeNode = [SKUShapeNode node];
	shapeNode.fillColor = color;
	shapeNode.path = rectPath;
	
	CGPathRelease(rectPath);
	
	return shapeNode;
}

+(SKUShapeNode*)rectangleRoundedWithSize:(CGSize)size andCornerRadius:(CGFloat)radius andColor:(SKColor*)color{
	CGRect rect = CGRectMake(-size.width / 2.0, -size.height / 2.0, size.width, size.height);
	CGPathRef rectPath = CGPathCreateWithRoundedRect(rect, radius, radius, NULL);
	
	SKUShapeNode* shapeNode = [SKUShapeNode node];
	shapeNode.fillColor = color;
	shapeNode.path = rectPath;
	
	CGPathRelease(rectPath);
	
	return shapeNode;
}

+(SKUShapeNode*)shapeWithPath:(CGPathRef)path andColor:(SKColor *)color {
	SKUShapeNode* shapeNode = [SKUShapeNode node];
	shapeNode.fillColor = color;
	shapeNode.path = path;
	return shapeNode;
}
-(id)init {
	
	if (self = [super init]) {
		
		self.name = @"SKUShapeNode";
		
		null = [SKNode node];
		null.name = @"SKUShapeNodeNULL";
		[self addChild:null];
		
		drawSprite = [SKSpriteNode node];
		drawSprite.name = @"SKUShapeNodeDrawSprite";
		[null addChild:drawSprite];
		_strokeColor = [SKColor whiteColor];
		_fillColor = [SKColor clearColor];
		_lineWidth = 0.0;
		_fillRule = kCAFillRuleNonZero;
		_lineCap = kCALineCapButt;
		_lineDashPattern = nil;
		_lineDashPhase = 0;
		_lineJoin = kCALineJoinMiter;
		_miterLimit = 10.0;
		_antiAlias = YES;
		
		_anchorPoint = CGPointMake(0.5, 0.5);
	}
	
	return self;
}

-(CGLineCap)CGLineCapFromStringEnum:(NSString*)stringEnum {
	CGLineCap lineCapEnum = kCGLineCapSquare;
	if ([stringEnum isEqualToString:kCALineCapSquare]) {
		lineCapEnum = kCGLineCapSquare;
	} else if ([stringEnum isEqualToString:kCALineCapRound]) {
		lineCapEnum = kCGLineCapRound;
	} else if ([stringEnum isEqualToString:kCALineCapButt]) {
		lineCapEnum = kCGLineCapButt;
	}
	return lineCapEnum;
}

-(CGLineJoin)CGLineJoinFromStringEnum:(NSString*)stringEnum {
	CGLineJoin lineJoinEnum = kCGLineJoinMiter;
	if ([stringEnum isEqualToString:kCALineJoinBevel]) {
		lineJoinEnum = kCGLineJoinBevel;
	} else if ([stringEnum isEqualToString:kCALineJoinMiter]) {
		lineJoinEnum = kCGLineJoinMiter;
	} else if ([stringEnum isEqualToString:kCALineJoinRound]) {
		lineJoinEnum = kCGLineJoinRound;
	}
	return lineJoinEnum;
}

-(void)redrawTexture {
	
	if (!_path) {
		return;
	}
	
	if (!shapeLayer) {
		shapeLayer = [CAShapeLayer layer];
		outlineLayer = [CAShapeLayer layer];
		[shapeLayer addSublayer:outlineLayer];
	}
	
	shapeLayer.strokeColor = [[SKColor clearColor] CGColor];
	shapeLayer.fillColor = [_fillColor CGColor];
	shapeLayer.lineWidth = 0;
	shapeLayer.fillRule = _fillRule;


	
	CGRect enclosure = CGPathGetPathBoundingBox(_path);
//	SKULog(0,@"bounding: %f %f %f %f", enclosure.origin.x, enclosure.origin.y, enclosure.size.width, enclosure.size.height);
	CGPoint enclosureOffset;
	
	if (![_strokeColor isEqual:[SKColor clearColor]]) {
		enclosureOffset = CGPointMake(enclosure.origin.x - _lineWidth, enclosure.origin.y - _lineWidth);
	} else {
		enclosureOffset = CGPointMake(enclosure.origin.x, enclosure.origin.y);
	}
	
	CGAffineTransform transform = CGAffineTransformMake(1, 0, 0, 1, -enclosureOffset.x, -enclosureOffset.y);
	CGPathRef newPath = CGPathCreateCopyByTransformingPath(_path, &transform);
	
	CGPathRef outlinePath = NULL;
	if (_lineWidth > 0) {
		CGLineCap lineCapEnum = [self CGLineCapFromStringEnum:_lineCap];
		CGLineJoin lineJoinEnum = [self CGLineJoinFromStringEnum:_lineJoin];
		if (_lineDashPattern.count > 0 && _lineDashPhase > 0) {
			NSUInteger lengthCount = _lineDashPattern.count;
			CGFloat lengths[lengthCount];
			for (uint32_t i = 0; i < _lineDashPattern.count; i++) {
				lengths[i] = [_lineDashPattern[i] doubleValue];
			}
			CGPathRef dashPath = CGPathCreateCopyByDashingPath(newPath, NULL, 0, lengths, lengthCount);
			outlinePath = CGPathCreateCopyByStrokingPath(dashPath, NULL, _lineWidth, lineCapEnum, lineJoinEnum, _miterLimit);
			CGPathRelease(dashPath);
		} else {
			outlinePath = CGPathCreateCopyByStrokingPath(newPath, NULL, _lineWidth, lineCapEnum, lineJoinEnum, _miterLimit);
		}
	}
	outlineLayer.strokeColor = [[SKColor clearColor] CGColor];
	outlineLayer.fillColor = [_strokeColor CGColor];
	outlineLayer.lineWidth = 0;
	outlineLayer.fillRule = _fillRule;
	
	shapeLayer.path = newPath;
	if (_lineWidth > 0 && outlinePath) {
		outlineLayer.path = outlinePath;
	} else {
		outlineLayer.path = nil;
	}
	
	boundingSize = CGSizeMake(enclosure.size.width + _lineWidth * 2, enclosure.size.height + _lineWidth * 2);
	
#if TARGET_OS_IPHONE
	CGFloat scaleFactor = [[UIScreen mainScreen] scale];
	NSString* systemVersion = [[UIDevice currentDevice] systemVersion];
	if ([systemVersion floatValue] < 8.0) {
		scaleFactor = 1.0;
	}
#endif
	
	CGSize imageSize = boundingSize;
	imageSize.width = ceil(imageSize.width);
	imageSize.height = ceil(imageSize.height);
#if TARGET_OS_OSX_SKU
	NSImage *image = [[NSImage alloc] initWithSize:imageSize];
	[image lockFocus];
	CGContextRef newContext = [NSGraphicsContext currentContext].CGContext;
	CGContextSetAllowsAntialiasing(newContext, _antiAlias);
	[shapeLayer renderInContext:newContext];
	[image unlockFocus];

	SKTexture* tex = [SKTexture textureWithImage:image];
#else
	UIGraphicsBeginImageContextWithOptions(imageSize, NO, scaleFactor);
	[shapeLayer renderInContext:UIGraphicsGetCurrentContext()];
	SKTexture* tex = [SKTexture textureWithImage:UIGraphicsGetImageFromCurrentImageContext()];
	UIGraphicsEndImageContext();
#endif
	
	CGPathRelease(newPath);
	if (outlinePath) {
		CGPathRelease(outlinePath);
	}
	
	drawSprite.texture = tex;
	drawSprite.size = boundingSize;
	drawSprite.anchorPoint = CGPointZero;
	defaultPosition = CGPointMake(enclosureOffset.x, enclosureOffset.y);
	drawSprite.position = defaultPosition;
	[self setAnchorPoint:_anchorPoint];
	
	_texture = tex;
}

-(void)setPath:(CGPathRef)path {
	_path = CGPathCreateCopy(path);
	[self redrawTexture];
}

-(void)setStrokeColor:(SKColor *)strokeColor {
	_strokeColor = strokeColor;
	[self redrawTexture];
}

-(void)setFillColor:(SKColor *)fillColor {
	_fillColor = fillColor;
	[self redrawTexture];
}

-(void)setLineWidth:(CGFloat)lineWidth {
	_lineWidth = fmax(0.0, lineWidth);
	[self redrawTexture];
}

-(void)setFillRule:(NSString *)fillRule {
	_fillRule = fillRule;
	[self redrawTexture];
}

-(void)setAntiAlias:(BOOL)antiAlias {
	_antiAlias = antiAlias;
	[self redrawTexture];
}

-(void)setLineCap:(NSString *)lineCap {
	_lineCap = lineCap;
	[self redrawTexture];
}

-(void)setLineDashPattern:(NSArray *)lineDashPattern {
	_lineDashPattern = lineDashPattern;
	[self redrawTexture];
}

-(void)setLineJoin:(NSString *)lineJoin {
	_lineJoin = lineJoin;
	[self redrawTexture];
}

-(void)setMiterLimit:(CGFloat)miterLimit {
	_miterLimit = miterLimit;
	[self redrawTexture];
}

-(void)setAnchorPoint:(CGPoint)anchorPoint {
	_anchorPoint = anchorPoint;
	null.position = CGPointMake(boundingSize.width * (0.5 - anchorPoint.x), boundingSize.height * (0.5 - anchorPoint.y));
}

-(void)dealloc {
	CGPathRelease(_path);
}

@end


#pragma mark SKUMultiLineLabelNode

@interface SKUMultiLineLabelNode () {
	
	bool setupMode;
	
}

@end

@implementation SKUMultiLineLabelNode

#pragma mark init and convenience methods

-(instancetype)copyWithZone:(NSZone *)zone {
	SKUMultiLineLabelNode* label = [SKUMultiLineLabelNode labelNodeWithFontNamed:_fontName];
	label.fontColor = _fontColor;
	label.fontSize = _fontSize;
	label.horizontalAlignmentMode = _horizontalAlignmentMode;
	label.verticalAlignmentMode = _verticalAlignmentMode;
	label.paragraphWidth = _paragraphWidth;
	label.paragraphHeight = _paragraphHeight;
	label.lineSpacing = _lineSpacing;
	label.strokeWidth = _strokeWidth;
	label.strokeColor = _strokeColor;
	label.text = _text;
	return label;
}

- (instancetype) init {
	self = [super init];
	
	if (self) {
		
		setupMode = YES;
		
		//Initialize the same values as a default SKLabelNode
		self.fontColor = [SKColor whiteColor];
		self.fontName = @"Helvetica";
		self.fontSize = 32.0;
		_lineSpacing = 1;
		
		self.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
		self.verticalAlignmentMode = SKLabelVerticalAlignmentModeBaseline;
		
		//Paint our initial texture
		[self retexture];
		
		setupMode = NO;
	}
	
	return self;
	
}

//init method to support drop-in replacement for SKLabelNode
- (instancetype)initWithFontNamed:(NSString *)fontName {
	self = [self init];
	
	if (self) {
		self.fontName = fontName;
	}
	
	return self;
}

//Convenience method to support drop-in replacement for SKLabelNode
+ (instancetype)labelNodeWithFontNamed:(NSString *)fontName {
	SKUMultiLineLabelNode* node = [[SKUMultiLineLabelNode alloc] initWithFontNamed:fontName];
	
	return node;
}

#pragma mark setters for SKLabelNode properties
//For each of the setters, after we set the appropriate property, we call the
//retexture method to generate and apply our new texture to the node

-(void) setFontColor:(SKColor *)fontColor {
	_fontColor = fontColor;
	[self retexture];
}

-(void) setFontName:(NSString *)fontName {
	_fontName = fontName;
	[self retexture];
}

-(void) setFontSize:(CGFloat)fontSize {
	_fontSize = fontSize;
	[self retexture];
}

-(void) setHorizontalAlignmentMode:(SKLabelHorizontalAlignmentMode)horizontalAlignmentMode {
	_horizontalAlignmentMode = horizontalAlignmentMode;
	[self retexture];
	switch (_horizontalAlignmentMode) {
		case SKLabelHorizontalAlignmentModeCenter:
			self.anchorPoint = CGPointMake(0.5, self.anchorPoint.y);
			break;
		case SKLabelHorizontalAlignmentModeLeft:
			self.anchorPoint = CGPointMake(0.0, self.anchorPoint.y);
			break;
		case SKLabelHorizontalAlignmentModeRight:
			self.anchorPoint = CGPointMake(1.0, self.anchorPoint.y);
			break;
			
		default:
			break;
	}
}

-(void) setText:(NSString *)text {
	_text = text;
	[self retexture];
}

-(void) setVerticalAlignmentMode:(SKLabelVerticalAlignmentMode)verticalAlignmentMode {
	_verticalAlignmentMode = verticalAlignmentMode;
	switch (_verticalAlignmentMode) {
		case SKLabelVerticalAlignmentModeBaseline:
			self.anchorPoint = CGPointMake(self.anchorPoint.x, 0.0);
			break;
		case SKLabelVerticalAlignmentModeBottom:
			self.anchorPoint = CGPointMake(self.anchorPoint.x, 0.0);
			break;
		case SKLabelVerticalAlignmentModeCenter:
			self.anchorPoint = CGPointMake(self.anchorPoint.x, 0.5);
			break;
		case SKLabelVerticalAlignmentModeTop:
			self.anchorPoint = CGPointMake(self.anchorPoint.x, 1.0);
			break;
			
		default:
			break;
	}
}

-(void)setParagraphWidth:(CGFloat)paragraphWidth {
	
	_paragraphWidth = paragraphWidth;
	[self retexture];
	
}

-(void)setLineSpacing:(CGFloat)lineSpacing {
	
	_lineSpacing = lineSpacing;
	[self retexture];
	
}

-(void)setStrokeColor:(SKColor *)strokeColor {
	if (!strokeColor) {
		_strokeColor = [SKColor blackColor];
	} else {
		_strokeColor = strokeColor;
	}
	[self retexture];
	
}

-(void)setStrokeWidth:(CGFloat)strokeWidth {
	
	_strokeWidth = strokeWidth;
	[self retexture];
	
}

-(void)setParagraphHeight:(CGFloat)paragraphHeight {
	
	_paragraphHeight = paragraphHeight;
	[self retexture];
}


//Generates and applies new textures based on the current property values
-(void)retexture {
	if (!self.text) {
		return;
	}
	SKUImage *newTextImage = [self imageFromText:self.text];
	SKTexture *newTexture;
	
	if (newTextImage) {
		newTexture =[SKTexture textureWithImage:newTextImage];
	}
	
//	SKSpriteNode *selfNode = (SKSpriteNode*) self;
	self.texture = newTexture;
	
	//Resetting the texture also reset the anchorPoint.  Let's recenter it.
	
	self.verticalAlignmentMode = _verticalAlignmentMode;
}




-(SKUImage*)imageFromText:(NSString *)text {
	//First we define a paragrahp style, which has the support for doing the line breaks and text alignment that we require
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping; //To get multi-line
	paragraphStyle.alignment = [self mapSkLabelHorizontalAlignmentToNSTextAlignment:self.horizontalAlignmentMode];
	paragraphStyle.lineSpacing = _lineSpacing;
	
	//Create the font using the values set by the user
	SKUFont* font = [SKUFont fontWithName:self.fontName size:self.fontSize];
	
	if (!font) {
		font = [SKUFont fontWithName:@"Helvetica" size:self.fontSize];
		if (!setupMode) {
			SKULog(0,@"The font you specified was unavailable. Defaulted to Helvetica.");
//			SKULog(0,@"The font you specified was unavailable. Defaulted to Helvetica. Here is a list of available fonts: %@", [SKUFont familyNames]); //only available for debugging on iOS
		}
	}
//	SKULog(0,@"Here is a list of variations to %@: %@", _fontName, [SKUFont fontNamesForFamilyName:_fontName]);

	//Create our textAttributes dictionary that we'll use when drawing to the graphics context
	NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
	
	//Font Name and size
	[textAttributes setObject:font forKey:NSFontAttributeName];
	
	//Line break mode and alignment
	[textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
	
	//Font Color
	[textAttributes setObject:self.fontColor forKey:NSForegroundColorAttributeName];
	
	//stroke
	if (_strokeWidth > 0 && _strokeColor) {
		[textAttributes setObject:_strokeColor forKey:NSStrokeColorAttributeName];
		[textAttributes setObject:[NSNumber numberWithDouble:-_strokeWidth] forKey:NSStrokeWidthAttributeName];
	}
	
	
	
	
	//Calculate the size that the text will take up, given our options.  We use the full screen size for the bounds
	if (_paragraphWidth == 0) {
		_paragraphWidth = self.scene.size.width;
	}
	
	if (_paragraphHeight == 0) {
		_paragraphHeight = self.scene.size.width;
	}
#if TARGET_OS_IPHONE
	CGRect textRect = [text boundingRectWithSize:CGSizeMake(_paragraphWidth, _paragraphHeight)
										 options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine
									  attributes:textAttributes
										 context:nil];
	
#else
	CGRect textRect = [text boundingRectWithSize:CGSizeMake(_paragraphWidth, _paragraphHeight)
										 options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine
									  attributes:textAttributes];
#endif
	//iOS7 uses fractional size values.  So we needed to ceil it to make sure we have enough room for display.
	textRect.size.height = ceil(textRect.size.height);
	textRect.size.width = ceil(textRect.size.width);
	
	//Mac build crashes when the size is nothing - this also skips out on unecessary cycles below when the size is nothing
	if (textRect.size.width == 0 || textRect.size.height == 0) {
		return Nil;
	}
	
	//	SKULog(0,@"textRect = %f %f %f %f", textRect.origin.x, textRect.origin.y, textRect.size.width, textRect.size.height);
	
	//The size of the bounding rect is going to be the size of our new node, so set the size here.
	self.size = textRect.size;
	
#if TARGET_OS_IPHONE
	//Create the graphics context
	UIGraphicsBeginImageContextWithOptions(textRect.size,NO,0.0);
	
	//Actually draw the text into the context, using our defined attributed
	[text drawInRect:textRect withAttributes:textAttributes];
	
	//Create the image from the context
	SKUImage* image = UIGraphicsGetImageFromCurrentImageContext();
	
	//Close the context
	UIGraphicsEndImageContext();
#else
	
	SKUImage* image = [[SKUImage alloc] initWithSize:textRect.size];
	/*
	 // this section may or may not be necessary (it builds and runs without, but I don't have enough experience to know if this makes things run smoother in any way, or if the stackexchange article was entirely purposed for something else)
	 NSBitmapImageRep* imageRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL pixelsWide:textRect.size.width pixelsHigh:textRect.size.height bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO colorSpaceName:NSCalibratedRGBColorSpace bytesPerRow:0 bitsPerPixel:0];
	 
	 [image addRepresentation:imageRep];
	 
	 */
	[image lockFocus];
	
	[text drawInRect:textRect withAttributes:textAttributes];
	
	[image unlockFocus];
	
	
#endif
	
	return image;
}

//Performs translation between the SKLabelHorizontalAlignmentMode supported by SKLabelNode and the NSTextAlignment required for string drawing
-(NSTextAlignment) mapSkLabelHorizontalAlignmentToNSTextAlignment:(SKLabelHorizontalAlignmentMode)alignment {
	switch (alignment) {
		case SKLabelHorizontalAlignmentModeLeft:
			return NSTextAlignmentLeft;
			break;
			
		case SKLabelHorizontalAlignmentModeCenter:
			return NSTextAlignmentCenter;
			break;
			
		case SKLabelHorizontalAlignmentModeRight:
			return NSTextAlignmentRight;
			break;
			
		default:
			break;
	}
	
	return NSTextAlignmentLeft;
}


@end

#pragma mark SKUButtonLabelProperties
@implementation SKUButtonLabelProperties

-(id)copyWithZone:(NSZone *)zone {
	return [SKUButtonLabelProperties propertiesWithText:_text andColor:_fontColor andSize:_fontSize andFontName:_fontName andPositionOffset:_position andScale:_scale];
}

+(SKUButtonLabelProperties*)propertiesWithText:(NSString *)text andColor:(SKColor *)fontColor andSize:(CGFloat)fontSize andFontName:(NSString *)fontName andPositionOffset:(CGPoint)position andScale:(CGFloat)scale {
	SKUButtonLabelProperties* props = [[SKUButtonLabelProperties alloc] init];
	props.text = text;
	props.fontSize = fontSize;
	props.fontColor = fontColor;
	props.fontName = fontName;
	props.position = position;
	props.scale = scale;
	return props;
}

+(SKUButtonLabelProperties*)propertiesWithText:(NSString *)text andColor:(SKColor *)fontColor andSize :(CGFloat)fontSize andFontName:(NSString *)fontName {
	SKUButtonLabelProperties* props = [[SKUButtonLabelProperties alloc] init];
	props.text = text;
	props.fontSize = fontSize;
	props.fontColor = fontColor;
	props.fontName = fontName;
	props.position = CGPointZero;
	props.scale = 1.0f;
	return props;
}

+(SKUButtonLabelProperties*)propertiesWithText:(NSString *)text {
	SKUButtonLabelProperties* props = [[SKUButtonLabelProperties alloc] init];
	props.text = text;
	props.fontSize = 28.0f;
	props.fontColor = [SKColor blackColor];
	props.fontName = @"Helvetica Neue UltraLight";
	props.position = CGPointZero;
	props.scale = 1.0f;
	return props;
}


@end

@implementation SKUButtonLabelPropertiesPackage

-(id)copyWithZone:(NSZone *)zone {
	return [SKUButtonLabelPropertiesPackage packageWithPropertiesForDefaultState:_propertiesDefaultState.copy andPressedState:_propertiesPressedState.copy andHoveredState:_propertiesHoveredState.copy andDisabledState:_propertiesDisabledState.copy];
}

+(SKUButtonLabelPropertiesPackage*)packageWithPropertiesForDefaultState:(SKUButtonLabelProperties *)defaultState andPressedState:(SKUButtonLabelProperties *)pressedState andHoveredState:(SKUButtonLabelProperties *)hoveredState andDisabledState:(SKUButtonLabelProperties *)disabledState {
	SKUButtonLabelPropertiesPackage* package = [[SKUButtonLabelPropertiesPackage alloc] init];
	package.propertiesDefaultState = defaultState;
	package.propertiesPressedState = pressedState;
	package.propertiesHoveredState = hoveredState;
	package.propertiesDisabledState = disabledState;
	return package;
}

+(SKUButtonLabelPropertiesPackage*)packageWithPropertiesForDefaultState:(SKUButtonLabelProperties *)defaultState andPressedState:(SKUButtonLabelProperties *)pressedState andDisabledState:(SKUButtonLabelProperties *)disabledState {
	SKUButtonLabelPropertiesPackage* package = [[SKUButtonLabelPropertiesPackage alloc] init];
	package.propertiesDefaultState = defaultState;
	package.propertiesPressedState = pressedState;
	package.propertiesHoveredState = defaultState.copy;
	package.propertiesHoveredState.scale *= skuHoverScale;
	package.propertiesDisabledState = disabledState;
	return package;
}

+(SKUButtonLabelPropertiesPackage*)packageWithPropertiesForDefaultState:(SKUButtonLabelProperties *)defaultState andPressedState:(SKUButtonLabelProperties *)pressedState {
	SKUButtonLabelPropertiesPackage* package = [[SKUButtonLabelPropertiesPackage alloc] init];
	package.propertiesDefaultState = defaultState;
	package.propertiesPressedState = pressedState;
	package.propertiesHoveredState = defaultState.copy;
	package.propertiesHoveredState.scale *= skuHoverScale;
	package.propertiesDisabledState = defaultState.copy;
	package.propertiesDisabledState.fontColor = [SKColor blendColorSKU:defaultState.fontColor withColor:[SKColor grayColor] alpha:0.5];
	return package;
}

+(SKUButtonLabelPropertiesPackage*)packageWithPropertiesForDefaultState:(SKUButtonLabelProperties *)defaultState {
	SKUButtonLabelPropertiesPackage* package = [[SKUButtonLabelPropertiesPackage alloc] init];
	package.propertiesDefaultState = defaultState;
	package.propertiesPressedState = defaultState.copy;
	package.propertiesPressedState.scale *= 0.9;
	package.propertiesHoveredState = defaultState.copy;
	package.propertiesHoveredState.scale *= skuHoverScale;
	package.propertiesDisabledState = defaultState.copy;
	package.propertiesDisabledState.fontColor = [SKColor blendColorSKU:defaultState.fontColor withColor:[SKColor grayColor] alpha:0.5];
	return package;
}

+(SKUButtonLabelPropertiesPackage*)packageWithDefaultPropertiesWithText:(NSString*)text {
	
	SKUButtonLabelPropertiesPackage* package = [[SKUButtonLabelPropertiesPackage alloc] init];
	package.propertiesDefaultState = [SKUButtonLabelProperties propertiesWithText:text];
	package.propertiesPressedState = package.propertiesDefaultState.copy;
	package.propertiesPressedState.scale *= 0.9;
	package.propertiesHoveredState = package.propertiesDefaultState.copy;
	package.propertiesHoveredState.scale *= skuHoverScale;
	package.propertiesDisabledState = package.propertiesDefaultState.copy;
	package.propertiesDisabledState.fontColor = [SKColor blendColorSKU:package.propertiesDefaultState.fontColor withColor:[SKColor grayColor] alpha:0.5];
	return package;
}


-(void)changeText:(NSString *)text {
	_propertiesDefaultState.text = text;
	_propertiesPressedState.text = text;
	_propertiesHoveredState.text = text;
	_propertiesDisabledState.text = text;
}

-(void)changeFontSize:(CGFloat)fontSize {
	_propertiesDefaultState.fontSize = fontSize;
	_propertiesPressedState.fontSize = fontSize;
	_propertiesHoveredState.fontSize = fontSize;
	_propertiesDisabledState.fontSize = fontSize;
}

-(void)changeFontName:(NSString *)fontName {
	_propertiesDefaultState.fontName = fontName;
	_propertiesPressedState.fontName = fontName;
	_propertiesHoveredState.fontName = fontName;
	_propertiesDisabledState.fontName = fontName;
}

@end

#pragma mark SKUButtonSpriteStateProperties

@implementation SKUButtonSpriteStateProperties

-(id)copyWithZone:(NSZone *)zone {
	return [SKUButtonSpriteStateProperties propertiesWithTexture:_texture andAlpha:_alpha andColor:_color andColorBlendFactor:_colorBlendFactor andPositionOffset:_position andXScale:_xScale andYScale:_yScale andCenterRect:_centerRect andPadding:_padding];
}

-(NSString*)description {
	return [NSString stringWithFormat:@"SKUButtonSpriteStateProperties texture: %@ alpha: %f color: %@ colorBlendFactor: %f positionOffset: %f, %f scale: %f, %f centerRect x: %f y: %f width: %f height %f", _texture, _alpha, _color, _colorBlendFactor, _position.x, _position.y, _xScale, _yScale, _centerRect.origin.x, _centerRect.origin.y, _centerRect.size.width, _centerRect.size.height];
}

+(SKUButtonSpriteStateProperties*)propertiesWithTexture:(SKTexture *)texture andAlpha:(CGFloat)alpha andColor:(UIColor *)color andColorBlendFactor:(CGFloat)colorBlendFactor andPositionOffset:(CGPoint)position andXScale:(CGFloat)xScale andYScale:(CGFloat)yScale andCenterRect:(CGRect)centerRect andPadding:(CGFloat)padding {
	SKUButtonSpriteStateProperties* props = [[SKUButtonSpriteStateProperties alloc] init];
	props.alpha = alpha;
	props.color = color;
	props.colorBlendFactor = colorBlendFactor;
	props.position = position;
	props.xScale = xScale;
	props.yScale = yScale;
	props.texture = texture;
	props.centerRect = centerRect;
	props.padding = padding;
	return props;
}

+(SKUButtonSpriteStateProperties*)propertiesWithTexture:(SKTexture*)texture andAlpha:(CGFloat)alpha andColor:(SKColor *)color andColorBlendFactor:(CGFloat)colorBlendFactor andPositionOffset:(CGPoint)position andXScale:(CGFloat)xScale andYScale:(CGFloat)yScale andCenterRect:(CGRect)centerRect {
	SKUButtonSpriteStateProperties* props = [[SKUButtonSpriteStateProperties alloc] init];
	props.alpha = alpha;
	props.color = color;
	props.colorBlendFactor = colorBlendFactor;
	props.position = position;
	props.xScale = xScale;
	props.yScale = yScale;
	props.texture = texture;
	props.centerRect = centerRect;
	props.padding = 30.0;
	return props;
}

+(SKUButtonSpriteStateProperties*)propertiesWithTexture:(SKTexture*)texture andAlpha:(CGFloat)alpha andColor:(SKColor *)color andColorBlendFactor:(CGFloat)colorBlendFactor andPositionOffset:(CGPoint)position andXScale:(CGFloat)xScale andYScale:(CGFloat)yScale {
	SKUButtonSpriteStateProperties* props = [[SKUButtonSpriteStateProperties alloc] init];
	props.alpha = alpha;
	props.color = color;
	props.colorBlendFactor = colorBlendFactor;
	props.position = position;
	props.xScale = xScale;
	props.yScale = yScale;
	props.texture = texture;
	props.centerRect = CGRectMake(0, 0, 1.0, 1.0);
	props.padding = 30.0;
	return props;
}

+(SKUButtonSpriteStateProperties*)propertiesWithTexture:(SKTexture*)texture andAlpha:(CGFloat)alpha andColor:(SKColor*)color andColorBlendFactor:(CGFloat)colorBlendFactor andPositionOffset:(CGPoint)position {
	SKUButtonSpriteStateProperties* props = [[SKUButtonSpriteStateProperties alloc] init];
	props.alpha = alpha;
	props.color = color;
	props.colorBlendFactor = colorBlendFactor;
	props.position = position;
	props.xScale = 1.0f;
	props.yScale = 1.0f;
	props.texture = texture;
	props.centerRect = CGRectMake(0, 0, 1.0, 1.0);
	props.padding = 30.0;
	return props;
}

+(SKUButtonSpriteStateProperties*)propertiesWithTexture:(SKTexture*)texture andAlpha:(CGFloat)alpha andColor:(SKColor *)color andColorBlendFactor:(CGFloat)colorBlendFactor {
	SKUButtonSpriteStateProperties* props = [[SKUButtonSpriteStateProperties alloc] init];
	props.alpha = alpha;
	props.color = color;
	props.colorBlendFactor = colorBlendFactor;
	props.position = CGPointZero;
	props.xScale = 1.0f;
	props.yScale = 1.0f;
	props.texture = texture;
	props.centerRect = CGRectMake(0, 0, 1.0, 1.0);
	props.padding = 30.0;
	return props;
}

+(SKUButtonSpriteStateProperties*)propertiesWithTexture:(SKTexture*)texture andAlpha:(CGFloat)alpha {
	SKUButtonSpriteStateProperties* props = [[SKUButtonSpriteStateProperties alloc] init];
	props.alpha = alpha;
	props.color = [SKColor clearColor];
	props.colorBlendFactor = 0.0f;
	props.position = CGPointZero;
	props.xScale = 1.0f;
	props.yScale = 1.0f;
	props.texture = texture;
	props.centerRect = CGRectMake(0, 0, 1.0, 1.0);
	props.padding = 30.0;
	return props;
}

+(SKUButtonSpriteStateProperties*)propertiesWithDefaultsSKU {
	SKTexture* buttonBG = [SKTexture textureWithImageNamed:@"buttonBG_SKU"];
	SKUButtonSpriteStateProperties* props = [[SKUButtonSpriteStateProperties alloc] init];
	props.alpha = 1.0f;
	props.color = [SKColor clearColor];
	props.colorBlendFactor = 0.0f;
	props.position = CGPointMake(0, 0.0);
	props.xScale = 1.0f;
	props.yScale = 1.0f;
	props.texture = buttonBG;
	props.centerRect = CGRectMake(40.0/buttonBG.size.width, 60.0/buttonBG.size.height, 40.0/buttonBG.size.width, 40.0/buttonBG.size.height);
	props.padding = 30.0;
	return props;
}


+(SKUButtonSpriteStateProperties*)propertiesWithDefaultsToggleOnSKU {
	SKTexture* tex = [SKTexture textureWithImageNamed:@"checkBoxOnSKU"];
	SKUButtonSpriteStateProperties* props = [[SKUButtonSpriteStateProperties alloc] init];
	props.alpha = 1.0f;
	props.color = [SKColor clearColor];
	props.colorBlendFactor = 0.0f;
	props.position = CGPointMake(0, 0);
	props.xScale = 1.0f;
	props.yScale = 1.0f;
	props.texture = tex;
	props.centerRect = CGRectMake(0, 0, 1.0, 1.0);
	props.padding = 30.0;
	return props;
}

+(SKUButtonSpriteStateProperties*)propertiesWithDefaultsToggleOffSKU {
	SKTexture* tex = [SKTexture textureWithImageNamed:@"checkBoxOffSKU"];
	SKUButtonSpriteStateProperties* props = [[SKUButtonSpriteStateProperties alloc] init];
	props.alpha = 1.0f;
	props.color = [SKColor clearColor];
	props.colorBlendFactor = 0.0f;
	props.position = CGPointMake(0, 0);
	props.xScale = 1.0f;
	props.yScale = 1.0f;
	props.texture = tex;
	props.centerRect = CGRectMake(0, 0, 1.0, 1.0);
	props.padding = 30.0;
	return props;
}

+(SKUButtonSpriteStateProperties*)propertiesWithDefaultsSliderKnobSKU:(BOOL)pressed {
	NSString* name;
	if (pressed) {
		name = @"knobSKU";
	} else {
		name = @"knobPressedSKU";
	}
	SKTexture* tex = [SKTexture textureWithImageNamed:name];
	SKUButtonSpriteStateProperties* props = [[SKUButtonSpriteStateProperties alloc] init];
	props.alpha = 1.0f;
	props.color = [SKColor clearColor];
	props.colorBlendFactor = 0.0f;
	props.position = CGPointMake(0, 0);
	props.xScale = 1.0f;
	props.yScale = 1.0f;
	props.texture = tex;
	props.centerRect = CGRectMake(0, 0, 1.0, 1.0);
	props.padding = 0.0;
	return props;
}

+(SKUButtonSpriteStateProperties*)propertiesWithDefaultsSliderSlideSKU {
	SKTexture* tex = [SKTexture textureWithImageNamed:@"slideSKU"];
	SKUButtonSpriteStateProperties* props = [[SKUButtonSpriteStateProperties alloc] init];
	props.alpha = 1.0f;
	props.color = [SKColor clearColor];
	props.colorBlendFactor = 0.0f;
	props.position = CGPointMake(0, 0);
	props.xScale = 1.0f;
	props.yScale = 1.0f;
	props.texture = tex;
	props.centerRect = CGRectMake(15.0/tex.size.width, 0, 40.0/tex.size.width, 1.0);
	props.padding = 0.0;
	return props;
}



-(void)setScale:(CGFloat)scale {
	_xScale = scale;
	_yScale = scale;
}

@end

@implementation SKUButtonSpriteStatePropertiesPackage

-(id)init {
	if (self = [super init]) {
		
	}
	return self;
}

-(NSString*)description {
	return [NSString stringWithFormat:@"SKUButtonSpriteStatePropertiesPackage: {\n\tDefaultState: %@\n\tPressedState: %@\n\tHoveredState: %@\n\tDisabledState: %@\n}", _propertiesDefaultState, _propertiesPressedState, _propertiesHoveredState, _propertiesDisabledState];
}

-(id)copyWithZone:(NSZone *)zone {
	return [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_propertiesDefaultState.copy andPressedState:_propertiesPressedState.copy andHoveredState:_propertiesHoveredState.copy andDisabledState:_propertiesDisabledState.copy];
}

+(SKUButtonSpriteStatePropertiesPackage*)packageWithPropertiesForDefaultState:(SKUButtonSpriteStateProperties*)defaultState andPressedState:(SKUButtonSpriteStateProperties*)pressedState andHoveredState:(SKUButtonSpriteStateProperties*)hoveredState andDisabledState:(SKUButtonSpriteStateProperties*)disabledState {
	SKUButtonSpriteStatePropertiesPackage* package = [[SKUButtonSpriteStatePropertiesPackage alloc] init];
	package.propertiesDefaultState = defaultState;
	package.propertiesPressedState = pressedState;
	package.propertiesHoveredState = hoveredState;
	package.propertiesDisabledState = disabledState;
	return package;}


+(SKUButtonSpriteStatePropertiesPackage*)packageWithPropertiesForDefaultState:(SKUButtonSpriteStateProperties *)defaultState andPressedState:(SKUButtonSpriteStateProperties *)pressedState andDisabledState:(SKUButtonSpriteStateProperties *)disabledState {
	SKUButtonSpriteStatePropertiesPackage* package = [[SKUButtonSpriteStatePropertiesPackage alloc] init];
	package.propertiesDefaultState = defaultState;
	package.propertiesPressedState = pressedState;
	package.propertiesHoveredState = defaultState.copy;
	package.propertiesHoveredState.xScale *= skuHoverScale;
	package.propertiesHoveredState.yScale *= skuHoverScale;
	package.propertiesDisabledState = disabledState;
	return package;
}

+(SKUButtonSpriteStatePropertiesPackage*)packageWithPropertiesForDefaultState:(SKUButtonSpriteStateProperties *)defaultState andPressedState:(SKUButtonSpriteStateProperties *)pressedState {
	SKUButtonSpriteStatePropertiesPackage* package = [[SKUButtonSpriteStatePropertiesPackage alloc] init];
	package.propertiesDefaultState = defaultState;
	package.propertiesPressedState = pressedState;
	package.propertiesHoveredState = defaultState.copy;
	package.propertiesHoveredState.xScale *= skuHoverScale;
	package.propertiesHoveredState.yScale *= skuHoverScale;
	package.propertiesDisabledState = defaultState.copy;
	package.propertiesDisabledState.alpha *= 0.5;
	return package;
}

+(SKUButtonSpriteStatePropertiesPackage*)packageWithPropertiesForDefaultState:(SKUButtonSpriteStateProperties *)defaultState {
	SKUButtonSpriteStatePropertiesPackage* package = [[SKUButtonSpriteStatePropertiesPackage alloc] init];
	package.propertiesDefaultState = defaultState;
	package.propertiesPressedState = defaultState.copy;
	package.propertiesPressedState.color = [SKColor grayColor];
	package.propertiesPressedState.colorBlendFactor = 0.5;
	package.propertiesHoveredState = defaultState.copy;
	package.propertiesHoveredState.xScale *= skuHoverScale;
	package.propertiesHoveredState.yScale *= skuHoverScale;
	package.propertiesDisabledState = defaultState.copy;
	package.propertiesDisabledState.alpha *= 0.5;
	return package;
}

+(SKUButtonSpriteStatePropertiesPackage*)packageWithDefaultPropertiesSKU {
	SKUButtonSpriteStatePropertiesPackage* package = [[SKUButtonSpriteStatePropertiesPackage alloc] init];
	package.propertiesDefaultState = [SKUButtonSpriteStateProperties propertiesWithDefaultsSKU];
	package.propertiesPressedState = package.propertiesDefaultState.copy;
	package.propertiesPressedState.color = [SKColor grayColor];
	package.propertiesPressedState.colorBlendFactor = 0.5;
	package.propertiesHoveredState = package.propertiesDefaultState.copy;
	package.propertiesHoveredState.texture = [SKTexture textureWithImageNamed:@"buttonHoverBG_SKU"];
	package.propertiesHoveredState.xScale *= skuHoverScale;
	package.propertiesHoveredState.yScale *= skuHoverScale;
	package.propertiesDisabledState = package.propertiesDefaultState.copy;
	package.propertiesDisabledState.alpha *= 0.5;
	return package;
}

+(SKUButtonSpriteStatePropertiesPackage*)packageWithDefaultToggleOnPropertiesSKU {
	return [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:[SKUButtonSpriteStateProperties propertiesWithDefaultsToggleOnSKU]];
}

+(SKUButtonSpriteStatePropertiesPackage*)packageWithDefaultToggleOffPropertiesSKU {
	return [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:[SKUButtonSpriteStateProperties propertiesWithDefaultsToggleOffSKU]];
}

+(SKUButtonSpriteStatePropertiesPackage*)packageWithDefaultSliderKnobPropertiesSKU {
	SKUButtonSpriteStatePropertiesPackage* package = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:[SKUButtonSpriteStateProperties propertiesWithDefaultsSliderKnobSKU:NO]];
	package.propertiesPressedState = [SKUButtonSpriteStateProperties propertiesWithDefaultsSliderKnobSKU:YES];
	return package;
}

+(SKUButtonSpriteStatePropertiesPackage*)packageWithDefaultSliderSliderSlidePropertiesSKU {
	SKUButtonSpriteStatePropertiesPackage* package = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:[SKUButtonSpriteStateProperties propertiesWithDefaultsSliderSlideSKU]];
	package.propertiesPressedState = package.propertiesDefaultState.copy;
	package.propertiesHoveredState = package.propertiesDefaultState.copy;
	return package;
}

-(void)changeTexture:(SKTexture *)texture {
	_propertiesDefaultState.texture = texture;
	_propertiesPressedState.texture = texture;
	_propertiesDisabledState.texture = texture;
	_propertiesHoveredState.texture = texture;
}

-(void)changePadding:(CGFloat)padding {
	_propertiesDefaultState.padding = padding;
	_propertiesPressedState.padding = padding;
	_propertiesDisabledState.padding = padding;
	_propertiesHoveredState.padding = padding;
}

@end

#pragma mark SKUButton
@interface SKUButton() {
	NSInvocation* downSelector;
	NSInvocation* upSelector;
	SKUButtonSpriteStateProperties* defaultProperties;
	CGFloat padding;
	
	BOOL stateDefaultInitialized;
	BOOL statePressedInitialized;
	BOOL stateDisabledInitialized;
	BOOL stateHoveredInitialized;
}

@end

@implementation SKUButton
#pragma mark SKUButton INITERs
-(id)init {
	if (self = [super init]) {
	}
	[self internalPreDidInitialize];
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
	}
	[self internalPreDidInitialize];
	return self;
}

+(SKUButton*)buttonWithImageNamed:(NSString*)name {
	SKUButton* button = [SKUButton node];
	SKTexture* texture = [SKTexture textureWithImageNamed:name];
	button.baseSpritePropertiesDefault = [SKUButtonSpriteStateProperties propertiesWithTexture:texture andAlpha:1.0];
	[button buttonStatesDefault];
	return button;
}

+(SKUButton*)buttonWithTexture:(SKTexture*)texture {
	SKUButton* button = [SKUButton node];
	button.baseSpritePropertiesDefault = [SKUButtonSpriteStateProperties propertiesWithTexture:texture andAlpha:1.0];
	[button buttonStatesDefault];
	return button;
}

+(SKUButton*)buttonWithPropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)package {
	SKUButton* button = [SKUButton node];
	[button setBaseStatesWithPackage:package];
	return button;
}

-(void)internalPreDidInitialize {
	_buttonType = 0;
	_whichButton = 0;
	_buttonMethod = 0;
	_buttonState = kSKUButtonStateDefault;
	self.name = @"SKUButton";

	SKTexture* tex = [SKTexture textureVectorNoiseWithSmoothness:1.0 size:CGSizeMake(2, 2)];
	defaultProperties = [SKUButtonSpriteStateProperties propertiesWithTexture:tex andAlpha:1.0];
	_baseSpritePropertiesDefault = defaultProperties.copy;
	_baseSpritePropertiesPressed = defaultProperties.copy;
	_baseSpritePropertiesDisabled = defaultProperties.copy;
	_baseSpritePropertiesHovered = defaultProperties.copy;
	stateDefaultInitialized = NO;
	statePressedInitialized = NO;
	stateDisabledInitialized = NO;
	stateHoveredInitialized = NO;
	padding = 30.0f;
	
	[self internalDidInitialize];
	[self enableButton];
	[self didInitialize];
}

-(void)internalDidInitialize {
	if (!_baseSprite) {
		_baseSprite = [SKSpriteNode spriteNodeWithTexture:_baseSpritePropertiesDefault.texture];
		_baseSprite.zPosition = 0.0;
		_baseSprite.name = @"SKUButtonBaseSprite";
		[self addChild:_baseSprite];
	}
}

-(void)didInitialize {
}

#pragma mark SKUButton ACTION SETTERS

-(void)setDownAction:(SEL)selector toPerformOnTarget:(NSObject*)target {
	NSMethodSignature* sig = [target methodSignatureForSelector:selector];
	downSelector = [NSInvocation invocationWithMethodSignature:sig];
	[downSelector setSelector:selector];
	SKUButton* button = self;
	[downSelector setArgument:&button atIndex:2];
	[downSelector setTarget:target];
	_buttonMethod = _buttonMethod | kSKUButtonMethodRunActions;
}

-(void)setUpAction:(SEL)selector toPerformOnTarget:(NSObject*)target {
	NSMethodSignature* sig = [target methodSignatureForSelector:selector];
	upSelector = [NSInvocation invocationWithMethodSignature:sig];
	[upSelector setSelector:selector];
	SKUButton* button = self;
	[upSelector setArgument:&button atIndex:2];
	[upSelector setTarget:target];
	_buttonMethod = _buttonMethod | kSKUButtonMethodRunActions;
}

-(void)setDelegate:(id<SKUButtonDelegate>)delegate {
	_delegate = delegate;
	_buttonMethod = _buttonMethod | kSKUButtonMethodDelegate;
}

-(void)setNotificationNameDown:(NSString *)notificationNameDown {
	_notificationNameDown = notificationNameDown;
	_buttonMethod = _buttonMethod | kSKUButtonMethodPostNotification;
}

-(void)setNotificationNameUp:(NSString *)notificationNameUp {
	_notificationNameUp = notificationNameUp;
	_buttonMethod = _buttonMethod | kSKUButtonMethodPostNotification;
}

#pragma mark SKUButton OTHER SETTERS

//-(void)setDebugMode:(BOOL)debugMode {
//	_debugMode = debugMode;
//	if (_debugMode) {
//		CGSize newSize = [self calculateAccumulatedFrame].size;
//		SKULog(0, @"size: %f %f", newSize.width, newSize.height);
//		self.texture = [SKTexture textureVectorNoiseWithSmoothness:0.5 size:newSize];
//		self.color = [SKColor colorWithRed:randomFloatBetweenZeroAndHighend(1.0) green:randomFloatBetweenZeroAndHighend(1.0) blue:randomFloatBetweenZeroAndHighend(1.0) alpha:1.0];
//		self.colorBlendFactor = 1.0;
//	}
//}

-(void)setSizeMinimumBoundary:(CGSize)sizeMinimumBoundary {
	_sizeMinimumBoundary = sizeMinimumBoundary;
	self.size = sizeMinimumBoundary;
	[self updateCurrentSpriteStateProperties];
}

-(void)setSize:(CGSize)size {
	[super setSize:size];
	_sizeMinimumBoundary = size;
	[self updateCurrentSpriteStateProperties];
}

-(void)setBaseStatesWithPackage:(SKUButtonSpriteStatePropertiesPackage*)package {
	_baseSpritePropertiesDefault = package.propertiesDefaultState;
	_baseSpritePropertiesPressed = package.propertiesPressedState;
	_baseSpritePropertiesDisabled = package.propertiesDisabledState;
	_baseSpritePropertiesHovered = package.propertiesHoveredState;
	stateDefaultInitialized = YES;
	statePressedInitialized = YES;
	stateDisabledInitialized = YES;
	stateHoveredInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}

-(void)setBaseSpritePropertiesDefault:(SKUButtonSpriteStateProperties *)baseSpritePropertiesDefault {
	_baseSpritePropertiesDefault = baseSpritePropertiesDefault;
	stateDefaultInitialized = YES;
	if (!statePressedInitialized) {
		_baseSpritePropertiesPressed = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_baseSpritePropertiesDefault].propertiesPressedState;
		statePressedInitialized = YES;
	}
	if (!stateDisabledInitialized) {
		_baseSpritePropertiesDisabled = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_baseSpritePropertiesDefault].propertiesDisabledState;
		stateDisabledInitialized = YES;
	}
	if (!stateHoveredInitialized) {
		_baseSpritePropertiesHovered = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_baseSpritePropertiesDefault].propertiesHoveredState;
		stateHoveredInitialized = YES;
	}
	
	[self updateCurrentSpriteStateProperties];
}

-(void)setBaseSpritePropertiesPressed:(SKUButtonSpriteStateProperties *)baseSpritePropertiesPressed {
	_baseSpritePropertiesPressed = baseSpritePropertiesPressed;
	statePressedInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}

-(void)setBaseSpritePropertiesDisabled:(SKUButtonSpriteStateProperties *)baseSpritePropertiesDisabled {
	_baseSpritePropertiesDisabled = baseSpritePropertiesDisabled;
	stateDisabledInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}

-(void)setBaseSpritePropertiesHovered:(SKUButtonSpriteStateProperties *)baseSpritePropertiesHovered {
	_baseSpritePropertiesHovered = baseSpritePropertiesHovered;
	stateHoveredInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}

-(void)updateCurrentSpriteStateProperties {
	SKUButtonSpriteStateProperties* properties;
	switch (_buttonState) {
		case kSKUButtonStateDefault:
			properties = _baseSpritePropertiesDefault;
			break;
		case kSKUButtonStatePressed:
			properties = _baseSpritePropertiesPressed;
			break;
		case kSKUButtonStateDisabled:
			properties = _baseSpritePropertiesDisabled;
			break;
		case kSKUButtonStatePressedOutOfBounds:
			properties = _baseSpritePropertiesDefault;
			break;
		case kSKUButtonStateHovered:
			properties = _baseSpritePropertiesHovered;
			break;
			
		default:
			break;
	}
	
	SKTexture* prevTex = _baseSprite.texture;
	_baseSprite.texture = properties.texture;
	_baseSprite.xScale = 1.0;
	_baseSprite.yScale = 1.0;
	if (![prevTex isEqual:_baseSprite.texture]) {
		_baseSprite.size = properties.texture.size;
	}
	_baseSprite.position = properties.position;
	_baseSprite.color = properties.color;
	_baseSprite.colorBlendFactor = properties.colorBlendFactor;
	_baseSprite.alpha = properties.alpha;
	_baseSprite.centerRect = properties.centerRect;
	_baseSprite.xScale = properties.xScale;
	_baseSprite.yScale = properties.yScale;
	padding = properties.padding;
	
	if (_baseSprite.centerRect.origin.x != 0.0 || _baseSprite.centerRect.origin.y != 0.0 || _baseSprite.centerRect.size.width != 1.0 || _baseSprite.centerRect.size.height != 1.0) {
		CGSize thisSize = [self getButtonSizeMinusBase];
		thisSize = CGSizeMake(thisSize.width + padding * 2.0f, thisSize.height + padding * 2.0f);
		_baseSprite.xScale = thisSize.width / properties.texture.size.width;
		_baseSprite.yScale = thisSize.height / properties.texture.size.height;
	}
	
	_baseSpritePropertiesPackage = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_baseSpritePropertiesDefault andPressedState:_baseSpritePropertiesPressed andHoveredState:_baseSpritePropertiesHovered andDisabledState:_baseSpritePropertiesDisabled];
}

-(CGSize)getButtonSizeMinusBase { //// note to remember to update subclasses if any changes are made - they don't call super
	SKNode* baseParent;
	if (_baseSprite.parent) {
		baseParent = _baseSprite.parent;
		[_baseSprite removeFromParent];
	}
	[_baseSprite removeFromParent];
	CGSize thisSize = [self calculateAccumulatedFrame].size;
	if (baseParent) {
		[self addChild:_baseSprite];
	}
	return thisSize;
}

-(void)setButtonType:(kSKUButtonTypes)buttonType {
	_buttonType = buttonType;
}

#pragma mark SKUButton METHODS

-(void)enableButton {
	_isEnabled = YES;
	_buttonState = kSKUButtonStateDefault;
	[self updateCurrentSpriteStateProperties];
#if TARGET_OS_TV
	self.userInteractionEnabled = NO;
#else
	self.userInteractionEnabled = YES;
#endif
}

-(void)disableButton {
	_isEnabled = NO;
	_buttonState = kSKUButtonStateDisabled;
	[self updateCurrentSpriteStateProperties];
	self.userInteractionEnabled = NO;
}

-(void)buttonStatesNormalize {
	SKUButtonSpriteStatePropertiesPackage* package = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_baseSpritePropertiesDefault andPressedState:_baseSpritePropertiesDefault andHoveredState:_baseSpritePropertiesDefault andDisabledState:_baseSpritePropertiesDefault];
	[self setBaseStatesWithPackage:package];
}

-(void)buttonStatesDefault {
	SKUButtonSpriteStatePropertiesPackage* package = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_baseSpritePropertiesDefault];
	[self setBaseStatesWithPackage:package];
}

-(void)absoluteInputBeganSKU:(CGPoint)location withEventDictionary:(NSDictionary *)eventDict {
	[self buttonPressed:location];
}

-(void)buttonPressed:(CGPoint)location {
	if (_isEnabled) {
		_buttonState = kSKUButtonStatePressed;
		
		[self updateCurrentSpriteStateProperties];
		BOOL notificationMethod = kSKUButtonMethodPostNotification & _buttonMethod;
		BOOL delegateMethod = kSKUButtonMethodDelegate & _buttonMethod;
		BOOL actionMethod = kSKUButtonMethodRunActions & _buttonMethod;
		
		if (notificationMethod) {
			[[NSNotificationCenter defaultCenter] postNotificationName:_notificationNameDown object:self];
		}
		
		if (delegateMethod) {
			if ([_delegate respondsToSelector:@selector(doButtonDown:)]) {
				[_delegate doButtonDown:self];
			}
		}
		
		if (actionMethod) {
			[downSelector invoke];
		}
	}
}

-(void)absoluteInputMovedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary *)eventDict {
	kSKUButtonStates preState = _buttonState;
	BOOL inBounds = [self checkIfLocationIsWithinButtonBounds:location];
	if (inBounds) {
		_buttonState = kSKUButtonStatePressed;
	} else {
		_buttonState = kSKUButtonStatePressedOutOfBounds;
	}
	
	if (preState != _buttonState) {
		[self updateCurrentSpriteStateProperties];
	}
}

-(void)absoluteInputEndedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary *)eventDict {
	[self buttonReleased:location];
}

-(void)buttonReleased:(CGPoint)location {
	if (_isEnabled) {
		if (_isHovered) {
			_buttonState = kSKUButtonStateHovered;
		} else {
			_buttonState = kSKUButtonStateDefault;
		}
		
		[self updateCurrentSpriteStateProperties];
		BOOL notificationMethod = kSKUButtonMethodPostNotification & _buttonMethod;
		BOOL delegateMethod = kSKUButtonMethodDelegate & _buttonMethod;
		BOOL actionMethod = kSKUButtonMethodRunActions & _buttonMethod;
		
		BOOL locationIsInBounds = [self checkIfLocationIsWithinButtonBounds:location];
		
		if (notificationMethod && locationIsInBounds) {
			[[NSNotificationCenter defaultCenter] postNotificationName:_notificationNameUp object:self];
		}
		
		if (delegateMethod) {
			if ([_delegate respondsToSelector:@selector(doButtonUp:inBounds:)]) {
				[_delegate doButtonUp:self inBounds:locationIsInBounds];
			}
		}
		
		if (actionMethod && locationIsInBounds) {
			[upSelector invoke];
		}
	}
}

-(BOOL)checkIfLocationIsWithinButtonBounds:(CGPoint)location {
	CGRect newFrame = [self calculateAccumulatedFrame];
	CGFloat width = newFrame.size.width;
	CGFloat height = newFrame.size.height;
	newFrame.origin = CGPointMake(-width * 0.5, -height * 0.5);
	CGPathRef thePath = CGPathCreateWithRect(newFrame, NULL);
	bool answer = CGPathContainsPoint(thePath, NULL, location, YES);
	CGPathRelease(thePath);
	return answer;
}

#pragma mark SKUButton HOVER STUFF

-(void)hoverButton {
	_isHovered = YES;
	if (_buttonState != kSKUButtonStatePressed && _buttonState != kSKUButtonStateDisabled) {
		_buttonState = kSKUButtonStateHovered;
		[self updateCurrentSpriteStateProperties];
	}
}

-(void)unhoverButton {
	_isHovered = NO;
	if (_buttonState != kSKUButtonStatePressed && _buttonState != kSKUButtonStateDisabled) {
		_buttonState = kSKUButtonStateDefault;
		[self updateCurrentSpriteStateProperties];
	}
}

@end


#pragma mark SKUPushButton

@interface SKUPushButton() {
	BOOL stateTSpriteDefaultInitialized;
	BOOL stateTSpritePressedInitialized;
	BOOL stateTSpriteHoveredInitialized;
	BOOL stateTSpriteDisabledInitialized;
	BOOL stateTLabelDefaultInitialized;
	BOOL stateTLabelPressedInitialized;
	BOOL stateTLabelHoveredInitialized;
	BOOL stateTLabelDisabledInitialized;
}

@end

@implementation SKUPushButton
#pragma mark SKUPushButton inits

+(SKUPushButton*)pushButtonWithTitle:(NSString*)title{
	SKUPushButton* button = [SKUPushButton node];
	[button setBaseStatesWithPackage:[SKUButtonSpriteStatePropertiesPackage packageWithDefaultPropertiesSKU]];
	[button setTitleLabelStatesWithPackage:[SKUButtonLabelPropertiesPackage packageWithDefaultPropertiesWithText:title]];
	return button;
}

+(SKUPushButton*)pushButtonWithBackgroundPropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)backgroundPackage andForeGroundSpritePropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)foregroundPackage {
	SKUPushButton* button = [SKUPushButton node];
	[button setBaseStatesWithPackage:backgroundPackage];
	[button setTitleSpriteStatesWithPackage:foregroundPackage];
	return button;
}

+(SKUPushButton*)pushButtonWithBackgroundPropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)backgroundPackage andTitleLabelPropertiesPackage:(SKUButtonLabelPropertiesPackage*)titlePackage {
	SKUPushButton* button = [SKUPushButton node];
	[button setBaseStatesWithPackage:backgroundPackage];
	[button setTitleLabelStatesWithPackage:titlePackage];
	return button;
}

+(SKUPushButton*)pushButtonWithBackgroundPropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)backgroundPackage andForeGroundSpritePropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)foregroundPackage andTitleLabelPropertiesPackage:(SKUButtonLabelPropertiesPackage*)titlePackage {
	SKUPushButton* button = [SKUPushButton node];
	[button setBaseStatesWithPackage:backgroundPackage];
	[button setTitleSpriteStatesWithPackage:foregroundPackage];
	[button setTitleLabelStatesWithPackage:titlePackage];
	return button;
}


-(void)internalDidInitialize {
	stateTSpriteDefaultInitialized = NO;
	stateTSpritePressedInitialized = NO;
	stateTSpriteHoveredInitialized = NO;
	stateTSpriteDisabledInitialized = NO;
	stateTLabelDefaultInitialized = NO;
	stateTLabelPressedInitialized = NO;
	stateTLabelHoveredInitialized = NO;
	stateTLabelDisabledInitialized = NO;
	[self setButtonType:kSKUButtonTypePush];
	self.name = @"SKUPushButton";
	[super internalDidInitialize];
}

#pragma mark SKUPushButton setters

-(void)updateCurrentSpriteStateProperties {
	SKUButtonSpriteStateProperties* propertiesSprite;
	SKUButtonLabelProperties* propertiesLabel;
	switch (self.buttonState) {
		case kSKUButtonStateDefault:
			propertiesSprite = _titleSpritePropertiesDefault;
			propertiesLabel = _labelPropertiesDefault;
			break;
		case kSKUButtonStatePressed:
			propertiesSprite = _titleSpritePropertiesPressed;
			propertiesLabel = _labelPropertiesPressed;
			break;
		case kSKUButtonStateHovered:
			propertiesSprite = _titleSpritePropertiesHovered;
			propertiesLabel = _labelPropertiesHovered;
			break;
		case kSKUButtonStateDisabled:
			propertiesSprite = _titleSpritePropertiesDisabled;
			propertiesLabel = _labelPropertiesDisabled;
			break;
		case kSKUButtonStatePressedOutOfBounds:
			propertiesSprite = _titleSpritePropertiesDefault;
			propertiesLabel = _labelPropertiesDefault;
			break;
			
		default:
			break;
	}
	
	if (_titleSprite) {
		SKTexture* prevTex = _titleSprite.texture;
		_titleSprite.texture = propertiesSprite.texture;
		if (![prevTex isEqual:_titleSprite.texture]) {
			_titleSprite.size = propertiesSprite.texture.size;
		}
		_titleSprite.position = propertiesSprite.position;
		_titleSprite.color = propertiesSprite.color;
		_titleSprite.colorBlendFactor = propertiesSprite.colorBlendFactor;
		_titleSprite.alpha = propertiesSprite.alpha;
		_titleSprite.centerRect = propertiesSprite.centerRect;
		_titleSprite.xScale = propertiesSprite.xScale;
		_titleSprite.yScale = propertiesSprite.yScale;
	}
	
	if (_titleLabel) {
		_titleLabel.text = propertiesLabel.text;
		_titleLabel.fontColor = propertiesLabel.fontColor;
		_titleLabel.fontSize = propertiesLabel.fontSize;
		_titleLabel.fontName = propertiesLabel.fontName;
		_titleLabel.position = propertiesLabel.position;
		_titleLabel.xScale = propertiesLabel.scale;
		_titleLabel.yScale = propertiesLabel.scale;
	}
	[super updateCurrentSpriteStateProperties];

	
	_labelPropertiesPackage = [SKUButtonLabelPropertiesPackage packageWithPropertiesForDefaultState:_labelPropertiesDefault andPressedState:_labelPropertiesPressed andHoveredState:_labelPropertiesHovered andDisabledState:_labelPropertiesDisabled];
}

-(void)setTitleSpritePropertiesDefault:(SKUButtonSpriteStateProperties *)titleSpritePropertiesDefault {
	_titleSpritePropertiesDefault = titleSpritePropertiesDefault;
	if (!_titleSprite) {
		_titleSprite = [SKSpriteNode spriteNodeWithTexture:_titleSpritePropertiesDefault.texture];
		_titleSprite.zPosition = 0.001;
		_titleSprite.name = @"SKUPushButtonTitleSprite";
		[self addChild:_titleSprite];
	}
	stateTSpriteDefaultInitialized = YES;
	
	if (!stateTSpritePressedInitialized) {
		_titleSpritePropertiesPressed = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_titleSpritePropertiesDefault].propertiesPressedState;
		stateTSpritePressedInitialized = YES;
	}
	
	if (!stateTSpriteHoveredInitialized) {
		_titleSpritePropertiesHovered = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_titleSpritePropertiesDefault].propertiesHoveredState;
		stateTSpriteHoveredInitialized = YES;
	}
	
	if (!stateTSpriteDisabledInitialized) {
		_titleSpritePropertiesDisabled = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_titleSpritePropertiesDefault].propertiesDisabledState;
		stateTSpriteDisabledInitialized = YES;
	}
	
	[self updateCurrentSpriteStateProperties];
}

-(void)setTitleSpritePropertiesPressed:(SKUButtonSpriteStateProperties *)titleSpritePropertiesPressed {
	_titleSpritePropertiesPressed = titleSpritePropertiesPressed;
	stateTSpritePressedInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}

-(void)setTitleSpritePropertiesHovered:(SKUButtonSpriteStateProperties *)titleSpritePropertiesHovered {
	_titleSpritePropertiesHovered = titleSpritePropertiesHovered;
	stateTSpriteHoveredInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}

-(void)setTitleSpriteDisabledProperties:(SKUButtonSpriteStateProperties *)titleSpriteDisabledProperties {
	_titleSpritePropertiesDisabled = titleSpriteDisabledProperties;
	stateTSpriteDisabledInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}

-(void)setLabelPropertiesDefault:(SKUButtonLabelProperties *)labelPropertiesDefault {
	_labelPropertiesDefault = labelPropertiesDefault;
	if (!_titleLabel) {
		_titleLabel = [SKLabelNode labelNodeWithFontNamed:_labelPropertiesDefault.fontName];
		_titleLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
		_titleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
		_titleLabel.zPosition = 0.002;
		_titleLabel.name = @"SKUPushButtonTitleLabel";
		[self addChild:_titleLabel];
	}
	stateTLabelDefaultInitialized = YES;
	
	if (!stateTLabelPressedInitialized) {
		_labelPropertiesPressed = [SKUButtonLabelPropertiesPackage packageWithPropertiesForDefaultState:_labelPropertiesDefault].propertiesPressedState;
		stateTLabelPressedInitialized = YES;
	}
	
	if (!stateTLabelHoveredInitialized) {
		_labelPropertiesHovered = [SKUButtonLabelPropertiesPackage packageWithPropertiesForDefaultState:_labelPropertiesDefault].propertiesHoveredState;
		stateTLabelHoveredInitialized = YES;
	}
	
	if (!stateTLabelDisabledInitialized) {
		_labelPropertiesDisabled = [SKUButtonLabelPropertiesPackage packageWithPropertiesForDefaultState:_labelPropertiesDefault].propertiesDisabledState;
		stateTLabelDisabledInitialized = YES;
	}
	[self updateCurrentSpriteStateProperties];
}

-(void)setLabelPropertiesPressed:(SKUButtonLabelProperties *)labelPropertiesPressed {
	_labelPropertiesPressed = labelPropertiesPressed;
	stateTLabelPressedInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}

-(void)setLabelPropertiesHovered:(SKUButtonLabelProperties *)labelPropertiesHovered {
	_labelPropertiesHovered = labelPropertiesHovered;
	stateTLabelHoveredInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}

-(void)setLabelPropertiesDisabled:(SKUButtonLabelProperties *)labelPropertiesDisabled {
	_labelPropertiesDisabled = labelPropertiesDisabled;
	stateTLabelDisabledInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}

-(void)setTitleSpriteStatesWithPackage:(SKUButtonSpriteStatePropertiesPackage*)package {
	_titleSpritePropertiesPressed = package.propertiesPressedState;
	stateTSpritePressedInitialized = YES;
	_titleSpritePropertiesHovered = package.propertiesHoveredState;
	stateTSpriteHoveredInitialized = YES;
	_titleSpritePropertiesDisabled = package.propertiesDisabledState;
	stateTSpriteDisabledInitialized = YES;
	self.titleSpritePropertiesDefault = package.propertiesDefaultState;
	stateTSpriteDefaultInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}

-(void)setTitleLabelStatesWithPackage:(SKUButtonLabelPropertiesPackage*)package {
	_labelPropertiesPressed = package.propertiesPressedState;
	stateTLabelPressedInitialized = YES;
	_labelPropertiesHovered = package.propertiesHoveredState;
	stateTLabelHoveredInitialized = YES;
	_labelPropertiesDisabled = package.propertiesDisabledState;
	stateTLabelDisabledInitialized = YES;
	self.labelPropertiesDefault = package.propertiesDefaultState;
	stateTLabelDefaultInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}

-(void)changeTitleLabelText:(NSString*)text forStates:(kSKUButtonStates)states {
	BOOL stateDefault = states & kSKUButtonStateDefault,
		statePressed = states & kSKUButtonStatePressed,
		stateHovered = states & kSKUButtonStateHovered,
		stateDisabled = states & kSKUButtonStateDisabled;
	
	if (stateDefault && stateTLabelDefaultInitialized) {
		_labelPropertiesDefault.text = text;
	}
	if (statePressed && stateTLabelPressedInitialized) {
		_labelPropertiesPressed.text = text;
	}
	if (stateHovered && stateTLabelHoveredInitialized) {
		_labelPropertiesHovered.text = text;
	}
	if (stateDisabled && stateTLabelDisabledInitialized) {
		_labelPropertiesDisabled.text = text;
	}
	[self updateCurrentSpriteStateProperties];
}

-(void)buttonStatesDefault {
	[super buttonStatesDefault];
	
	if (_titleSpritePropertiesDefault.texture) {
		SKUButtonSpriteStatePropertiesPackage* package = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_titleSpritePropertiesDefault];
		[self setTitleSpriteStatesWithPackage:package];
		
	} else {
		stateTSpriteDefaultInitialized = NO;
		stateTSpritePressedInitialized = NO;
		stateTSpriteHoveredInitialized = NO;
		stateTSpriteDisabledInitialized = NO;
	}

	if (_labelPropertiesDefault.text) {
		SKUButtonLabelPropertiesPackage* package = [SKUButtonLabelPropertiesPackage packageWithPropertiesForDefaultState:_labelPropertiesDefault];
		[self setTitleLabelStatesWithPackage:package];
		
	} else {
		stateTLabelDefaultInitialized = NO;
		stateTLabelPressedInitialized = NO;
		stateTLabelHoveredInitialized = NO;
		stateTLabelDisabledInitialized = NO;
	}
}

-(void)buttonStatesNormalize {
	[super buttonStatesNormalize];
	
	if (_titleSpritePropertiesDefault.texture) {
		SKUButtonSpriteStatePropertiesPackage* package = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_titleSpritePropertiesDefault andPressedState:_titleSpritePropertiesDefault andHoveredState:_titleSpritePropertiesDefault andDisabledState:_titleSpritePropertiesDefault];
		[self setTitleSpriteStatesWithPackage:package];
	} else {
		stateTSpriteDefaultInitialized = NO;
		stateTSpritePressedInitialized = NO;
		stateTSpriteHoveredInitialized = NO;
		stateTSpriteDisabledInitialized = NO;
	}
	
	if (_labelPropertiesDefault.text) {
		SKUButtonLabelPropertiesPackage* package = [SKUButtonLabelPropertiesPackage packageWithPropertiesForDefaultState:_labelPropertiesDefault andPressedState:_labelPropertiesDefault andHoveredState:_labelPropertiesDefault andDisabledState:_labelPropertiesDefault];
		[self setTitleLabelStatesWithPackage:package];
		
	} else {
		stateTLabelDefaultInitialized = NO;
		stateTLabelPressedInitialized = NO;
		stateTLabelHoveredInitialized = NO;
		stateTLabelDisabledInitialized = NO;
	}
}

@end

#pragma mark SKUToggleButton

@interface SKUToggleButton() {
	BOOL stateToggleOnDefaultInitialized;
	BOOL stateToggleOnPressedInitialized;
	BOOL stateToggleOnHoveredInitialized;
	BOOL stateToggleOnDisabledInitialized;
	BOOL stateToggleOffDefaultInitialized;
	BOOL stateToggleOffPressedInitialized;
	BOOL stateToggleOffHoveredInitialized;
	BOOL stateToggleOffDisabledInitialized;
}

@end

@implementation SKUToggleButton

+(SKUToggleButton*)toggleButtonWithTitle:(NSString *)title {
	SKUToggleButton* button = [SKUToggleButton node];
	
	[button setBaseStatesWithPackage:[SKUButtonSpriteStatePropertiesPackage packageWithDefaultPropertiesSKU]];
	[button setTitleLabelStatesWithPackage:[SKUButtonLabelPropertiesPackage packageWithDefaultPropertiesWithText:title]];
	[button setToggleSpriteOnStatesWithPackage:[SKUButtonSpriteStatePropertiesPackage packageWithDefaultToggleOnPropertiesSKU]];
	[button setToggleSpriteOffStatesWithPackage:[SKUButtonSpriteStatePropertiesPackage packageWithDefaultToggleOffPropertiesSKU]];
	return button;
}

+(SKUToggleButton*)toggleButtonWithBackgroundPropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)backgroundPackage andForeGroundSpritePropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)foregroundPackage {
	
	SKUToggleButton* button = [SKUToggleButton node];
	[button setBaseStatesWithPackage:backgroundPackage];
	[button setTitleSpriteStatesWithPackage:foregroundPackage];
	[button setToggleSpriteOnStatesWithPackage:[SKUButtonSpriteStatePropertiesPackage packageWithDefaultToggleOnPropertiesSKU]];
	[button setToggleSpriteOffStatesWithPackage:[SKUButtonSpriteStatePropertiesPackage packageWithDefaultToggleOffPropertiesSKU]];
	return button;
}

+(SKUToggleButton*)toggleButtonWithBackgroundPropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)backgroundPackage andTitleLabelPropertiesPackage:(SKUButtonLabelPropertiesPackage*)foregroundPackage {
	
	SKUToggleButton* button = [SKUToggleButton node];
	[button setBaseStatesWithPackage:backgroundPackage];
	[button setTitleLabelStatesWithPackage:foregroundPackage];
	[button setToggleSpriteOnStatesWithPackage:[SKUButtonSpriteStatePropertiesPackage packageWithDefaultToggleOnPropertiesSKU]];
	[button setToggleSpriteOffStatesWithPackage:[SKUButtonSpriteStatePropertiesPackage packageWithDefaultToggleOffPropertiesSKU]];
	return button;
}

+(SKUToggleButton*)toggleButtonWithBackgroundPropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)backgroundPackage andForeGroundSpritePropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)foregroundPackage andToggleOnPackage:(SKUButtonSpriteStatePropertiesPackage*)toggleSpriteOnPropertiesPackage andToggleOffPackage:(SKUButtonSpriteStatePropertiesPackage*)toggleSpriteOffPropertiesPackage {
	
	SKUToggleButton* button = [SKUToggleButton node];
	[button setBaseStatesWithPackage:backgroundPackage];
	[button setTitleSpriteStatesWithPackage:foregroundPackage];
	[button setToggleSpriteOnStatesWithPackage:toggleSpriteOnPropertiesPackage];
	[button setToggleSpriteOffStatesWithPackage:toggleSpriteOffPropertiesPackage];
	return button;
}

+(SKUToggleButton*)toggleButtonWithBackgroundPropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)backgroundPackage andTitleLabelPropertiesPackage:(SKUButtonLabelPropertiesPackage*)foregroundPackage andToggleOnPackage:(SKUButtonSpriteStatePropertiesPackage*)toggleSpriteOnPropertiesPackage andToggleOffPackage:(SKUButtonSpriteStatePropertiesPackage*)toggleSpriteOffPropertiesPackage {
	
	SKUToggleButton* button = [SKUToggleButton node];
	[button setBaseStatesWithPackage:backgroundPackage];
	[button setTitleLabelStatesWithPackage:foregroundPackage];
	[button setToggleSpriteOnStatesWithPackage:toggleSpriteOnPropertiesPackage];
	[button setToggleSpriteOffStatesWithPackage:toggleSpriteOffPropertiesPackage];
	return button;
}

-(void)internalDidInitialize {
	stateToggleOnDefaultInitialized = NO;
	stateToggleOnPressedInitialized = NO;
	stateToggleOnHoveredInitialized = NO;
	stateToggleOnDisabledInitialized = NO;
	stateToggleOffDefaultInitialized = NO;
	stateToggleOffPressedInitialized = NO;
	stateToggleOffHoveredInitialized = NO;
	stateToggleOffDisabledInitialized = NO;
	[self setButtonType:kSKUButtonTypeToggle];
	self.name = @"SKUToggleButton";
	self.on = NO;
	[super internalDidInitialize];
}

-(void)updateCurrentSpriteStateProperties {
	[super updateCurrentSpriteStateProperties];
	SKUButtonSpriteStateProperties* propertiesSprite;
	if (_on) {
		switch (self.buttonState) {
			case kSKUButtonStateDefault:
				propertiesSprite = _toggleSpritePropertiesOnDefault;
				break;
			case kSKUButtonStatePressed:
				propertiesSprite = _toggleSpritePropertiesOnPressed;
				break;
			case kSKUButtonStateHovered:
				propertiesSprite = _toggleSpritePropertiesOnHovered;
				break;
			case kSKUButtonStateDisabled:
				propertiesSprite = _toggleSpritePropertiesOnDisabled;
				break;
			case kSKUButtonStatePressedOutOfBounds:
				propertiesSprite = _toggleSpritePropertiesOnDefault;
				break;
				
			default:
				break;
		}
	} else {
		switch (self.buttonState) {
			case kSKUButtonStateDefault:
				propertiesSprite = _toggleSpritePropertiesOffDefault;
				break;
			case kSKUButtonStatePressed:
				propertiesSprite = _toggleSpritePropertiesOffPressed;
				break;
			case kSKUButtonStateHovered:
				propertiesSprite = _toggleSpritePropertiesOffHovered;
				break;
			case kSKUButtonStateDisabled:
				propertiesSprite = _toggleSpritePropertiesOffDisabled;
				break;
			case kSKUButtonStatePressedOutOfBounds:
				propertiesSprite = _toggleSpritePropertiesOffDefault;
				break;
				
			default:
				break;
		}
	}
	
	
	if (_toggleSprite) {
		SKTexture* prevTex = _toggleSprite.texture;
		_toggleSprite.texture = propertiesSprite.texture;
		if (![prevTex isEqual:_toggleSprite.texture]) {
			_toggleSprite.size = propertiesSprite.texture.size;
		}
		_toggleSprite.position = propertiesSprite.position;
		_toggleSprite.color = propertiesSprite.color;
		_toggleSprite.colorBlendFactor = propertiesSprite.colorBlendFactor;
		_toggleSprite.alpha = propertiesSprite.alpha;
		_toggleSprite.centerRect = propertiesSprite.centerRect;
		_toggleSprite.xScale = propertiesSprite.xScale;
		_toggleSprite.yScale = propertiesSprite.yScale;
		
		CGSize buttonSize = [self getButtonSizeMinusBase];
		_toggleSprite.position = pointAdd(_toggleSprite.position, CGPointMake((-buttonSize.width / 2.0) - _toggleSprite.size.width * 1.25, 0.0));
		
	}

}

-(void)setOn:(BOOL)on {
	_on	= on;
	[self updateCurrentSpriteStateProperties];
}

-(void)setToggleSpritePropertiesOnDefault:(SKUButtonSpriteStateProperties *)toggleSpritePropertiesOnDefault {
	_toggleSpritePropertiesOnDefault = toggleSpritePropertiesOnDefault;
	if (!_toggleSprite) {
		_toggleSprite = [SKSpriteNode spriteNodeWithTexture:_toggleSpritePropertiesOnDefault.texture];
		_toggleSprite.zPosition = 0.003;
		_toggleSprite.name = @"SKUToggleButtonToggleSprite";
		[self addChild:_toggleSprite];
	}
	stateToggleOnDefaultInitialized = YES;
	
	if (!stateToggleOnPressedInitialized) {
		_toggleSpritePropertiesOnPressed = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_toggleSpritePropertiesOnDefault].propertiesPressedState;
		stateToggleOnPressedInitialized = YES;
	}
	
	if (!stateToggleOnHoveredInitialized) {
		_toggleSpritePropertiesOnHovered = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_toggleSpritePropertiesOnDefault].propertiesHoveredState;
		stateToggleOnHoveredInitialized = YES;
	}
	
	if (!stateToggleOnDisabledInitialized) {
		_toggleSpritePropertiesOnDisabled = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_toggleSpritePropertiesOnDefault].propertiesDisabledState;
		stateToggleOnDisabledInitialized = YES;
	}
	[self updateCurrentSpriteStateProperties];
}

-(void)setToggleSpritePropertiesOnPressed:(SKUButtonSpriteStateProperties *)toggleSpritePropertiesOnPressed {
	_toggleSpritePropertiesOnPressed = toggleSpritePropertiesOnPressed;
	stateToggleOnPressedInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}

-(void)setToggleSpritePropertiesOnHovered:(SKUButtonSpriteStateProperties *)toggleSpritePropertiesOnHovered {
	_toggleSpritePropertiesOnHovered = toggleSpritePropertiesOnHovered;
	stateToggleOnHoveredInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}

-(void)setToggleSpritePropertiesOnDisabled:(SKUButtonSpriteStateProperties *)toggleSpritePropertiesOnDisabled {
	_toggleSpritePropertiesOnDisabled = toggleSpritePropertiesOnDisabled;
	stateToggleOnDisabledInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}

-(void)setToggleSpritePropertiesOffDefault:(SKUButtonSpriteStateProperties *)toggleSpritePropertiesOffDefault {
	_toggleSpritePropertiesOffDefault = toggleSpritePropertiesOffDefault;
	if (!_toggleSprite) {
		_toggleSprite = [SKSpriteNode spriteNodeWithTexture:_toggleSpritePropertiesOffDefault.texture];
		_toggleSprite.zPosition = 0.003;
		_toggleSprite.name = @"SKUToggleButtonToggleSprite";
		[self addChild:_toggleSprite];
	}
	stateToggleOffDefaultInitialized = YES;
	
	if (!stateToggleOffPressedInitialized) {
		_toggleSpritePropertiesOffPressed = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_toggleSpritePropertiesOffDefault].propertiesPressedState;
		stateToggleOffPressedInitialized = YES;
	}
	
	if (!stateToggleOffHoveredInitialized) {
		_toggleSpritePropertiesOffHovered = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_toggleSpritePropertiesOffDefault].propertiesHoveredState;
		stateToggleOffHoveredInitialized = YES;
	}
	
	if (!stateToggleOffDisabledInitialized) {
		_toggleSpritePropertiesOffDisabled = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_toggleSpritePropertiesOffDefault].propertiesDisabledState;
		stateToggleOffDisabledInitialized = YES;
	}
	[self updateCurrentSpriteStateProperties];
}

-(void)setToggleSpritePropertiesOffPressed:(SKUButtonSpriteStateProperties *)toggleSpritePropertiesOffPressed {
	_toggleSpritePropertiesOffPressed = toggleSpritePropertiesOffPressed;
	stateToggleOffPressedInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}

-(void)setToggleSpritePropertiesOffHovered:(SKUButtonSpriteStateProperties *)toggleSpritePropertiesOffHovered {
	_toggleSpritePropertiesOffHovered = toggleSpritePropertiesOffHovered;
	stateToggleOffHoveredInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}

-(void)setToggleSpritePropertiesOffDisabled:(SKUButtonSpriteStateProperties *)toggleSpritePropertiesOffDisabled {
	_toggleSpritePropertiesOffDisabled = toggleSpritePropertiesOffDisabled;
	stateToggleOffDisabledInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}

-(void)setToggleSpriteOnStatesWithPackage:(SKUButtonSpriteStatePropertiesPackage*)package {
	_toggleSpritePropertiesOnPressed = package.propertiesPressedState;
	stateToggleOnPressedInitialized = YES;
	_toggleSpritePropertiesOnHovered = package.propertiesHoveredState;
	stateToggleOnHoveredInitialized = YES;
	_toggleSpritePropertiesOnDisabled = package.propertiesDisabledState;
	stateToggleOnDisabledInitialized = YES;
	self.toggleSpritePropertiesOnDefault = package.propertiesDefaultState;
	[self updateCurrentSpriteStateProperties];
}

-(void)setToggleSpriteOffStatesWithPackage:(SKUButtonSpriteStatePropertiesPackage*)package {
	_toggleSpritePropertiesOffPressed = package.propertiesPressedState;
	stateToggleOffPressedInitialized = YES;
	_toggleSpritePropertiesOffHovered = package.propertiesHoveredState;
	stateToggleOffHoveredInitialized = YES;
	_toggleSpritePropertiesOffDisabled = package.propertiesDisabledState;
	stateToggleOffDisabledInitialized = YES;
	self.toggleSpritePropertiesOffDefault = package.propertiesDefaultState;
	[self updateCurrentSpriteStateProperties];
}

-(void)buttonStatesDefault {
	[super buttonStatesDefault];
	
	if (_toggleSpritePropertiesOnDefault.texture) {
		SKUButtonSpriteStatePropertiesPackage* package = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_toggleSpritePropertiesOnDefault];
		[self setToggleSpriteOnStatesWithPackage:package];
	} else {
		stateToggleOnDefaultInitialized = NO;
		stateToggleOnPressedInitialized = NO;
		stateToggleOnHoveredInitialized = NO;
		stateToggleOnDisabledInitialized = NO;
	}
	
	if (_toggleSpritePropertiesOffDefault.texture) {
		SKUButtonSpriteStatePropertiesPackage* package = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_toggleSpritePropertiesOffDefault];
		[self setToggleSpriteOffStatesWithPackage:package];
	} else {
		stateToggleOffDefaultInitialized = NO;
		stateToggleOffPressedInitialized = NO;
		stateToggleOffHoveredInitialized = NO;
		stateToggleOffDisabledInitialized = NO;
	}
}

-(void)buttonStatesNormalize {
	[super buttonStatesNormalize];
	
	if (_toggleSpritePropertiesOnDefault.texture) {
		SKUButtonSpriteStatePropertiesPackage* package = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_toggleSpritePropertiesOnDefault andPressedState:_toggleSpritePropertiesOnDefault andHoveredState:_toggleSpritePropertiesOnDefault andDisabledState:_toggleSpritePropertiesOnDefault];
		[self setToggleSpriteOnStatesWithPackage:package];
	} else {
		stateToggleOnDefaultInitialized = NO;
		stateToggleOnPressedInitialized = NO;
		stateToggleOnHoveredInitialized = NO;
		stateToggleOnDisabledInitialized = NO;
	}
	
	if (_toggleSpritePropertiesOffDefault.texture) {
		SKUButtonSpriteStatePropertiesPackage* package = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_toggleSpritePropertiesOffDefault andPressedState:_toggleSpritePropertiesOffDefault andHoveredState:_toggleSpritePropertiesOffDefault andDisabledState:_toggleSpritePropertiesOffDefault];
		[self setToggleSpriteOffStatesWithPackage:package];
	} else {
		stateToggleOffDefaultInitialized = NO;
		stateToggleOffPressedInitialized = NO;
		stateToggleOffHoveredInitialized = NO;
		stateToggleOffDisabledInitialized = NO;
	}
}

-(void)buttonReleased:(CGPoint)location {
	if (self.isEnabled) {
		if ([self checkIfLocationIsWithinButtonBounds:location]) {
			[self toggleOnOff];
		}
	}
	[super buttonReleased:location];
}

-(void)toggleOnOff {
	self.on = !_on;
}

-(CGSize)getButtonSizeMinusBase {
	SKNode* baseParent, *toggleParent;
	if (self.baseSprite.parent) {
		baseParent = self.baseSprite.parent;
		[self.baseSprite removeFromParent];
	}
	if (_toggleSprite.parent) {
		toggleParent = _toggleSprite.parent;
		[_toggleSprite removeFromParent];
	}
	CGSize thisSize = [self calculateAccumulatedFrame].size;
	if (baseParent) {
		[self addChild:self.baseSprite];
	}
	if (toggleParent) {
		[self addChild:_toggleSprite];
	}
	return thisSize;
}

@end

#pragma mark SKUSliderButton

@interface SKUSliderButton() {
	
	BOOL stateKnobDefaultInitialized;
	BOOL stateKnobPressedInitialized;
	BOOL stateKnobDisabledInitialized;
	BOOL stateKnobHoveredInitialized;
	
	BOOL stateSlideDefaultInitialized;
	BOOL stateSlidePressedInitialized;
	BOOL stateSlideDisabledInitialized;
	BOOL stateSlideHoveredInitialized;
	
	BOOL stateMaxValueDefaultInitialized;
	BOOL stateMaxValueDisabledInitialized;
	
	BOOL stateMinValueDefaultInitialized;
	BOOL stateMinValueDisabledInitialized;
	
	BOOL focusStartPress;
	BOOL focusSlideMode;
	
	NSInvocation* changedSelector;
	
	CGFloat actualSlideWidth;
}

@end


@implementation SKUSliderButton

#pragma mark SKUSliderButton inits

+(SKUSliderButton*)sliderButtonWithSliderPackage:(SKUButtonSpriteStatePropertiesPackage*)sliderPackage andKnobPackage:(SKUButtonSpriteStatePropertiesPackage*)knobPackage {
	SKUSliderButton* button = [SKUSliderButton node];
	[button setSlideSpriteStatesWithPackage:sliderPackage];
	[button setKnobSpriteStatesWithPackage:knobPackage];
	return button;
}

+(SKUSliderButton*)sliderButtonWithKnobPackage:(SKUButtonSpriteStatePropertiesPackage*)knobPackage {
	SKUSliderButton* button = [SKUSliderButton node];
	[button setSlideSpriteStatesWithPackage:[SKUButtonSpriteStatePropertiesPackage packageWithDefaultSliderSliderSlidePropertiesSKU]];
	[button setKnobSpriteStatesWithPackage:knobPackage];
	return button;
}

+(SKUSliderButton*)sliderButtonWithDefaults {
	SKUSliderButton* button = [SKUSliderButton node];
	[button setSlideSpriteStatesWithPackage:[SKUButtonSpriteStatePropertiesPackage packageWithDefaultSliderSliderSlidePropertiesSKU]];
	[button setKnobSpriteStatesWithPackage:[SKUButtonSpriteStatePropertiesPackage packageWithDefaultSliderKnobPropertiesSKU]];
	return button;
}

-(void)internalDidInitialize {
	
	stateKnobDefaultInitialized = NO;
	stateKnobPressedInitialized = NO;
	stateKnobDisabledInitialized = NO;
	stateKnobHoveredInitialized = NO;
	
	stateSlideDefaultInitialized = NO;
	stateSlidePressedInitialized = NO;
	stateSlideDisabledInitialized = NO;
	stateSlideHoveredInitialized = NO;
	
	stateMaxValueDefaultInitialized = NO;
	stateMaxValueDisabledInitialized = NO;
	
	stateMinValueDefaultInitialized = NO;
	stateMinValueDisabledInitialized = NO;
	
	_value = 50.0;
	_maximumValue = 100.0;
	_minimumValue = 0.0f;
	_continuous = NO;
	_stepSize = 0.0f;
	self.sliderWidth = 200.0f;
	
	self.name = @"SKUSliderButton";
	
	[self setButtonType:kSKUButtonTypeSlider];
	[super internalDidInitialize];
}

#pragma mark SKUSliderButton updates


-(void)updateCurrentSpriteStateProperties {
	[super updateCurrentSpriteStateProperties];
	SKUButtonSpriteStateProperties* knobProperties;
	SKUButtonSpriteStateProperties* slideProperties;
	SKUButtonSpriteStateProperties* maxProperties;
	SKUButtonSpriteStateProperties* minProperties;
	switch (self.buttonState) {
		case kSKUButtonStateDefault:
			knobProperties = _knobSpritePropertiesDefault;
			maxProperties = _maximumValueImagePropertiesDefault;
			minProperties = _minimumValueImagePropertiesDefault;
			slideProperties = _slideSpritePropertiesDefault;
			break;
		case kSKUButtonStatePressed:
			knobProperties = _knobSpritePropertiesPressed;
			maxProperties = _maximumValueImagePropertiesDefault;
			minProperties = _minimumValueImagePropertiesDefault;
			slideProperties = _slideSpritePropertiesPressed;
			break;
		case kSKUButtonStateHovered:
			knobProperties = _knobSpritePropertiesHovered;
			maxProperties = _maximumValueImagePropertiesDefault;
			minProperties = _minimumValueImagePropertiesDefault;
			slideProperties = _slideSpritePropertiesHovered;
			break;
		case kSKUButtonStateDisabled:
			knobProperties = _knobSpritePropertiesDisabled;
			maxProperties = _maximumValueImagePropertiesDisabled;
			minProperties = _minimumValueImagePropertiesDisabled;
			slideProperties = _slideSpritePropertiesDisabled;
			break;
		case kSKUButtonStatePressedOutOfBounds:
			knobProperties = _knobSpritePropertiesPressed;
			maxProperties = _maximumValueImagePropertiesDefault;
			minProperties = _minimumValueImagePropertiesDefault;
			slideProperties = _slideSpritePropertiesPressed;
			break;
			
		default:
			knobProperties = _knobSpritePropertiesDefault;
			maxProperties = _maximumValueImagePropertiesDefault;
			minProperties = _minimumValueImagePropertiesDefault;
			slideProperties = _slideSpritePropertiesDefault;
			break;
	}
	
	if (_knobSprite) {
		SKTexture* prevTex = _knobSprite.texture;
		_knobSprite.texture = knobProperties.texture;
		if (![prevTex isEqual:_knobSprite.texture]) {
			_knobSprite.size = knobProperties.texture.size;
		}
		_knobSprite.position = CGPointZero;
		_knobSprite.color = knobProperties.color;
		_knobSprite.colorBlendFactor = knobProperties.colorBlendFactor;
		_knobSprite.alpha = knobProperties.alpha;
		_knobSprite.centerRect = knobProperties.centerRect;
		_knobSprite.xScale = knobProperties.xScale;
		_knobSprite.yScale = knobProperties.yScale;
	}
	
	if (_maximumValueImage) {
		SKTexture* prevTex = _maximumValueImage.texture;
		_maximumValueImage.texture = maxProperties.texture;
		if (![prevTex isEqual:_maximumValueImage.texture]) {
			_maximumValueImage.size = maxProperties.texture.size;
		}
		_maximumValueImage.position = maxProperties.position;
		_maximumValueImage.color = maxProperties.color;
		_maximumValueImage.colorBlendFactor = maxProperties.colorBlendFactor;
		_maximumValueImage.alpha = maxProperties.alpha;
		_maximumValueImage.centerRect = maxProperties.centerRect;
		_maximumValueImage.xScale = maxProperties.xScale;
		_maximumValueImage.yScale = maxProperties.yScale;
		
		CGSize buttonSize = [self getButtonSizeMinusBase];
		_maximumValueImage.position = pointAdd(_maximumValueImage.position, CGPointMake(buttonSize.width * 0.5 + _maximumValueImage.texture.size.width * 0.5, 0));
	}
	
	if (_minimumValueImage) {
		SKTexture* prevTex = _minimumValueImage.texture;
		_minimumValueImage.texture = minProperties.texture;
		if (![prevTex isEqual:_minimumValueImage.texture]) {
			_minimumValueImage.size = minProperties.texture.size;
		}
		_minimumValueImage.position = minProperties.position;
		_minimumValueImage.color = minProperties.color;
		_minimumValueImage.colorBlendFactor = minProperties.colorBlendFactor;
		_minimumValueImage.alpha = minProperties.alpha;
		_minimumValueImage.centerRect = minProperties.centerRect;
		_minimumValueImage.xScale = minProperties.xScale;
		_minimumValueImage.yScale = minProperties.yScale;

		CGSize buttonSize = [self getButtonSizeMinusBase];
		_minimumValueImage.position = pointAdd(_minimumValueImage.position, CGPointMake(-buttonSize.width * 0.5 - _minimumValueImage.texture.size.width * 0.5, 0));
	}
	
	if(_slideSprite) {
		SKTexture* prevTex = _slideSprite.texture;
		_slideSprite.texture = slideProperties.texture;
		if (![prevTex isEqual:_slideSprite.texture]) {
			_slideSprite.size = slideProperties.texture.size;
		}
		_slideSprite.position = slideProperties.position;
		_slideSprite.color = slideProperties.color;
		_slideSprite.colorBlendFactor = slideProperties.colorBlendFactor;
		_slideSprite.alpha = slideProperties.alpha;
		_slideSprite.centerRect = slideProperties.centerRect;
		_slideSprite.yScale = slideProperties.yScale;
		_slideSprite.xScale = _sliderWidth / _slideSprite.texture.size.width;
//		SKULog(0, @"xScale = %f", _slideSprite.xScale);
	}
	[self updateKnobPosition];
}

-(CGSize)getButtonSizeMinusBase {
	
	SKNode* baseParent, *minParent, *maxParent;
	if (self.baseSprite.parent) {
		baseParent = self.baseSprite.parent;
		[self.baseSprite removeFromParent];
	}
	if (_minimumValueImage.parent) {
		minParent = _minimumValueImage.parent;
		[_minimumValueImage removeFromParent];
	}
	if (_maximumValueImage.parent) {
		maxParent = _maximumValueImage.parent;
		[_maximumValueImage removeFromParent];
	}
	
	
	CGSize thisSize = [self calculateAccumulatedFrame].size;
	if (baseParent) {
		[self addChild:self.baseSprite];
	}
	
	if (minParent) {
		[minParent addChild:_minimumValueImage];
	}
	if (maxParent) {
		[maxParent addChild:_maximumValueImage];
	}
	return thisSize;
	
}

-(CGFloat)getActualWidthFromTexture:(SKTexture*)texture withCenterRect:(CGRect)rect {
	CGFloat tWidth = texture.size.width;
	CGFloat sectionANorm = rect.origin.x;
	CGFloat sectionABNorm = rect.size.width + sectionANorm;
	CGFloat sectionAPoints = sectionANorm * tWidth;
	CGFloat sectionCPoints = tWidth - (tWidth * sectionABNorm);
	CGFloat rWidth = _sliderWidth - (sectionAPoints + sectionCPoints);
	return rWidth;
}


-(void)updateKnobPosition {
	CGFloat extremesDifference = _maximumValue - _minimumValue;
	CGFloat normalValue = (_value - _minimumValue) / extremesDifference;
	CGFloat xPos = linearInterpolationBetweenFloatValues(-actualSlideWidth * 0.5, actualSlideWidth * 0.5, normalValue, YES);
	_knobSprite.position = CGPointMake(xPos, _knobSprite.position.y);
}

-(void)deriveValueFromKnobPosition {
	CGFloat sliderPos = (_knobSprite.position.x + actualSlideWidth * 0.5) / actualSlideWidth;
	CGFloat extremesDifference = _maximumValue - _minimumValue;
	CGFloat value = (sliderPos * extremesDifference) + _minimumValue;
	_previousValue = _value;
	_value = clipFloatWithinRange(value, _minimumValue, _maximumValue);
}

-(void)absoluteInputMovedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary *)eventDict {
	_knobSprite.position = CGPointMake(clipFloatWithinRange(location.x, -actualSlideWidth * 0.5f, actualSlideWidth * 0.5f), _knobSprite.position.y);
	[self deriveValueFromKnobPosition];
	[super absoluteInputMovedSKU:location withDelta:delta withEventDictionary:eventDict];
	[self sendChanged:NO];
}

-(void)absoluteInputEndedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary *)eventDict {
	_knobSprite.position = CGPointMake(clipFloatWithinRange(location.x, -actualSlideWidth * 0.5f, actualSlideWidth * 0.5f), _knobSprite.position.y);
	[self deriveValueFromKnobPosition];
	[super absoluteInputEndedSKU:location withDelta:delta withEventDictionary:eventDict];
	[self sendChanged:YES];
}

-(void)sendChanged:(BOOL)forced {
	if (self.isEnabled) {
		if ((_previousValue != _value && _continuous) || forced) {
			BOOL notificationMethod = kSKUButtonMethodPostNotification & self.buttonMethod;
			BOOL delegateMethod = kSKUButtonMethodDelegate & self.buttonMethod;
			BOOL actionMethod = kSKUButtonMethodRunActions & self.buttonMethod;
			
			if (notificationMethod) {
				[[NSNotificationCenter defaultCenter] postNotificationName:_notificationNameChanged object:self];
			}
			
			if (delegateMethod) {
				if ([self.delegate respondsToSelector:@selector(valueChanged:)]) {
					[self.delegate valueChanged:self];
				}
			}
			
			if (actionMethod) {
				[changedSelector invoke];
			}
		}
	}
}


#pragma mark SKUSliderButton setters (slide)

-(void)setSlideSpritePropertiesDefault:(SKUButtonSpriteStateProperties *)slideSpritePropertiesDefault {
	_slideSpritePropertiesDefault = slideSpritePropertiesDefault;
	if (!_slideSprite) {
		_slideSprite = [SKSpriteNode spriteNodeWithTexture:_slideSpritePropertiesDefault.texture];
		_slideSprite.zPosition = 0.001;
		_slideSprite.name = @"SKUSliderButtonSlideSprite";
		[self addChild:_slideSprite];
	}
	stateSlideDefaultInitialized = YES;
	
	if (!stateSlidePressedInitialized) {
		_slideSpritePropertiesPressed = _slideSpritePropertiesDefault.copy;
		stateSlidePressedInitialized = YES;
	}
	
	if (!stateSlideHoveredInitialized) {
		_slideSpritePropertiesHovered = _slideSpritePropertiesDefault.copy;
		stateSlideHoveredInitialized = YES;
	}
	
	if (!stateSlideDisabledInitialized) {
		_slideSpritePropertiesDisabled = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_slideSpritePropertiesDefault].propertiesDisabledState;
		stateSlideDisabledInitialized = YES;
	}
}

-(void)setSlideSpritePropertiesPressed:(SKUButtonSpriteStateProperties *)slideSpritePropertiesPressed {
	_slideSpritePropertiesPressed = slideSpritePropertiesPressed;
	stateSlidePressedInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}

-(void)setSlideSpritePropertiesHovered:(SKUButtonSpriteStateProperties *)slideSpritePropertiesHovered {
	_slideSpritePropertiesHovered = slideSpritePropertiesHovered;
	stateSlideHoveredInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}

-(void)setSlideSpritePropertiesDisabled:(SKUButtonSpriteStateProperties *)slideSpritePropertiesDisabled {
	_slideSpritePropertiesDisabled = slideSpritePropertiesDisabled;
	stateSlideDisabledInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}


-(void)setSlideSpriteStatesWithPackage:(SKUButtonSpriteStatePropertiesPackage*)package {
	_slideSpritePropertiesPressed = package.propertiesPressedState;
	stateSlidePressedInitialized = YES;
	_slideSpritePropertiesHovered = package.propertiesHoveredState;
	stateSlideHoveredInitialized = YES;
	_slideSpritePropertiesDisabled = package.propertiesDisabledState;
	stateSlideDisabledInitialized = YES;
	self.slideSpritePropertiesDefault = package.propertiesDefaultState;
	stateSlideDefaultInitialized = YES;
}

#pragma mark SKUSliderButton setters (knob)


-(void)setKnobSpritePropertiesDefault:(SKUButtonSpriteStateProperties *)knobSpritePropertiesDefault {
	_knobSpritePropertiesDefault = knobSpritePropertiesDefault;
	if (!_knobSprite) {
		_knobSprite = [SKSpriteNode spriteNodeWithTexture:_knobSpritePropertiesDefault.texture];
		_knobSprite.zPosition = 0.002;
		_knobSprite.name = @"SKUSliderButtonKnobSprite";
		[self addChild:_knobSprite];
	}
	stateKnobDefaultInitialized = YES;
	
	if (!stateKnobPressedInitialized) {
		_knobSpritePropertiesPressed = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_knobSpritePropertiesDefault].propertiesDefaultState;
		stateKnobPressedInitialized = YES;
	}
	
	if (!stateKnobHoveredInitialized) {
		_knobSpritePropertiesHovered = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_knobSpritePropertiesDefault].propertiesHoveredState;
		stateKnobHoveredInitialized = YES;
	}
	
	if (!stateKnobDisabledInitialized) {
		_knobSpritePropertiesDisabled = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_knobSpritePropertiesDefault].propertiesDisabledState;
		stateKnobDisabledInitialized = YES;
	}
	
	[self updateCurrentSpriteStateProperties];
}

-(void)setKnobSpritePropertiesPressed:(SKUButtonSpriteStateProperties *)knobSpritePropertiesPressed {
	_knobSpritePropertiesPressed = knobSpritePropertiesPressed;
	stateKnobPressedInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}

-(void)setKnobSpritePropertiesHovered:(SKUButtonSpriteStateProperties *)knobSpritePropertiesHovered {
	_knobSpritePropertiesHovered = knobSpritePropertiesHovered;
	stateKnobHoveredInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}

-(void)setKnobSpritePropertiesDisabled:(SKUButtonSpriteStateProperties *)knobSpritePropertiesDisabled {
	_knobSpritePropertiesDisabled = knobSpritePropertiesDisabled;
	stateKnobDisabledInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}

-(void)setKnobSpriteStatesWithPackage:(SKUButtonSpriteStatePropertiesPackage*)package {
	_knobSpritePropertiesPressed = package.propertiesPressedState;
	stateKnobPressedInitialized = YES;
	_knobSpritePropertiesHovered = package.propertiesHoveredState;
	stateKnobHoveredInitialized = YES;
	_knobSpritePropertiesDisabled = package.propertiesDisabledState;
	stateKnobDisabledInitialized = YES;
	self.knobSpritePropertiesDefault = package.propertiesDefaultState;
	stateKnobDefaultInitialized = YES;
}


#pragma mark SKUSliderButton setters (max and min)


-(void)setMaximumValueImagePropertiesDefault:(SKUButtonSpriteStateProperties *)maximumValueImagePropertiesDefault {
	_maximumValueImagePropertiesDefault = maximumValueImagePropertiesDefault;
	if (!_maximumValueImage) {
		_maximumValueImage = [SKSpriteNode spriteNodeWithTexture:_maximumValueImagePropertiesDefault.texture];
		_maximumValueImage.zPosition = 0.001;
		_maximumValueImage.name = @"SKUSliderButtonMaxValueImage";
		[self addChild:_maximumValueImage];
	}
	stateMaxValueDefaultInitialized = YES;
	
	if (!stateMaxValueDisabledInitialized) {
		_maximumValueImagePropertiesDisabled = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_maximumValueImagePropertiesDefault].propertiesDisabledState;
		stateMaxValueDisabledInitialized = YES;
	}
	
	[self updateCurrentSpriteStateProperties];
}

-(void)setMaximumValueImagePropertiesDisabled:(SKUButtonSpriteStateProperties *)maximumValueImagePropertiesDisabled {
	_maximumValueImagePropertiesDisabled = maximumValueImagePropertiesDisabled;
	stateMaxValueDisabledInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}

-(void)setMinimumValueImagePropertiesDefault:(SKUButtonSpriteStateProperties *)minimumValueImagePropertiesDefault {
	_minimumValueImagePropertiesDefault = minimumValueImagePropertiesDefault;
	if (!_minimumValueImage) {
		_minimumValueImage = [SKSpriteNode spriteNodeWithTexture:_minimumValueImagePropertiesDefault.texture];
		_minimumValueImage.zPosition = 0.001;
		_minimumValueImage.name = @"SKUSliderButtonMinValueImage";
		[self addChild:_minimumValueImage];
	}
	stateMinValueDefaultInitialized = YES;
	
	if (!stateMinValueDisabledInitialized) {
		_minimumValueImagePropertiesDisabled = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_minimumValueImagePropertiesDefault].propertiesDisabledState;
		stateMinValueDisabledInitialized = YES;
	}
	[self updateCurrentSpriteStateProperties];
}

-(void)setMinimumValueImagePropertiesDisabled:(SKUButtonSpriteStateProperties *)minimumValueImagePropertiesDisabled {
	_minimumValueImagePropertiesDisabled = minimumValueImagePropertiesDisabled;
	stateMinValueDisabledInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}


-(void)setMaxValueSpriteStatesWithPackage:(SKUButtonSpriteStatePropertiesPackage*)package {
	_maximumValueImagePropertiesDisabled = package.propertiesDisabledState;
	stateMaxValueDisabledInitialized = YES;
	self.maximumValueImagePropertiesDefault = package.propertiesDefaultState;
	stateMaxValueDefaultInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}


-(void)setMinValueSpriteStatesWithPackage:(SKUButtonSpriteStatePropertiesPackage*)package {
	_minimumValueImagePropertiesDisabled = package.propertiesDisabledState;
	stateMinValueDisabledInitialized = YES;
	self.minimumValueImagePropertiesDefault = package.propertiesDefaultState;
	stateMinValueDefaultInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}

#pragma mark SKUSliderButton setters (other)

-(void)setNotificationNameChanged:(NSString *)notificationNameChanged {
	_notificationNameChanged = notificationNameChanged;
	self.buttonMethod = self.buttonMethod | kSKUButtonMethodPostNotification;
}

-(void)setChangedAction:(SEL)selector toPerformOnTarget:(NSObject *)target {
	NSMethodSignature* sig = [target methodSignatureForSelector:selector];
	changedSelector = [NSInvocation invocationWithMethodSignature:sig];
	[changedSelector setSelector:selector];
	SKUButton* button = self;
	[changedSelector setArgument:&button atIndex:2];
	[changedSelector setTarget:target];
	self.buttonMethod = self.buttonMethod | kSKUButtonMethodRunActions;
}

-(void)setSliderWidth:(CGFloat)sliderWidth {
	_sliderWidth = fmax(sliderWidth, 25.0);
	actualSlideWidth = [self getActualWidthFromTexture:_slideSprite.texture withCenterRect:_slideSprite.centerRect];
	[self updateCurrentSpriteStateProperties];
}

-(void)setValue:(CGFloat)value {
	_previousValue = _value;
	_value = clipFloatWithinRange(value, _minimumValue, _maximumValue);
	[self updateCurrentSpriteStateProperties];
}

-(void)setMinimumValue:(CGFloat)minimumValue {
	_minimumValue = minimumValue;
	[self updateKnobPosition];
}

-(void)setMaximumValue:(CGFloat)maximumValue {
	_maximumValue = maximumValue;
	[self updateKnobPosition];
}

#pragma mark SKUSliderButton defaults

-(void)buttonStatesDefault {
	[super buttonStatesDefault];
	
	if (_knobSpritePropertiesDefault.texture) {
		SKUButtonSpriteStatePropertiesPackage* package = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_knobSpritePropertiesDefault];
		[self setKnobSpriteStatesWithPackage:package];
	} else {
		stateKnobDefaultInitialized = NO;
		stateKnobPressedInitialized = NO;
		stateKnobDisabledInitialized = NO;
		stateKnobHoveredInitialized = NO;
	}
	
	if (_slideSpritePropertiesDefault.texture) {
		SKUButtonSpriteStatePropertiesPackage* package = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_slideSpritePropertiesDefault];
		package.propertiesHoveredState = package.propertiesDefaultState.copy;
		package.propertiesPressedState = package.propertiesDefaultState.copy;
		[self setSlideSpriteStatesWithPackage:package];
	} else {
		stateSlideDefaultInitialized = NO;
		stateSlidePressedInitialized = NO;
		stateSlideHoveredInitialized = NO;
		stateSlideDisabledInitialized = NO;
	}
	
	if (_maximumValueImagePropertiesDefault.texture) {
		SKUButtonSpriteStatePropertiesPackage* package = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_maximumValueImagePropertiesDefault];
		[self setMaxValueSpriteStatesWithPackage:package];
	} else {
		stateMaxValueDefaultInitialized = NO;
		stateMaxValueDisabledInitialized = NO;
	}
	
	if (_minimumValueImagePropertiesDefault.texture) {
		SKUButtonSpriteStatePropertiesPackage* package = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_minimumValueImagePropertiesDefault];
		[self setMinValueSpriteStatesWithPackage:package];
	} else {
		stateMinValueDefaultInitialized = NO;
		stateMinValueDisabledInitialized = NO;
	}
	//might have to do the base sprite here too... just a reminder
}

-(void)buttonStatesNormalize {
	
	[super buttonStatesNormalize];
	
	if (_knobSpritePropertiesDefault.texture) {
		SKUButtonSpriteStatePropertiesPackage* package = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_knobSpritePropertiesDefault andPressedState:_knobSpritePropertiesDefault andHoveredState:_knobSpritePropertiesDefault andDisabledState:_knobSpritePropertiesDefault];
		[self setKnobSpriteStatesWithPackage:package];
	} else {
		stateKnobDefaultInitialized = NO;
		stateKnobPressedInitialized = NO;
		stateKnobDisabledInitialized = NO;
		stateKnobHoveredInitialized = NO;
	}

	if (_slideSpritePropertiesDefault.texture) {
		SKUButtonSpriteStatePropertiesPackage* package = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_slideSpritePropertiesDefault andPressedState:_slideSpritePropertiesDefault andHoveredState:_slideSpritePropertiesDefault andDisabledState:_slideSpritePropertiesDefault];
		[self setSlideSpriteStatesWithPackage:package];
	} else {
		stateSlideDefaultInitialized = NO;
		stateSlidePressedInitialized = NO;
		stateSlideHoveredInitialized = NO;
		stateSlideDisabledInitialized = NO;
	}
	
	if (_maximumValueImagePropertiesDefault.texture) {
		SKUButtonSpriteStatePropertiesPackage* package = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_maximumValueImagePropertiesDefault andPressedState:_maximumValueImagePropertiesDefault andHoveredState:_maximumValueImagePropertiesDefault andDisabledState:_maximumValueImagePropertiesDefault];
		[self setMaxValueSpriteStatesWithPackage:package];
	} else {
		stateMaxValueDefaultInitialized = NO;
		stateMaxValueDisabledInitialized = NO;
	}

	if (_minimumValueImagePropertiesDefault.texture) {
		SKUButtonSpriteStatePropertiesPackage* package = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_minimumValueImagePropertiesDefault andPressedState:_minimumValueImagePropertiesDefault andHoveredState:_minimumValueImagePropertiesDefault andDisabledState:_minimumValueImagePropertiesDefault];
		[self setMinValueSpriteStatesWithPackage:package];
	} else {
		stateMinValueDefaultInitialized = NO;
		stateMinValueDisabledInitialized = NO;
	}
	//might have to do the base sprite here too... just a reminder
}

#pragma mark SKUSliderButton tvOS Stuff

-(void)buttonPressed:(CGPoint)location {
	if (self.isEnabled) {
		if (!focusSlideMode) {
			[super buttonPressed:location];
			[SKUSharedUtilities setNavMode:kSKUNavModePressed];
			focusStartPress = YES;
			focusSlideMode = YES;
		}
	}
}

-(void)buttonReleased:(CGPoint)location {
	if (self.isEnabled) {
		if (focusStartPress) {
			focusStartPress = NO;
		} else {
			focusSlideMode = NO;
			[SKUSharedUtilities setNavMode:kSKUNavModeOn];
			[super buttonReleased:location];
		}
	}
}

@end


@implementation SKUNode

-(id)init {
	if (self = [super init]) {
		
	}
	[self didInitialize];
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		
	}
	[self didInitialize];
	return self;
}

-(void)didInitialize {
	
}

@end

@interface SKNode (SKUModifications) // this needs to be declared for SKUScene's update method to work right

-(void)skuInternalUpdateCurrentFocusedNode:(SKNode*)node;

@end


@implementation SKUScene

-(id)init {
	if (self = [super init]) {
		
	}
	[self preDidInitialize];
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		
	}
	[self preDidInitialize];
	return self;
}

-(id)initWithSize:(CGSize)size {
	if (self = [super initWithSize:size]) {
		
	}
	[self preDidInitialize];
	return self;
}

-(void)preDidInitialize {
	if (!SKUSharedUtilities.gcController) {
		SKUSharedUtilities.gcController = [[SKUGCControllerController alloc] init];
	}
	[self didInitialize];
}

-(void)didInitialize {
	
}

-(void)didMoveToView:(SKView *)view {
	SKUSharedUtilities.gcController.view = view;
}

#pragma mark gamepad executes
#pragma mark gamepad vague executes buttons


-(void)gamepadInputChangedForPlayer:(GCControllerPlayerIndex)player withInput:(kSKUGamePadInputs)input andXValue:(float)xValue andYValue:(float)yValue pressedState:(kSKUGamepadButtonStates)pressedState andEventDictionary:(NSDictionary*)eventDictionary {

}

-(void)gamepadMotionInputChangedForPlayer:(GCControllerPlayerIndex)player withAcceleration:(SKUAcceleration)acceleration andEventDictionary:(NSDictionary*)eventDictionary {

}

#pragma mark gamepad specific executes buttons

-(void)gamepadLeftShoulderChangedForPlayer:(GCControllerPlayerIndex)player withValue:(float)value pressedState:(kSKUGamepadButtonStates)pressedState andEventDictionary:(NSDictionary*)eventDictionary {
	
}

-(void)gamepadLeftTriggerChangedForPlayer:(GCControllerPlayerIndex)player withValue:(float)value pressedState:(kSKUGamepadButtonStates)pressedState andEventDictionary:(NSDictionary*)eventDictionary {
	
}

-(void)gamepadRightShoulderChangedForPlayer:(GCControllerPlayerIndex)player withValue:(float)value pressedState:(kSKUGamepadButtonStates)pressedState andEventDictionary:(NSDictionary*)eventDictionary {
	
}

-(void)gamepadRightTriggerChangedForPlayer:(GCControllerPlayerIndex)player withValue:(float)value pressedState:(kSKUGamepadButtonStates)pressedState andEventDictionary:(NSDictionary*)eventDictionary {
	
}

-(void)gamepadButtonAChangedForPlayer:(GCControllerPlayerIndex)player withValue:(float)value pressedState:(kSKUGamepadButtonStates)pressedState andEventDictionary:(NSDictionary*)eventDictionary {

}

-(void)gamepadButtonBChangedForPlayer:(GCControllerPlayerIndex)player withValue:(float)value pressedState:(kSKUGamepadButtonStates)pressedState andEventDictionary:(NSDictionary*)eventDictionary {
	
}

-(void)gamepadButtonXChangedForPlayer:(GCControllerPlayerIndex)player withValue:(float)value pressedState:(kSKUGamepadButtonStates)pressedState andEventDictionary:(NSDictionary*)eventDictionary {
	
}

-(void)gamepadButtonYChangedForPlayer:(GCControllerPlayerIndex)player withValue:(float)value pressedState:(kSKUGamepadButtonStates)pressedState andEventDictionary:(NSDictionary*)eventDictionary {
	
}

-(void)gamepadButtonPausePressedForPlayer:(GCControllerPlayerIndex)player andEventDictionary:(NSDictionary*)eventDictionary {
	
}

#pragma mark gamepad specific executes dpads

-(void)gamepadLeftThumbstickChangedForPlayer:(GCControllerPlayerIndex)player withVector:(CGVector)vector andEventDictionary:(NSDictionary*)eventDictionary {
	
}

-(void)gamepadRightThumbstickChangedForPlayer:(GCControllerPlayerIndex)player withVector:(CGVector)vector andEventDictionary:(NSDictionary*)eventDictionary {

}

-(void)gamepadDirectionalPadChangedForPlayer:(GCControllerPlayerIndex)player withVector:(CGVector)vector andEventDictionary:(NSDictionary*)eventDictionary {

}

#pragma mark update
-(void)update:(CFTimeInterval)currentTime {
	/* Called before each frame is rendered */
	
	[SKUSharedUtilities updateCurrentTime:currentTime];

	SKUGameControllerState* controllerState = SKUSharedUtilities.gcController.navControllerState;
	if (!controllerState) {
		controllerState = [SKUGameControllerState controllerStateWithCenterPosition:midPointOfRect(self.frame)];
		SKUSharedUtilities.gcController.navControllerState = controllerState;
	}
	
	if (SKUSharedUtilities.navMode == kSKUNavModeOn) {
		if (controllerState.buttonsPressed & kSKUGamePadInputDirectionalPad) {
			SKNode* prevFocus = SKUSharedUtilities.navFocus.userData[kSKUNavConstantCurrentFocusedNode];
			NSSet* nodeSet = SKUSharedUtilities.navFocus.userData[kSKUNavConstantNavNodes];
			if (!prevFocus) {
				SKULog(0,@"Error: no currently focused node - did you set the initial node focus (setCurrentFocusedNodeSKU:(SKNode*)) **AFTER** you set the navFocus on the singleton ([SKUSharedUtilities setNavFocus:(SKNode*)]?");
			} else if (!nodeSet) {
				SKULog(0,@"Error: no navNodes to navigate through - did you add nodes to the nav nodes (addNodeToNavNodesSKU:(SKNode*)) and set the navFocus on the singleton ([SKUSharedUtilities setNavFocus:(SKNode*)]?");
			} else {
				SKNode* currentFocusNode = [SKUSharedUtilities handleSubNodeMovement:controllerState.location withCurrentFocus:prevFocus inSet:nodeSet inScene:self.scene];
				[self skuInternalUpdateCurrentFocusedNode:currentFocusNode];
				controllerState.location = pointAdd(controllerState.location, pointMultiplyByFactor(pointFromCGVector(controllerState.vectorDPad), SKUSharedUtilities.navThresholdDistance * 0.05));
				//				NSLog(@"dpad pressed: vec: %f %f pos: %f %f pressed: %i", controllerState.vector.dx, controllerState.vector.dy, controllerState.location.x, controllerState.location.y, controllerState.buttonsPressed);
			}
		}
	} else if (SKUSharedUtilities.navMode == kSKUNavModePressed && controllerState.buttonsPressed & kSKUGamePadInputDirectionalPad) {
		SKNode* currentFocus = SKUSharedUtilities.navFocus.userData[kSKUNavConstantCurrentFocusedNode];
		if ([currentFocus isKindOfClass:[SKUSliderButton class]]) {
			SKUSliderButton* slider = (SKUSliderButton*)currentFocus;
			CGFloat stepsize;
			if (slider.stepSize > 0.0) {
				stepsize = slider.stepSize * controllerState.vectorDPad.dx;
			} else {
				stepsize = ((slider.maximumValue - slider.minimumValue) / (slider.sliderWidth * 0.2)) * controllerState.vectorDPad.dx;
			}
			slider.value += stepsize;
			[slider sendChanged:NO];
		}
	}
}


@end

@implementation SKUSpriteNode

-(id)init {
	if (self = [super init]) {
		
	}
	[self didInitialize];
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		
	}
	[self didInitialize];
	return self;
}

-(id)initWithColor:(SKColor *)color size:(CGSize)size {
	if (self = [super initWithColor:color size:size]) {
		
	}
	[self didInitialize];
	return self;
}

-(id)initWithImageNamed:(NSString *)name {
	if (self = [super initWithImageNamed:name]) {
		
	}
	[self didInitialize];
	return self;
}

-(id)initWithTexture:(SKTexture *)texture {
	if (self = [super initWithTexture:texture]) {
		
	}
	[self didInitialize];
	return self;
}

-(id)initWithTexture:(SKTexture *)texture color:(SKColor *)color size:(CGSize)size {
	if (self = [super initWithTexture:texture color:color size:size]) {
		
	}
	[self didInitialize];
	return self;
}

-(void)didInitialize {
	
}

@end

@implementation SKUViewController
-(instancetype)init {
	if (self = [super init]) {
		[self internalDidInitialize];
	}
	return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		[self internalDidInitialize];
	}
	return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		[self internalDidInitialize];
	}
	return self;
}

-(void)internalDidInitialize {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteInteractionOn) name:kSKURemoteInteractionOn object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteInteractionOff) name:kSKURemoteInteractionOff object:nil];
	[self didInitialize];
}
 
-(void)didInitialize {

}

-(void)remoteInteractionOn {
#if TARGET_OS_TV
	self.controllerUserInteractionEnabled = YES;
//	NSLog(@"user interaction: %i", self.controllerUserInteractionEnabled);
#endif
}

-(void)remoteInteractionOff {
#if TARGET_OS_TV
	self.controllerUserInteractionEnabled = NO;
//	NSLog(@"user interaction: %i", self.controllerUserInteractionEnabled);
#endif
}



@end

#pragma mark CLASS CATEGORIES

#pragma mark SKView Modifications

@implementation SKView (SKUModifications)


#if TARGET_OS_TV
-(void)pressesBegan:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event {
	[super pressesBegan:presses withEvent:event];
	for (UIPress* press in presses) {
		switch (press.type) {
			case UIPressTypeSelect: {
				[SKUSharedUtilities gestureTapDown];
			}
				break;
				
			default:
				break;
		}
	}
	
	[self.scene pressesBegan:presses withEvent:event];
}

-(void)pressesEnded:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event {
	[super pressesEnded:presses withEvent:event];
	for (UIPress* press in presses) {
		switch (press.type) {
			case UIPressTypeSelect: {
				[SKUSharedUtilities gestureTapUp];
			}
				break;
				
			default:
				break;
		}
	}
	[self.scene pressesEnded:presses withEvent:event];
}

-(void)pressesCancelled:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event { //not sure if this should send signals to tapUp (when it is there, it causes misfires on 04BezierDemo)
	[super pressesCancelled:presses withEvent:event];
//	for (UIPress* press in presses) {
//		switch (press.type) {
//			case UIPressTypeSelect: {
//				[SKUSharedUtilities gestureTapUp];
//			}
//				break;
//				
//			default:
//				break;
//		}
//		
//	}
	[self.scene pressesCancelled:presses withEvent:event];
}

-(void)pressesChanged:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event {
	[super pressesChanged:presses withEvent:event];
	[self.scene pressesChanged:presses withEvent:event];
}


#elif TARGET_OS_OSX_SKU

-(void)rightMouseDown:(NSEvent *)theEvent {
	CGPoint location = [theEvent locationInNode:self.scene];
	NSArray* nodes = [self.scene nodesAtPoint:location];
	if (nodes.count > 0) {
		for (SKNode* node in nodes) {
			if (node.userInteractionEnabled) {
				[node rightMouseDown:theEvent];
				[self initDictSKU];
				self.scene.userData[kSKUNavConstantRightMouseDown] = node;
				return;
			}
		}
	}
	[self.scene rightMouseDown:theEvent];
	
}

-(void)rightMouseDragged:(NSEvent *)theEvent {
	SKNode* node = self.scene.userData[kSKUNavConstantRightMouseDown];
	if (node) {
		[node rightMouseDragged:theEvent];
	} else {
		[self.scene rightMouseDragged:theEvent];
	}
}

-(void)rightMouseUp:(NSEvent *)theEvent {
	SKNode* node = self.scene.userData[kSKUNavConstantRightMouseDown];
	if (node) {
		[node rightMouseUp:theEvent];
		[self.scene.userData removeObjectForKey:kSKUNavConstantRightMouseDown];
	} else {
		[self.scene rightMouseUp:theEvent];
	}
}

-(void)otherMouseDown:(NSEvent *)theEvent {
	
	CGPoint location = [theEvent locationInNode:self.scene];
	NSArray* nodes = [self.scene nodesAtPoint:location];
	if (nodes.count > 0) {
		for (SKNode* node in nodes) {
			if (node.userInteractionEnabled) {
				[node otherMouseDown:theEvent];
				[self initDictSKU];
				self.scene.userData[kSKUNavConstantOtherMouseDown] = node;
				return;
			}
		}
	}
	[self.scene otherMouseDown:theEvent];
}

-(void)otherMouseDragged:(NSEvent *)theEvent {
	SKNode* node = self.scene.userData[kSKUNavConstantOtherMouseDown];
	if (node) {
		[node otherMouseDragged:theEvent];
	} else {
		[self.scene otherMouseDragged:theEvent];
	}
}

-(void)otherMouseUp:(NSEvent *)theEvent {
	SKNode* node = self.scene.userData[kSKUNavConstantOtherMouseDown];
	if (node) {
		[node otherMouseUp:theEvent];
		[self.scene.userData removeObjectForKey:kSKUNavConstantOtherMouseDown];
	} else {
		[self.scene otherMouseUp:theEvent];
	}
}

-(void)initDictSKU {
	if (!self.scene.userData) {
		self.scene.userData = [NSMutableDictionary dictionaryWithCapacity:kSKUNavConstantUserDictCapacity];
	}
	if (!self.scene.userData[kSKUNavConstantHoverArray]) {
		NSMutableArray* hoverArray = [NSMutableArray array];
		[self.scene.userData setObject:hoverArray forKey:kSKUNavConstantHoverArray];
	}
}

-(void)mouseMoved:(NSEvent *)theEvent {
	CGPoint location = [theEvent locationInNode:self.scene];
	NSArray* nodes = [self.scene nodesAtPoint:location];
	if (nodes.count > 0) {
		for (SKNode* node in nodes) {
			if ([node isKindOfClass:[SKUButton class]]) {
				SKUButton* button = (SKUButton*)node;
				[self initDictSKU];
				NSMutableArray* hoverArray = self.scene.userData[kSKUNavConstantHoverArray];
				if (![hoverArray containsObject:button]) {
					[hoverArray addObject:button];
					[button hoverButton];
				}
			}
		}
	}
	NSMutableArray* hoverArray = self.scene.userData[kSKUNavConstantHoverArray];
	for (int i = 0; i < hoverArray.count; i++) {
		SKUButton* button = hoverArray[i];
		bool inBounds = [button checkIfLocationIsWithinButtonBounds:[self.scene convertPoint:location toNode:button]];
		if (!inBounds) {
			[button unhoverButton];
			[hoverArray removeObject:button];
		}
	}

	[self.scene mouseMoved:theEvent];
}

#endif

-(void)gamepadInputChangedForPlayer:(GCControllerPlayerIndex)player withInput:(kSKUGamePadInputs)input andXValue:(float)xValue andYValue:(float)yValue pressedState:(kSKUGamepadButtonStates)pressedState andEventDictionary:(NSDictionary*)eventDictionary {
	
	if (![self.scene isKindOfClass:[SKUScene class]]) {
		return;
	}
	
	SKUScene* gcScene = (SKUScene*)self.scene;
	
	// DISTRIBUTING ALL BUTTONS
	
	CGVector inputVector = CGVectorMake(xValue, yValue);
	
	switch (input) {
		case kSKUGamePadInputButtonA:
			[gcScene gamepadButtonAChangedForPlayer:player withValue:xValue pressedState:pressedState andEventDictionary:eventDictionary];
			break;
		case kSKUGamePadInputButtonB:
			[gcScene gamepadButtonBChangedForPlayer:player withValue:xValue pressedState:pressedState andEventDictionary:eventDictionary];
			break;
		case kSKUGamePadInputButtonX:
			[gcScene gamepadButtonXChangedForPlayer:player withValue:xValue pressedState:pressedState andEventDictionary:eventDictionary];
			break;
		case kSKUGamePadInputButtonY:
			[gcScene gamepadButtonYChangedForPlayer:player withValue:xValue pressedState:pressedState andEventDictionary:eventDictionary];
			break;
		case kSKUGamePadInputButtonPause:
			[gcScene gamepadButtonPausePressedForPlayer:player andEventDictionary:eventDictionary];
			break;
		case kSKUGamePadInputLeftShoulder:
			[gcScene gamepadLeftShoulderChangedForPlayer:player withValue:xValue pressedState:pressedState andEventDictionary:eventDictionary];
			break;
		case kSKUGamePadInputLeftTrigger:
			[gcScene gamepadLeftTriggerChangedForPlayer:player withValue:xValue pressedState:pressedState andEventDictionary:eventDictionary];
			break;
		case kSKUGamePadInputRightShoulder:
			[gcScene gamepadRightShoulderChangedForPlayer:player withValue:xValue pressedState:pressedState andEventDictionary:eventDictionary];
			break;
		case kSKUGamePadInputRightTrigger:
			[gcScene gamepadRightTriggerChangedForPlayer:player withValue:xValue pressedState:pressedState andEventDictionary:eventDictionary];
			break;
			
		case kSKUGamePadInputLeftThumbstick:
			[gcScene gamepadLeftThumbstickChangedForPlayer:player withVector:inputVector andEventDictionary:eventDictionary];
			break;
		case kSKUGamePadInputRightThumbstick:
			[gcScene gamepadRightThumbstickChangedForPlayer:player withVector:inputVector andEventDictionary:eventDictionary];
			break;
		case kSKUGamePadInputDirectionalPad:
			[gcScene gamepadDirectionalPadChangedForPlayer:player withVector:inputVector andEventDictionary:eventDictionary];
			break;
			
		default:
			break;
	}
	
	[gcScene gamepadInputChangedForPlayer:player withInput:input andXValue:xValue andYValue:yValue pressedState:pressedState andEventDictionary:eventDictionary];
	
}

-(void)gamepadMotionInputChangedForPlayer:(GCControllerPlayerIndex)player withAcceleration:(SKUAcceleration)acceleration andEventDictionary:(NSDictionary*)eventDictionary {
	if (![self.scene isKindOfClass:[SKUScene class]]) {
		return;
	}
	
	SKUScene* gcScene = (SKUScene*)self.scene;
	
	[gcScene gamepadMotionInputChangedForPlayer:player withAcceleration:acceleration andEventDictionary:eventDictionary];
}

@end


#pragma mark SKNode Modifications

@implementation SKNode (SKUModifications)


#if TARGET_OS_IPHONE

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* touch = [touches anyObject];
	CGPoint location = [touch locationInNode:self];
	NSInteger touchCount = touch.tapCount;
	NSTimeInterval intervalTime = touch.timestamp;
	NSArray* keys = [NSArray arrayWithObjects:@"intervalTime", @"inputIteration", @"buttonNumber", @"event", @"touch", nil];
	NSArray* objects = [NSArray arrayWithObjects:
						[NSNumber numberWithDouble:intervalTime],
						[NSNumber numberWithInteger:touchCount],
						[NSNumber numberWithInteger:0],
						event,
						touch,
						nil];
	NSDictionary* eventDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
#if TARGET_OS_TV
	[self siriRemoteinputBeganSKU:location withEventDictionary:eventDict];
#else
	[self absoluteInputBeganSKU:location withEventDictionary:eventDict];
#endif
	[self inputBeganSKU:location withEventDictionary:eventDict];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* touch = [touches anyObject];
	CGPoint location = [touch locationInNode:self];
	NSInteger touchCount = touch.tapCount;
	NSTimeInterval intervalTime = touch.timestamp;
	
	NSArray* keys = [NSArray arrayWithObjects:@"intervalTime", @"inputIteration", @"buttonNumber", @"event", @"touch", nil];
	NSArray* objects = [NSArray arrayWithObjects:
						[NSNumber numberWithDouble:intervalTime],
						[NSNumber numberWithInteger:touchCount],
						[NSNumber numberWithInteger:0],
						event,
						touch,
						nil];
	NSDictionary* eventDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	CGPoint prevLocation = [touch previousLocationInNode:self];
	CGPoint delta = pointAdd(pointInverse(prevLocation), location);
#if TARGET_OS_TV
	[self siriRemoteinputMovedSKU:location withDelta:delta withEventDictionary:eventDict];
#else
	[self absoluteInputMovedSKU:location withDelta:delta withEventDictionary:eventDict];
#endif
	[self inputMovedSKU:location withDelta:delta withEventDictionary:eventDict];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* touch = [touches anyObject];
	CGPoint location = [touch locationInNode:self];
	NSInteger touchCount = touch.tapCount;
	NSTimeInterval intervalTime = touch.timestamp;
	
	NSArray* keys = [NSArray arrayWithObjects:@"intervalTime", @"inputIteration", @"buttonNumber", @"event", @"touch", nil];
	NSArray* objects = [NSArray arrayWithObjects:
						[NSNumber numberWithDouble:intervalTime],
						[NSNumber numberWithInteger:touchCount],
						[NSNumber numberWithInteger:0],
						event,
						touch,
						nil];
	NSDictionary* eventDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	CGPoint prevLocation = [touch previousLocationInNode:self];
	CGPoint delta = pointAdd(pointInverse(prevLocation), location);
#if TARGET_OS_TV
	[self siriRemoteinputEndedSKU:location withDelta:delta withEventDictionary:eventDict];
#else
	[self absoluteInputEndedSKU:location withDelta:delta withEventDictionary:eventDict];
#endif
	[self inputEndedSKU:location withDelta:delta withEventDictionary:eventDict];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* touch = [touches anyObject];
	CGPoint location = [touch locationInNode:self];
	NSInteger touchCount = touch.tapCount;
	NSTimeInterval intervalTime = touch.timestamp;
	
	NSArray* keys = [NSArray arrayWithObjects:@"intervalTime", @"inputIteration", @"buttonNumber", @"event", @"touch", nil];
	NSArray* objects = [NSArray arrayWithObjects:
						[NSNumber numberWithDouble:intervalTime],
						[NSNumber numberWithInteger:touchCount],
						[NSNumber numberWithInteger:0],
						event,
						touch,
						nil];
	NSDictionary* eventDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	CGPoint prevLocation = [touch previousLocationInNode:self];
	CGPoint delta = pointAdd(pointInverse(prevLocation), location);
#if TARGET_OS_TV
	[self siriRemoteinputEndedSKU:location withDelta:delta withEventDictionary:eventDict];
#else
	[self absoluteInputEndedSKU:location withDelta:delta withEventDictionary:eventDict];
#endif
	[self inputEndedSKU:location withDelta:delta withEventDictionary:eventDict];
}

#else

-(void)mouseDown:(NSEvent *)theEvent {
	if ((SKUSharedUtilities.macButtonFlags & kSKUMouseButtonFlagLeft) == 0) return;

	CGPoint location = [theEvent locationInNode:self];
	NSTimeInterval intervalTime = theEvent.timestamp;
	NSInteger clickCount = theEvent.clickCount;
	NSInteger buttonNumber = theEvent.buttonNumber;
	NSArray* keys = [NSArray arrayWithObjects:@"intervalTime", @"inputIteration", @"buttonNumber", @"event", nil];
	NSArray* objects = [NSArray arrayWithObjects:[NSNumber numberWithDouble:intervalTime],
						[NSNumber numberWithInteger:clickCount],
						[NSNumber numberWithInteger:buttonNumber],
						theEvent,
						nil];
	
	NSDictionary* eventDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	[self absoluteInputBeganSKU:location withEventDictionary:eventDict];
	[self inputBeganSKU:location withEventDictionary:eventDict];
}

-(void)mouseDragged:(NSEvent *)theEvent {
	if ((SKUSharedUtilities.macButtonFlags & kSKUMouseButtonFlagLeft) == 0) return;
	CGPoint location = [theEvent locationInNode:self];
	NSTimeInterval intervalTime = theEvent.timestamp;
	NSInteger clickCount = theEvent.clickCount;
	NSInteger buttonNumber = theEvent.buttonNumber;
	
	NSArray* keys = [NSArray arrayWithObjects:@"intervalTime", @"inputIteration", @"buttonNumber", @"event", nil];
	NSArray* objects = [NSArray arrayWithObjects:[NSNumber numberWithDouble:intervalTime],
						[NSNumber numberWithInteger:clickCount],
						[NSNumber numberWithInteger:buttonNumber],
						theEvent,
						nil];
	
	NSDictionary* eventDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	CGPoint delta = [self lastMouseDelta];
	[self absoluteInputMovedSKU:location withDelta:delta withEventDictionary:eventDict];
	[self inputMovedSKU:location withDelta:delta withEventDictionary:eventDict];
}

-(void)mouseUp:(NSEvent *)theEvent {
	if ((SKUSharedUtilities.macButtonFlags & kSKUMouseButtonFlagLeft) == 0) return;
	CGPoint location = [theEvent locationInNode:self];
	NSTimeInterval intervalTime = theEvent.timestamp;
	NSInteger clickCount = theEvent.clickCount;
	NSInteger buttonNumber = theEvent.buttonNumber;
	
	NSArray* keys = [NSArray arrayWithObjects:@"intervalTime", @"inputIteration", @"buttonNumber", @"event", nil];
	NSArray* objects = [NSArray arrayWithObjects:[NSNumber numberWithDouble:intervalTime],
						[NSNumber numberWithInteger:clickCount],
						[NSNumber numberWithInteger:buttonNumber],
						theEvent,
						nil];
	
	NSDictionary* eventDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	CGPoint delta = [self lastMouseDelta];
	[self absoluteInputEndedSKU:location withDelta:delta withEventDictionary:eventDict];
	[self inputEndedSKU:location withDelta:delta withEventDictionary:eventDict];
}

-(void)mouseExited:(NSEvent *)theEvent {
	if ((SKUSharedUtilities.macButtonFlags & kSKUMouseButtonFlagLeft) == 0) return;
	CGPoint location = [theEvent locationInNode:self];
	NSTimeInterval intervalTime = theEvent.timestamp;
	NSInteger clickCount = theEvent.clickCount;
	NSInteger buttonNumber = theEvent.buttonNumber;
	
	NSArray* keys = [NSArray arrayWithObjects:@"intervalTime", @"inputIteration", @"buttonNumber", @"event", nil];
	NSArray* objects = [NSArray arrayWithObjects:[NSNumber numberWithDouble:intervalTime],
						[NSNumber numberWithInteger:clickCount],
						[NSNumber numberWithInteger:buttonNumber],
						theEvent,
						nil];
	
	NSDictionary* eventDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	CGPoint delta = [self lastMouseDelta];
	[self absoluteInputEndedSKU:location withDelta:delta withEventDictionary:eventDict];
	[self inputEndedSKU:location withDelta:delta withEventDictionary:eventDict];
}

-(void)rightMouseDown:(NSEvent *)theEvent {
	if ((SKUSharedUtilities.macButtonFlags & kSKUMouseButtonFlagRight) == 0) return;
	CGPoint location = [theEvent locationInNode:self];
	NSTimeInterval intervalTime = theEvent.timestamp;
	NSInteger clickCount = theEvent.clickCount;
	NSInteger buttonNumber = theEvent.buttonNumber;
	NSArray* keys = [NSArray arrayWithObjects:@"intervalTime", @"inputIteration", @"buttonNumber", @"event", nil];
	NSArray* objects = [NSArray arrayWithObjects:[NSNumber numberWithDouble:intervalTime],
						[NSNumber numberWithInteger:clickCount],
						[NSNumber numberWithInteger:buttonNumber],
						theEvent,
						nil];
	NSDictionary* eventDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	[self absoluteInputBeganSKU:location withEventDictionary:eventDict];
	[self inputBeganSKU:location withEventDictionary:eventDict];
}

-(void)rightMouseDragged:(NSEvent *)theEvent {
	if ((SKUSharedUtilities.macButtonFlags & kSKUMouseButtonFlagRight) == 0) return;
	CGPoint location = [theEvent locationInNode:self];
	NSTimeInterval intervalTime = theEvent.timestamp;
	NSInteger clickCount = theEvent.clickCount;
	NSInteger buttonNumber = theEvent.buttonNumber;
	
	NSArray* keys = [NSArray arrayWithObjects:@"intervalTime", @"inputIteration", @"buttonNumber", @"event", nil];
	NSArray* objects = [NSArray arrayWithObjects:[NSNumber numberWithDouble:intervalTime],
						[NSNumber numberWithInteger:clickCount],
						[NSNumber numberWithInteger:buttonNumber],
						theEvent,
						nil];
	
	NSDictionary* eventDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	CGPoint delta = [self lastMouseDelta];
	[self absoluteInputMovedSKU:location withDelta:delta withEventDictionary:eventDict];
	[self inputMovedSKU:location withDelta:delta withEventDictionary:eventDict];
}

-(void)rightMouseUp:(NSEvent *)theEvent {
	if ((SKUSharedUtilities.macButtonFlags & kSKUMouseButtonFlagRight) == 0) return;
	CGPoint location = [theEvent locationInNode:self];
	NSTimeInterval intervalTime = theEvent.timestamp;
	NSInteger clickCount = theEvent.clickCount;
	NSInteger buttonNumber = theEvent.buttonNumber;
	
	NSArray* keys = [NSArray arrayWithObjects:@"intervalTime", @"inputIteration", @"buttonNumber", @"event", nil];
	NSArray* objects = [NSArray arrayWithObjects:[NSNumber numberWithDouble:intervalTime],
						[NSNumber numberWithInteger:clickCount],
						[NSNumber numberWithInteger:buttonNumber],
						theEvent,
						nil];
	
	NSDictionary* eventDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	CGPoint delta = [self lastMouseDelta];
	[self absoluteInputEndedSKU:location withDelta:delta withEventDictionary:eventDict];
	[self inputEndedSKU:location withDelta:delta withEventDictionary:eventDict];
}

-(void)otherMouseDown:(NSEvent *)theEvent {
	if ((SKUSharedUtilities.macButtonFlags & kSKUMouseButtonFlagOther) == 0) return;
	CGPoint location = [theEvent locationInNode:self];
	NSTimeInterval intervalTime = theEvent.timestamp;
	NSInteger clickCount = theEvent.clickCount;
	NSInteger buttonNumber = theEvent.buttonNumber;
	NSArray* keys = [NSArray arrayWithObjects:@"intervalTime", @"inputIteration", @"buttonNumber", @"event", nil];
	NSArray* objects = [NSArray arrayWithObjects:[NSNumber numberWithDouble:intervalTime],
						[NSNumber numberWithInteger:clickCount],
						[NSNumber numberWithInteger:buttonNumber],
						theEvent,
						nil];
	
	NSDictionary* eventDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	[self absoluteInputBeganSKU:location withEventDictionary:eventDict];
	[self inputBeganSKU:location withEventDictionary:eventDict];
}

-(void)otherMouseDragged:(NSEvent *)theEvent {
	if ((SKUSharedUtilities.macButtonFlags & kSKUMouseButtonFlagOther) == 0) return;
	CGPoint location = [theEvent locationInNode:self];
	NSTimeInterval intervalTime = theEvent.timestamp;
	NSInteger clickCount = theEvent.clickCount;
	NSInteger buttonNumber = theEvent.buttonNumber;
	
	NSArray* keys = [NSArray arrayWithObjects:@"intervalTime", @"inputIteration", @"buttonNumber", @"event", nil];
	NSArray* objects = [NSArray arrayWithObjects:[NSNumber numberWithDouble:intervalTime],
						[NSNumber numberWithInteger:clickCount],
						[NSNumber numberWithInteger:buttonNumber],
						theEvent,
						nil];
	
	NSDictionary* eventDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	CGPoint delta = [self lastMouseDelta];
	[self absoluteInputMovedSKU:location withDelta:delta withEventDictionary:eventDict];
	[self inputMovedSKU:location withDelta:delta withEventDictionary:eventDict];
}

-(void)otherMouseUp:(NSEvent *)theEvent {
	if ((SKUSharedUtilities.macButtonFlags & kSKUMouseButtonFlagOther) == 0) return;
	CGPoint location = [theEvent locationInNode:self];
	NSTimeInterval intervalTime = theEvent.timestamp;
	NSInteger clickCount = theEvent.clickCount;
	NSInteger buttonNumber = theEvent.buttonNumber;
	
	NSArray* keys = [NSArray arrayWithObjects:@"intervalTime", @"inputIteration", @"buttonNumber", @"event", nil];
	NSArray* objects = [NSArray arrayWithObjects:[NSNumber numberWithDouble:intervalTime],
						[NSNumber numberWithInteger:clickCount],
						[NSNumber numberWithInteger:buttonNumber],
						theEvent,
						nil];
	
	NSDictionary* eventDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	CGPoint delta = [self lastMouseDelta];
	[self absoluteInputEndedSKU:location withDelta:delta withEventDictionary:eventDict];
	[self inputEndedSKU:location withDelta:delta withEventDictionary:eventDict];
}

-(void)mouseMoved:(NSEvent *)theEvent {
	CGPoint location = [theEvent locationInNode:self];
	NSTimeInterval intervalTime = theEvent.timestamp;
	NSInteger clickCount = theEvent.clickCount;
	NSInteger buttonNumber = theEvent.buttonNumber;
	
	NSArray* keys = [NSArray arrayWithObjects:@"intervalTime", @"inputIteration", @"buttonNumber", @"event", nil];
	NSArray* objects = [NSArray arrayWithObjects:[NSNumber numberWithDouble:intervalTime],
						[NSNumber numberWithInteger:clickCount],
						[NSNumber numberWithInteger:buttonNumber],
						theEvent,
						nil];
	
	NSDictionary* eventDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	CGPoint delta = [self lastMouseDelta];
	[self mouseMovedSKU:location withDelta:delta withEventDictionary:eventDict];
}

-(CGPoint)lastMouseDelta {
	int dx, dy;
	CGGetLastMouseDelta(&dx, &dy);
	return CGPointMake((CGFloat)dx, (CGFloat)dy);
}

#endif




-(void)addNodeToNavNodesSKU:(SKNode*)node {
	
	if (!self.userData) {
		self.userData = [NSMutableDictionary dictionaryWithCapacity:kSKUNavConstantUserDictCapacity];
	}
	
	NSMutableSet* navNodes = self.userData[kSKUNavConstantNavNodes];
	
	if (!navNodes) {
		navNodes = [NSMutableSet set];
	}
	
	if (node.parent) {
		[navNodes addObject:node];
	} else {
		SKULog(0,@"error: can't add node named '%@' to navNodes when it doesn't have a parent.", node.name);
	}
	
	if (!self.userData[kSKUNavConstantNavNodes]) {
		self.userData[kSKUNavConstantNavNodes] = navNodes;
	}
}

-(void)removeNodeFromNavNodesSKU:(SKNode*)node {
	NSMutableSet* navNodes = self.userData[kSKUNavConstantNavNodes];
	if (navNodes && [navNodes containsObject:node]) {
		[navNodes removeObject:node];
	}
}

-(BOOL)nodeIsMemberOfNavNodesSKU:(SKNode*)node {
	NSMutableSet* navNodes = self.userData[kSKUNavConstantNavNodes];
	if (navNodes && [navNodes containsObject:node]) {
		return YES;
	} else {
		return NO;
	}
}

-(NSSet*)navNodes {
	return (NSSet*)self.userData[kSKUNavConstantNavNodes];
}

-(void)setCurrentFocusedNodeSKU:(SKNode*)node {
	[self skuInternalUpdateCurrentFocusedNode:node];
}

-(void)skuInternalUpdateCurrentFocusedNode:(SKNode*)node {
	if (!node || [SKUSharedUtilities.navFocus.userData[kSKUNavConstantCurrentFocusedNode] isEqual:node] || [self.userData[kSKUNavConstantCurrentFocusedNode] isEqual:node]) {
		return;
	}
	
	if (!SKUSharedUtilities.navFocus.userData) {
		SKUSharedUtilities.navFocus.userData = [NSMutableDictionary dictionaryWithCapacity:kSKUNavConstantUserDictCapacity];
	}
	
	if (!self.userData) {
		self.userData = [NSMutableDictionary dictionaryWithCapacity:kSKUNavConstantUserDictCapacity];
	}
	
	if ([self nodeIsMemberOfNavNodesSKU:node]) { //update current focused node on self if the node is a member of the navNodes set
		self.userData[kSKUNavConstantCurrentFocusedNode] = node;
		NSSet* navNodes = self.userData[kSKUNavConstantNavNodes];
		for (SKNode* tNode in navNodes) {
			if ([tNode isKindOfClass:[SKUButton class]]) {
				SKUButton* button = (SKUButton*)tNode;
				[button unhoverButton];
			}
		}
		if ([node isKindOfClass:[SKUButton class]]) {
			[(SKUButton*)node hoverButton];
		}
		[self currentFocusedNodeUpdatedSKU:node];
	} else if ([SKUSharedUtilities.navFocus nodeIsMemberOfNavNodesSKU:node]) { //update focused node on navFocus if the node is a member of the navNodes set
		SKUSharedUtilities.navFocus.userData[kSKUNavConstantCurrentFocusedNode] = node;
		NSSet* navNodes = SKUSharedUtilities.navFocus.userData[kSKUNavConstantNavNodes];
		for (SKNode* tNode in navNodes) {
			if ([tNode isKindOfClass:[SKUButton class]]) {
				SKUButton* button = (SKUButton*)tNode;
				[button unhoverButton];
			}
		}
		if ([node isKindOfClass:[SKUButton class]]) {
			[(SKUButton*)node hoverButton];
		}
		[SKUSharedUtilities.navFocus currentFocusedNodeUpdatedSKU:node];
	}
}

-(void)currentFocusedNodeUpdatedSKU:(SKNode *)node {
	//override this method to update visuals
}

#if TARGET_OS_TV
-(void)siriRemoteinputBeganSKU:(CGPoint)location withEventDictionary:(NSDictionary*)eventDict {
	
//	if (SKUSharedUtilities.navMode == kSKUNavModeOn) {
//		UITouch* touch = eventDict[@"touch"]; // this whole thing may be unecessary, but not removing cuz I don't remember why I did it
//		if (![SKUSharedUtilities.touchTracker containsObject:touch]) {
//			[SKUSharedUtilities.touchTracker addObject:touch];
//		}
//	}

	[self relativeInputBeganSKU:location withEventDictionary:eventDict];
}

-(void)siriRemoteinputMovedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary*)eventDict {
	if (SKUSharedUtilities.navMode == kSKUNavModeOn) {
//		UITouch* touch = eventDict[@"touch"];
//		if ([SKUSharedUtilities.touchTracker containsObject:touch]) {
			SKNode* prevFocus = SKUSharedUtilities.navFocus.userData[kSKUNavConstantCurrentFocusedNode];
			NSSet* nodeSet = SKUSharedUtilities.navFocus.userData[kSKUNavConstantNavNodes];
			if (!prevFocus) {
				SKULog(0,@"Error: no currently focused node - did you set the initial node focus (setCurrentFocusedNodeSKU:(SKNode*)) **AFTER** you set the navFocus on the singleton ([SKUSharedUtilities setNavFocus:(SKNode*)]?");
			} else if (!nodeSet) {
				SKULog(0,@"Error: no navNodes to navigate through - did you add nodes to the nav nodes (addNodeToNavNodesSKU:(SKNode*)) and set the navFocus on the singleton ([SKUSharedUtilities setNavFocus:(SKNode*)]?");
			} else {
				SKNode* currentFocusNode = [SKUSharedUtilities handleSubNodeMovement:location withCurrentFocus:prevFocus inSet:nodeSet inScene:self.scene];
				[self skuInternalUpdateCurrentFocusedNode:currentFocusNode];
			}
//		}
	} else if (SKUSharedUtilities.navMode == kSKUNavModePressed) { // special case for SKUSliderButton
		SKNode* currentFocus = SKUSharedUtilities.navFocus.userData[kSKUNavConstantCurrentFocusedNode];
		if ([currentFocus isKindOfClass:[SKUSliderButton class]]) {
			SKUSliderButton* slider = (SKUSliderButton*)currentFocus;
			CGFloat stepsize;
			if (slider.stepSize > 0.0) {
				stepsize = slider.stepSize * delta.x;
			} else {
				stepsize = ((slider.maximumValue - slider.minimumValue) / (slider.sliderWidth * 2.0f)) * delta.x;
			}
			slider.value += stepsize;
			[slider sendChanged:NO];
		}
	}
	[self relativeInputMovedSKU:location withDelta:delta withEventDictionary:eventDict];
}

-(void)siriRemoteinputEndedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary*)eventDict {
	if (SKUSharedUtilities.navMode == kSKUNavModeOn) {
//		UITouch* touch = eventDict[@"touch"];
//		if ([SKUSharedUtilities.touchTracker containsObject:touch]) {
//			[SKUSharedUtilities.touchTracker removeObject:touch];
//		}
		[SKUSharedUtilities resetSelectLocation];
	}
	[self relativeInputEndedSKU:location withDelta:delta withEventDictionary:eventDict];
}
#endif

-(void)nodePressedDownSKU:(SKNode*)node {
	
}

-(void)nodePressedUpSKU:(SKNode*)node {
	
}


-(void)relativeInputBeganSKU:(CGPoint)location withEventDictionary:(NSDictionary*)eventDict {
}

-(void)relativeInputMovedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary *)eventDict {
}

-(void)relativeInputEndedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary *)eventDict {
}

-(void)absoluteInputBeganSKU:(CGPoint)location withEventDictionary:(NSDictionary*)eventDict {
}

-(void)absoluteInputMovedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary *)eventDict {
}

-(void)absoluteInputEndedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary *)eventDict {
}

-(void)mouseMovedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary *)eventDict {
}

-(void)inputBeganSKU:(CGPoint)location withEventDictionary:(NSDictionary*)eventDict {
}

-(void)inputMovedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary *)eventDict {
}

-(void)inputEndedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary *)eventDict {
}

-(void)dealloc {
	if ([self isKindOfClass:[SKScene class]]) {
		SKULog(100, @"scene: %@ dealloced", self.name);
	} else {
		SKULog(150, @"node: %@ dealloced", self.name);
	}
}

@end

#pragma mark SKColor Modifications

@implementation SKColor (Mixing)

-(SKColor*)blendWithColorSKU:(SKColor*)color2 alpha:(CGFloat)alpha2 {
	SKColor* tColor1 = self;
	SKColor* tColor2 = color2;
	
#if	TARGET_OS_IPHONE
#else
	if ([tColor1.colorSpaceName isEqualToString:@"NSCalibratedWhiteColorSpace"]) {
		tColor1 = [SKColor convertGrayscaleColorSKU:tColor1];
	}
	if ([tColor2.colorSpaceName isEqualToString:@"NSCalibratedWhiteColorSpace"]) {
		tColor2 = [SKColor convertGrayscaleColorSKU:tColor2];
	}
	if (![self.colorSpaceName isEqualToString:color2.colorSpaceName]) {
		tColor2 = [color2 colorUsingColorSpace:self.colorSpace];
	}
#endif
	
	alpha2 = MIN( 1.0, MAX( 0.0, alpha2 ) );
	CGFloat beta = 1.0 - alpha2;
	CGFloat r1, g1, b1, a1, r2, g2, b2, a2;
	[tColor1 getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
	[tColor2 getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
	CGFloat red	 = r1 * beta + r2 * alpha2;
	CGFloat green   = g1 * beta + g2 * alpha2;
	CGFloat blue	= b1 * beta + b2 * alpha2;
	CGFloat alpha   = a1 * beta + a2 * alpha2;
	return [SKColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+(SKColor*)blendColorSKU:(SKColor *)color1 withColor:(SKColor *)color2 alpha:(CGFloat)alpha2 {
	SKColor* tColor1 = color1.copy;
	return [tColor1 blendWithColorSKU:color2 alpha:alpha2];
}

+(SKColor*)convertGrayscaleColorSKU:(SKColor*)grayScaleColor {
	CGFloat w, a;
	[grayScaleColor getWhite:&w alpha:&a];
	return [SKColor colorWithRed:w green:w blue:w alpha:a];
}

@end



