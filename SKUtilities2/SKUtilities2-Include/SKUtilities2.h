/*!
 @header SKUtilities2
 
 @brief SpriteKit Utilities 2
 
 <p>This is a collection of functions, classes, and categories to greatly simplify and speed up development with SpriteKit.</p>
 <p>Available for download at <a href="https://github.com/mredig/SKUtilities2">GitHub</a></p>
 <p>Documentation available at <a href="http://mredig.github.io/SKUtilities2_Doc/">GitHub Pages</a></p>
 
 <p><h4>Miscellaneous:</h4></p>
 
 <p>
 
 <ul>
 
 <li>Run this as a script in a build phase to automatically increment build numbers
  <pre>
 @textblock
 #!/bin/bash
 bN=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$INFOPLIST_FILE")
 bN=$((bN += 1))
 bN=$(printf "%d" $bN)
 /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $bN" "$INFOPLIST_FILE"
 @/textblock
 </pre></li>
 
 <li>Header formatting for documentation can be referenced <a href="https://developer.apple.com/library/mac/documentation/DeveloperTools/Conceptual/HeaderDoc/tags/tags.html#//apple_ref/doc/uid/TP40001215-CH346-SW16">here</a> and <a href="http://www.raywenderlich.com/66395/documenting-in-xcode-with-headerdoc-tutorial">here</a></li>

 <li>To activate mouse movement capture on OSX, use this line in Obj C
 
  <pre>
 @textblock
 self.view.window.acceptsMouseMovedEvents = YES;
 @/textblock
 </pre>
 
 or this line in Swift
 
  <pre>
 @textblock
 self.view!.window!.acceptsMouseMovedEvents = true;
 @/textblock
 </pre>
 
 </li>
 
 </ul>
 </p>
 
 @author	Michael Redig
 @copyright	2015 Michael Redig - (See license file)
 @version	2.0b
 */

// run this as a script in a build phase to automatically increment build numbers
/**
 
#!/bin/bash
bN=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$INFOPLIST_FILE")
bN=$((bN += 1))
bN=$(printf "%d" $bN)
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $bN" "$INFOPLIST_FILE"
 
 */

// Swift copy/paste convenience
/**
 
 let SKUSharedUtilities = SKUtilities2.sharedUtilities();
 
 #if os(OSX)
	 typealias SKUImage = NSImage;
	 typealias SKUFont = NSFont;
 #else
	 typealias SKUImage = UIImage;
	 typealias SKUFont = UIFont;
 #endif
 
 */


/**
 Header formatting for documentation can be referenced here https://developer.apple.com/library/mac/documentation/DeveloperTools/Conceptual/HeaderDoc/tags/tags.html#//apple_ref/doc/uid/TP40001215-CH346-SW16 and here http://www.raywenderlich.com/66395/documenting-in-xcode-with-headerdoc-tutorial
 */

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <SpriteKit/SpriteKit.h>
#import <CoreGraphics/CoreGraphics.h>
@import GameController;

#pragma mark CONSTANTS
/*! @group Common Constants */

/*!
 Constant approximate value (0.41666) good for scaling assets.
 */
static const CGFloat kSKUPadToPhoneScale = (CGFloat) 0.41666;
/*!
 Constant approximate value (0.41666) good for scaling assets.
 */
static const CGFloat kSKUPhoneFromPadScale = (CGFloat) 0.41666;
/*!
 Constant approximate value (2.40003840061441) good for scaling assets.
 */
static const CGFloat kSKUPhoneToPadScale = (CGFloat) 2.40003840061441; //likely very low usage as it would be upscaling
/*!
 Constant approximate value (2.40003840061441) good for scaling assets.
 */
static const CGFloat kSKUPadFromPhoneScale = ((CGFloat) 2.40003840061441);

/*!
 Constant value to convert from degrees to radians. (0.017453292519943295)
 */
static const CGFloat kSKUDegToRadConvFactor = 0.017453292519943295; // pi/180
/*!
 Constant value to convert from radians to degrees. (57.29577951308232)
 */
static const CGFloat kSKURadToDegConvFactor = 57.29577951308232; // 180/pi

/*!
 @discussion BOOLEAN determining visibility
 
 For node.hidden properties, this is more intuitive than YES/NO
 <pre>
 @textblock
 node.hidden = VISIBLE; //this is visible
 node.hidden = HIDDEN; //this is hidden
 @/textblock
 </pre>
 */
static const BOOL VISIBLE = 0;
/*!
 @discussion 
 BOOLEAN determining visibility
 For node.hidden properties, this is more intuitive than YES/NO
 <pre>
 @textblock
 node.hidden = VISIBLE; //this is visible
 node.hidden = HIDDEN; //this is hidden
 @/textblock
 </pre>
 */
static const BOOL HIDDEN = 1;

/*!
 Allows simplification between platforms, using similar classes.
 On iOS and tvOS, remaps <i>UIImage</i> to <i>SKUImage</i> and <i>UIFont</i> to <i>SKUFont</i> and on OS X, remaps <i>NSImage</i> to <i>SKUImage</i> and <i>NSFont</i> to <i>SKUFont</i> as they are close enough that most methods work on all platforms. Also defines a constant that is only true on OS X for conditional targetting.
 
 To get the same result in Swift, use this in a global scope:
  <pre>
 @textblock
 #if os(OSX)
	typealias SKUImage = NSImage;
	typealias SKUFont = NSFont;
 #else
	typealias SKUImage = UIImage;
	typealias SKUFont = UIFont;
 #endif
 @/textblock
 </pre>
 
 @attributelist Language:
 Objective-C
 */
#if TARGET_OS_IPHONE
#define SKUImage UIImage
#define SKUFont UIFont
#else
#define SKUImage NSImage
#define SKUFont NSFont
#define TARGET_OS_OSX_SKU 1
#endif
/*!
 Simplifies access to the singleton.
 
 To get the same result in Swift, use this in a global scope:
  <pre>
 @textblock
 let SKUSharedUtilities = SKUtilities2.sharedUtilities();
 @/textblock
 </pre>

 
 @attributelist Language:
 Objective-C
 */
#define SKUSharedUtilities [SKUtilities2 sharedUtilities] 

/*!
 Constant for posting notification to turn user interface interaction on for the remote and controllers on tvOS.
 */
extern NSString* const kSKURemoteInteractionOn;
/*!
 Constant for posting notification to turn user interface interaction off for the remote and controllers on tvOS.
 */
extern NSString* const kSKURemoteInteractionOff;

/*!
 Constant for retrieving whatever node is currently focused.
 */
extern NSString* const kSKUNavConstantCurrentFocusedNode;

#pragma mark NUMBER INTERPOLATION
/*! @functiongroup Number Interpolation */

/*!
 Returns a CGFloat interpolated linearly between two values. Clipped determines whether it can go beyond the bounds of the values.
@param valueA
 CGFloat low end value
@param valueB
 CGFloat high end value
@param pointBetween
 CGFloat value between the two numbers to interpolate to; 0.0 = valueA, 1.0 = valueB
@param clipped
 bool determines whether or not pointBetween can be a value beyond the range of 0.0 to 1.0
 @seealso reverseLinearInterpolationBetweenFloatValues
 @seealso rampToValue
 @seealso clipFloatWithinRange
*/
CGFloat linearInterpolationBetweenFloatValues (CGFloat valueA, CGFloat valueB, CGFloat pointBetween, bool clipped);

/*!
 Returns a CGFloat of the value of pointBetween interpolated linearly between two values. Clipped determines whether it can go beyond the bounds of the values. If that didn't make sense, it's a reversal of what linearInterpolationBetweenFloatValues does - it will return the value of "pointBetween" from linearInterpolationBetweenFloatValues.
@param valueA
 CGFloat low end range value
@param valueB
 CGFloat high end range value
@param valueBetween
 CGFloat point between the two numbers to interpolate to; valueA = 0.0, valueB = 1.0
@param clipped
 bool determines whether or not valueBetween can be a value beyond the range of valueA to valueB
 @seealso linearInterpolationBetweenFloatValues
 @seealso rampToValue
 @seealso clipFloatWithinRange
 */

CGFloat reverseLinearInterpolationBetweenFloatValues (CGFloat valueA, CGFloat valueB, CGFloat valueBetween, bool clipped);

/*!
 Returns a CGFloat modifying currentValue that iteratively changes over time to become closer to idealValue in iterations of stepValue
 @param idealValue
 CGFloat value that you are approaching
 @param currentValue
 CGFloat input value of where you are now
 @param stepValue
 CGFloat amount to iterate by
 @seealso linearInterpolationBetweenFloatValues
 @seealso reverseLinearInterpolationBetweenFloatValues
 @seealso clipFloatWithinRange
 */
CGFloat rampToValue (CGFloat idealValue, CGFloat currentValue, CGFloat stepValue);

/*!
 Returns a CGFloat clipped within the range provided.
 @param value
 CGFloat value that is evaluated
 @param minimum
 CGFloat input of the low end range of what the output value could be
 @param maximum
 CGFloat input of the high end range of what the output value could be
 @seealso clipIntegerWithinRange
 */
CGFloat clipFloatWithinRange (CGFloat value, CGFloat minimum, CGFloat maximum);

/*!
 Returns an NSInteger clipped within the range provided.
 @param value
 NSInteger value that is evaluated
 @param minimum
 NSInteger input of the low end range of what the output value could be
 @param maximum
 NSInteger input of the high end range of what the output value could be
 @seealso clipFloatWithinRange
 */
NSInteger clipIntegerWithinRange (NSInteger value, NSInteger minimum, NSInteger maximum);


#pragma mark RANDOM NUMBERS
/*! @functiongroup Random Numbers */

/*!
 Returns a u_int_32_t value randomized between two other values.
 @param lowend  u_int32_t low end range value
 @param highend u_int32_t high end range value
 @return random u_int32_t value
 @seealso randomFloatBetweenZeroAndHighend
 */
u_int32_t randomUnsignedIntegerBetweenTwoValues (u_int32_t lowend, u_int32_t highend);

/*!
 Returns a CGFloat value randomized between zero and a higher value.
 @param highend
 CGFloat max range value
 @seealso randomUnsignedIntegerBetweenTwoValues
 */
CGFloat randomFloatBetweenZeroAndHighend (CGFloat highend);

#pragma mark DISTANCE FUNCTIONS
/*! @functiongroup Distance Functions */

/*!
 Returns a CGFloat value measuring the distance between two CGPoint values.
 @param pointA
 CGPoint start or end point
 @param pointB
 CGPoint start or end point
 @seealso distanceBetweenIsWithinXDistance
 @seealso distanceBetweenIsWithinXDistancePreSquared
 */
CGFloat distanceBetween (CGPoint pointA, CGPoint pointB);

/*!
 Returns a bool value determining if the distance between two points is less than a predetermined maximum value.
 @param pointA
 CGPoint start or end point
 @param pointB
 CGPoint start or end point
 @param xDistance
 CGFloat max distance between points
 @seealso distanceBetweenIsWithinXDistancePreSquared
 @seealso distanceBetween
 */
bool distanceBetweenIsWithinXDistance (CGPoint pointA, CGPoint pointB, CGFloat xDistance);

/*!
 Returns a bool value determining if the distance between two points is less than a predetermined maximum value. This is a small optimization over the previous function as it saves the step of squaring the x value.
 @param pointA
 CGPoint start or end point
 @param pointB
 CGPoint start or end point
 @param xDistancePresquared
 CGFloat max distance between points, squared (x * x)
 @seealso distanceBetweenIsWithinXDistance
 @seealso distanceBetween
 */
bool distanceBetweenIsWithinXDistancePreSquared (CGPoint pointA, CGPoint pointB, CGFloat xDistancePresquared);


#pragma mark ORIENTATION
/*! @functiongroup Orientation */

/*!
 Returns a float value in radians to rotate a node at position *from* to face *facing*, when the node is facing right at 0 rotation.
 @param facing
 CGPoint a point in the direction that the node should be facing.
 @param from
 CGPoint point that the node is located at
 @seealso orientToFromUpFace
 @seealso orientToFromLeftFace
 @seealso orientToFromDownFace
 */
CGFloat orientToFromRightFace (CGPoint facing, CGPoint from);
/*!
 Returns a float value in radians to rotate a node at position *from* to face *facing*, when the node is facing up at 0 rotation.
 @param facing
 CGPoint a point in the direction that the node should be facing.
 @param from
 CGPoint point that the node is located at
 @seealso orientToFromRightFace
 @seealso orientToFromLeftFace
 @seealso orientToFromDownFace
 */
CGFloat orientToFromUpFace (CGPoint facing, CGPoint from);
/*!
 Returns a float value in radians to rotate a node at position *from* to face *facing*, when the node is facing left at 0 rotation.
 @param facing
 CGPoint a point in the direction that the node should be facing.
 @param from
 CGPoint point that the node is located at
 @seealso orientToFromRightFace
 @seealso orientToFromUpFace
 @seealso orientToFromDownFace
 */
CGFloat orientToFromLeftFace (CGPoint facing, CGPoint from);
/*!
 Returns a float value in radians to rotate a node at position *from* to face *facing*, when the node is facing down at 0 rotation.
 @param facing
 CGPoint a point in the direction that the node should be facing.
 @param from
 CGPoint point that the node is located at
 @seealso orientToFromRightFace
 @seealso orientToFromUpFace
 @seealso orientToFromLeftFace
 */
