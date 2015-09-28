//
//  SKUtilities2.h
//  SKUtilities2
//
//  Created by Michael Redig on 9/26/15.
//  Copyright © 2015 Michael Redig. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark CONSTANTS

#define kSKUPadToPhoneScale ((CGFloat) 0.41666)
#define kSKUPhoneFromPadScale ((CGFloat) 0.41666)
#define kSKUPhoneToPadScale ((CGFloat) 2.40003840061441) //likely very low usage as it would be upscaling
#define kSKUPadFromPhoneScale ((CGFloat) 2.40003840061441)

#define kSKUDegToRadConvFactor 0.017453292519943295 // pi/180
#define kSKURadToDegConvFactor 57.29577951308232 // 180/pi

#define VISIBLE 0 //for node.hidden properties, this is more intuitive than YES/NO
#define HIDDEN 1 //for node.hidden properties, this is more intuitive than YES/NO

#if TARGET_OS_IPHONE
#define SKUImage UIImage
#define SKUFont UIFont
#else
#define SKUImage NSImage
#define SKUFont NSFont
#endif


#pragma mark NUMBER INTERPOLATION
/**
 Returns a CGFloat interpolated linearly between two values. Clipped determines whether it can go beyond the bounds of the values.
@param valueA
 CGFloat low end value
@param valueB
 CGFloat high end value
@param pointBetween
 CGFloat value between the two numbers to interpolate to; 0.0 = valueA, 1.0 = valueB
@param clipped
 bool determines whether or not pointBetween can be a value beyond the range of 0.0 to 1.0
*/
CGFloat linearInterpolationBetweenFloatValues (CGFloat valueA, CGFloat valueB, CGFloat pointBetween, bool clipped);

/**
 Returns a CGFloat of the value of pointBetween interpolated linearly between two values. Clipped determines whether it can go beyond the bounds of the values. If that didn't make sense, it's a reversal of what linearInterpolationBetweenFloatValues does - it will return the value of "pointBetween" from linearInterpolationBetweenFloatValues.
@param valueA
 CGFloat low end range value
@param valueB
 CGFloat high end range value
@param valueBetween
 CGFloat point between the two numbers to interpolate to; valueA = 0.0, valueB = 1.0
@param clipped
 bool determines whether or not valueBetween can be a value beyond the range of valueA to valueB
 */

CGFloat reverseLinearInterpolationBetweenFloatValues (CGFloat valueA, CGFloat valueB, CGFloat valueBetween, bool clipped);

/**
 Returns a CGFloat modifying currentValue that iteratively changes over time to become closer to idealValue in iterations of stepValue
 @param idealValue
 CGFloat value that you are approaching
 @param currentValue
 CGFloat input value of where you are now
 @param stepValue
 CGFloat amount to iterate by
 */
CGFloat rampToValue (CGFloat idealValue, CGFloat currentValue, CGFloat stepValue);

#pragma mark RANDOM NUMBERS

/**
 Returns a u_int_32_t value randomized between two other values.
 @param lowend
 u_int32_t low end range value
 @param highend
 u_int32_t high end range value
 */
u_int32_t randomUnsignedIntegerBetweenTwoValues (u_int32_t lowend, u_int32_t highend);

/**
 Returns a CGFloat value randomized between zero and a higher value.
 @param highend
 CGFloat max range value
 */
CGFloat randomFloatBetweenZeroAndHighend (CGFloat highend);

#pragma mark DISTANCE FUNCTIONS

/**
 Returns a CGFloat value measuring the distance between two CGPoint values.
 @param pointA
 CGPoint start or end point
 @param pointB
 CGPoint start or end point
 */
CGFloat distanceBetween (CGPoint pointA, CGPoint pointB);


/**
 Returns a bool value determining if the distance between two points is less than a predetermined maximum value.
 @param pointA
 CGPoint start or end point
 @param pointB
 CGPoint start or end point
 @param xDistance
 CGFloat max distance between points
 */
bool distanceBetweenIsWithinXDistance (CGPoint pointA, CGPoint pointB, CGFloat xDistance);


/**
 Returns a bool value determining if the distance between two points is less than a predetermined maximum value. This is a small optimization over the previous function as it saves the step of squaring the x value.
 @param pointA
 CGPoint start or end point
 @param pointB
 CGPoint start or end point
 @param xDistancePresquared
 CGFloat max distance between points, squared (x * x)
 */
bool distanceBetweenIsWithinXDistancePreSquared (CGPoint pointA, CGPoint pointB, CGFloat xDistanceSquared);


#pragma mark ORIENTATION


/**
 Returns a float value in radians to rotate a node at position *from* to face *facing*, when the node is facing right at 0 rotation.
 @param facing
 CGPoint a point in the direction that the node should be facing.
 @param from
 CGPoint point that the node is located at
 */
CGFloat orientToFromRightFace (CGPoint facing, CGPoint from);
/**
 Returns a float value in radians to rotate a node at position *from* to face *facing*, when the node is facing up at 0 rotation.
 @param facing
 CGPoint a point in the direction that the node should be facing.
 @param from
 CGPoint point that the node is located at
 */
