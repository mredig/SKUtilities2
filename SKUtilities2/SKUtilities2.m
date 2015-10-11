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

CGPoint pointMultiplyByPoint (CGPoint pointA, CGPoint pointB){
	return CGPointMake(pointA.x * pointB.x, pointA.y * pointB.y);
}

CGPoint pointMultiplyByFactor (CGPoint point, CGFloat factor){
	return CGPointMake(point.x * factor, point.y * factor);
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
		NSLog(@"1");
		rValue.c = 0;
		rValue.values[0] = 0;
		return rValue;
	} else {
		double possibleA = (-b + sqrt(discriminant) / (2 * a));
		double possibleB = (-b - sqrt(discriminant) / (2 * a));
		NSLog(@"2");
		
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
		NSLog(@"I've made a huge mistake: Cubic equation seemingly impossible.");
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

@interface SKUtilities2() {
	CGPoint selectLocation; // initial value could be wonky... look into this
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
	_deltaMaxTime = 1.0f;
	_deltaFrameTime = 1.0f/60.0f;
	_deltaFrameTimeUncapped = 1.0f/60.0f;
#if TARGET_OS_TV
	_touchTracker = [NSMutableSet set];
	_navThresholdDistance = 125.0;
	selectLocation = CGPointMake(960.0, 540.0); //midpoint of 1080p
	_navMode = kSKUNavModeOn;
#endif
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

#if TARGET_OS_TV

-(void)setNavFocus:(SKNode *)navFocus {
	_navFocus = navFocus;
}

-(SKNode*)handleSubNodeMovement:(CGPoint)location withCurrentSelection:(SKNode *)currentSelectedNode inSet:(NSSet *)navNodeSet inScene:(SKScene*)scene {
	
	SKNode* rNode;
	
	CGFloat distance = distanceBetween(location, selectLocation);
	if (distance > _navThresholdDistance) {
		CGPoint diff = pointAdd(pointInverse(selectLocation), location);
		
		CGFloat absX, absY;
		absX = fabs(diff.x);
		absY = fabs(diff.y);
		
		if (absX > absY) { // horizontal movement
			if (diff.x > 0) {
				rNode = [self selectDirection:UISwipeGestureRecognizerDirectionRight withNodes:navNodeSet fromCurrentNode:currentSelectedNode inScene:scene];
			} else {
				rNode = [self selectDirection:UISwipeGestureRecognizerDirectionLeft withNodes:navNodeSet fromCurrentNode:currentSelectedNode inScene:scene];
			}
		} else { // vertical movement
			if (diff.y > 0) {
				rNode = [self selectDirection:UISwipeGestureRecognizerDirectionUp withNodes:navNodeSet fromCurrentNode:currentSelectedNode inScene:scene];
			} else {
				rNode = [self selectDirection:UISwipeGestureRecognizerDirectionDown withNodes:navNodeSet fromCurrentNode:currentSelectedNode inScene:scene];
			}
		}
		selectLocation = location;
	} else {
		rNode = currentSelectedNode;
	}
	
	return rNode;
	
}

-(SKNode*)selectDirection:(UISwipeGestureRecognizerDirection)direction withNodes:(NSSet*)pNavNodes fromCurrentNode:(SKNode*)pCurrentNode inScene:(SKScene*)scene {
	
	if (!pCurrentNode.parent) {
		return nil;
	}
	
	CGPoint selectionWorldSpace = [pCurrentNode.parent convertPoint:pCurrentNode.position toNode:scene];
	
	NSMutableSet* directionCandidates = [NSMutableSet set];
	
	for (SKNode* selectionCandidate in pNavNodes) {
		CGPoint newNodeWorldSpace = [selectionCandidate.parent convertPoint:selectionCandidate.position toNode:scene];
		
		switch (direction) {
			case UISwipeGestureRecognizerDirectionUp:
				if (newNodeWorldSpace.y > selectionWorldSpace.y) {
					[directionCandidates addObject:selectionCandidate];
				}
				break;
			case UISwipeGestureRecognizerDirectionDown:
				if (newNodeWorldSpace.y < selectionWorldSpace.y) {
					[directionCandidates addObject:selectionCandidate];
				}
				break;
			case UISwipeGestureRecognizerDirectionLeft:
				if (newNodeWorldSpace.x < selectionWorldSpace.x) {
					[directionCandidates addObject:selectionCandidate];
				}
				break;
			case UISwipeGestureRecognizerDirectionRight:
				if (newNodeWorldSpace.x > selectionWorldSpace.x) {
					[directionCandidates addObject:selectionCandidate];
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
		CGFloat distance = distanceBetween(selectionWorldSpace, newNodeWorldSpace);
		if (distance < lowestDistance) {
			newNode = directionCand;
			lowestDistance = distance;
		}
	}
	return newNode;
}
#endif

@end

#pragma mark SKU_PositionObject

@implementation SKU_PositionObject

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


+(SKU_PositionObject*)position:(CGPoint)location {
	return [[SKU_PositionObject alloc]initWithPosition:location];
}

+(SKU_PositionObject*)vector:(CGVector)vector {
	return [[SKU_PositionObject alloc]initWithVector:vector];
}

+(SKU_PositionObject*)size:(CGSize)size {
	return [[SKU_PositionObject alloc]initWithSize:size];
}

+(SKU_PositionObject*)rect:(CGRect)rect {
	return [[SKU_PositionObject alloc]initWithRect:rect];
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

#pragma mark SKU_ShapeNode

@interface SKU_ShapeNode() {
	
	CAShapeLayer* shapeLayer;
	
	CGSize boundingSize;
	
	SKSpriteNode* drawSprite;
	CGPoint defaultPosition;
	
	SKNode* null;
	
	
}

@end


@implementation SKU_ShapeNode

+(SKU_ShapeNode*)circleWithRadius:(CGFloat)radius andColor:(SKColor*)color{
	CGRect rect = CGRectMake(-radius, -radius, radius*2.0, radius*2.0);
	CGPathRef circle = CGPathCreateWithEllipseInRect(rect, NULL);
	
	SKU_ShapeNode* shapeNode = [SKU_ShapeNode node];
	shapeNode.fillColor = color;
	shapeNode.path = circle;
	
	CGPathRelease(circle);
	
	return shapeNode;
}

+(SKU_ShapeNode*)squareWithWidth:(CGFloat)width andColor:(SKColor*)color{
	CGRect rect = CGRectMake(-width / 2.0, -width / 2.0, width, width);
	CGPathRef square = CGPathCreateWithRect(rect, NULL);
	
	SKU_ShapeNode* shapeNode = [SKU_ShapeNode node];
	shapeNode.fillColor = color;
	shapeNode.path = square;
	
	CGPathRelease(square);
	
	return shapeNode;
}

+(SKU_ShapeNode*)rectangleWithSize:(CGSize)size andColor:(SKColor*)color{
	CGRect rect = CGRectMake(-size.width / 2.0, -size.height / 2.0, size.width, size.height);
	CGPathRef rectPath = CGPathCreateWithRect(rect, NULL);
	
	SKU_ShapeNode* shapeNode = [SKU_ShapeNode node];
	shapeNode.fillColor = color;
	shapeNode.path = rectPath;
	
	CGPathRelease(rectPath);
	
	return shapeNode;
}

+(SKU_ShapeNode*)rectangleRoundedWithSize:(CGSize)size andCornerRadius:(CGFloat)radius andColor:(SKColor*)color{
	CGRect rect = CGRectMake(-size.width / 2.0, -size.height / 2.0, size.width, size.height);
	CGPathRef rectPath = CGPathCreateWithRoundedRect(rect, radius, radius, NULL);
	
	SKU_ShapeNode* shapeNode = [SKU_ShapeNode node];
	shapeNode.fillColor = color;
	shapeNode.path = rectPath;
	
	CGPathRelease(rectPath);
	
	return shapeNode;
}

+(SKU_ShapeNode*)shapeWithPath:(CGPathRef)path andColor:(SKColor *)color {
	SKU_ShapeNode* shapeNode = [SKU_ShapeNode node];
	shapeNode.fillColor = color;
	shapeNode.path = path;
	return shapeNode;
}
-(id)init {
	
	if (self = [super init]) {
		
		self.name = @"SKU_ShapeNode";
		
		null = [SKNode node];
		null.name = @"SKU_ShapeNodeNULL";
		[self addChild:null];
		
		drawSprite = [SKSpriteNode node];
		drawSprite.name = @"SKU_ShapeNodeDrawSprite";
		[null addChild:drawSprite];
//		_boundingSize = CGSizeMake(500, 500);
		_strokeColor = [SKColor whiteColor];
		_fillColor = [SKColor clearColor];
		_lineWidth = 0.0;
		_fillRule = kCAFillRuleNonZero;
		_lineCap = kCALineCapButt;
		_lineDashPattern = nil;
		_lineDashPhase = 0;
		_lineJoin = kCALineJoinMiter;
		_miterLimit = 10.0;
		_strokeEnd = 1.0;
		_strokeStart = 0.0;
		
		_anchorPoint = CGPointMake(0.5, 0.5);
	}
	
	return self;
}


-(void)redrawTexture {
	
	if (!_path) {
		return;
	}
	
	if (!shapeLayer) {
		shapeLayer = [CAShapeLayer layer];
	}
	
	shapeLayer.strokeColor = [_strokeColor CGColor];
	shapeLayer.fillColor = [_fillColor CGColor];
	shapeLayer.lineWidth = _lineWidth;
	shapeLayer.fillRule = _fillRule;
	shapeLayer.lineCap = _lineCap;
	shapeLayer.lineDashPattern = _lineDashPattern;
	shapeLayer.lineDashPhase = _lineDashPhase;
	shapeLayer.lineJoin = _lineJoin;
	shapeLayer.miterLimit = _miterLimit;
	shapeLayer.strokeEnd = _strokeEnd;
	shapeLayer.strokeStart = _strokeStart;

	
	CGRect enclosure = CGPathGetPathBoundingBox(_path);
//	NSLog(@"bounding: %f %f %f %f", enclosure.origin.x, enclosure.origin.y, enclosure.size.width, enclosure.size.height);
	CGPoint enclosureOffset;
	
	if (![_strokeColor isEqual:[SKColor clearColor]]) {
		enclosureOffset = CGPointMake(enclosure.origin.x - _lineWidth, enclosure.origin.y - _lineWidth);
	} else {
		enclosureOffset = CGPointMake(enclosure.origin.x, enclosure.origin.y);
	}
	
	CGAffineTransform transform = CGAffineTransformMake(1, 0, 0, 1, -enclosureOffset.x, -enclosureOffset.y);
	CGPathRef newPath = CGPathCreateCopyByTransformingPath(_path, &transform);
	
	shapeLayer.path = newPath;
	
	boundingSize = CGSizeMake(enclosure.size.width + _lineWidth * 2, enclosure.size.height + _lineWidth * 2);
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	CGContextRef context = CGBitmapContextCreate(NULL, boundingSize.width, boundingSize.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast); //fixing this warning with a proper CGBitmapInfo enum causes the build to crash - Perhaps I did something wrong?
//	CGContextRef context = CGBitmapContextCreate(NULL, _boundingSize.width, _boundingSize.height, 8, 0, colorSpace, kCGBitmapAlphaInfoMask);
	
//	CGContextTranslateCTM(context, enclosureOffset.x, enclosureOffset.y);
	
	[shapeLayer renderInContext:context];
	
	CGImageRef imageRef = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	CGPathRelease(newPath);
	
	
	SKTexture* tex = [SKTexture textureWithCGImage:imageRef];
	
	CGImageRelease(imageRef);
	
	drawSprite.texture = tex;
	drawSprite.size = boundingSize;
	drawSprite.anchorPoint = CGPointZero;
	defaultPosition = CGPointMake(enclosureOffset.x, enclosureOffset.y);
	drawSprite.position = defaultPosition;
	[self setAnchorPoint:_anchorPoint];
	
}

-(void)setAnchorPoint:(CGPoint)anchorPoint {
	_anchorPoint = anchorPoint;
//	drawSprite.position = defaultPosition;
	null.position = CGPointMake(boundingSize.width * (0.5 - anchorPoint.x), boundingSize.height * (0.5 - anchorPoint.y));
//	NSLog(@"defx: %f defy: %f boundw: %f boundh: %f finalx: %f finaly: %f", defaultPosition.x, defaultPosition.y, boundingSize.width, boundingSize.height, drawSprite.position.x, drawSprite.position.y);
}


-(void)setPath:(CGPathRef)path {
	_path = path;
	[self redrawTexture];
}

-(void)setFillColor:(SKColor *)fillColor {
	_fillColor = fillColor;
	[self redrawTexture];
}

-(void)setStrokeEnd:(CGFloat)strokeEnd {
	_strokeEnd = strokeEnd;
	[self redrawTexture];
}

-(void)setStrokeStart:(CGFloat)strokeStart {
	_strokeStart = strokeStart;
	[self redrawTexture];
}

@end


#pragma mark SKU_MultiLineLabelNode

@interface SKU_MultiLineLabelNode () {
	
	bool setupMode;
	
}

@end

@implementation SKU_MultiLineLabelNode

#pragma mark init and convenience methods
- (instancetype) init
{
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
- (instancetype)initWithFontNamed:(NSString *)fontName
{
	self = [self init];
	
	if (self) {
		self.fontName = fontName;
	}
	
	return self;
}

//Convenience method to support drop-in replacement for SKLabelNode
+ (instancetype)labelNodeWithFontNamed:(NSString *)fontName
{
	SKU_MultiLineLabelNode* node = [[SKU_MultiLineLabelNode alloc] initWithFontNamed:fontName];
	
	return node;
}

#pragma mark setters for SKLabelNode properties
//For each of the setters, after we set the appropriate property, we call the
//retexture method to generate and apply our new texture to the node

-(void) setFontColor:(SKColor *)fontColor
{
	_fontColor = fontColor;
	[self retexture];
}

-(void) setFontName:(NSString *)fontName
{
	_fontName = fontName;
	[self retexture];
}

-(void) setFontSize:(CGFloat)fontSize
{
	_fontSize = fontSize;
	[self retexture];
}

-(void) setHorizontalAlignmentMode:(SKLabelHorizontalAlignmentMode)horizontalAlignmentMode
{
	_horizontalAlignmentMode = horizontalAlignmentMode;
	[self retexture];
}

-(void) setText:(NSString *)text
{
	_text = text;
	[self retexture];
}

-(void) setVerticalAlignmentMode:(SKLabelVerticalAlignmentMode)verticalAlignmentMode
{
	_verticalAlignmentMode = verticalAlignmentMode;
	[self retexture];
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
-(void) retexture
{
	SKUImage *newTextImage = [self imageFromText:self.text];
	SKTexture *newTexture;
	
	if (newTextImage) {
		newTexture =[SKTexture textureWithImage:newTextImage];
	}
	
	SKSpriteNode *selfNode = (SKSpriteNode*) self;
	selfNode.texture = newTexture;
	
	//Resetting the texture also reset the anchorPoint.  Let's recenter it.
	selfNode.anchorPoint = CGPointMake(0.5, 0.5);
	
}




-(SKUImage*)imageFromText:(NSString *)text
{
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
			NSLog(@"The font you specified was unavailable. Defaulted to Helvetica.");
			//		NSLog(@"The font you specified was unavailable. Defaulted to Helvetica. Here is a list of available fonts: %@", [DSMultiLineLabelFont familyNames]); //only available for debugging on iOS
			//		NSLog(@"Here is a list of variations to %@: %@", _fontName, [DSMultiLineLabelFont familyNames]);
		}
		
	}
	
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
	
	//	NSLog(@"textRect = %f %f %f %f", textRect.origin.x, textRect.origin.y, textRect.size.width, textRect.size.height);
	
	//The size of the bounding rect is going to be the size of our new node, so set the size here.
	SKSpriteNode *selfNode = (SKSpriteNode*) self;
	selfNode.size = textRect.size;
	
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
-(NSTextAlignment) mapSkLabelHorizontalAlignmentToNSTextAlignment:(SKLabelHorizontalAlignmentMode)alignment
{
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

@end

@implementation SKUButtonLabelPropertiesPackage

-(id)copyWithZone:(NSZone *)zone {
	return [SKUButtonLabelPropertiesPackage packageWithPropertiesForDefaultState:_propertiesDefaultState.copy andPressedState:_propertiesPressedState.copy andDisabledState:_propertiesDisabledState.copy];
}

+(SKUButtonLabelPropertiesPackage*)packageWithPropertiesForDefaultState:(SKUButtonLabelProperties *)defaultState andPressedState:(SKUButtonLabelProperties *)pressedState andDisabledState:(SKUButtonLabelProperties *)disabledState {
	SKUButtonLabelPropertiesPackage* package = [[SKUButtonLabelPropertiesPackage alloc] init];
	package.propertiesDefaultState = defaultState;
	package.propertiesPressedState = pressedState;
	package.propertiesDisabledState = disabledState;
	return package;
}

+(SKUButtonLabelPropertiesPackage*)packageWithPropertiesForDefaultState:(SKUButtonLabelProperties *)defaultState andPressedState:(SKUButtonLabelProperties *)pressedState {
	SKUButtonLabelPropertiesPackage* package = [[SKUButtonLabelPropertiesPackage alloc] init];
	package.propertiesDefaultState = defaultState;
	package.propertiesPressedState = pressedState;
	package.propertiesDisabledState = defaultState.copy;
	package.propertiesDisabledState.fontColor = [SKColor blendColor:defaultState.fontColor withColor:[SKColor grayColor] alpha:0.5];
	return package;
}

+(SKUButtonLabelPropertiesPackage*)packageWithPropertiesForDefaultState:(SKUButtonLabelProperties *)defaultState {
	SKUButtonLabelPropertiesPackage* package = [[SKUButtonLabelPropertiesPackage alloc] init];
	package.propertiesDefaultState = defaultState;
	package.propertiesPressedState = defaultState.copy;
	package.propertiesPressedState.scale *= 0.9;
	package.propertiesDisabledState = defaultState.copy;
	package.propertiesDisabledState.fontColor = [SKColor blendColor:defaultState.fontColor withColor:[SKColor grayColor] alpha:0.5];
	return package;
}

-(void)changeText:(NSString *)text {
	_propertiesDefaultState.text = text;
	_propertiesPressedState.text = text;
	_propertiesDisabledState.text = text;
}

@end

#pragma mark SKUButtonSpriteStateProperties

@implementation SKUButtonSpriteStateProperties

-(id)copyWithZone:(NSZone *)zone {
	return [SKUButtonSpriteStateProperties propertiesWithTexture:_texture andAlpha:_alpha andColor:_color andColorBlendFactor:_colorBlendFactor andPositionOffset:_position andXScale:_xScale andYScale:_yScale];
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


-(id)copyWithZone:(NSZone *)zone {
	return [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_propertiesDefaultState.copy andPressedState:_propertiesPressedState.copy andDisabledState:_propertiesDisabledState.copy];
}

+(SKUButtonSpriteStatePropertiesPackage*)packageWithPropertiesForDefaultState:(SKUButtonSpriteStateProperties *)defaultState andPressedState:(SKUButtonSpriteStateProperties *)pressedState andDisabledState:(SKUButtonSpriteStateProperties *)disabledState {
	SKUButtonSpriteStatePropertiesPackage* package = [[SKUButtonSpriteStatePropertiesPackage alloc] init];
	package.propertiesDefaultState = defaultState;
	package.propertiesPressedState = pressedState;
	package.propertiesDisabledState = disabledState;
	return package;
}

+(SKUButtonSpriteStatePropertiesPackage*)packageWithPropertiesForDefaultState:(SKUButtonSpriteStateProperties *)defaultState andPressedState:(SKUButtonSpriteStateProperties *)pressedState {
	SKUButtonSpriteStatePropertiesPackage* package = [[SKUButtonSpriteStatePropertiesPackage alloc] init];
	package.propertiesDefaultState = defaultState;
	package.propertiesPressedState = pressedState;
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
	package.propertiesDisabledState = defaultState.copy;
	package.propertiesDisabledState.alpha *= 0.5;
	return package;
}

-(void)changeTexture:(SKTexture *)texture {
	_propertiesDefaultState.texture = texture;
	_propertiesPressedState.texture = texture;
	_propertiesDisabledState.texture = texture;
}

@end

#pragma mark SKUButton
@interface SKUButton() {
	NSInvocation* downSelector;
	NSInvocation* upSelector;
	SKUButtonSpriteStateProperties* defaultProperties;
	
	BOOL stateDefaultInitialized;
	BOOL statePressedInitialized;
	BOOL stateDisabledInitialized;
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
	button.baseSpriteDefaultProperties = [SKUButtonSpriteStateProperties propertiesWithTexture:texture andAlpha:1.0];
	[button buttonStatesDefault];
	return button;
}

+(SKUButton*)buttonWithTexture:(SKTexture*)texture {
	SKUButton* button = [SKUButton node];
	button.baseSpriteDefaultProperties = [SKUButtonSpriteStateProperties propertiesWithTexture:texture andAlpha:1.0];
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

	SKTexture* tex = [SKTexture textureVectorNoiseWithSmoothness:1.0 size:CGSizeMake(2, 2)];
	defaultProperties = [SKUButtonSpriteStateProperties propertiesWithTexture:tex andAlpha:1.0];
	_baseSpriteDefaultProperties = defaultProperties.copy;
	_baseSpritePressedProperties = defaultProperties.copy;
	_baseSpriteDisabledProperties = defaultProperties.copy;
	stateDefaultInitialized = NO;
	statePressedInitialized = NO;
	stateDisabledInitialized = NO;
	
	[self internalDidInitialize];
	[self enableButton];
	[self didInitialize];
}

-(void)internalDidInitialize {
	if (!_baseSprite) {
		_baseSprite = [SKSpriteNode spriteNodeWithTexture:_baseSpriteDefaultProperties.texture];
		_baseSprite.zPosition = 0.0;
		[self addChild:_baseSprite];
	}
}

-(void)didInitialize {
	
}

#pragma mark SKUButton ACTION SETTERS

-(void)setDownAction:(SEL)selector toPerformOnTarget:(NSObject*)target {
	NSMethodSignature* sig = [target methodSignatureForSelector:selector];
	downSelector = [NSInvocation invocationWithMethodSignature:sig];
	[downSelector retainArguments];
	[downSelector setSelector:selector];
	SKUButton* button = self;
	[downSelector setArgument:&button atIndex:2];
	[downSelector setTarget:target];
	_buttonMethod = _buttonMethod | kSKUButtonMethodRunActions;
}

-(void)setUpAction:(SEL)selector toPerformOnTarget:(NSObject*)target {
	NSMethodSignature* sig = [target methodSignatureForSelector:selector];
	upSelector = [NSInvocation invocationWithMethodSignature:sig];
	[upSelector retainArguments];
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

-(void)setBaseStatesWithPackage:(SKUButtonSpriteStatePropertiesPackage*)package {
	_baseSpriteDefaultProperties = package.propertiesDefaultState;
	_baseSpritePressedProperties = package.propertiesPressedState;
	_baseSpriteDisabledProperties = package.propertiesDisabledState;
	stateDefaultInitialized = YES;
	statePressedInitialized = YES;
	stateDisabledInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}

-(void)setBaseSpriteDefaultProperties:(SKUButtonSpriteStateProperties *)baseSpriteDefaultProperties {
	_baseSpriteDefaultProperties = baseSpriteDefaultProperties;
	stateDefaultInitialized = YES;
	if (!statePressedInitialized) {
		_baseSpritePressedProperties = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_baseSpriteDefaultProperties].propertiesPressedState;
		statePressedInitialized = YES;
	}
	if (!stateDisabledInitialized) {
		_baseSpriteDisabledProperties = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_baseSpriteDefaultProperties].propertiesDisabledState;
		stateDisabledInitialized = YES;
	}
	[self updateCurrentSpriteStateProperties];
}

-(void)setBaseSpritePressedProperties:(SKUButtonSpriteStateProperties *)baseSpritePressedProperties {
	_baseSpritePressedProperties = baseSpritePressedProperties;
	statePressedInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}

-(void)setBaseSpriteDisabledProperties:(SKUButtonSpriteStateProperties *)baseSpriteDisabledProperties {
	_baseSpriteDisabledProperties = baseSpriteDisabledProperties;
	stateDisabledInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}

-(void)updateCurrentSpriteStateProperties {
	SKUButtonSpriteStateProperties* properties;
	switch (_buttonState) {
		case kSKUButtonStateDefault:
			properties = _baseSpriteDefaultProperties;
			break;
		case kSKUButtonStatePressed:
			properties = _baseSpritePressedProperties;
			break;
		case kSKUButtonStateDisabled:
			properties = _baseSpriteDisabledProperties;
			break;
		case kSKUButtonStatePressedOutOfBounds:
			properties = _baseSpriteDefaultProperties;
			break;
			
		default:
			break;
	}
	
	_baseSprite.texture = properties.texture;
	_baseSprite.size = properties.texture.size;
	_baseSprite.position = properties.position;
	_baseSprite.color = properties.color;
	_baseSprite.colorBlendFactor = properties.colorBlendFactor;
	_baseSprite.alpha = properties.alpha;
	_baseSprite.xScale = properties.xScale;
	_baseSprite.yScale = properties.yScale;
}

-(void)setButtonType:(kSKUButtonTypes)buttonType {
	_buttonType = buttonType;
}

#pragma mark SKUButton METHODS

-(void)enableButton {
	_isEnabled = YES;
	_buttonState = kSKUButtonStateDefault;
	[self updateCurrentSpriteStateProperties];
	self.userInteractionEnabled = YES;
}

-(void)disableButton {
	_isEnabled = NO;
	_buttonState = kSKUButtonStateDisabled;
	[self updateCurrentSpriteStateProperties];
	self.userInteractionEnabled = NO;
}

-(void)buttonStatesNormalize {
	SKUButtonSpriteStatePropertiesPackage* package = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_baseSpriteDefaultProperties andPressedState:_baseSpriteDefaultProperties andDisabledState:_baseSpriteDefaultProperties];
	[self setBaseStatesWithPackage:package];
}

-(void)buttonStatesDefault {
	SKUButtonSpriteStatePropertiesPackage* package = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_baseSpriteDefaultProperties];
	[self setBaseStatesWithPackage:package];
}

-(void)inputBegan:(CGPoint)location withEventDictionary:(NSDictionary *)eventDict {
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
			[_delegate doButtonDown:self];
		}
		
		if (actionMethod) {
			[downSelector invoke];
		}
	}
}

-(void)inputMoved:(CGPoint)location withEventDictionary:(NSDictionary *)eventDict {
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

-(void)inputEnded:(CGPoint)location withEventDictionary:(NSDictionary *)eventDict {
	[self buttonReleased:location];
}

-(void)buttonReleased:(CGPoint)location {
	if (_isEnabled) {
		_buttonState = kSKUButtonStateDefault;
		
		[self updateCurrentSpriteStateProperties];
		BOOL notificationMethod = kSKUButtonMethodPostNotification & _buttonMethod;
		BOOL delegateMethod = kSKUButtonMethodDelegate & _buttonMethod;
		BOOL actionMethod = kSKUButtonMethodRunActions & _buttonMethod;
		
		BOOL locationIsInBounds = [self checkIfLocationIsWithinButtonBounds:location];
		
		if (notificationMethod && locationIsInBounds) {
			[[NSNotificationCenter defaultCenter] postNotificationName:_notificationNameUp object:self];
		}
		
		if (delegateMethod) {
			[_delegate doButtonUp:self inBounds:locationIsInBounds];
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


@end


#pragma mark SKUPushButton

@interface SKUPushButton() {
	BOOL stateTSpriteDefaultInitialized;
	BOOL stateTSpritePressedInitialized;
	BOOL stateTSpriteDisabledInitialized;
	BOOL stateTLabelDefaultInitialized;
	BOOL stateTLabelPressedInitialized;
	BOOL stateTLabelDisabledInitialized;
}

@end

@implementation SKUPushButton
#pragma mark SKUPushButton inits
+(SKUPushButton*)pushButtonWithBackgroundTexture:(SKTexture*)texture {
	SKUPushButton* button = [SKUPushButton node];
	button.baseSpriteDefaultProperties = [SKUButtonSpriteStateProperties propertiesWithTexture:texture andAlpha:1.0];
	[button buttonStatesDefault];
	return button;
}

+(SKUPushButton*)pushButtonWithImageNamed:(NSString*)name {
	SKUPushButton* button = [SKUPushButton node];
	button.baseSpriteDefaultProperties = [SKUButtonSpriteStateProperties propertiesWithTexture:[SKTexture textureWithImageNamed:name] andAlpha:1.0];
	[button buttonStatesDefault];
	return button;
}

+(SKUPushButton*)pushButtonWithBackgroundTexture:(SKTexture*)backgroundTexture andTitleTexture:(SKTexture*)titleTexture {
	SKUPushButton* button = [SKUPushButton node];
	button.baseSpriteDefaultProperties = [SKUButtonSpriteStateProperties propertiesWithTexture:backgroundTexture andAlpha:1.0];
	button.titleSpriteDefaultProperties = [SKUButtonSpriteStateProperties propertiesWithTexture:titleTexture andAlpha:1.0];
	[button buttonStatesDefault];
	return button;
}

+(SKUPushButton*)pushButtonWithBackgroundTexture:(SKTexture*)texture andTitleLabelText:(NSString*)text {
	SKUPushButton* button = [SKUPushButton node];
	button.baseSpriteDefaultProperties = [SKUButtonSpriteStateProperties propertiesWithTexture:texture andAlpha:1.0];
	button.labelPropertiesDefault = [SKUButtonLabelProperties propertiesWithText:text andColor:[SKColor whiteColor] andSize:35.0 andFontName:@"Helvetica Neue"];
	[button buttonStatesDefault];
	return button;
}

+(SKUPushButton*)pushButtonWithBackgroundTexture:(SKTexture*)texture andTitleLabelText:(NSString*)text andTitleLabelColor:(SKColor*)fontColor andTitleLabelSize:(CGFloat)fontSize andTitleLabelFont:(NSString*)fontName {
	SKUPushButton* button = [SKUPushButton node];
	button.baseSpriteDefaultProperties = [SKUButtonSpriteStateProperties propertiesWithTexture:texture andAlpha:1.0];
	button.labelPropertiesDefault = [SKUButtonLabelProperties propertiesWithText:text andColor:fontColor andSize:fontSize andFontName:fontName];
	[button buttonStatesDefault];
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
	stateTSpriteDisabledInitialized = NO;
	stateTLabelDefaultInitialized = NO;
	stateTLabelPressedInitialized = NO;
	stateTLabelDisabledInitialized = NO;
	[self setButtonType:kSKUButtonTypePush];
	[super internalDidInitialize];
}

#pragma mark SKUPushButton setters

-(void)updateCurrentSpriteStateProperties {
	[super updateCurrentSpriteStateProperties];
	SKUButtonSpriteStateProperties* propertiesSprite;
	SKUButtonLabelProperties* propertiesLabel;
	switch (self.buttonState) {
		case kSKUButtonStateDefault:
			propertiesSprite = _titleSpriteDefaultProperties;
			propertiesLabel = _labelPropertiesDefault;
			break;
		case kSKUButtonStatePressed:
			propertiesSprite = _titleSpritePressedProperties;
			propertiesLabel = _labelPropertiesPressed;
			break;
		case kSKUButtonStateDisabled:
			propertiesSprite = _titleSpriteDisabledProperties;
			propertiesLabel = _labelPropertiesDisabled;
			break;
		case kSKUButtonStatePressedOutOfBounds:
			propertiesSprite = _titleSpriteDefaultProperties;
			propertiesLabel = _labelPropertiesDefault;
			break;
			
		default:
			break;
	}
	
	if (_titleSprite) {
		_titleSprite.texture = propertiesSprite.texture;
		_titleSprite.size = propertiesSprite.texture.size;
		_titleSprite.position = propertiesSprite.position;
		_titleSprite.color = propertiesSprite.color;
		_titleSprite.colorBlendFactor = propertiesSprite.colorBlendFactor;
		_titleSprite.alpha = propertiesSprite.alpha;
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
}

-(void)setTitleSpriteDefaultProperties:(SKUButtonSpriteStateProperties *)titleSpriteDefaultProperties {
	_titleSpriteDefaultProperties = titleSpriteDefaultProperties;
	if (!_titleSprite) {
		_titleSprite = [SKSpriteNode spriteNodeWithTexture:_titleSpriteDefaultProperties.texture];
		_titleSprite.zPosition = 0.001;
		[self addChild:_titleSprite];
	}
	stateTSpriteDefaultInitialized = YES;
	
	if (!stateTSpritePressedInitialized) {
		_titleSpritePressedProperties = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_titleSpriteDefaultProperties].propertiesPressedState;
		stateTSpritePressedInitialized = YES;
	}
	
	if (!stateTSpriteDisabledInitialized) {
		_titleSpriteDisabledProperties = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_titleSpriteDefaultProperties].propertiesDisabledState;
		stateTSpriteDisabledInitialized = YES;
	}
	
	[self updateCurrentSpriteStateProperties];
}

-(void)setTitleSpritePressedProperties:(SKUButtonSpriteStateProperties *)titleSpritePressedProperties {
	_titleSpritePressedProperties = titleSpritePressedProperties;
	stateTSpritePressedInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}

-(void)setTitleSpriteDisabledProperties:(SKUButtonSpriteStateProperties *)titleSpriteDisabledProperties {
	_titleSpriteDisabledProperties = titleSpriteDisabledProperties;
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
		[self addChild:_titleLabel];
	}
	stateTLabelDefaultInitialized = YES;
	
	if (!stateTLabelPressedInitialized) {
		_labelPropertiesPressed = [SKUButtonLabelPropertiesPackage packageWithPropertiesForDefaultState:_labelPropertiesDefault].propertiesPressedState;
		stateTLabelPressedInitialized = YES;
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

-(void)setLabelPropertiesDisabled:(SKUButtonLabelProperties *)labelPropertiesDisabled {
	_labelPropertiesDisabled = labelPropertiesDisabled;
	stateTLabelDisabledInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}

-(void)setTitleSpriteStatesWithPackage:(SKUButtonSpriteStatePropertiesPackage*)package {
	_titleSpritePressedProperties = package.propertiesPressedState;
	stateTSpritePressedInitialized = YES;
	_titleSpriteDisabledProperties = package.propertiesDisabledState;
	stateTSpriteDisabledInitialized = YES;
	self.titleSpriteDefaultProperties = package.propertiesDefaultState;
	stateTSpriteDefaultInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}

-(void)setTitleLabelStatesWithPackage:(SKUButtonLabelPropertiesPackage*)package {
	_labelPropertiesPressed = package.propertiesPressedState;
	stateTLabelPressedInitialized = YES;
	_labelPropertiesDisabled = package.propertiesDisabledState;
	stateTLabelDisabledInitialized = YES;
	self.labelPropertiesDefault = package.propertiesDefaultState;
	stateTLabelDefaultInitialized = YES;
	[self updateCurrentSpriteStateProperties];
}

-(void)buttonStatesDefault {
	[super buttonStatesDefault];
	
	if (_titleSpriteDefaultProperties.texture) {
		SKUButtonSpriteStatePropertiesPackage* package = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_titleSpriteDefaultProperties];
		[self setTitleSpriteStatesWithPackage:package];
		
	} else {
		stateTSpriteDefaultInitialized = NO;
		stateTSpritePressedInitialized = NO;
		stateTSpriteDisabledInitialized = NO;
	}

	if (_labelPropertiesDefault.text) {
		SKUButtonLabelPropertiesPackage* package = [SKUButtonLabelPropertiesPackage packageWithPropertiesForDefaultState:_labelPropertiesDefault];
		[self setTitleLabelStatesWithPackage:package];
		
	} else {
		stateTLabelDefaultInitialized = NO;
		stateTLabelPressedInitialized = NO;
		stateTLabelDisabledInitialized = NO;
	}

}

-(void)buttonStatesNormalize {
	[super buttonStatesNormalize];
	
	if (_titleSpriteDefaultProperties.texture) {
		SKUButtonSpriteStatePropertiesPackage* package = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:_titleSpriteDefaultProperties andPressedState:_titleSpriteDefaultProperties andDisabledState:_titleSpriteDefaultProperties];
		[self setTitleSpriteStatesWithPackage:package];
	} else {
		stateTSpriteDefaultInitialized = NO;
		stateTSpritePressedInitialized = NO;
		stateTSpriteDisabledInitialized = NO;
	}
	
	if (_labelPropertiesDefault.text) {
		SKUButtonLabelPropertiesPackage* package = [SKUButtonLabelPropertiesPackage packageWithPropertiesForDefaultState:_labelPropertiesDefault andPressedState:_labelPropertiesDefault andDisabledState:_labelPropertiesDefault];
		[self setTitleLabelStatesWithPackage:package];
		
	} else {
		stateTLabelDefaultInitialized = NO;
		stateTLabelPressedInitialized = NO;
		stateTLabelDisabledInitialized = NO;
	}
}


//-(void)set

@end


#pragma mark CLASS CATEGORIES

#pragma mark SKNode Modifications

@implementation SKNode (ConsolidatedInput)


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
	[self siriRemoteInputBegan:location withEventDictionary:eventDict];
#else
	[self inputBegan:location withEventDictionary:eventDict];
#endif
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
#if TARGET_OS_TV
	[self siriRemoteInputMoved:location withEventDictionary:eventDict];
#else
	[self inputMoved:location withEventDictionary:eventDict];
#endif
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
#if TARGET_OS_TV
	[self siriRemoteInputEnded:location withEventDictionary:eventDict];
#else
	[self inputEnded:location withEventDictionary:eventDict];
#endif
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
#if TARGET_OS_TV
	[self siriRemoteInputEnded:location withEventDictionary:eventDict];
#else
	[self inputEnded:location withEventDictionary:eventDict];
#endif
}

#else

-(void)mouseDown:(NSEvent *)theEvent {
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
	[self inputBegan:location withEventDictionary:eventDict];
}

-(void)mouseDragged:(NSEvent *)theEvent {
	
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
	[self inputMoved:location withEventDictionary:eventDict];
}

-(void)mouseUp:(NSEvent *)theEvent {
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
	[self inputEnded:location withEventDictionary:eventDict];
	
}

-(void)mouseExited:(NSEvent *)theEvent {
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
	[self inputEnded:location withEventDictionary:eventDict];
}

-(void)rightMouseDown:(NSEvent *)theEvent {
	
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
	[self inputBegan:location withEventDictionary:eventDict];}

-(void)rightMouseDragged:(NSEvent *)theEvent {
	
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
	[self inputMoved:location withEventDictionary:eventDict];
}

-(void)rightMouseUp:(NSEvent *)theEvent {
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
	[self inputEnded:location withEventDictionary:eventDict];
	
}

-(void)otherMouseDown:(NSEvent *)theEvent {
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
	[self inputBegan:location withEventDictionary:eventDict];
}

-(void)otherMouseDragged:(NSEvent *)theEvent {
	
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
	[self inputMoved:location withEventDictionary:eventDict];
}

-(void)otherMouseUp:(NSEvent *)theEvent {
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
	[self inputEnded:location withEventDictionary:eventDict];
	
}

#endif


#if TARGET_OS_TV


-(void)addNodeToNavNodes:(SKNode*)node {
	
	if (!self.userData) {
		self.userData = [NSMutableDictionary dictionary];
	}
	
	NSMutableSet* navNodes = self.userData[@"sku_navNodes"];
	
	if (!navNodes) {
		navNodes = [NSMutableSet set];
	}
	
	if (node.parent) {
		[navNodes addObject:node];
	} else {
		NSLog(@"error: can't add node named '%@' to navNodes when it doesn't have a parent.", node.name);
	}
	
	if (!self.userData[@"sku_navNodes"]) {
		self.userData[@"sku_navNodes"] = navNodes;
	}
}

-(void)setCurrentSelectedNode:(SKNode*)node {
	[self skuInternalUpdateCurrentSelectedNode:node];
}

-(void)skuInternalUpdateCurrentSelectedNode:(SKNode*)node {
	if (!node || [self.userData[@"sku_currentSelectedNode"] isEqual:node]) {
		return;
	}
	
	if (!self.userData) {
		self.userData = [NSMutableDictionary dictionary];
	}
	
	self.userData[@"sku_currentSelectedNode"] = node;
	[self currentSelectedNodeUpdated:node];
}

-(void)currentSelectedNodeUpdated:(SKNode *)node {
	//override this method to update visuals
}

-(void)siriRemoteInputBegan:(CGPoint)location withEventDictionary:(NSDictionary*)eventDict {
	
	if (SKUSharedUtilities.navMode == kSKUNavModeOn) {
		UITouch* touch = eventDict[@"touch"];
		if (![SKUSharedUtilities.touchTracker containsObject:touch]) {
			[SKUSharedUtilities.touchTracker addObject:touch];
		}
	}

	[self inputBegan:location withEventDictionary:eventDict];
}

-(void)siriRemoteInputMoved:(CGPoint)location withEventDictionary:(NSDictionary*)eventDict {
	if (SKUSharedUtilities.navMode == kSKUNavModeOn) {
		UITouch* touch = eventDict[@"touch"];
		if ([SKUSharedUtilities.touchTracker containsObject:touch]) {
			SKNode* prevSelection = SKUSharedUtilities.navFocus.userData[@"sku_currentSelectedNode"];
			NSSet* nodeSet = SKUSharedUtilities.navFocus.userData[@"sku_navNodes"];
			if (!prevSelection) {
				NSLog(@"Error: no currently selected node - did you set the initial node selection (setCurrentSelectedNode:(SKNode*)) and set the navFocus on the singleton ([SKUSharedUtilities setNavFocus:(SKNode*)]?");
			} else if (!nodeSet) {
				NSLog(@"Error: no navNodes to navigate through - did you add nodes to the nav nodes (addNodeToNavNodes:(SKNode*)) and set the navFocus on the singleton ([SKUSharedUtilities setNavFocus:(SKNode*)]?");
			} else {
				SKNode* currentSelectionNode = [SKUSharedUtilities handleSubNodeMovement:location withCurrentSelection:prevSelection inSet:nodeSet inScene:self.scene];
				[self skuInternalUpdateCurrentSelectedNode:currentSelectionNode];
			}
		}
	}
	[self inputMoved:location withEventDictionary:eventDict];
}

-(void)siriRemoteInputEnded:(CGPoint)location withEventDictionary:(NSDictionary*)eventDict {
	if (SKUSharedUtilities.navMode == kSKUNavModeOn) {
		UITouch* touch = eventDict[@"touch"];
		if (![SKUSharedUtilities.touchTracker containsObject:touch]) {
			[SKUSharedUtilities.touchTracker removeObject:touch];
		}
	}
	[self inputEnded:location withEventDictionary:eventDict];
}



#endif



-(void)inputBegan:(CGPoint)location withEventDictionary:(NSDictionary*)eventDict {

}

-(void)inputMoved:(CGPoint)location withEventDictionary:(NSDictionary*)eventDict {

}

-(void)inputEnded:(CGPoint)location withEventDictionary:(NSDictionary*)eventDict {

}

@end

#pragma mark SKColor Modifications

@implementation SKColor (Mixing)

-(SKColor*)blendWithColor:(SKColor*)color2 alpha:(CGFloat)alpha2 {
	SKColor* tColor1 = self;
	SKColor* tColor2 = color2;
	
#if	TARGET_OS_IPHONE
#else
	if ([tColor1.colorSpaceName isEqualToString:@"NSCalibratedWhiteColorSpace"]) {
		tColor1 = [SKColor convertGrayscaleColor:tColor1];
	}
	if ([tColor2.colorSpaceName isEqualToString:@"NSCalibratedWhiteColorSpace"]) {
		tColor2 = [SKColor convertGrayscaleColor:tColor2];
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

+(SKColor*)blendColor:(SKColor *)color1 withColor:(SKColor *)color2 alpha:(CGFloat)alpha2 {
	SKColor* tColor1 = color1.copy;
	return [tColor1 blendWithColor:color2 alpha:alpha2];
}

+(SKColor*)convertGrayscaleColor:(SKColor*)grayScaleColor {
	CGFloat w, a;
	[grayScaleColor getWhite:&w alpha:&a];
	return [SKColor colorWithRed:w green:w blue:w alpha:a];
}

@end