CGFloat orientToFromDownFace (CGPoint facing, CGPoint from);


#pragma mark CGVector HELPERS
/*! @functiongroup CGVector Helpers */

/*!
 Returns a CGVector struct converted from a CGPoint struct.
 @param point
 CGPoint point struct to be converted
 @seealso vectorFromCGSize
 @seealso pointFromCGSize
 @seealso pointFromCGVector
 */
CGVector vectorFromCGPoint (CGPoint point);
/*!
 Returns a CGVector struct converted from a CGSize struct.
 @param size
 CGSize size struct to be converted
 @seealso vectorFromCGPoint
 @seealso pointFromCGSize
 @seealso pointFromCGVector
 */
CGVector vectorFromCGSize (CGSize size);
/*!
 Returns a CGVector struct with negated values.
 @param vector
 CGVector vector struct to be inverted
 @seealso pointInverse
 */
CGVector vectorInverse (CGVector vector);
/*!
 Returns a CGVector normalized to have a distance of 1.0.
 @param vector
 CGVector vector struct to be normalized
 */
CGVector vectorNormalize (CGVector vector);
/*!
 Returns a CGVector that is the sum of two other CGVectors
 @param vectorA
 CGVector vector struct to be added.
 @param vectorB
 CGVector vector struct to be added.
 @seealso vectorMultiplyByVector
 @seealso vectorMultiplyByFactor
 @seealso pointAdd
 @seealso pointAddValue
 @seealso pointMultiplyByFactor
 @seealso pointMultiplyByPoint
 */
CGVector vectorAdd (CGVector vectorA, CGVector vectorB);
/*!
 Returns a CGVector that is the product of two other CGVectors (dx * dx, dy * dy)
 @param vectorA
 CGVector vector struct to be factored.
 @param vectorB
 CGVector vector struct to be factored.
 @seealso vectorAdd
 @seealso vectorMultiplyByFactor
 @seealso pointAdd
 @seealso pointAddValue
 @seealso pointMultiplyByFactor
 @seealso pointMultiplyByPoint
 */
CGVector vectorMultiplyByVector (CGVector vectorA, CGVector vectorB);
/*!
 Returns a CGVector that is the product of multiplying both values by the same factor.
 @param vector
 CGVector vector struct to be multiplied.
 @param factor
 CGFloat value to multiply both dx and dy by.
 @seealso vectorAdd
 @seealso vectorMultiplyByVector
 @seealso pointAdd
 @seealso pointAddValue
 @seealso pointMultiplyByFactor
 @seealso pointMultiplyByPoint
 */
CGVector vectorMultiplyByFactor (CGVector vector, CGFloat factor);
/*!
 Checks if a vector is equal to CGVectorZero
 @param vector value to check
 @return boolean determining whether it was equal to zero or not
 */
BOOL vectorIsZero (CGVector vector);
/*!
 Calculates the distance of a vector
 @param vector vector to check
 @return distance value
 */
CGFloat vectorDistance (CGVector vector);
/*!
 Returns a CGVector that would face the destination point from the origin point
 @param destination
 CGPoint struct
 @param origin
 CGPoint struct
 @param normalize
 bool value determining whether to normalize the result or not
 */
CGVector vectorFacingPoint (CGPoint destination, CGPoint origin, bool normalize);
/*!
 Returns a normal CGVector converted from a radian value
 @param radianAngle
 CGFloat radian value
 */
CGVector vectorFromRadian (CGFloat radianAngle);
/*!
 Returns a normal CGVector converted from a degree value
 @param degreeAngle
 CGFloat degree value
 */
CGVector vectorFromDegree (CGFloat degreeAngle);

#pragma mark CGPoint HELPERS
/*! @functiongroup CGPoint Helpers */

/*!
 Returns a CGPoint struct converted from a CGVector
 @param vector
 CGVector vector
 @seealso vectorFromCGPoint
 @seealso vectorFromCGSize
 @seealso pointFromCGSize
 */
CGPoint pointFromCGVector (CGVector vector);
/*!
 Returns a CGPoint struct converted from a CGSize
 @param size
 CGSize size
 @seealso vectorFromCGPoint
 @seealso pointFromCGSize
 @seealso pointFromCGVector
 */
CGPoint pointFromCGSize (CGSize size);
/*!
 Returns a CGPoint struct with negated values.
 @param point
 CGPoint point struct to be inverted
 @seealso vectorInverse
 */
CGPoint pointInverse (CGPoint point);

/*!
 Returns a CGPoint struct as a sum from both CGPoint input parameters.
 @param pointA
 CGPoint point A
 @param pointB
 CGPoint point B
 @seealso vectorAdd
 @seealso vectorMultiplyByVector
 @seealso vectorMultiplyByFactor
 @seealso pointAddValue
 @seealso pointMultiplyByFactor
 @seealso pointMultiplyByPoint
 */
CGPoint pointAdd (CGPoint pointA, CGPoint pointB);

/*!
 Returns a CGPoint struct with value added to both dimensions
 @param point
 CGPoint point
 @param value
 CGFloat value
 @seealso vectorAdd
 @seealso vectorMultiplyByVector
 @seealso vectorMultiplyByFactor
 @seealso pointAdd
 @seealso pointMultiplyByFactor
 @seealso pointMultiplyByPoint
 */
CGPoint pointAddValue (CGPoint point, CGFloat value);

/*!
 Returns a CGPoint that is the product of two other CGPoints (Ax * Bx, Ay * By)
 @param pointA
 CGPoint point struct to be factored.
 @param pointB
 CGPoint point struct to be factored.
 @seealso vectorAdd
 @seealso pointAdd
 @seealso pointAddValue 
 @seealso vectorMultiplyByVector
 @seealso vectorMultiplyByFactor
 @seealso pointAdd
 @seealso pointAddValue
 @seealso pointMultiplyByFactor
 */
CGPoint pointMultiplyByPoint (CGPoint pointA, CGPoint pointB);

/*!
 Returns a CGPoint that is the product of multiplying both values by the same factor.
 @param point
 CGPoint point struct to be factored.
 @param factor
 CGFloat value to multiply both x and y by.
 @seealso vectorAdd
 @seealso vectorMultiplyByVector
 @seealso vectorMultiplyByFactor
 @seealso pointAdd
 @seealso pointAddValue
 @seealso pointMultiplyByPoint
 */
CGPoint pointMultiplyByFactor (CGPoint point, CGFloat factor);

/*!
 Returns a boolean stating whether the given point was equal to CGPointZero or not.
 @param point
 CGPoint point struct to be evaluated as to whether it is equal to CGPointZero or not.
 */
BOOL pointIsZero (CGPoint point);

/*!
 Returns a CGPoint that is the result of multiplying the scene size by the point provided
 @param scene scene
 @param point point (anchor point style: 0.0 - 1.0 range)
 @seealso pointMultiplyByPoint
 @seealso pointFromCGSize
 */
CGPoint pointRelativeToScene (SKScene* scene, CGPoint point);

/*!
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
 @seealso pointStepVectorFromPoint
 @seealso pointStepTowardsPointWithInterval
 @seealso pointInterpolationLinearBetweenTwoPoints
 */
CGPoint pointStepVectorFromPointWithInterval (CGPoint origin, CGVector normalVector, CFTimeInterval interval, CFTimeInterval maxInterval, CGFloat speed, CGFloat speedModifiers);
/*!
 Returns a CGPoint struct that is the result of movement based on the factors provided
 @param origin
 CGPoint where the point is in the current frame, prior to moving to the next frame
 @param normalVector
 CGVector vector determining where the movement is headed. This is assumed to be normalized. If it is not normal, calculations will go awry.
 @param distance
 CGFloat value: The distance to move in the direction of the vector.
 @seealso pointStepVectorFromPointWithInterval
 @seealso pointStepTowardsPointWithInterval
 @seealso pointInterpolationLinearBetweenTwoPoints
 */
CGPoint pointStepVectorFromPoint (CGPoint origin, CGVector normalVector, CGFloat distance);
/*!
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
 @seealso pointStepVectorFromPointWithInterval
 @seealso pointStepVectorFromPoint
 @seealso pointInterpolationLinearBetweenTwoPoints
 */
CGPoint pointStepTowardsPointWithInterval (CGPoint origin, CGPoint destination, CFTimeInterval interval, CFTimeInterval maxInterval, CGFloat speed, CGFloat speedModifiers);
/*!
 Returns a CGPoint struct positioned at a varying value between two points, based on the input of "factorBetween"
 @param pointA
 CGPoint start or end point
 @param pointB
 CGPoint start or end point
 @param factorBetween
 CGFloat value at which to interpolate to between the points. For example, a value of 0.5 would be halfway between the two points, a value of 0.25 would only be a quarter of the way between them.
 @seealso pointStepVectorFromPointWithInterval
 @seealso pointStepVectorFromPoint
 @seealso pointStepTowardsPointWithInterval
 */
CGPoint pointInterpolationLinearBetweenTwoPoints (CGPoint pointA, CGPoint pointB, CGFloat factorBetween);
/*!
 Returns a CGPoint struct positioned at the midpoint of a CGRect, including the offset of the origin of the CGRect.
 @param rect
 CGRect rect struct that you need the midpoint of.
 @seealso midPointOfSize
 */
CGPoint midPointOfRect (CGRect rect);
/*!
 Returns a CGPoint struct positioned at the midpoint of a CGSize struct.
 @param size
 CGSize size struct that you need the midpoint of.
 @seealso midPointOfRect
 */
CGPoint midPointOfSize (CGSize size);
/*!
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
/*! @functiongroup Coordinate Format Conversions */

/*!
 Returns a CGPoint struct converted from a properly formatted string.
 @param string
 NSString formatted like { ##,## } where ## are numbers.
 @seealso getStringFromPoint
 */
CGPoint getCGPointFromString (NSString* string);
/*!
 Returns a properly formatted NSString to later be converted back to a CGPoint. This is useful for saving to plist files.
 @param location
 CGPoint struct
 @seealso getCGPointFromString
 */
NSString* getStringFromPoint (CGPoint location);

#pragma mark BEZIER CALCUATIONS
/*! @functiongroup Bezier Calculations */

/*!
 Returns a point on a bezier curve. Provide it with the anchor points (point0 and point3) and the handle points (point1 and point2) and the value at which to evaluate between 0.0 and 1.0 (0 being point0 and 1.0 being point3).
 @param t      Interpolation between points.
 @param point0 Anchor point 1.
 @param point1 Handle point 1.
 @param point2 Handle point 2.
 @param point3 Anchor point 2.
 @return CGPoint value.
 @seealso bezierTValueAtXValue
 */
CGPoint bezierPoint (CGFloat t, CGPoint point0, CGPoint point1, CGPoint point2, CGPoint point3);

/*!
 Since bezier paths are distributed more densely in some areas, while more sparse in others, sometimes you need to be able to get the point at a certain x value instead of a t value. Provide this function with the x values of the curve and what x value you need the y value for.
 @param x   x value that you need to get the y value from
 @param p0x x value from point 0
 @param p1x x value from point 1
 @param p2x x value from point 2
 @param p3x x value from point 3
 @return t value for given x value - you can then get the y value from the previous function
 @seealso bezierPoint
 */
double bezierTValueAtXValue (double x, double p0x, double p1x, double p2x, double p3x);


#pragma mark Mac Cursor Handling

/*!
 Used to show or hide the OS Cursor. Mac only, but harmless on other platforms.
 @param hide Boolean determining if
 @seealso centerOSCursorInWindow
 */
void hideOSCursor(BOOL hide);

/*!
 Centers the Mac OS Cursor in the center of the window. Typically used incoordination of mouseMoved events. Mac only, but harmless on other platforms.
 @seealso hideOSCursor
 @seealso SKNode(SKUModifications) mouseMovedSKU
 */
void centerOSCursorInWindow();

#pragma mark LOGGING
/*! @functiongroup Logging */

/*!
 Prints text to the console using NSLog, but only prints if verbosityLevelRequired is lower than SKUSharedUtilities.verbosityLevel. Also only prints in compiler debug mode.
  @attributelist Language:
 Objective-C
 @seealso SKUtilities2 SKUtilities2 verbosityLevel
 */
void SKULog(NSInteger verbosityLevelRequired, NSString *format, ...);
/*!
 Prints the 0s and 1s of a number. Useful for visualizing flags.
 @param value uint32_t value.
 */
void SKULogBinary(uint32_t value);

#pragma mark SKUTILITES SINGLETON

/*!
 Nav mode enumerator for focus based navigation.
 @constant kSKUNavModeOn Nav mode on.
 @constant kSKUNavModeOff Nav mode off.
 @constant kSKUNavModePressed Nav mode paused while a press is in progress. (Don't set this manually).
 @seealso SKUtilities2
 */
typedef enum {
	kSKUNavModeOn = 1,
	kSKUNavModeOff,
	kSKUNavModePressed,
} kSKUNavModes;


typedef enum {
	kSKUSwipeDirectionRight,
	kSKUSwipeDirectionLeft,
	kSKUSwipeDirectionUp,
	kSKUSwipeDirectionDown,
} kSKUSwipeDirections;

/*!
 Enumeration describing the state of a button press from a gamepad.
 @constant kSKUGamepadButtonStateBegan Represents when a button is first pressed.
 @constant kSKUGamepadButtonStateChanged Represents when a button's value changes, but remains pressed.
 @constant kSKUGamepadButtonStateEnded Represents when a button is released.
 */