CGFloat orientToFromUpFace (CGPoint facing, CGPoint from);
/**
 Returns a float value in radians to rotate a node at position *from* to face *facing*, when the node is facing left at 0 rotation.
 @param facing
 CGPoint a point in the direction that the node should be facing.
 @param from
 CGPoint point that the node is located at
 */
CGFloat orientToFromLeftFace (CGPoint facing, CGPoint from);
/**
 Returns a float value in radians to rotate a node at position *from* to face *facing*, when the node is facing down at 0 rotation.
 @param facing
 CGPoint a point in the direction that the node should be facing.
 @param from
 CGPoint point that the node is located at
 */
CGFloat orientToFromDownFace (CGPoint facing, CGPoint from);


#pragma mark CGVector HELPERS

/**
 Returns a CGVector struct converted from a CGPoint struct.
 @param point
 CGPoint point struct to be converted
 */
CGVector vectorFromCGPoint (CGPoint point);
/**
 Returns a CGVector struct converted from a CGSize struct.
 @param size
 CGSize size struct to be converted
 */
CGVector vectorFromCGSize (CGSize size);
/**
 Returns a CGVector struct with negated values.
 @param vector
 CGVector vector struct to be inverted
 */
CGVector vectorInverse (CGVector vector);
/**
 Returns a CGVector normalized to have a distance of 1.0.
 @param vector
 CGVector vector struct to be normalized
 */
CGVector vectorNormalize (CGVector vector);
/**
 Returns a CGVector that is the sum of two other CGVectors
 @param vectorA
 CGVector vector struct to be added.
 @param vectorB
 CGVector vector struct to be added.
 */
CGVector vectorAdd (CGVector vectorA, CGVector vectorB);
/**
 Returns a CGVector that is the product of two other CGVectors (dx * dx, dy * dy)
 @param vectorA
 CGVector vector struct to be factored.
 @param vectorB
 CGVector vector struct to be factored.
 */
CGVector vectorMultiplyByVector (CGVector vectorA, CGVector vectorB);
/**
 Returns a CGVector that is the product of multiplying both values by the same factor.
 @param vectorA
 CGVector vector struct to be multiplied.
 @param factor
 CGFloat value to multiply both dx and dy by.
 */
CGVector vectorMultiplyByFactor (CGVector vector, CGFloat factor);
/**
 Returns a CGVector that would face the destination point from the origin point
 @param destination
 CGPoint struct
 @param origin
 CGPoint struct
 @param normalize
 bool value determining whether to normalize the result or not
 */
CGVector vectorFacingPoint (CGPoint destination, CGPoint origin, bool normalize);
/**
 Returns a normal CGVector converted from a radian value
 @param radianAngle
 CGFloat radian value
 */
CGVector vectorFromRadian (CGFloat radianAngle);
/**
 Returns a normal CGVector converted from a degree value
 @param degreeAngle
 CGFloat degree value
 */
CGVector vectorFromDegree (CGFloat degreeAngle);

#pragma mark CGPoint HELPERS

/**
 Returns a CGPoint struct converted from a CGVector
 @param vector
 CGVector vector
 */
CGPoint pointFromCGVector (CGVector vector);
/**
 Returns a CGPoint struct converted from a CGSize
 @param size
 CGSize size
 */
CGPoint pointFromCGSize (CGSize size);
/**
 Returns a CGPoint struct with negated values.
 @param point
 CGPoint point struct to be inverted
 */
CGPoint pointInverse (CGPoint point);

/**
 Returns a CGPoint struct as a sum from both CGPoint input parameters.
 @param pointA
 CGPoint point A
 @param pointB
 CGPoint point B
 */
CGPoint pointAdd (CGPoint pointA, CGPoint pointB);

/**
 Returns a CGPoint struct with value added to both dimensions
 @param point
 CGPoint point
 @param value
 CGFloat value
 */
CGPoint pointAddValue (CGPoint point, CGFloat value);

/**
 Returns a CGPoint that is the product of two other CGPoints (Ax * Bx, Ay * By)
 @param pointB
 CGPoint point struct to be factored.
 @param vectorB
 CGPoint point struct to be factored.
 */
CGPoint pointMultiplyByPoint (CGPoint pointA, CGPoint pointB);

/**
 Returns a CGPoint that is the product of multiplying both values by the same factor.
 @param point
 CGPoint point struct to be factored.
 @param factor
 CGFloat value to multiply both x and y by.
 */
CGPoint pointMultiplyByFactor (CGPoint point, CGFloat factor);

/**
 Returns a CGPoint struct that is the result of movement based on the factors provided
 @param origin
 CGPoint where the point is in the current frame, prior to moving to the next frame
 @param normalVector
 CGVector vector determining where the movement is headed. This is assumed to be normalized. If it is not normal, calculations will go awry.
 @param interval
 CFTimeInterval The amount of time that has passed since the previous frame.
 @param maxInterval
 CFTimeInterval The maximum amount of time to alot between frames. This is useful for keeping things from jumping around the screen too far in the event of lag.
 @param speed
 CGFloat value determining how fast (in points) this is moving per second. That is points per second speed.
 @param speedModifiers
 CGFlaot value to conveniently modify speed based on buffs or debuffs
 */
