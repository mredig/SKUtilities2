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

CGFloat orientToFromRightFace (CGPoint facing, CGPoint from);
CGFloat orientToFromUpFace (CGPoint facing, CGPoint from);
CGFloat orientToFromLeftFace (CGPoint facing, CGPoint from);
CGFloat orientToFromDownFace (CGPoint facing, CGPoint from);


#pragma mark CGVector HELPERS

#pragma mark CGPoint HELPERS

CGPoint midPointOfRect (CGRect rect);
CGPoint midPointOfSize (CGSize size);

#pragma mark COORDINATE CONVERSIONS






/**
Returns a CGPoint struct as a sum from both CGPoint input parameters.
@param pointA
 CGPoint point A
@param pointB
 CGPoint point B
*/

CGPoint pointAdd (CGPoint pointA, CGPoint pointB);

@interface SKUtilities2 : NSObject

@property (nonatomic, readonly) CFTimeInterval currentTime;
@property (nonatomic, readonly) CFTimeInterval deltaFrameTime;
@property (nonatomic, readonly) CFTimeInterval deltaFrameTimeUncapped;
/**
 Defaults to 1.0f.
 */
@property (nonatomic) CGFloat deltaMaxTime;

+(SKUtilities2*) sharedUtilities;


@end