typedef enum {
	kSKUGamepadButtonStateBegan,
	kSKUGamepadButtonStateChanged,
	kSKUGamepadButtonStateEnded,
//	kSKUGamepadButtonStateCancelled,
} kSKUGamepadButtonStates;

struct SKUAcceleration {
	double x;
	double y;
	double z;
};
typedef struct SKUAcceleration SKUAcceleration;

/*!
 Gamepad buttons enumerated as flags.
 @constant kSKUGamePadInputLeftShoulder Represents the left shoulder button.
 @constant kSKUGamePadInputLeftTrigger Represents the left trigger button.
 @constant kSKUGamePadInputLeftThumbstick Represents the left thumbstick axis.
 @constant kSKUGamePadInputRightShoulder Represents the right shoulder button.
 @constant kSKUGamePadInputRightTrigger Represents the right trigger button.
 @constant kSKUGamePadInputRightThumbstick Represents the right thumbstick axis.
 @constant kSKUGamePadInputDirectionalPad Represents the dpad axis.
 @constant kSKUGamePadInputButtonA Represents the A button.
 @constant kSKUGamePadInputButtonB Represents the B button.
 @constant kSKUGamePadInputButtonX Represents the X button.
 @constant kSKUGamePadInputButtonY Represents the Y button.
 @constant kSKUGamePadInputButtonPause  Represents the Pause button.
 @seealso SKUGCControllerController
 */
typedef enum {
	kSKUGamePadInputLeftShoulder = 1 << 0,
	kSKUGamePadInputLeftTrigger = 1 << 1,
	kSKUGamePadInputLeftThumbstick = 1 << 2,
	kSKUGamePadInputRightShoulder = 1 << 3,
	kSKUGamePadInputRightTrigger = 1 << 4,
	kSKUGamePadInputRightThumbstick = 1 << 5,
	kSKUGamePadInputDirectionalPad = 1 << 6,
	kSKUGamePadInputButtonA = 1 << 7,
	kSKUGamePadInputButtonB = 1 << 8,
	kSKUGamePadInputButtonX = 1 << 9,
	kSKUGamePadInputButtonY = 1 << 10,
	kSKUGamePadInputButtonPause = 1 << 11,
} kSKUGamePadInputs;

/*!
 Player IDs enumerated as flags. Used to turn flags for which players can control nav, but you can use it for your own purposes as well.
 @seealso validPlayerNav SKUGCControllerController validPlayerNav
 */
typedef enum {
	kSKUGamePadPlayerFlag1 = 1 << 0,
	kSKUGamePadPlayerFlag2 = 1 << 1,
	kSKUGamePadPlayerFlag3 = 1 << 2,
	kSKUGamePadPlayerFlag4 = 1 << 3,
} kSKUGamePadPlayerFlags;

#if TARGET_OS_OSX_SKU
/*!
 Mouse button type enumerator/flags for Mac.
 @constant kSKUMouseButtonFlagLeft Flag for when left mouse is used.
 @constant kSKUMouseButtonFlagRight Flag for when right mouse is used.
 @constant kSKUMouseButtonFlagOther Flag for when other mouse is used (mouse buttons 3 and greater).
 
 To get the same result in Swift, be sure to use rawValue
 
 @attributelist Platforms:
 OSX
 @seealso SKUtilities2
 */
typedef enum {
	kSKUMouseButtonFlagLeft = 1 << 0,
	kSKUMouseButtonFlagRight = 1 << 1,
	kSKUMouseButtonFlagOther = 1 << 2,
} kSKUMouseButtonFlags;

#endif

@class SKUGameControllerState;
@class SKUGCControllerController;

/*!
 This is a singleton class that carries a lot of information allowing for access anywhere within your app. It'll track the current time, intervals between frames, handle logging, store objects, and manage navigation and other built in utilties with this library.
 */
@interface SKUtilities2 : NSObject
/*! @group Time */

/*!
 Current time passed in from scene update method, but must be set up properly. This allows you to get the currentTime into other objects or methods without directly calling them from the update method.
 */
@property (nonatomic, readonly) CFTimeInterval currentTime;
/*!
 Amount of time passed since last frame. This value is capped by deltaMaxTime.
 */
@property (nonatomic, readonly) CFTimeInterval deltaFrameTime;
/*!
 Amount of time passed since last frame. This value is NOT capped by deltaMaxTime.
Vulnerable to lag spikes if used.
 */
@property (nonatomic, readonly) CFTimeInterval deltaFrameTimeUncapped;
/*!
 Defaults to 1.0f.
 */
@property (nonatomic) CGFloat deltaMaxTime;

/*! @group Logging */

/*!
 Used to determine if SKULogs print to the console. A value of 100 or more will automatically print notifications of SKScene deallocation. A value of 150 will print notifications of SKNode deallocation.
 @seealso SKULog
 */
@property (nonatomic) NSInteger verbosityLevel;

/*! @group Object Storage and Retrieval */

/*!
 This mutable dictionary is similar in concept to the item of the same name on all SKNodes that Apple does, but on the singleton allows you to store objects for access game wide, not just on one node. It remains uninitialized until you initialize it.
 */
@property (nonatomic, strong) NSMutableDictionary* userData;

/*! @group Game Controllers */

/*!
 Gives you access to controls from gamepad inputs. Setup is relatively simple - Change your SKScene superclass to SKUScene, modify your update method to call its super method, and be sure to call setNavFocus on the SKUSharedUtilities singleton, call SKUScene's didMoveToView super method, or manually set SKUSharedUtilities.gcController.view to the current view. This achieves several things: SKUScene has built in methods for overriding for each input button on controllers that get called when buttons are pressed as well as automatically updates [SKUSharedUtilities updateCurrentTime], and enables controllers for navigation within the game.
 
 To fully enable navigation on tvOS requires a couple additional steps - Change your ViewController superclass to SKUViewController, making sure SKUSharedUtilities.navFocus is on the right node and making sure that SKUSharedUtilities.navMode is set. Once that is set, SKUViewController listens for notifications with the string constant kSKURemoteInteractionOn or kSKURemoteInteractionOff in the name. When kSKURemoteInteractionOn is set, the A button on the controller will double as the Siri Remote select button and the B and Pause buttons will double as the menu button. SKUSharedUtilities.navMode operates independently of this setting - you will likely want to use SKUSharedUtilities.navMode within your game, but when you're on the top menu of the game, likely activate kSKURemoteInteractionOn so your game can exit to the tvOS menu. Once descended into game menus, kSKURemoteInteractionOff will likely be activated so the player won't accidentally leave the game when they only meant to go up a menu within the game.
 */
@property (nonatomic, strong) SKUGCControllerController* gcController;

/*! @group Navigational */

#if TARGET_OS_OSX_SKU
/*!
 Flags to determine what sort of mouse button is passed onto nodes. By default, it only passes left mouse button events, but adding other kSKUMouseButtonFlags flags allows to respond to other mouse buttons.
 
 To get the same result in Swift, be sure to use rawValue
 
 @seealso kSKUMouseButtonFlags
 @attributelist Platforms:
 OSX
 */
@property (nonatomic) kSKUMouseButtonFlags macButtonFlags;
#endif


/*!
 Allows you to set the current kSKUNavModes type.
 @seealso kSKUNavModes
 */
@property (nonatomic) kSKUNavModes navMode;
/*!
 Allows for access to and setting the current navFocus node.
 
 Set via
  <pre>
 @textblock
 [SKUSharedUtilities setNavFocus:self]; //called from a node
 @/textblock
 </pre>
 
 When navMode is on, whatever node is set here is the node that dictates what nav nodes are used. Typically this will be set to the current scene that you will then call
 <pre>
 @textblock
 SKUPushButton* buttonExample; // assuming this is created properly
 [self addNodeToNavNodesSKU:buttonExample];
 @/textblock
 </pre>
 
 Note that only SKUButton nodes (and subclasses) are set to automatically distinguish focus states when focused or removed from focus. For your own nodes, you can use whatever current navFocus is set when it calls
  <pre>
 @textblock
 -(void)currentFocusedNodeUpdatedSKU:(SKNode *)node {
	//do logic here to update visuals
 }
 @/textblock
 </pre>
 
 
 @seealso SKNode(SKUModifications)
 */
@property (nonatomic, weak) SKNode* navFocus;
/*!
 Change this value to change how sensitive the Siri remote or controller is to movement. The concept is that from one navigation movement to another, this is the distance your touch must travel before signalling another navigational focus change. Higher values are less sensitive.
 */
@property (nonatomic) CGFloat navThresholdDistance;

/*! @group Internal - best not to touch */

/*!
 Used internally to track current touches. Best not to touch.
 @attributelist Platforms:
 tvOS
 */
@property (nonatomic, strong) NSMutableSet* touchTracker;
/*! @methodgroup Internal - best not to touch */

/*!
 Used internally. Best not to touch.
 
 Gets called when movement exceeds the navThresholdDistance. Logic determines which primary direction the movement was in and decides what node is closest in that direction.
 @attributelist Platforms:
 tvOS
 */
-(SKNode*)handleSubNodeMovement:(CGPoint)location withCurrentFocus:(SKNode*)currentFocusedNode inSet:(NSSet*)navNodeSet inScene:(SKScene*)scene;


/*!
 Used internally to communicate logic for button presses.
 @attributelist Platforms:
 tvOS
 */
-(void)gestureTapDown;
/*!
 Used internally to communicate logic for button presses.
 @attributelist Platforms:
 tvOS
 */
-(void)gestureTapUp;

/*! @methodgroup Navigational */

/*!
 Call this method to update the current navFocus node. Typically used on scenes when initially presented.
 @param navFocus SKNode to set as the navFocus.
 <pre>
 @textblock
 SKUPushButton* buttonExample; // assuming this is created properly
 [self addNodeToNavNodesSKU:buttonExample];
 @/textblock
 </pre>
 */
-(void)setNavFocus:(SKNode *)navFocus;


/*! @methodgroup Singleton */

/*!
 Singleton object. Called via
 <pre>
 @textblock
 SKUSharedUtilities
 @/textblock
 </pre>
 
 Allows for storing objects in the userData NSMutableDictionary, carrying time information, managing tvOS navigation logic, and more.
 */
+(SKUtilities2*) sharedUtilities;

/*! @methodgroup Time */

/*!
 Call this method in your scene's update method to share the time with other objects throughout the game.
  <pre>
 @textblock
 -(void)update:(CFTimeInterval)currentTime {
	[SKUSharedUtilities updateCurrentTIme:currentTime];
}
 @/textblock
 </pre>
 */
-(void)updateCurrentTime:(CFTimeInterval)timeUpdate;
/*!
 Enables or disables the sleeping of the display on iOS and tvOS platforms. Off by default. Harmless on other platforms.
 @param enableIdleTimer boolean determining whether idle time is enabled or not.
 @attributelist Platforms:
 tvOS
 iOS
 */
-(void)idleTimerEnable:(BOOL)enableIdleTimer;


-(void)resetSelectLocation;

@end



#pragma mark NEW CLASSES

#pragma mark SKUGCControllerController
/*!
 Not intended for you to create instances of this class but instead to be able to control controller related functions through the SKUtilities singleton. See the see also above.
 
 @seealso gcController SKUtilities2 gcController

 */
@interface SKUGCControllerController : NSObject

/*! @group Game Controllers */
/*!
 Array with controller objects in the order of players. Note that it's not readonly and is mutable, but do NOT change it. It's this way for internal reasons: it's only intended for you to read from this array.
 */
@property (nonatomic, strong) NSMutableArray* playerControllers;
/*!
 Array with a designated controller state for each player. These are initialized and updated automatically.
 */
@property (nonatomic, strong, readonly) NSArray<SKUGameControllerState*>* controllerStates;
/*!
 Flags determining which players are allowed to control navigation. Note that Siri Remote ALWAYS gets to control nav.
 @seealso canPlayerControlNav:
 */
@property (nonatomic) uint8_t validPlayerNav;

/*!
 Set automatically when setting the [SKUtilities setNavFocus] method on the scene itself or if you call [super didMoveToView] on an SKUScene. Note that this is only set if the gcController object has already been initialized (which happens automatically if you use SKUScene). If the view ever gets changed, you will need to update this property with the current view and call "checkForChangedControllerState" again (untested, but I think should work).
 */
@property (nonatomic, weak) SKView* view;
/*!
 Used for access to the current controller state for navigation purposes. Internal.
 */
@property (nonatomic, strong) SKUGameControllerState* navControllerState;

/*!
 Called automatically when a controller connects or disconnects, but can also be called manually if you want to.
 */
-(void)checkForChangedControllerState;
/*!
 Allows you to set which controller is player one and then fills in the rest automatically. This is primarily intended for convenience on the AppleTV if you want to turn the Siri remote to player two and allow the gamepad to take over as P1.
 @param controller GCController object that should get set to player one.
 */
-(void)setPlayerOne:(GCController*)controller;
/*!
 Finds the GCController object for a given player. Returns nil if not found.
 @param player which player
 @return GCController object designated for the player.
 */
-(GCController*)gamepadForPlayer:(GCControllerPlayerIndex)player;
/*!
 Returns the first GCController object found for a given vendor string. Returns nil if not found.
 */
-(GCController*)gamepadForVendor:(NSString*)vendor;
/*!
 Returns boolean answering whether a particular player is allowed to control navigation set via the flag validPlayerNav.
 @seealso validPlayerNav
 */