CGPoint pointStepVectorFromPointWithInterval (CGPoint origin, CGVector normalVector, CFTimeInterval interval, CFTimeInterval maxInterval, CGFloat speed, CGFloat speedModifiers);
/**
 Returns a CGPoint struct that is the result of movement based on the factors provided
 @param origin
 CGPoint where the point is in the current frame, prior to moving to the next frame
 @param normalVector
 CGVector vector determining where the movement is headed. This is assumed to be normalized. If it is not normal, calculations will go awry.
 @param distance
 CGFloat value: The distance to move in the direction of the vector.
 */
CGPoint pointStepVectorFromPoint (CGPoint origin, CGVector normalVector, CGFloat distance);
/**
 Returns a CGPoint struct that is the result of movement based on the factors provided
 @param origin
 CGPoint where the point is in the current frame, prior to moving to the next frame
 @param destination
 CGPoint the point that the node is trying to move toward.
 @param interval
 CFTimeInterval The amount of time that has passed since the previous frame.
 @param maxInterval
 CFTimeInterval The maximum amount of time to alot between frames. This is useful for keeping things from jumping around the screen too far in the event of lag.
 @param speed
 CGFloat value determining how fast (in points) this is moving per second. That is points per second speed.
 @param speedModifiers
 CGFlaot value to conveniently modify speed based on buffs or debuffs
 */
CGPoint pointStepTowardsPointWithInterval (CGPoint origin, CGPoint destination, CFTimeInterval interval, CFTimeInterval maxInterval, CGFloat speed, CGFloat speedModifiers);
/**
 Returns a CGPoint struct positioned at a varying value between two points, based on the input of "factorBetween"
 @param pointA
 CGPoint start or end point
 @param pointB
 CGPoint start or end point
 @param factorBetween
 CGFloat value at which to interpolate to between the points. For example, a value of 0.5 would be halfway between the two points, a value of 0.25 would only be a quarter of the way between them.
 */
CGPoint pointInterpolationLinearBetweenTwoPoints (CGPoint pointA, CGPoint pointB, CGFloat factorBetween);
/**
 Returns a CGPoint struct positioned at the midpoint of a CGRect, including the offset of the origin of the CGRect.
 @param rect
 CGRect rect struct that you need the midpoint of.
 */
CGPoint midPointOfRect (CGRect rect);
/**
 Returns a CGPoint struct positioned at the midpoint of a CGSize struct.
 @param size
 CGSize size struct that you need the midpoint of.
 */
CGPoint midPointOfSize (CGSize size);
/**
 Returns a bool determining whether origin is behind victim, based on victim's facing direction.
 @param origin
 CGPoint the point in contention
 @param victim
 CGPoint position of the victim
 @param normalVictimFacingVector
 CGVector normalized vector determining the direction victim is facing
 @param latitude
 CGFloat value determining how precisely behind origin has to be to be valid
 */
bool pointIsBehindVictim (CGPoint origin, CGPoint victim, CGVector normalVictimFacingVector, CGFloat latitude);


#pragma mark COORDINATE FORMAT CONVERSIONS
/**
 Returns a CGPoint struct converted from a properly formatted string.
 @param string
 NSString formatted like { ##,## } where ## are numbers.
 */
CGPoint getCGPointFromString (NSString* string);
/**
 Returns a properly formatted NSString to later be converted back to a CGPoint. This is useful for saving to plist files.
 @param location
 CGPoint struct
 */
NSString* getStringFromPoint (CGPoint location);

#pragma mark BEZIER CALCUATIONS
CGPoint bezierPoint (CGFloat t, CGPoint point0, CGPoint point1, CGPoint point2, CGPoint point3);

double bezierTValueAtXValue (double x, double p0x, double p1x, double p2x, double p3x);



@interface SKUtilities2 : NSObject

@property (nonatomic, readonly) CFTimeInterval currentTime;
@property (nonatomic, readonly) CFTimeInterval deltaFrameTime;
@property (nonatomic, readonly) CFTimeInterval deltaFrameTimeUncapped;
/**
 Defaults to 1.0f.
 */
@property (nonatomic) CGFloat deltaMaxTime;

+(SKUtilities2*) sharedUtilities;
-(void)updateCurrentTime:(CFTimeInterval)timeUpdate;


@end


@interface SGG_PositionObject : NSObject

@property (nonatomic) CGPoint position;
@property (nonatomic) CGSize size;
@property (nonatomic) CGRect rect;
@property (nonatomic) CGVector vector;


-(id)initWithPosition:(CGPoint)position;
-(id)initWithVector:(CGVector)vector;
-(id)initWithSize:(CGSize)size;
-(id)initWithRect:(CGRect)rect;
+(SGG_PositionObject*)position:(CGPoint)location;
+(SGG_PositionObject*)vector:(CGVector)vector;
+(SGG_PositionObject*)size:(CGSize)size;
+(SGG_PositionObject*)rect:(CGRect)rect;

-(CGSize)getSizeFromPosition;
-(CGPoint)getPositionFromSize;
-(CGVector)getVectorFromSize;

@end