-(BOOL)canPlayerControlNav:(GCControllerPlayerIndex)player;


@end

#pragma mark SKUGameControllerState

/*!
 Controller events only fire when changed, so this is needed to store the state on frames when the state doesn't change.
 */
@interface SKUGameControllerState : NSObject
/*!
 Vector that the control was pointed in. May or may not be normal.
 */
@property (nonatomic, assign) CGVector vectorDPad;
/*!
 Vector that the control was pointed in. Always normal.
 */
@property (nonatomic, assign) CGVector normalVectorDPad;
/*!
 Vector that the control was pointed in. May or may not be normal.
 */
@property (nonatomic, assign) CGVector vectorLThumbstick;
/*!
 Vector that the control was pointed in. Always normal.
 */
@property (nonatomic, assign) CGVector normalVectorLThumbstick;
/*!
 Vector that the control was pointed in. May or may not be normal.
 */
@property (nonatomic, assign) CGVector vectorRThumbstick;
/*!
 Vector that the control was pointed in. Always normal.
 */
@property (nonatomic, assign) CGVector normalVectorRThumbstick;
/*!
 CGFloat storing a speed value.
 */
@property (nonatomic, assign) CGFloat speed;
/*!
 CGFloat storing a speed mod value.
 */
@property (nonatomic, assign) CGFloat speedModDPad;
/*!
 CGFloat storing a speed mod value.
 */
@property (nonatomic, assign) CGFloat speedModLThumbstick;
/*!
 CGFloat storing a speed mod value.
 */
@property (nonatomic, assign) CGFloat speedModRThumbstick;
/*!
 Location store for determining relative input.
 */
@property (nonatomic, assign) CGPoint location;
/*!
 Flags determining which buttons are pressed or not.
 */
@property (nonatomic, assign) kSKUGamePadInputs buttonsPressed;
/*!
 Flags determining which buttons are pressed or not, prior to the most recent change.
 */
@property (nonatomic, assign) kSKUGamePadInputs buttonsPressedPrevious;

+(SKUGameControllerState*)controllerState;
/*!
 Returns a new object with a center position provided.
 */
+(SKUGameControllerState*)controllerStateWithCenterPosition:(CGPoint)location;

@end



#pragma mark SKUPositionObject

/*!
 For easy passing of struct data through mediums that only accept objects, like NSArrays or performSelectors that only accept passing of objects.
 */
@interface SKUPositionObject : NSObject  <NSCopying>

/*! @group SKUPositionObject Properties */

/*!
 CGPoint representation of data.
 */
@property (nonatomic) CGPoint position;
/*!
 CGSize representation of data.
 */
@property (nonatomic) CGSize size;
/*!
 CGRect representation of data.
 */
@property (nonatomic) CGRect rect;
/*!
 CGVector representation of data.
 */
@property (nonatomic) CGVector vector;

/*! @group SKUPositionObject Methods */

-(id)initWithPosition:(CGPoint)position;
-(id)initWithVector:(CGVector)vector;
-(id)initWithSize:(CGSize)size;
-(id)initWithRect:(CGRect)rect;

/*! @methodgroup Initialization */

/*!
 Creates and returns an SKUPositionObject from a CGPoint parameter. This becomes the origin in the bundled CGRect.
 @param location CGPoint value
 @return SKUPositionObject with input position data
 */
+(SKUPositionObject*)position:(CGPoint)location;
/*!
 Creates and returns an SKUPositionObject from a CGVector parameter. This becomes the origin in the bundled CGRect.
 @param vector CGVector value
 @return SKUPositionObject with input vector data
 */
+(SKUPositionObject*)vector:(CGVector)vector;
/*!
 Creates and returns an SKUPositionObject from a CGSize parameter. This becomes the size in the bundled CGRect.
 @param size CGSize value
 @return SKUPositionObject with input size data
 */
+(SKUPositionObject*)size:(CGSize)size;
/*!
 Creates and returns an SKUPositionObject from a CGRect parameter. This sets the position property from the origin and the size property from the size.
 @param rect CGRect value
 @return SKUPositionObject with input rect data
 */
+(SKUPositionObject*)rect:(CGRect)rect;

/*! @methodgroup Conversion and retrieval */

-(CGSize)getSizeFromPosition;
-(CGPoint)getPositionFromSize;
-(CGVector)getVectorFromSize;

@end


#pragma mark SKUShapeNode

/*!
 Apple's shape generator for SpriteKit causes performance issues. Shapes are rerendered each frame, despite a lack of change in appearance. You can cheat by parenting it to an SKEffectNode and setting it to rasterize. However, any changes cause it to rerender with high cpu usage. It also has low quality anti aliasing. Instead, you can use this class. SKUShapeNode uses CAShapeLayer to render a shape, which is slightly more costly than the rendering of the SKShapeNode, but once it's rendered, is cached as a bitmap and renders very quickly in SpriteKit thereafter. TLDR: SpriteKit's shape node fast redner, slow draw. SKUShapeNode is slow render, fast draw.
 */
@interface SKUShapeNode : SKNode <NSCopying>

/*! @group SKUShapeNode Properties */

/*!
 The CGPath to be drawn (in the Node's coordinate space) (will only redraw the image if the path is non-nil, so it's best to set the path as the last property and save some CPU cycles)
 */
@property (nonatomic) CGPathRef path;

/*!
 The color to draw the path with. (for no stroke use [SKColor clearColor]). Defaults to [SKColor whiteColor].
 */
@property (nonatomic, retain) SKColor *strokeColor;

/*!
 The color to fill the path with. Defaults to [SKColor clearColor] (no fill).
 */
@property (nonatomic, retain) SKColor *fillColor;

/*!
 The width used to stroke the path. Widths larger than 2.0 may result in artifacts. Defaults to 1.0.
 */
@property (nonatomic) CGFloat lineWidth;


/*! The fill rule used when filling the path. Options are `non-zero' and
 * `even-odd'. Defaults to `non-zero'. */
@property (nonatomic, assign) NSString* fillRule;
/*!
 Boolean determining whether to anti-alias the rendered image.
 */
@property (nonatomic, assign) BOOL antiAlias;
/*!
 See CAShapeLayer for information on this.
 */
@property (nonatomic, assign) NSString* lineCap;
/*! Causing exceptions (at least on OSX) - keeping it in there cuz I BELIEVE the error is on Apple's side. Careful using this though. See CAShapeLayer for information. */
@property (nonatomic, assign) NSArray* lineDashPattern;
/*! Causing exceptions (at least on OSX) - keeping it in there cuz I BELIEVE the error is on Apple's side. Careful using this though. See CAShapeLayer for information. */
@property (nonatomic, assign) CGFloat lineDashPhase;
/*!
 See CAShapeLayer for information.
 */
@property (nonatomic, assign) NSString* lineJoin;
/*!
 Miter limit value for stroked paths.
 */
@property (nonatomic, assign) CGFloat miterLimit;
/*!
 Anchor point of the sprite.
 */
@property (nonatomic, assign) CGPoint anchorPoint;
/*!
 Readonly access to the rendered texture. MIGHT not be properly retina-ized.
 */
@property(nonatomic, readonly) SKTexture* texture;

/*! @methodgroup Initialization */

/*!
 Convenience method that creates and returns a new shape object in the shape of a circle.
 @brief circleWithRadius:andColor:
 @param radius radius of circle.
 @param color  Color of circle.
 @return SKUShapeNode
 */
+(SKUShapeNode*)circleWithRadius:(CGFloat)radius andColor:(SKColor*)color NS_SWIFT_NAME(init(circleWithRadius:andColor:));
/*!
 Convenience method that creates and returns a new shape object in the shape of a sqaure.
 @brief squareWithWidth:andColor:
 @param width Value that determines size of square.
 @param color Color of square
 @return SKUShapeNode
 */
+(SKUShapeNode*)squareWithWidth:(CGFloat)width andColor:(SKColor*)color NS_SWIFT_NAME(init(squareWithWidth:andColor:));
/*!
 Convenience method that creates and returns a new shape object in the shape of a rectanlge.
 @brief rectangleWithSize:andColor:
 @param size  CGSize value to make a rectange of.
 @param color Color of rectangle.
 @return SKUShapeNode
 */
+(SKUShapeNode*)rectangleWithSize:(CGSize)size andColor:(SKColor*)color NS_SWIFT_NAME(init(rectangleWithSize:andColor:));
/*!
 Convenience method that creates and returns a new shape object in the shape of a rounded rectangle.
 @brief rectangleRoundedWithSize:andCornerRadius:andColor:
 @param size   CGSize value to make a rectangle of.
 @param radius Radius value for corners
 @param color  Color of shape
 @return SKUShapeNode
 */
+(SKUShapeNode*)rectangleRoundedWithSize:(CGSize)size andCornerRadius:(CGFloat)radius andColor:(SKColor*)color NS_SWIFT_NAME(init(rectangleRoundedWithSize:andCornerRadius:andColor:));
/*!
 Convenience method that creates and returns a new shape object in the shape of the provided path.
 @brief shapeWithPath:andColor:
 @param path  CGPathRef path to make a shape out of. A copy is made, so you are responsible for releasing this reference.
 @param color Color to make shape.
 @return SKUShapeNode
 */
+(SKUShapeNode*)shapeWithPath:(CGPathRef)path andColor:(SKColor*)color NS_SWIFT_NAME(init(shapeWithPath:andColor:));


@end

#pragma mark SKUMultiLineLabelNode
/*!
 Provides an SKLabelNode-like interface for multiline labels.
 */
@interface SKUMultiLineLabelNode : SKSpriteNode <NSCopying>

/*! @group SKUMultiLineLabelNode Properties */

/*!
 Color to make text.
 */
@property(retain, nonatomic) SKColor* fontColor;
/*!
 NSString name of font.
 */
@property(copy, nonatomic) NSString* fontName;
/*!
 Size of font.
 */
@property(nonatomic) CGFloat fontSize;
/*!
 Uses SKLabelNode alignment mode enumerations to determine horizontal alignment.
 */
@property(nonatomic) SKLabelHorizontalAlignmentMode horizontalAlignmentMode;
/*!
 NSString representation of the text.
 */
@property(copy, nonatomic) NSString* text;
/*!
 Uses SKLabelNode alignment mode enumerations to determine horizontal alignment. Note that, due to the inability to determine the location of the bottom baseline, both the baseline and bottom enumerations result in bottom-like behavior.
 */
@property(nonatomic) SKLabelVerticalAlignmentMode verticalAlignmentMode;
/*!
 Used to determine the width the text can occupy before creating a new line.
 */
@property(nonatomic, assign) CGFloat paragraphWidth;
/*!
 Allows to make text fit into a vertical space. Might be necessary to force stroke to work right.
 */
@property(nonatomic, assign) CGFloat paragraphHeight;
/*!
 Space between lines in points.
 */
@property(nonatomic, assign) CGFloat lineSpacing;
/*!
 Width of the stroke.
 */
@property(nonatomic, assign) CGFloat strokeWidth;
/*!
 Color of the stroke.
 */
@property(retain, nonatomic) SKColor* strokeColor;

/*! @group SKUMultiLineLabelNode Methods */

/*!
 Convenience method to create and return a new object with specific font name.
 @param fontName Name of the font.
 @return SKUMultiLineLabelNode object
 */
+ (instancetype)labelNodeWithFontNamed:(NSString *)fontName;
- (instancetype)initWithFontNamed:(NSString *)fontName;


@end

#pragma mark SKUButtonLabelProperties
/*! 
 Stores a single state for labels in buttons. The properties set on this object gets passed to the button's label for the appropriate state.
 */
@interface SKUButtonLabelProperties : NSObject <NSCopying>

/*! @group SKUButtonLabelProperties Properties */

/*!
 text string
 */
@property (nonatomic) NSString* text;
/*!
 fontColor object
 */
@property (atomic, strong) SKColor* fontColor;
/*!
 fontSize value
 */
@property (nonatomic) CGFloat fontSize;
/*!
 fontName string
 */
@property (nonatomic) NSString* fontName;
/*!
 CGPoint of positional data
 */
@property (nonatomic) CGPoint position;
/*!
 scale value
 */
@property (nonatomic) CGFloat scale;

/*! @group SKUButtonLabelProperties Methods */

/*!
 Creates and returns an object with default properties for everything but the text.
 @param text NSString value for this state object to store
 @return SKUButtonLabelProperties object
 */
+(SKUButtonLabelProperties*)propertiesWithText:(NSString *)text;
/*!
 Creates and returns an object with default properties for position offset and scale (CGPointZero and 1.0f respectively).
 @param text      NSString value for this state object to store
 @param fontColor SKColor value for this state object to store
 @param fontSize  Font size value for this state object to store
 @param fontName  Font name value for this state object to store
 @return SKUButtonLabelProperties object
 */
+(SKUButtonLabelProperties*)propertiesWithText:(NSString *)text andColor:(SKColor *)fontColor andSize :(CGFloat)fontSize andFontName:(NSString *)fontName;
/*!
 Creates and returns an object allowing you to set all properties explicitly.
 @param text      NSString value for this state object to store
 @param fontColor SKColor value for this state object to store
 @param fontSize  Font size value for this state object to store
 @param fontName  Font name value for this state object to store
 @param position  Position value for this state object to store
 @param scale     Scale value for this state object to store
 @return SKUButtonLabelProperties object
 */
+(SKUButtonLabelProperties*)propertiesWithText:(NSString *)text andColor:(SKColor *)fontColor andSize :(CGFloat)fontSize andFontName:(NSString *)fontName andPositionOffset:(CGPoint)position andScale:(CGFloat)scale;

@end
/*! 
 Stores all states for a label in buttons. The properties collected on this object get passed to the button's states.
 */
@interface SKUButtonLabelPropertiesPackage : NSObject <NSCopying>

/*! @group SKUButtonLabelPropertiesPackage Properties */

#define skuHoverScale ((CGFloat) 1.3)
/*!
 Label properties for default state.
 */
@property (nonatomic) SKUButtonLabelProperties* propertiesDefaultState;
/*!
 Label properties for pressed state.
 */
@property (nonatomic) SKUButtonLabelProperties* propertiesPressedState;
/*!
 Label properties for hovered state.
 */
@property (nonatomic) SKUButtonLabelProperties* propertiesHoveredState;
/*!
 Label properties for disabled state.
 */
@property (nonatomic) SKUButtonLabelProperties* propertiesDisabledState;

/*! Allows you to explicitly set all states. */
+(SKUButtonLabelPropertiesPackage*)packageWithPropertiesForDefaultState:(SKUButtonLabelProperties *)defaultState andPressedState:(SKUButtonLabelProperties *)pressedState andHoveredState:(SKUButtonLabelProperties *)hoveredState andDisabledState:(SKUButtonLabelProperties *)disabledState;
/*! Allows you to explicitly set default and pressed states, derives the disabled state from default, but with a gray overlay, and derives the hovered state from the default at a skuHoverScale scale. */
+(SKUButtonLabelPropertiesPackage*)packageWithPropertiesForDefaultState:(SKUButtonLabelProperties*)defaultState andPressedState:(SKUButtonLabelProperties*)pressedState andDisabledState:(SKUButtonLabelProperties*)disabledState;
/*! Allows you to explicitly set default and pressed states and derives the disabled state from default, but with a gray overlay, and derives the hovered state from the default at a skuHoverScale scale. */
+(SKUButtonLabelPropertiesPackage*)packageWithPropertiesForDefaultState:(SKUButtonLabelProperties *)defaultState andPressedState:(SKUButtonLabelProperties *)pressedState;
/*! Allows you to explicitly set default state, derives the pressed state from the default by scaling it down to a relative 90% size, and derives the disabled state from default, but with a gray overlay, and derives the hovered state from the default at a skuHoverScale scale. */
+(SKUButtonLabelPropertiesPackage*)packageWithPropertiesForDefaultState:(SKUButtonLabelProperties *)defaultState;
/*! Creates and returns a package based on SKU defaults. */
+(SKUButtonLabelPropertiesPackage*)packageWithDefaultPropertiesWithText:(NSString*)text;

/*! @group SKUButtonLabelPropertiesPackage Methods */

/*! Allows you to change the text for all states at once. */
-(void)changeText:(NSString*)text;
/*! Change the size of all states at once. */
-(void)changeFontSize:(CGFloat)fontSize;
/*! Change the font of all states at once. */
-(void)changeFontName:(NSString*)fontName;

@end

#pragma mark SKUButtonSpriteStateProperties
/*! 
 Stores a single state for sprites in buttons. The properties set on this object gets passed to the button's sprite for the appropriate state.
 */
@interface SKUButtonSpriteStateProperties : NSObject <NSCopying>

/*! @group SKUButtonSpriteStateProperties Properties */

/*!
 Alpha value stored for a given state.
 */
@property (nonatomic) CGFloat alpha;
/*!
 Color value stored for a given state.
 */
@property (nonatomic, strong) SKColor* color;
/*!
 colorBlendFactor value stored for a given state.
 */
@property (nonatomic) CGFloat colorBlendFactor;
/*!
 Position value stored for a given state.
 */
@property (nonatomic) CGPoint position;

/*!
 CenterRect value stored for a given state.
 */
@property (nonatomic) CGRect centerRect;
/*!
 xScale value stored for a given state.
 */
@property (nonatomic) CGFloat xScale;
/*!
 yScale value stored for a given state.
 */
@property (nonatomic) CGFloat yScale;
/*!
 padding value stored for a given state.
 */
@property (nonatomic) CGFloat padding;
/*!
 SKTexture object stored for a given state.
 */
@property (nonatomic, strong) SKTexture* texture;

/*! @group SKUButtonSpriteStateProperties Methods */

/*! Returns a new object with the following properties. */
+(SKUButtonSpriteStateProperties*)propertiesWithTexture:(SKTexture*)texture andAlpha:(CGFloat)alpha andColor:(SKColor *)color andColorBlendFactor:(CGFloat)colorBlendFactor andPositionOffset:(CGPoint)position andXScale:(CGFloat)xScale andYScale:(CGFloat)yScale andCenterRect:(CGRect)centerRect andPadding:(CGFloat)padding;
/*! Returns a new object with the following properties. */
+(SKUButtonSpriteStateProperties*)propertiesWithTexture:(SKTexture*)texture andAlpha:(CGFloat)alpha andColor:(SKColor *)color andColorBlendFactor:(CGFloat)colorBlendFactor andPositionOffset:(CGPoint)position andXScale:(CGFloat)xScale andYScale:(CGFloat)yScale andCenterRect:(CGRect)centerRect;
/*! Returns a new object with the following properties. */
+(SKUButtonSpriteStateProperties*)propertiesWithTexture:(SKTexture*)texture andAlpha:(CGFloat)alpha andColor:(SKColor*)color andColorBlendFactor:(CGFloat)colorBlendFactor andPositionOffset:(CGPoint)position andXScale:(CGFloat)xScale andYScale:(CGFloat)yScale;
/*! Returns a new object with the following properties. */
+(SKUButtonSpriteStateProperties*)propertiesWithTexture:(SKTexture*)texture andAlpha:(CGFloat)alpha andColor:(SKColor*)color andColorBlendFactor:(CGFloat)colorBlendFactor andPositionOffset:(CGPoint)position;
/*! Returns a new object with the following properties. */
+(SKUButtonSpriteStateProperties*)propertiesWithTexture:(SKTexture*)texture andAlpha:(CGFloat)alpha andColor:(SKColor*)color andColorBlendFactor:(CGFloat)colorBlendFactor;
/*! Returns a new object with the following properties. */
+(SKUButtonSpriteStateProperties*)propertiesWithTexture:(SKTexture*)texture andAlpha:(CGFloat)alpha;
/*! Returns a new object with the included default properties. 
 @brief propertiesWithDefaultsSKU
 */
+(SKUButtonSpriteStateProperties*)propertiesWithDefaultsSKU NS_SWIFT_NAME(init(defaultsSKU:));
/*! Returns a new object with the included default toggle on properties.
 @brief propertiesWithDefaultsToggleOnSKU
*/
+(SKUButtonSpriteStateProperties*)propertiesWithDefaultsToggleOnSKU NS_SWIFT_NAME(init(defaultsToggleOnSKU:));
/*! Returns a new object with the included default toggle off properties. 
 @brief propertiesWithDefaultsToggleOffSKU
*/
+(SKUButtonSpriteStateProperties*)propertiesWithDefaultsToggleOffSKU NS_SWIFT_NAME(init(defaultsToggleOffSKU:));
/*! Returns a new object with the included default knob properties. */
+(SKUButtonSpriteStateProperties*)propertiesWithDefaultsSliderKnobSKU:(BOOL)pressed;
/*! Returns a new object with the included default slider slide properties. 
 @brief propertiesWithDefaultsSliderSlideSKU
*/
+(SKUButtonSpriteStateProperties*)propertiesWithDefaultsSliderSlideSKU NS_SWIFT_NAME(init(defaultsSliderSlideSKU:));
/*! Sets the x and y scale together. */
-(void)setScale:(CGFloat)scale;

@end
/*! 
 Stores all states for a sprite in buttons. The properties collected on this object get passed to the button's states.
 */
@interface SKUButtonSpriteStatePropertiesPackage : NSObject <NSCopying>

/*! @group SKUButtonSpriteStatePropertiesPackage Properties */

/*!
 Sprite properties for default state.
 */
@property (nonatomic) SKUButtonSpriteStateProperties* propertiesDefaultState;
/*!
 Sprite properties for pressed state.
 */
@property (nonatomic) SKUButtonSpriteStateProperties* propertiesPressedState;
/*!
 Sprite properties for hovered state.
 */
@property (nonatomic) SKUButtonSpriteStateProperties* propertiesHoveredState;
/*!
 Sprite properties for disabled state.
 */
@property (nonatomic) SKUButtonSpriteStateProperties* propertiesDisabledState;

/*! @group SKUButtonSpriteStatePropertiesPackage Methods */

/*! Allows you to explicitly set all states. */
+(SKUButtonSpriteStatePropertiesPackage*)packageWithPropertiesForDefaultState:(SKUButtonSpriteStateProperties*)defaultState andPressedState:(SKUButtonSpriteStateProperties*)pressedState andHoveredState:(SKUButtonSpriteStateProperties*)hoveredState andDisabledState:(SKUButtonSpriteStateProperties*)disabledState;
/*! Allows you to explicitly set default and pressed states and derives the disabled state from default, but with half opacity, and the hovered state from the default with skuHoverScale scale. */
+(SKUButtonSpriteStatePropertiesPackage*)packageWithPropertiesForDefaultState:(SKUButtonSpriteStateProperties*)defaultState andPressedState:(SKUButtonSpriteStateProperties*)pressedState andDisabledState:(SKUButtonSpriteStateProperties*)disabledState;
/*! Allows you to explicitly set default and pressed states and derives the disabled state from default, but with half opacity, and the hovered state from the default with skuHoverScale scale. */
+(SKUButtonSpriteStatePropertiesPackage*)packageWithPropertiesForDefaultState:(SKUButtonSpriteStateProperties *)defaultState andPressedState:(SKUButtonSpriteStateProperties *)pressedState;
/*! Allows you to explicitly set default state and derives the pressed state from the default with 0.5 blend factor of a gray color overlay, and the disabled state from default, but with half opacity, and the hovered state from the default with skuHoverScale scale. */
+(SKUButtonSpriteStatePropertiesPackage*)packageWithPropertiesForDefaultState:(SKUButtonSpriteStateProperties *)defaultState;
/*! Returns a package based on the included assets. 
 @brief packageWithDefaultPropertiesSKU
 */
+(SKUButtonSpriteStatePropertiesPackage*)packageWithDefaultPropertiesSKU NS_SWIFT_NAME(init(defaultPropertiesSKU:));
/*! Returns a package based on the included assets. 
 @brief packageWithDefaultToggleOnPropertiesSKU
 */
+(SKUButtonSpriteStatePropertiesPackage*)packageWithDefaultToggleOnPropertiesSKU NS_SWIFT_NAME(init(defaultToggleOnPropertiesSKU:));
/*! Returns a package based on the included assets. 
 @brief packageWithDefaultToggleOffPropertiesSKU
 */
+(SKUButtonSpriteStatePropertiesPackage*)packageWithDefaultToggleOffPropertiesSKU NS_SWIFT_NAME(init(defaultToggleOffPropertiesSKU:));
/*! Returns a package based on the included assets. 
 @brief packageWithDefaultSliderKnobPropertiesSKU
 */
+(SKUButtonSpriteStatePropertiesPackage*)packageWithDefaultSliderKnobPropertiesSKU NS_SWIFT_NAME(init(defaultSliderKnobPropertiesSKU:));
/*! Returns a package based on the included assets. 
 @brief packageWithDefaultSliderSliderSlidePropertiesSKU
 */
+(SKUButtonSpriteStatePropertiesPackage*)packageWithDefaultSliderSliderSlidePropertiesSKU NS_SWIFT_NAME(init(defaultSliderSliderSlidePropertiesSKU:));

/*! Allows you to change the texture for all states at once. */
-(void)changeTexture:(SKTexture*)texture;
/*! Allows you to change the padding for all states at once. */
-(void)changePadding:(CGFloat)padding;

@end

#pragma mark SKUButton

/*! @group SKUButton Enums */

/*!
 Enumerator/flags for determining how buttons send signals.
 @constant kSKUButtonMethodPostNotification Sends out an NSNotification with a name determined by either the notificationNameDown or notificationNameUp property. Only sends button release notifications if the release remained within the button bounds.
 @constant kSKUButtonMethodDelegate Calls doButtonDown or doButtonUp on the delegate, set with the delegate property. This is the only way to detech button releases that aren't within the bounds of the button.
 @constant kSKUButtonMethodRunActions Calls selectors set with methods setDownAction and setUpAction. Only sends button release calls if the release remained within the button bounds.
 
 To get the same result in Swift, be sure to use rawValue
 
@seealso SKUButton
 */
typedef enum {
	kSKUButtonMethodPostNotification = 1,
	kSKUButtonMethodDelegate = 1 << 1,
	kSKUButtonMethodRunActions = 1 << 2,
} kSKUButtonMethods;

/*!
 Enumerator to differentiate button types from each other.
 @constant kSKUButtonTypePush Determines push button type.
 @constant kSKUButtonTypeToggle Determines toggle button type.
 @constant kSKUButtonTypeSlider Determines slider button type.
 @seealso SKUButton
 */
typedef enum {
	kSKUButtonTypePush = 1,
	kSKUButtonTypeToggle,
	kSKUButtonTypeSlider,
} kSKUButtonTypes;

/*!
 Enumerator/flags for determining the state of buttons. States can coexist, but are unlikely for anything other than Hovered and either Pressed or Default to coincide.
 @constant kSKUButtonStateUndefined Hopefully true if no state is present. Should never be the case.
 @constant kSKUButtonStateDefault Flagged when enabled, yet sitting dormat.
 @constant kSKUButtonStatePressed Flagged when enabled and actively pressed down.
 @constant kSKUButtonStatePressedOutOfBounds Flagged when enabled and pressed down, but the current location of the input is beyond the bounds of the button.
 @constant kSKUButtonStateHovered Flagged when button is hovered. (This will either be an OS X mouse or a tvOS focus)
 @constant kSKUButtonStateDisabled Flagged when the button is disabled.
 
 To get the same result in Swift, be sure to use rawValue
 
 @seealso SKUButton
 */
typedef enum {
	kSKUButtonStateUndefined = 1 << 0,
	kSKUButtonStateDefault = 1 << 1,
	kSKUButtonStatePressed = 1 << 2,
	kSKUButtonStatePressedOutOfBounds = 1 << 3,
	kSKUButtonStateHovered = 1 << 4,
	kSKUButtonStateDisabled = 1 << 5,

} kSKUButtonStates;

@class SKUSliderButton;
@class SKUButton;

/*!
 Delegate protocol for SKUButton. Only used if flagged for sending delegate signals.
 */
@protocol SKUButtonDelegate <NSObject>	//define delegate protocol

/*! @group SKUButtonDelegate Methods */

@optional
/*!
 Optional: Called on the delegate when a button is pressed.
 @param button The button pressed.
 */
-(void)doButtonDown:(SKUButton*)button;
/*!
 Optional: Called on the delegate when a button is released.
 @param button   The button released.
 @param inBounds Boolean determining whether the release was inside button bounds (YES) or not (NO).
 */
-(void)doButtonUp:(SKUButton*)button inBounds:(BOOL)inBounds;
/*!
 Optional: Called on delegate when a button's value changes (only used with SKUSliderButton)
 @param button button whose value changed
 */
-(void)valueChanged:(SKUSliderButton*)button;
@required
@end //end protocol

/*! SKUButton: Intended as a cross platform, unified way to design buttons for menus and input, instead of designing a completely different interface for Mac, iOS, and tvOS. Still needs a bit more effort when used on tvOS, but shouldn't be too hard. 
 
 Note: anchorPoint (and potentially other) SKSpriteNode properties have no effect - it is only subclassed as a sprite to help with Xcode's scene creation tool and determine a minimum boundary.
 
 Also Note: when using action or notification button methods, the release of a button will only trigger the button release methods when the release is in the bounds of the button. However, using the delegate method, you will see the delegate called in both situations as well as a boolean passed that will tell you if the release is in bounds or not.
 @warning This class is not intended for direct usage: instead, use SKUPushButton, SKUToggleButton, or SKUSliderButton. While it's not what I would define as "risky", you will likely get better results by using the subclasses. You are also free to subclass. Use the other subclasses as a reference.
 @seealso SKUPushButton
 @seealso SKUToggleButton
 @seealso SKUSliderButton
 */
@interface SKUButton : SKSpriteNode

/*! @group Button state */

/*! 
 Identifies button type.
 @seealso kSKUButtonTypes
 */
@property (nonatomic, readonly) kSKUButtonTypes buttonType;
/*! Used for enumeration of button ids - this is for you to set. Intended for use in switch statements. */
@property (nonatomic) NSInteger whichButton;
/*! 
 Current state of the button

 To get the same result in Swift, be sure to use rawValue

 @seealso kSKUButtonStates
 */
@property (nonatomic, readonly) kSKUButtonStates buttonState;
/*! Returns whether the button is currently being hovered. */
@property (nonatomic, readonly) BOOL isHovered;
/*! 
 Used for enumeration of button ids 

 To get the same result in Swift, be sure to use rawValue

 @seealso kSKUButtonMethods
 */
@property (nonatomic) uint8_t buttonMethod;
/*! Readonly: tells you if button is enabled or not */
@property (nonatomic, readonly) BOOL isEnabled;

/*! @group Button actions */

/*!
 If button is set to call delegate, this is the delegate used.
 @seealso SKUButtonDelegate
 */
@property (nonatomic, weak) id <SKUButtonDelegate> delegate;

/*! If button is set to send notifications, this is the name of the notification. Can set the name here as well. */
@property (nonatomic) NSString* notificationNameDown;
/*! If button is set to send notifications, this is the name of the notification. Can set the name here as well. */
@property (nonatomic) NSString* notificationNameUp;

/*! @group Button Looks */

/*!
 Readonly access to the base sprite.
 While you can edit properties on the sprite itself, it is discouraged unless you really know what you're doing.
 */
@property (nonatomic, readonly) SKSpriteNode* baseSprite;
/*! Establishes the smallest possible area the button can take up (not accounting for properties with centerRect set that automatically expand). This is the same thing as setting the size property. It only exists to document clarity. */
@property (nonatomic) CGSize sizeMinimumBoundary;
/*!
 Properties to use on the base sprite in default state.
 */
@property (nonatomic) SKUButtonSpriteStateProperties* baseSpritePropertiesDefault;
/*! Properties to use on the base sprite in pressed state. */
@property (nonatomic) SKUButtonSpriteStateProperties* baseSpritePropertiesPressed;
/*! Properties to use on the base sprite in hovered state. */
@property (nonatomic) SKUButtonSpriteStateProperties* baseSpritePropertiesHovered;
/*! Properties to use on the base sprite in disabled state. */
@property (nonatomic) SKUButtonSpriteStateProperties* baseSpritePropertiesDisabled;
/*! Readonly access to a package for the base sprite properties */
@property (nonatomic) SKUButtonSpriteStatePropertiesPackage* baseSpritePropertiesPackage;


/*! @methodgroup Initialization */

/*! Creates and returns a button with a base sprite of the image named. */
+(SKUButton*)buttonWithImageNamed:(NSString*)name;
/*! Creates and returns a button with a base sprite of the texture. */
+(SKUButton*)buttonWithTexture:(SKTexture*)texture;
/*! Creates and returns a button with a base sprite package. */
+(SKUButton*)buttonWithPropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)package;

/*! This SHOULD be called after either raw init or initWithCoder. Meant to be overridden with post initialization purposes in custom subclasses. */
-(void)didInitialize;

/*! @methodgroup Button state */

/*! Sets all states based off of the default state. 
 @warning
 baseSpritePropertiesDefault, baseSpritePropertiesPressed, baseSpritePropertiesHovered, and baseSpritePropertiesDisabled all point to the same pointer as a result. If you edit one state, they will all change. If you don't want them all to change with an edit, do
 
 <pre>
 @textblock
 SKUButton* button; // assuming this is properly set up
 [button buttonStatesNormalize];
 button.baseSpritePropertiesPressed = button.baseSpritePropertiesPressed.copy;
 @/textblock
 </pre>
 Behaves similarly in subclasses, but also applies to the additional state packages included on those.
 */
-(void)buttonStatesNormalize;
/*! Sets all states based off of the default state using the settings determined in 
 <pre>
 @textblock
 [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:(SKUButtonSpriteStateProperties *)defaultState] 
 @/textblock
 </pre>
 Behaves similarly in subclasses, but also applies to the additional state packages included on those.
  */
-(void)buttonStatesDefault;
/*! Call to explicitly enable button (meant to reverse the state of being disabled). Be sure to call super method if you override. */
-(void)enableButton;
/*! Call to explicitly disable button (meant to reverse the state of being enabled). Be sure to call super method if you override. */
-(void)disableButton;

/*! @methodgroup Button actions */

/*! If button is set to call actions, set method and target to call on method when pressed down. Sets flag on self.buttonMethods to run actions. */
-(void)setDownAction:(SEL)selector toPerformOnTarget:(NSObject*)target;
/*! If button is set to call actions, set method and target to call on method when released. Sets flag on self.buttonMethods to run actions. */
-(void)setUpAction:(SEL)selector toPerformOnTarget:(NSObject*)target;

/*! Sets all base sprite states in one command. */
-(void)setBaseStatesWithPackage:(SKUButtonSpriteStatePropertiesPackage*)package;
/*! Calls the actions for button down press. Location is in local space. */
-(void)buttonPressed:(CGPoint)location;
/*! Calls the actions for button release. Location is in local space. */
-(void)buttonReleased:(CGPoint)location;

-(void)updateCurrentSpriteStateProperties;



@end

#pragma mark SKUPushButton

/*!
 Cross platform solution for basic push buttons.
 @seealso SKUToggleButton
 @seealso SKUSliderButton
 */
@interface SKUPushButton : SKUButton

/*! @group SKUPushButton Properties */

/*! Read only access to title label. */
@property (nonatomic, strong, readonly) SKLabelNode* titleLabel;
/*! Set this to setup the title label. */
@property (nonatomic) SKUButtonLabelProperties* labelPropertiesDefault;
/*! Set this to setup the title label properties when the button is pressed. */
@property (nonatomic) SKUButtonLabelProperties* labelPropertiesPressed;
/*! Set this to setup the title label properties when the button is hovered. */
@property (nonatomic) SKUButtonLabelProperties* labelPropertiesHovered;
/*! Set this to setup the title label properties when the button is disabled. */
@property (nonatomic) SKUButtonLabelProperties* labelPropertiesDisabled;
/*! Readonly access to a package for the label properties */
@property (nonatomic, readonly) SKUButtonLabelPropertiesPackage* labelPropertiesPackage;



/*! Read only access to title sprite. */
@property (nonatomic, strong, readonly) SKSpriteNode* titleSprite;
/*! Properties to use on the title sprite in default state. */
@property (nonatomic) SKUButtonSpriteStateProperties* titleSpritePropertiesDefault;
/*! Properties to use on the title sprite in pressed state. */
@property (nonatomic) SKUButtonSpriteStateProperties* titleSpritePropertiesPressed;
/*! Properties to use on the title sprite in hovered state. */
@property (nonatomic) SKUButtonSpriteStateProperties* titleSpritePropertiesHovered;
/*! Properties to use on the title sprite in disabled state. */
@property (nonatomic) SKUButtonSpriteStateProperties* titleSpritePropertiesDisabled;
#pragma mark SKUPushButton inits

/*! @group SKUPushButton Methods */

/*!
 Creates and returns an SKUPushButton with default settings plus the text provided.
 @param title Text value of the label on the button.
 @return new SKUPushButton object
 */
+(SKUPushButton*)pushButtonWithTitle:(NSString*)title;
/*!
 Creates and returns an SKUPushButton with packages provided.
 @param backgroundPackage SKUButtonSpriteStatePropertiesPackage object providing varied background sprite states.
 @param foregroundPackage SKUButtonSpriteStatePropertiesPackage object providing varied foreground sprite states.
 @return new SKUPushButton object
 */
+(SKUPushButton*)pushButtonWithBackgroundPropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)backgroundPackage andForeGroundSpritePropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)foregroundPackage;
/*!
 Creates and returns an SKUPushButton with packages provided.
 @param backgroundPackage SKUButtonSpriteStatePropertiesPackage object providing varied background sprite states.
 @param titleLabelPackage SKUButtonLabelPropertiesPackage object providing varied foreground label states.
 @return new SKUPushButton object
 */
+(SKUPushButton*)pushButtonWithBackgroundPropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)backgroundPackage andTitleLabelPropertiesPackage:(SKUButtonLabelPropertiesPackage*)titleLabelPackage;
/*!
 Creates and returns an SKUPushButton with packages provided.
 @param backgroundPackage SKUButtonSpriteStatePropertiesPackage object providing varied background sprite states.
 @param foregroundPackage SKUButtonSpriteStatePropertiesPackage object providing varied foreground sprite states.
 @param titlePackage      SKUButtonLabelPropertiesPackage object providing varied foreground label states.
 @return new SKUPushButton object
 */
+(SKUPushButton*)pushButtonWithBackgroundPropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)backgroundPackage andForeGroundSpritePropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)foregroundPackage andTitleLabelPropertiesPackage:(SKUButtonLabelPropertiesPackage*)titlePackage;

/*!
 Allows the passing of a SKUButtonSpriteStatePropertiesPackage to an already created SKUPushButton
 @param package SKUButtonSpriteStatePropertiesPackage object providing varied foreground sprite states.
 */
-(void)setTitleSpriteStatesWithPackage:(SKUButtonSpriteStatePropertiesPackage*)package;
/*!
 Allows the passing of a SKUButtonLabelPropertiesPackage to an already created SKUPushButton
 @param package SKUButtonLabelPropertiesPackage object providing varied foreground label states.
 */
-(void)setTitleLabelStatesWithPackage:(SKUButtonLabelPropertiesPackage*)package;
/*!
 Allows you to change the text value for multiple states in one call.
 @param text   Text to change the label to.
 @param states Flagged states to change text.
 */
-(void)changeTitleLabelText:(NSString*)text forStates:(kSKUButtonStates)states;
@end

#pragma mark SKUToggleButton

/*!
 Cross platform solution for basic toggle buttons.
 @seealso SKUPushButton
 @seealso SKUSliderButton
 */
@interface SKUToggleButton : SKUPushButton

/*! @group SKUToggleButton Properties */

/*! Read only access to toggle sprite. */
@property (nonatomic, strong, readonly) SKSpriteNode* toggleSprite;
/*! Properties to use on the toggle sprite in default on state. */
@property (nonatomic) SKUButtonSpriteStateProperties* toggleSpritePropertiesOnDefault;
/*! Properties to use on the toggle sprite in pressed on state. */
@property (nonatomic) SKUButtonSpriteStateProperties* toggleSpritePropertiesOnPressed;
/*! Properties to use on the toggle sprite in hovered on state. */
@property (nonatomic) SKUButtonSpriteStateProperties* toggleSpritePropertiesOnHovered;
/*! Properties to use on the toggle sprite in disabled on state. */
@property (nonatomic) SKUButtonSpriteStateProperties* toggleSpritePropertiesOnDisabled;

/*! Properties to use on the toggle sprite in default off state. */
@property (nonatomic) SKUButtonSpriteStateProperties* toggleSpritePropertiesOffDefault;
/*! Properties to use on the toggle sprite in pressed off state. */
@property (nonatomic) SKUButtonSpriteStateProperties* toggleSpritePropertiesOffPressed;
/*! Properties to use on the toggle sprite in hovered off state. */
@property (nonatomic) SKUButtonSpriteStateProperties* toggleSpritePropertiesOffHovered;
/*! Properties to use on the toggle sprite in disabled off state. */
@property (nonatomic) SKUButtonSpriteStateProperties* toggleSpritePropertiesOffDisabled;

/*! Boolean determining whether the button is in an on state or not. */
@property (nonatomic) BOOL on;

/*! @group SKUToggleButton Methods */

/*!
 Creates and returns an SKUToggleButton with title provided.
 @param title String to derive packages from.
 @return new SKUToggleButton object
 */
+(SKUToggleButton*)toggleButtonWithTitle:(NSString*)title;
/*!
 Creates and returns an SKUToggleButton with packages provided.
 @param backgroundPackage SKUButtonSpriteStatePropertiesPackage object providing varied background sprite states.
 @param foregroundPackage SKUButtonSpriteStatePropertiesPackage object providing varied foreground sprite states.
 @return new SKUToggleButton object
 */
+(SKUToggleButton*)toggleButtonWithBackgroundPropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)backgroundPackage andForeGroundSpritePropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)foregroundPackage;
/*!
 Creates and returns an SKUToggleButton with packages provided.
 @param backgroundPackage SKUButtonSpriteStatePropertiesPackage object providing varied background sprite states.
 @param foregroundPackage SKUButtonLabelPropertiesPackage object providing varied foreground sprite states.
 @return new SKUToggleButton object
 */
+(SKUToggleButton*)toggleButtonWithBackgroundPropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)backgroundPackage andTitleLabelPropertiesPackage:(SKUButtonLabelPropertiesPackage*)foregroundPackage;
/*!
 Creates and returns an SKUToggleButton with packages provided.
 @param backgroundPackage                SKUButtonSpriteStatePropertiesPackage object providing varied background sprite states.
 @param foregroundPackage                SKUButtonSpriteStatePropertiesPackage object providing varied foreground sprite states.
 @param toggleSpriteOnPropertiesPackage  SKUButtonSpriteStatePropertiesPackage object providing varied toggle off sprite states.
 @param toggleSpriteOffPropertiesPackage SKUButtonSpriteStatePropertiesPackage object providing varied toggle on sprite states.
 @return new SKUToggleButton object
 */
+(SKUToggleButton*)toggleButtonWithBackgroundPropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)backgroundPackage andForeGroundSpritePropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)foregroundPackage andToggleOnPackage:(SKUButtonSpriteStatePropertiesPackage*)toggleSpriteOnPropertiesPackage andToggleOffPackage:(SKUButtonSpriteStatePropertiesPackage*)toggleSpriteOffPropertiesPackage;
/*!
 Creates and returns an SKUToggleButton with packages provided.
 @param backgroundPackage                SKUButtonSpriteStatePropertiesPackage object providing varied background sprite states.
 @param foregroundPackage				 SKUButtonLabelPropertiesPackage object providing varied foreground sprite states.
 @param toggleSpriteOnPropertiesPackage  SKUButtonSpriteStatePropertiesPackage object providing varied toggle off sprite states.
 @param toggleSpriteOffPropertiesPackage SKUButtonSpriteStatePropertiesPackage object providing varied toggle on sprite states.
 @return new SKUToggleButton object
 */
+(SKUToggleButton*)toggleButtonWithBackgroundPropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)backgroundPackage andTitleLabelPropertiesPackage:(SKUButtonLabelPropertiesPackage*)foregroundPackage andToggleOnPackage:(SKUButtonSpriteStatePropertiesPackage*)toggleSpriteOnPropertiesPackage andToggleOffPackage:(SKUButtonSpriteStatePropertiesPackage*)toggleSpriteOffPropertiesPackage;


/*! Toggles button on/off state. */
-(void)toggleOnOff;
/*!
 Allows the passing of a SKUButtonSpriteStatePropertiesPackage to an already created SKUToggleButton to update the toggled on states.
 @param package SKUButtonLabelPropertiesPackage object providing toggle on sprite states.
 */
-(void)setToggleSpriteOnStatesWithPackage:(SKUButtonSpriteStatePropertiesPackage*)package;
/*!
 Allows the passing of a SKUButtonSpriteStatePropertiesPackage to an already created SKUToggleButton to update the toggled off states.
 @param package SKUButtonLabelPropertiesPackage object providing toggle off sprite states.
 */
-(void)setToggleSpriteOffStatesWithPackage:(SKUButtonSpriteStatePropertiesPackage*)package;
@end

#pragma mark SKUSliderButton

/*!
 Cross platform solution for basic sliders.
 @seealso SKUPushButton
 @seealso SKUToggleButton
 */
@interface SKUSliderButton : SKUButton

/*! @group Slider Looks */

/*! Read only access to knob sprite. */
@property (nonatomic, strong, readonly) SKSpriteNode* knobSprite;
/*! Read only access to slide sprite. */
@property (nonatomic, strong, readonly) SKSpriteNode* slideSprite;
/*! Read only access to maximumValueImage sprite. */
@property (nonatomic, strong, readonly) SKSpriteNode* maximumValueImage;
/*! Read only access to minimumValueImage sprite. */
@property (nonatomic, strong, readonly) SKSpriteNode* minimumValueImage;

/*! Properties to use on the knob sprite in default state. */
@property (nonatomic) SKUButtonSpriteStateProperties* knobSpritePropertiesDefault;
/*! Properties to use on the knob sprite in pressed state. */
@property (nonatomic) SKUButtonSpriteStateProperties* knobSpritePropertiesPressed;
/*! Properties to use on the knob sprite in hovered state. */
@property (nonatomic) SKUButtonSpriteStateProperties* knobSpritePropertiesHovered;
/*! Properties to use on the knob sprite in disabled state. */
@property (nonatomic) SKUButtonSpriteStateProperties* knobSpritePropertiesDisabled;

/*! Properties to use on the slide sprite in default state. */
@property (nonatomic) SKUButtonSpriteStateProperties* slideSpritePropertiesDefault;
/*! Properties to use on the slide sprite in pressed state. */
@property (nonatomic) SKUButtonSpriteStateProperties* slideSpritePropertiesPressed;
/*! Properties to use on the slide sprite in hovered state. */
@property (nonatomic) SKUButtonSpriteStateProperties* slideSpritePropertiesHovered;
/*! Properties to use on the slide sprite in disabled state. */
@property (nonatomic) SKUButtonSpriteStateProperties* slideSpritePropertiesDisabled;

/*! Properties to use on the maximumValueImage sprite in default state. */
@property (nonatomic) SKUButtonSpriteStateProperties* maximumValueImagePropertiesDefault;
/*! Properties to use on the maximumValueImage sprite in disabled state. */
@property (nonatomic) SKUButtonSpriteStateProperties* maximumValueImagePropertiesDisabled;

/*! Properties to use on the minimumValueImage sprite in default state. */
@property (nonatomic) SKUButtonSpriteStateProperties* minimumValueImagePropertiesDefault;
/*! Properties to use on the minimumValueImage sprite in disabled state. */
@property (nonatomic) SKUButtonSpriteStateProperties* minimumValueImagePropertiesDisabled;

/*! @group Slider Values and Functional Settings */

/*! Defaults to 50.0. */
@property (nonatomic) CGFloat value;
/*! Stores the previous value. */
@property (nonatomic, readonly) CGFloat previousValue;
/*! Defaults to 0.0. */
@property (nonatomic) CGFloat minimumValue;
/*! Defaults to 100.0. */
@property (nonatomic) CGFloat maximumValue;
/*! Defaults to NO. */
@property (nonatomic) BOOL continuous;
/*! Defaults to 200.0. */
@property (nonatomic) CGFloat sliderWidth;
/*! If button is set to send notifications, this is the name of the notification when the value changes. */
@property (nonatomic) NSString* notificationNameChanged;
/*!
 Step value to increment (modified by speed of movement) or decrement the value by when sliding with a Siri Remote. This is not required as a value is generated on the fly, but is available for customization. Uses auto generated value if the value is 0. Default value is 0. Harmless to use on other platforms, but has no effect.
 @attributelist Platforms:
 tvOS
 */
@property (nonatomic) CGFloat stepSize;

/*! @methodgroup Slider Inits */

/*!
 Creates and returns an SKUSliderButton with packages provided.
 @param sliderPackage SKUButtonSpriteStatePropertiesPackage object providing a stretching slider.
 @param knobPackage   SKUButtonSpriteStatePropertiesPackage object providing knob sprite states.
 @return new SKUSliderButton object
 */
+(SKUSliderButton*)sliderButtonWithSliderPackage:(SKUButtonSpriteStatePropertiesPackage*)sliderPackage andKnobPackage:(SKUButtonSpriteStatePropertiesPackage*)knobPackage;
/*!
 Creates and returns an SKUSliderButton with packages provided.
 @param knobPackage   SKUButtonSpriteStatePropertiesPackage object providing knob sprite states.
 @return new SKUSliderButton object
 */
+(SKUSliderButton*)sliderButtonWithKnobPackage:(SKUButtonSpriteStatePropertiesPackage*)knobPackage;
/*! 
 Creates and returns an SKUSliderButton with default settings.
 @return new SKUSliderButton object
 @brief sliderButtonWithDefaults
 */
+(SKUSliderButton*)sliderButtonWithDefaults NS_SWIFT_NAME(init(defaults:));


/*! @methodgroup Slider Looks */

-(void)setKnobSpriteStatesWithPackage:(SKUButtonSpriteStatePropertiesPackage*)package;
-(void)setSlideSpriteStatesWithPackage:(SKUButtonSpriteStatePropertiesPackage*)package;
-(void)setMaxValueSpriteStatesWithPackage:(SKUButtonSpriteStatePropertiesPackage*)package;
-(void)setMinValueSpriteStatesWithPackage:(SKUButtonSpriteStatePropertiesPackage*)package;

/*! @methodgroup Slider Actions */

/*! If button is set to call actions, set method and target to call on method when value changed. Sets flag on self.buttonMethods to run actions. */
-(void)setChangedAction:(SEL)selector toPerformOnTarget:(NSObject*)target;

@end
#pragma mark SKUNode

/*!
 Subclass of SKNode unifying all initialization methods to call "didInitialize" when finished.
 */
@interface SKUNode : SKNode
/*! @methodgroup Inits */
/*!
 Called once initialization is finished: use to handle events that you want to complete before "didMoveToView".
 */
-(void)didInitialize;

@end

#pragma mark SKUScene
/*!
 Subclass of SKScene unifying all initialization methods to call "didInitialize" when finished.
 */
@interface SKUScene : SKScene
/*! @methodgroup Inits */
/*!
 Called once initialization is finished: use to handle events that you want to complete before "didMoveToView".
 */
-(void)didInitialize;

#pragma mark gamepad executes
#pragma mark gamepad vague executes buttons
/*! @methodgroup Gamepad Calls */

/*!
 Called when gamepad input changes.
 @param player          GCControllerPlayerIndex determining which player caused the input.
 @param input           kSKUGamePadInputs enumeration determining which input was pressed
 @param xValue          Used for both button and directional inputs. Directional inputs will show x direction vector of the input while button inputs will show the pressure it was pressed with.
 @param yValue          Used only for directional inputs. Shows the y direction vector of the input.
 @param pressedState    kSKUGamepadButtonStates representing the state of the button press.
 @param eventDictionary NSDictionary object with objects originating the events.
 */
-(void)gamepadInputChangedForPlayer:(GCControllerPlayerIndex)player withInput:(kSKUGamePadInputs)input andXValue:(float)xValue andYValue:(float)yValue pressedState:(kSKUGamepadButtonStates)pressedState andEventDictionary:(NSDictionary*)eventDictionary;
/*!
 Called when gamepad motion input changes.
 @param player          GCControllerPlayerIndex determining which player caused the input.
 @param acceleration    SKUAcceleration struct to determine which direction the controller is facing.
 @param eventDictionary NSDictionary object with objects originating the events.
 */
-(void)gamepadMotionInputChangedForPlayer:(GCControllerPlayerIndex)player withAcceleration:(SKUAcceleration)acceleration andEventDictionary:(NSDictionary*)eventDictionary;

#pragma mark gamepad specific executes buttons
/*!
 Called when the left shoulder input changes.
 @param player          GCControllerPlayerIndex value for player who caused change.
 @param value           float value of pressure applied to input
 @param pressedState    kSKUGamepadButtonStates representing the state of the button press.
 @param eventDictionary NSDictionary containing objects originating events
 */
-(void)gamepadLeftShoulderChangedForPlayer:(GCControllerPlayerIndex)player withValue:(float)value pressedState:(kSKUGamepadButtonStates)pressedState andEventDictionary:(NSDictionary*)eventDictionary;
/*!
 Called when the left trigger input changes.
 @param player          GCControllerPlayerIndex value for player who caused change.
 @param value           float value of pressure applied to input
 @param pressedState    kSKUGamepadButtonStates representing the state of the button press.
 @param eventDictionary NSDictionary containing objects originating events
 */
-(void)gamepadLeftTriggerChangedForPlayer:(GCControllerPlayerIndex)player withValue:(float)value pressedState:(kSKUGamepadButtonStates)pressedState andEventDictionary:(NSDictionary*)eventDictionary;
/*!
 Called when the right shoulder input changes.
 @param player          GCControllerPlayerIndex value for player who caused change.
 @param value           float value of pressure applied to input
 @param pressedState    kSKUGamepadButtonStates representing the state of the button press.
 @param eventDictionary NSDictionary containing objects originating events
 */
-(void)gamepadRightShoulderChangedForPlayer:(GCControllerPlayerIndex)player withValue:(float)value pressedState:(kSKUGamepadButtonStates)pressedState andEventDictionary:(NSDictionary*)eventDictionary;
/*!
 Called when the right trigger input changes.
 @param player          GCControllerPlayerIndex value for player who caused change.
 @param value           float value of pressure applied to input
 @param pressedState    kSKUGamepadButtonStates representing the state of the button press.
 @param eventDictionary NSDictionary containing objects originating events
 */
-(void)gamepadRightTriggerChangedForPlayer:(GCControllerPlayerIndex)player withValue:(float)value pressedState:(kSKUGamepadButtonStates)pressedState andEventDictionary:(NSDictionary*)eventDictionary;
/*!
 Called when the A button input changes.
 @param player          GCControllerPlayerIndex value for player who caused change.
 @param value           float value of pressure applied to input
 @param pressedState    kSKUGamepadButtonStates representing the state of the button press.
 @param eventDictionary NSDictionary containing objects originating events
 */
-(void)gamepadButtonAChangedForPlayer:(GCControllerPlayerIndex)player withValue:(float)value pressedState:(kSKUGamepadButtonStates)pressedState andEventDictionary:(NSDictionary*)eventDictionary;
/*!
 Called when the B button input changes.
 @param player          GCControllerPlayerIndex value for player who caused change.
 @param value           float value of pressure applied to input
 @param pressedState    kSKUGamepadButtonStates representing the state of the button press.
 @param eventDictionary NSDictionary containing objects originating events
 */
-(void)gamepadButtonBChangedForPlayer:(GCControllerPlayerIndex)player withValue:(float)value pressedState:(kSKUGamepadButtonStates)pressedState andEventDictionary:(NSDictionary*)eventDictionary;
/*!
 Called when the X button input changes.
 @param player          GCControllerPlayerIndex value for player who caused change.
 @param value           float value of pressure applied to input
 @param pressedState    kSKUGamepadButtonStates representing the state of the button press.
 @param eventDictionary NSDictionary containing objects originating events
 */
-(void)gamepadButtonXChangedForPlayer:(GCControllerPlayerIndex)player withValue:(float)value pressedState:(kSKUGamepadButtonStates)pressedState andEventDictionary:(NSDictionary*)eventDictionary;
/*!
 Called when the Y button input changes.
 @param player          GCControllerPlayerIndex value for player who caused change.
 @param value           float value of pressure applied to input
 @param pressedState    kSKUGamepadButtonStates representing the state of the button press.
 @param eventDictionary NSDictionary containing objects originating events
 */
-(void)gamepadButtonYChangedForPlayer:(GCControllerPlayerIndex)player withValue:(float)value pressedState:(kSKUGamepadButtonStates)pressedState andEventDictionary:(NSDictionary*)eventDictionary;
/*!
 Called when the pause button is pressed. Note that there's no call for when the button is let go.
 @param player          GCControllerPlayerIndex value for player who caused change.
 @param eventDictionary NSDictionary containing objects originating events
 */
-(void)gamepadButtonPausePressedForPlayer:(GCControllerPlayerIndex)player andEventDictionary:(NSDictionary*)eventDictionary;

#pragma mark gamepad specific executes dpads
/*!
 Called when the left thumbstick input changes.
 @param player          GCControllerPlayerIndex value for player who caused change.
 @param vector          CGVector of direction the joystick is pointing.
 @param eventDictionary NSDictionary containing objects originating events
 */
-(void)gamepadLeftThumbstickChangedForPlayer:(GCControllerPlayerIndex)player withVector:(CGVector)vector andEventDictionary:(NSDictionary*)eventDictionary;
/*!
 Called when the right thumbstick input changes.
 @param player          GCControllerPlayerIndex value for player who caused change.
 @param vector          CGVector of direction the joystick is pointing.
 @param eventDictionary NSDictionary containing objects originating events
 */
-(void)gamepadRightThumbstickChangedForPlayer:(GCControllerPlayerIndex)player withVector:(CGVector)vector andEventDictionary:(NSDictionary*)eventDictionary;
/*!
 Called when the dpad input changes.
 @param player          GCControllerPlayerIndex value for player who caused change.
 @param vector          CGVector of direction the dpad is pointing.
 @param eventDictionary NSDictionary containing objects originating events
 */
-(void)gamepadDirectionalPadChangedForPlayer:(GCControllerPlayerIndex)player withVector:(CGVector)vector andEventDictionary:(NSDictionary*)eventDictionary;
#pragma mark update
/*! @methodgroup Update Note */

/*!
 This is simply in the header as a reminder that you need to call [super update] to allow controllers to work with nav functions. Also automatically calls [SKUSharedUtilities updateCurrentTime] so you don't have to.
 */
-(void)update:(CFTimeInterval)currentTime;


@end
#pragma mark SKUSpriteNode

/*!
 Subclass of SKSpriteNode unifying all initialization methods to call "didInitialize" when finished.
 */
@interface SKUSpriteNode : SKSpriteNode
/*! @methodgroup Inits */
/*!
 Called once initialization is finished: use to handle events that you want to complete before "didMoveToView".
 */
-(void)didInitialize;

@end


#pragma mark SKUViewController
/*!
 Subclass of platform dependent view controller, primarily intended for GCEventViewController on tvOS to be able to turn off the X button's default function on controllers for tvOS. Call this following line anywhere in your code to use the controller for system nav:
  <pre>
 @textblock
 [[NSNotificationCenter defaultCenter] postNotificationName:kSKURemoteInteractionOn object:nil];
 @/textblock
 </pre>
 or to turn it off:
 <pre>
 @textblock
 [[NSNotificationCenter defaultCenter] postNotificationName:kSKURemoteInteractionOff object:nil];
 @/textblock
 </pre>
 */
#if TARGET_OS_TV
@interface SKUViewController : GCEventViewController
#elif TARGET_OS_IOS
@interface SKUViewController : UIViewController
#elif TARGET_OS_OSX_SKU
@interface SKUViewController : NSViewController
#endif
/*! @methodgroup Inits */
/*!
 Called once initialization is finished: use to handle events that you want to complete before "viewDidLoad".
 */
-(void)didInitialize;

#if TARGET_OS_TV // headerdoc requires this stupidity
@end
#elif TARGET_OS_IOS
@end
#elif TARGET_OS_OSX_SKU
@end
#endif

#pragma mark CLASS CATEGORIES

#pragma mark SKView Modifications
/*!
 Category on SKView to allow for additional mouse buttons on OS X and some button support for AppleTV. Also adds controller support for all platforms.
 */
@interface SKView (SKUModifications)

/*!
 Called when gamepad motion input changes. Automatically passes onto scene if the scene is a subclass of SKUScene.
 @param player          GCControllerPlayerIndex determining which player caused the input.
 @param acceleration    SKUAcceleration struct to determine which direction the controller is facing.
 @param eventDictionary NSDictionary object with objects originating the events.
 */
-(void)gamepadMotionInputChangedForPlayer:(GCControllerPlayerIndex)player withAcceleration:(SKUAcceleration)acceleration andEventDictionary:(NSDictionary*)eventDictionary;
/*!
 Called when gamepad input changes. Automatically passes onto scene if the scene is a subclass of SKUScene.
 @param player          GCControllerPlayerIndex determining which player caused the input.
 @param input           kSKUGamePadInputs enumeration determining which input was pressed
 @param xValue          Used for both button and directional inputs. Directional inputs will show x direction vector of the input while button inputs will show the pressure it was pressed with.
 @param yValue          Used only for directional inputs. Shows the y direction vector of the input.
 @param pressedState    kSKUGamepadButtonStates representing the state of the button press.
 @param eventDictionary NSDictionary object with objects originating the events.
 */
-(void)gamepadInputChangedForPlayer:(GCControllerPlayerIndex)player withInput:(kSKUGamePadInputs)input andXValue:(float)xValue andYValue:(float)yValue pressedState:(kSKUGamepadButtonStates)pressedState andEventDictionary:(NSDictionary*)eventDictionary;

@end


#pragma mark SKNode Modifications
/*!
 Category on SKNode augmenting a LOT of functionality to scenes and nodes (Scenes are a subclass of SKNode). First and foremost is the ability to consolidate input between the different platforms. Instead of having a different -(void)touchesBegan for iOS and tvOS and -(void)mouseDown on OS X, you can instead use inputBeganSKU in both situation. It also allows for getting mouse movement (non clicking) on OS X, and a simple way to distinguish the separate movement types between iOS, tvOS, and Mac OS.
 */
@interface SKNode (SKUModifications)


/*! @methodgroup Navigational */

/*! Call this method to add a node to the list of navigation nodes paired with this node. */
-(void)addNodeToNavNodesSKU:(SKNode*)node;
/*! Call this method to remove a node from the list of navigation nodes paired with this node. */
-(void)removeNodeFromNavNodesSKU:(SKNode*)node;
/*! Call this method to get a boolean returned answering whether a specified node is part of the nav nodes set. */
-(BOOL)nodeIsMemberOfNavNodesSKU:(SKNode*)node;
/*!
 Returns an NSSet of the current collection of navNodes. Returns nil if it doesn't exist.
 */
-(NSSet*)navNodes;

/*! Call this method to set the currently focused node within the navNodes set. */
-(void)setCurrentFocusedNodeSKU:(SKNode*)node;
/*! Override this method to update visuals. It is called automatically when the focus changes. */
-(void)currentFocusedNodeUpdatedSKU:(SKNode *)node;

/*! @methodgroup Input */

/*! Override this method to perform logic with non SKUButton nodes when pressed on a controller or remote button.
 */
-(void)nodePressedDownSKU:(SKNode*)node;
/*! Override this method to perform logic with non SKUButton nodes when released on a controller or remote button.
 */
-(void)nodePressedUpSKU:(SKNode*)node;

/*! Called when relative type input begins (Currently only AppleTV's Siri Remote touches). Harmless to include on other platforms. */
-(void)relativeInputBeganSKU:(CGPoint)location withEventDictionary:(NSDictionary*)eventDict;
/*! Called when relative type input moves (Currently only AppleTV's Siri Remote touches). Harmless to include on other platforms. */
-(void)relativeInputMovedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary*)eventDict;
/*! Called when relative type input ends (Currently only AppleTV's Siri Remote touches). Harmless to include on other platforms. */
-(void)relativeInputEndedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary*)eventDict;
/*! Called when absolute type input begins (Currently iOS touches and Mac mouse clicks). Harmless to include on other platforms. */
-(void)absoluteInputBeganSKU:(CGPoint)location withEventDictionary:(NSDictionary*)eventDict;
/*! Called when absolute type input moves (Currently iOS touches and Mac mouse clicks). Harmless to include on other platforms. */
-(void)absoluteInputMovedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary*)eventDict;
/*! Called when absolute type input ends (Currently iOS touches and Mac mouse clicks). Harmless to include on other platforms. */
-(void)absoluteInputEndedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary*)eventDict;
/*! Called only on OSX when the mouse moves around the screen unclicked. Harmless to include on other platforms. */
-(void)mouseMovedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary*)eventDict;
/*! Called when any input location based input begins (Currently iOS touches, Mac mouse clicks, and AppleTV Siri Remote touches). */
-(void)inputBeganSKU:(CGPoint)location withEventDictionary:(NSDictionary*)eventDict;
/*! Called when any input location based input moves (Currently iOS touches, Mac mouse clicks, and AppleTV Siri Remote touches). */
-(void)inputMovedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary*)eventDict;
/*! Called when any input location based input ends (Currently iOS touches, Mac mouse clicks, and AppleTV Siri Remote touches). */
-(void)inputEndedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary*)eventDict;

@end

#pragma mark SKColor Modifications
/*!
 Simple interface for mixing colors.
 */
@interface SKColor (Mixing)
/*! @group SKColor Category Methods */

/*! Blends two colors together. May run into issues if using convenience methods (grayColor, whiteColor, etc). */
+(SKColor*)blendColorSKU:(SKColor*)color1 withColor:(SKColor*)color2 alpha:(CGFloat)alpha2;

@end

