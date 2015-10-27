//
//  SKUtilities2.h
//  SKUtilities2
//
//  Created by Michael Redig on 9/26/15.
//  Copyright © 2015 Michael Redig. All rights reserved.
//


// run this as a script in a build phase to automatically increment build numbers

// #!/bin/bash
// bN=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$INFOPLIST_FILE")
// bN=$((bN += 1))
// bN=$(printf "%d" $bN)
// /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $bN" "$INFOPLIST_FILE"

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <SpriteKit/SpriteKit.h>

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
#define TARGET_OS_OSX_SKU 1
#endif

#define SKUSharedUtilities [SKUtilities2 sharedUtilities] 


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

/**
 Returns a CGFloat clipped within the range provided.
 @param value
 CGFloat value that is evaluated
 @param minimum
 CGFloat input of the low end range of what the output value could be
 @param maximum
 CGFloat input of the high end range of what the output value could be
 */
CGFloat clipFloatWithinRange (CGFloat value, CGFloat minimum, CGFloat maximum);

/**
 Returns an NSInteger clipped within the range provided.
 @param value
 NSInteger value that is evaluated
 @param minimum
 NSInteger input of the low end range of what the output value could be
 @param maximum
 NSInteger input of the high end range of what the output value could be
 */
NSInteger clipIntegerWithinRange (NSInteger value, NSInteger minimum, NSInteger maximum);


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

#pragma mark LOGGING

void SKULog(NSInteger verbosityLevel, NSString *format, ...);


#pragma mark SKUTILITES SINGLETON

#if TARGET_OS_TV

typedef enum {
	kSKUNavModeOn = 1,
	kSKUNavModeOff,
	kSKUNavModePressed,
} kSKUNavModes;

#endif

#if TARGET_OS_OSX_SKU

typedef enum {
	kSKUMouseButtonFlagLeft = 1 << 0,
	kSKUMouseButtonFlagRight = 1 << 1,
	kSKUMouseButtonFlagOther = 1 << 2,
} kSKUMouseButtonFlags;

#endif

@interface SKUtilities2 : NSObject
/**
 Current time passed in from scene update method, but must be set up properly. This allows you to get the currentTime into other objects or methods without directly calling them from the update method.
 */
@property (nonatomic, readonly) CFTimeInterval currentTime;
/**
 Amount of time passed since last frame. This value is capped by deltaMaxTime.
 */
@property (nonatomic, readonly) CFTimeInterval deltaFrameTime;
/**
 Amount of time passed since last frame. This value is NOT capped by deltaMaxTime.
Vulnerable to lag spikes if used.
 */
@property (nonatomic, readonly) CFTimeInterval deltaFrameTimeUncapped;
/**
 Defaults to 1.0f.
 */
@property (nonatomic) CGFloat deltaMaxTime;
/**
 Used to determine how many logs print to the console.
 */
@property (nonatomic) NSInteger verbosityLevel;
/**
 This mutable dictionary is similar in concept to the item of the same name on all SKNodes that Apple does, but on the singleton allows you to store objects for access game wide, not just on one node. It remains uninitialized until you initialize it.
 */
@property (nonatomic, strong) NSMutableDictionary* userData;
#if TARGET_OS_OSX_SKU
/**
 Flags to determine what sort of mouse button is passed onto nodes. By default, it only passes left mouse button events, but adding other kSKUMouseButtonFlags flags allows to respond to other mouse buttons.
 */
@property (nonatomic) kSKUMouseButtonFlags macButtonFlags;
#endif

#if TARGET_OS_TV


@property (nonatomic) kSKUNavModes navMode;
@property (nonatomic, readonly) SKNode* navFocus;
@property (nonatomic, strong) NSMutableSet* touchTracker;
@property (nonatomic) CGFloat navThresholdDistance;

-(SKNode*)handleSubNodeMovement:(CGPoint)location withCurrentSelection:(SKNode*)currentSelectedNode inSet:(NSSet*)navNodeSet inScene:(SKScene*)scene;
-(void)setNavFocus:(SKNode *)navFocus;
-(void)gestureTapDown;
-(void)gestureTapUp;
#endif


/**
 Singleton object. Currently only has timing info on it. May be expanded in future.
 */
+(SKUtilities2*) sharedUtilities;
/**
 Call this method in your scene's update method to share the time with other objects throughout the game.
 */
-(void)updateCurrentTime:(CFTimeInterval)timeUpdate;


@end

#pragma mark NEW CLASSES

#pragma mark SKU_PositionObject

/**
 For easy passing of struct data through mediums that only accept objects, like NSArrays or performSelectors that only accept passing of objects.
 */
@interface SKU_PositionObject : NSObject  <NSCopying>

@property (nonatomic) CGPoint position;
@property (nonatomic) CGSize size;
@property (nonatomic) CGRect rect;
@property (nonatomic) CGVector vector;


-(id)initWithPosition:(CGPoint)position;
-(id)initWithVector:(CGVector)vector;
-(id)initWithSize:(CGSize)size;
-(id)initWithRect:(CGRect)rect;
+(SKU_PositionObject*)position:(CGPoint)location;
+(SKU_PositionObject*)vector:(CGVector)vector;
+(SKU_PositionObject*)size:(CGSize)size;
+(SKU_PositionObject*)rect:(CGRect)rect;

-(CGSize)getSizeFromPosition;
-(CGPoint)getPositionFromSize;
-(CGVector)getVectorFromSize;

@end


#pragma mark SKU_ShapeNode

/**
 Apple's shape generator for SpriteKit causes performance issues. It appears that shapes are rerendered each frame, despite a lack of change in appearance. This method uses CAShapeLayer to render a shape, which is slightly more costly than the rendering of the SKShapeNode, but once it's rendered, is cached as a bitmap and renders very quickly in SpriteKit thereafter. TLDR: SpriteKit's shape node fast redner, slow draw. SKUShapeNode is slow render, fast draw.
 */
@interface SKU_ShapeNode : SKNode <NSCopying>

/**
 The CGPath to be drawn (in the Node's coordinate space) (will only redraw the image if the path is non-nil, so it's best to set the path as the last property and save some CPU cycles)
 */
@property (nonatomic) CGPathRef path;

/**
 The color to draw the path with. (for no stroke use [SKColor clearColor]). Defaults to [SKColor whiteColor].
 */
@property (nonatomic, retain) SKColor *strokeColor;

/**
 The color to fill the path with. Defaults to [SKColor clearColor] (no fill).
 */
@property (nonatomic, retain) SKColor *fillColor;

/**
 The width used to stroke the path. Widths larger than 2.0 may result in artifacts. Defaults to 1.0.
 */
@property (nonatomic) CGFloat lineWidth;


/** The fill rule used when filling the path. Options are `non-zero' and
 * `even-odd'. Defaults to `non-zero'. */
@property (nonatomic, assign) NSString* fillRule;

@property (nonatomic, assign) BOOL antiAlias;

@property (nonatomic, assign) NSString* lineCap;
/** Causing exceptions (at least on OSX) - keeping it in there cuz I BELIEVE the error is on Apple's side. Careful using this though. */
@property (nonatomic, assign) NSArray* lineDashPattern;
/** Causing exceptions (at least on OSX) - keeping it in there cuz I BELIEVE the error is on Apple's side. Careful using this though. */
@property (nonatomic, assign) CGFloat lineDashPhase;
@property (nonatomic, assign) NSString* lineJoin;
@property (nonatomic, assign) CGFloat miterLimit;
@property (nonatomic, assign) CGPoint anchorPoint;

+(SKU_ShapeNode*)circleWithRadius:(CGFloat)radius andColor:(SKColor*)color;
+(SKU_ShapeNode*)squareWithWidth:(CGFloat)width andColor:(SKColor*)color;
+(SKU_ShapeNode*)rectangleWithSize:(CGSize)size andColor:(SKColor*)color;
+(SKU_ShapeNode*)rectangleRoundedWithSize:(CGSize)size andCornerRadius:(CGFloat)radius andColor:(SKColor*)color;
+(SKU_ShapeNode*)shapeWithPath:(CGPathRef)path andColor:(SKColor*)color;


@end

#pragma mark SKU_MultiLineLabelNode

@interface SKU_MultiLineLabelNode : SKSpriteNode <NSCopying>

@property(retain, nonatomic) SKColor* fontColor;
@property(copy, nonatomic) NSString* fontName;
@property(nonatomic) CGFloat fontSize;
@property(nonatomic) SKLabelHorizontalAlignmentMode horizontalAlignmentMode;
@property(copy, nonatomic) NSString* text;
@property(nonatomic) SKLabelVerticalAlignmentMode verticalAlignmentMode;
@property(nonatomic, assign) CGFloat paragraphWidth;
@property(nonatomic, assign) CGFloat paragraphHeight; //should only be necessary to force a proper height for stroked text
@property(nonatomic, assign) CGFloat lineSpacing; //measures in points
@property(nonatomic, assign) CGFloat strokeWidth;
@property(retain, nonatomic) SKColor* strokeColor;

+ (instancetype)labelNodeWithFontNamed:(NSString *)fontName;
- (instancetype)initWithFontNamed:(NSString *)fontName;


@end

#pragma mark SKUButtonLabelProperties
/** Stores a single state for labels in buttons. The properties set on this object gets passed to the button's label for the appropriate state.
 @param text text value
 @param fontColor fontColor object
 @param fontSize fontSize value
 @param fontName fontName value
 @param position position value
 @param scale scale value
 */
@interface SKUButtonLabelProperties : NSObject <NSCopying>

@property (nonatomic) NSString* text;
@property (atomic, strong) SKColor* fontColor;
@property (nonatomic) CGFloat fontSize;
@property (nonatomic) NSString* fontName;
@property (nonatomic) CGPoint position;
@property (nonatomic) CGFloat scale;

+(SKUButtonLabelProperties*)propertiesWithText:(NSString *)text;
+(SKUButtonLabelProperties*)propertiesWithText:(NSString *)text andColor:(SKColor *)fontColor andSize :(CGFloat)fontSize andFontName:(NSString *)fontName;
+(SKUButtonLabelProperties*)propertiesWithText:(NSString *)text andColor:(SKColor *)fontColor andSize :(CGFloat)fontSize andFontName:(NSString *)fontName andPositionOffset:(CGPoint)position andScale:(CGFloat)scale;

@end
/** Stores all states for a label in buttons. The properties collected on this object get passed to the button's states.
 @param propertiesDefaultState propertiesDefaultState object
 @param propertiesPressedState propertiesPressedState object
 @param propertiesHoveredState propertiesHoveredState object
 @param propertiesDisabledState propertiesDisabledState object
 
 */
@interface SKUButtonLabelPropertiesPackage : NSObject <NSCopying>

#define skuHoverScale ((CGFloat) 1.3)

@property (nonatomic) SKUButtonLabelProperties* propertiesDefaultState;
@property (nonatomic) SKUButtonLabelProperties* propertiesPressedState;
@property (nonatomic) SKUButtonLabelProperties* propertiesHoveredState;
@property (nonatomic) SKUButtonLabelProperties* propertiesDisabledState;

/** Allows you to explicitly set all states. */
+(SKUButtonLabelPropertiesPackage*)packageWithPropertiesForDefaultState:(SKUButtonLabelProperties *)defaultState andPressedState:(SKUButtonLabelProperties *)pressedState andHoveredState:(SKUButtonLabelProperties *)hoveredState andDisabledState:(SKUButtonLabelProperties *)disabledState;
/** Allows you to explicitly set default and pressed states, derives the disabled state from default, but with a gray overlay, and derives the hovered state from the default at a skuHoverScale scale. */
+(SKUButtonLabelPropertiesPackage*)packageWithPropertiesForDefaultState:(SKUButtonLabelProperties*)defaultState andPressedState:(SKUButtonLabelProperties*)pressedState andDisabledState:(SKUButtonLabelProperties*)disabledState;
/** Allows you to explicitly set default and pressed states and derives the disabled state from default, but with a gray overlay, and derives the hovered state from the default at a skuHoverScale scale. */
+(SKUButtonLabelPropertiesPackage*)packageWithPropertiesForDefaultState:(SKUButtonLabelProperties *)defaultState andPressedState:(SKUButtonLabelProperties *)pressedState;
/** Allows you to explicitly set default state, derives the pressed state from the default by scaling it down to a relative 90% size, and derives the disabled state from default, but with a gray overlay, and derives the hovered state from the default at a skuHoverScale scale. */
+(SKUButtonLabelPropertiesPackage*)packageWithPropertiesForDefaultState:(SKUButtonLabelProperties *)defaultState;
/** Creates and returns a package based on SKU defaults. */
+(SKUButtonLabelPropertiesPackage*)packageWithDefaultPropertiesWithText:(NSString*)text;

/** Allows you to change the text for all states at once. */
-(void)changeText:(NSString*)text;

@end

#pragma mark SKUButtonSpriteStateProperties
/** Stores a single state for sprites in buttons. The properties set on this object gets passed to the button's sprite for the appropriate state. 
 @param alpha alpha value
 @param color color object
 @param colorBlendFactor colorBlendFactor value
 @param position position value
 @param centerRect centerRect value (if set, ignores the xScale and yScale values)
 @param xScale xScale value
 @param yScale yScale value
 @param texture texture object
 */
@interface SKUButtonSpriteStateProperties : NSObject <NSCopying>

@property (nonatomic) CGFloat alpha;
@property (nonatomic, strong) SKColor* color;
@property (nonatomic) CGFloat colorBlendFactor;
@property (nonatomic) CGPoint position;

@property (nonatomic) CGRect centerRect;
@property (nonatomic) CGFloat xScale;
@property (nonatomic) CGFloat yScale;
@property (nonatomic, strong) SKTexture* texture;

/** Returns a new object with the following properties. */
+(SKUButtonSpriteStateProperties*)propertiesWithTexture:(SKTexture*)texture andAlpha:(CGFloat)alpha andColor:(SKColor *)color andColorBlendFactor:(CGFloat)colorBlendFactor andPositionOffset:(CGPoint)position andXScale:(CGFloat)xScale andYScale:(CGFloat)yScale andCenterRect:(CGRect)centerRect;
/** Returns a new object with the following properties. */
+(SKUButtonSpriteStateProperties*)propertiesWithTexture:(SKTexture*)texture andAlpha:(CGFloat)alpha andColor:(SKColor*)color andColorBlendFactor:(CGFloat)colorBlendFactor andPositionOffset:(CGPoint)position andXScale:(CGFloat)xScale andYScale:(CGFloat)yScale;
/** Returns a new object with the following properties. */
+(SKUButtonSpriteStateProperties*)propertiesWithTexture:(SKTexture*)texture andAlpha:(CGFloat)alpha andColor:(SKColor*)color andColorBlendFactor:(CGFloat)colorBlendFactor andPositionOffset:(CGPoint)position;
/** Returns a new object with the following properties. */
+(SKUButtonSpriteStateProperties*)propertiesWithTexture:(SKTexture*)texture andAlpha:(CGFloat)alpha andColor:(SKColor*)color andColorBlendFactor:(CGFloat)colorBlendFactor;
/** Returns a new object with the following properties. */
+(SKUButtonSpriteStateProperties*)propertiesWithTexture:(SKTexture*)texture andAlpha:(CGFloat)alpha;
/** Returns a new object with the included default properties. */
+(SKUButtonSpriteStateProperties*)propertiesWithDefaultsSKU;
/** Returns a new object with the included default toggle on properties. */
+(SKUButtonSpriteStateProperties*)propertiesWithDefaultsToggleOnSKU;
/** Returns a new object with the included default toggle off properties. */
+(SKUButtonSpriteStateProperties*)propertiesWithDefaultsToggleOffSKU;
/** Sets the x and y scale together. */
-(void)setScale:(CGFloat)scale;

@end
/** Stores all states for a sprite in buttons. The properties collected on this object get passed to the button's states.
 @param propertiesDefaultState propertiesDefaultState object
 @param propertiesPressedState propertiesPressedState object
 @param propertiesHoveredState propertiesHoveredState object
 @param propertiesDisabledState propertiesDisabledState object

 */
@interface SKUButtonSpriteStatePropertiesPackage : NSObject <NSCopying>

@property (nonatomic) SKUButtonSpriteStateProperties* propertiesDefaultState;
@property (nonatomic) SKUButtonSpriteStateProperties* propertiesPressedState;
@property (nonatomic) SKUButtonSpriteStateProperties* propertiesHoveredState;
@property (nonatomic) SKUButtonSpriteStateProperties* propertiesDisabledState;
/** Allows you to explicitly set all states. */
+(SKUButtonSpriteStatePropertiesPackage*)packageWithPropertiesForDefaultState:(SKUButtonSpriteStateProperties*)defaultState andPressedState:(SKUButtonSpriteStateProperties*)pressedState andHoveredState:(SKUButtonSpriteStateProperties*)hoveredState andDisabledState:(SKUButtonSpriteStateProperties*)disabledState;
/** Allows you to explicitly set default and pressed states and derives the disabled state from default, but with half opacity, and the hovered state from the default with skuHoverScale scale. */
+(SKUButtonSpriteStatePropertiesPackage*)packageWithPropertiesForDefaultState:(SKUButtonSpriteStateProperties*)defaultState andPressedState:(SKUButtonSpriteStateProperties*)pressedState andDisabledState:(SKUButtonSpriteStateProperties*)disabledState;
/** Allows you to explicitly set default and pressed states and derives the disabled state from default, but with half opacity, and the hovered state from the default with skuHoverScale scale. */
+(SKUButtonSpriteStatePropertiesPackage*)packageWithPropertiesForDefaultState:(SKUButtonSpriteStateProperties *)defaultState andPressedState:(SKUButtonSpriteStateProperties *)pressedState;
/** Allows you to explicitly set default state and derives the pressed state from the default with 0.5 blend factor of a gray color overlay, and the disabled state from default, but with half opacity, and the hovered state from the default with skuHoverScale scale. */
+(SKUButtonSpriteStatePropertiesPackage*)packageWithPropertiesForDefaultState:(SKUButtonSpriteStateProperties *)defaultState;
/** Returns a package based on the included assets. */
+(SKUButtonSpriteStatePropertiesPackage*)packageWithDefaultPropertiesSKU;
/** Returns a package based on the included assets. */
+(SKUButtonSpriteStatePropertiesPackage*)packageWithDefaultToggleOnPropertiesSKU;
/** Returns a package based on the included assets. */
+(SKUButtonSpriteStatePropertiesPackage*)packageWithDefaultToggleOffPropertiesSKU;

/** Allows you to change the texture for all states at once. */
-(void)changeTexture:(SKTexture*)texture;

@end

#pragma mark SKUButton

typedef enum {
/** Sends out an NSNotification with a name determined by either the notificationNameDown or notificationNameUp property. Only sends button release notifications if the release remained within the button bounds. */
	kSKUButtonMethodPostNotification = 1,
/** Calls doButtonDown or doButtonUp on the delegate, set with the delegate property. This is the only way to detech button releases that aren't within the bounds of the button. */
	kSKUButtonMethodDelegate = 1 << 1,
/** Calls selectors set with methods setDownAction and setUpAction. Only sends button release calls if the release remained within the button bounds. */
	kSKUButtonMethodRunActions = 1 << 2,
} kSKUButtonMethods;

typedef enum {
	kSKUButtonTypePush = 1,
	kSKUButtonTypeToggle,
	kSKUButtonTypeSlider,
} kSKUButtonTypes;


typedef enum {
	kSKUButtonStateUndefined,
	kSKUButtonStateDefault,
	kSKUButtonStatePressed,
	kSKUButtonStatePressedOutOfBounds,
	kSKUButtonStateHovered,
	kSKUButtonStateDisabled,

} kSKUButtonStates;



@class SKUButton;

@protocol SKUButtonDelegate   //define delegate protocol
-(void)doButtonDown:(SKUButton*)button;
-(void)doButtonUp:(SKUButton*)button inBounds:(BOOL)inBounds;
@end //end protocol

/** SKUButton: Intended as a cross platform, unified way to design buttons for menus and input, instead of designing a completely different interface for Mac, iOS, and tvOS. Still needs a bit more effort when used on tvOS, but shouldn't be too hard. 
 
 Note: anchorPoint (and potentially other) SKSpriteNode properties have no effect - it is only subclassed as a sprite to help with Xcode's scene creation tool. (Note to self: fall back to SKNode if that idea doesn't pan out)
 
 Also Note: when using action or notification button methods, the release of a button will only trigger the button release methods when the release is in the bounds of the button. However, using the delegate method, you will see the delegate called in both situations as well as a boolean passed that will tell you if the release is in bounds or not.
 */
@interface SKUButton : SKSpriteNode


/** Identifies button type. */
@property (nonatomic, readonly) kSKUButtonTypes buttonType;
/** Used for enumeration of button ids */
@property (nonatomic) NSInteger whichButton;
/** Current state of the button */
@property (nonatomic, readonly) kSKUButtonStates buttonState;
/** Returns whether the button is currently being hovered. */
@property (nonatomic, readonly) BOOL isHovered;
/** Used for enumeration of button ids */
@property (nonatomic) uint8_t buttonMethod;
/** If button is set to call delegate, this is the delegate used. */
@property (nonatomic, weak) id <SKUButtonDelegate> delegate;
/** Readonly: tells you if button is enabled or not */
@property (nonatomic, readonly) BOOL isEnabled;
/** If button is set to send notifications, this is the name of the notification. */
@property (nonatomic) NSString* notificationNameDown;
/** If button is set to send notifications, this is the name of the notification. */
@property (nonatomic) NSString* notificationNameUp;
/** Readonly: access to the base sprite. */
@property (nonatomic, readonly) SKSpriteNode* baseSprite;
/** Used for padding around buttons when using centerRect to scale imagery. */
@property (nonatomic) CGFloat padding;
/** Properties to use on the base sprite in default state. */
@property (nonatomic) SKUButtonSpriteStateProperties* baseSpritePropertiesDefault;
/** Properties to use on the base sprite in pressed state. */
@property (nonatomic) SKUButtonSpriteStateProperties* baseSpritePropertiesPressed;
/** Properties to use on the base sprite in hovered state. */
@property (nonatomic) SKUButtonSpriteStateProperties* baseSpritePropertiesHovered;
/** Properties to use on the base sprite in disabled state. */
@property (nonatomic) SKUButtonSpriteStateProperties* baseSpritePropertiesDisabled;

/** Sets all states based off of the default state. 
 @warning
 baseSpritePropertiesDefault, baseSpritePropertiesPressed, baseSpritePropertiesHovered, and baseSpritePropertiesDisabled all point to the same pointer as a result. If you edit one, they will all change. If you don't want them all to update, do
 @code
 SKUButton* button; // assuming this is properly set up
 [button buttonStatesNormalize];
 button.baseSpritePropertiesPressed = button.baseSpritePropertiesPressed.copy;
 @endcode
 */
-(void)buttonStatesNormalize;
/** Sets all states based off of the default state using the settings determined in 
 [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:(SKUButtonSpriteStateProperties *)defaultState]
  */
-(void)buttonStatesDefault;

/** Creates and returns a button with a base sprite of the image named. */
+(SKUButton*)buttonWithImageNamed:(NSString*)name;
/** Creates and returns a button with a base sprite of the texture. */
+(SKUButton*)buttonWithTexture:(SKTexture*)texture;
/** Creates and returns a button with a base sprite package. */
+(SKUButton*)buttonWithPropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)package;

/** This SHOULD be called after either raw init or initWithCoder. Meant to be overridden with post initialization purposes. */
-(void)didInitialize;

/** If button is set to call actions, set method and target to call on method when pressed down. Sets flag on self.buttonMethods to run actions. */
-(void)setDownAction:(SEL)selector toPerformOnTarget:(NSObject*)target;
/** If button is set to call actions, set method and target to call on method when released. Sets flag on self.buttonMethods to run actions. */
-(void)setUpAction:(SEL)selector toPerformOnTarget:(NSObject*)target;

/** Sets all base sprite states in one command. */
-(void)setBaseStatesWithPackage:(SKUButtonSpriteStatePropertiesPackage*)package;
/** Calls the actions for button down press. Location is in local space. */
-(void)buttonPressed:(CGPoint)location;
/** Calls the actions for button release. Location is in local space. */
-(void)buttonReleased:(CGPoint)location;

/** Call to explicitly enable button (meant to reverse the state of being disabled). Be sure to call super method if you override. */
-(void)enableButton;
/** Call to explicitly disable button (meant to reverse the state of being enabled). Be sure to call super method if you override. Also, be sure the button is parented in the scene before using if you using kSKUButtonDisableTypeDim. */
-(void)disableButton;


@end

#pragma mark SKUPushButton

@interface SKUPushButton : SKUButton

/** Read only access to title label. */
@property (nonatomic, strong, readonly) SKLabelNode* titleLabel;
/** Set this to setup the title label. */
@property (nonatomic) SKUButtonLabelProperties* labelPropertiesDefault;
/** Set this to setup the title label properties when the button is pressed. */
@property (nonatomic) SKUButtonLabelProperties* labelPropertiesPressed;
/** Set this to setup the title label properties when the button is hovered. */
@property (nonatomic) SKUButtonLabelProperties* labelPropertiesHovered;
/** Set this to setup the title label properties when the button is disabled. */
@property (nonatomic) SKUButtonLabelProperties* labelPropertiesDisabled;



/** Read only access to title sprite. */
@property (nonatomic, strong, readonly) SKSpriteNode* titleSprite;
/** Properties to use on the title sprite in default state. */
@property (nonatomic) SKUButtonSpriteStateProperties* titleSpritePropertiesDefault;
/** Properties to use on the title sprite in pressed state. */
@property (nonatomic) SKUButtonSpriteStateProperties* titleSpritePropertiesPressed;
/** Properties to use on the title sprite in hovered state. */
@property (nonatomic) SKUButtonSpriteStateProperties* titleSpritePropertiesHovered;
/** Properties to use on the title sprite in disabled state. */
@property (nonatomic) SKUButtonSpriteStateProperties* titleSpritePropertiesDisabled;
#pragma mark SKUPushButton inits

+(SKUPushButton*)pushButtonWithText:(NSString*)text;
+(SKUPushButton*)pushButtonWithBackgroundTexture:(SKTexture*)texture;
+(SKUPushButton*)pushButtonWithImageNamed:(NSString*)name;
+(SKUPushButton*)pushButtonWithBackgroundTexture:(SKTexture*)backgroundTexture andTitleTexture:(SKTexture*)titleTexture;
+(SKUPushButton*)pushButtonWithBackgroundTexture:(SKTexture*)texture andTitleLabelText:(NSString*)text;
+(SKUPushButton*)pushButtonWithBackgroundTexture:(SKTexture*)texture andTitleLabelText:(NSString*)text andTitleLabelColor:(SKColor*)fontColor andTitleLabelSize:(CGFloat)fontSize andTitleLabelFont:(NSString*)fontName;
+(SKUPushButton*)pushButtonWithBackgroundPropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)backgroundPackage andForeGroundSpritePropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)foregroundPackage;
+(SKUPushButton*)pushButtonWithBackgroundPropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)backgroundPackage andTitleLabelPropertiesPackage:(SKUButtonLabelPropertiesPackage*)foregroundPackage;
+(SKUPushButton*)pushButtonWithBackgroundPropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)backgroundPackage andForeGroundSpritePropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)foregroundPackage andTitleLabelPropertiesPackage:(SKUButtonLabelPropertiesPackage*)titlePackage;

-(void)setTitleSpriteStatesWithPackage:(SKUButtonSpriteStatePropertiesPackage*)package;
-(void)setTitleLabelStatesWithPackage:(SKUButtonLabelPropertiesPackage*)package;
@end

#pragma mark SKUToggleButton

@interface SKUToggleButton : SKUPushButton
/** Read only access to toggle sprite. */
@property (nonatomic, strong, readonly) SKSpriteNode* toggleSprite;
/** Properties to use on the toggle sprite in default on state. */
@property (nonatomic) SKUButtonSpriteStateProperties* toggleSpritePropertiesOnDefault;
/** Properties to use on the toggle sprite in pressed on state. */
@property (nonatomic) SKUButtonSpriteStateProperties* toggleSpritePropertiesOnPressed;
/** Properties to use on the toggle sprite in hovered on state. */
@property (nonatomic) SKUButtonSpriteStateProperties* toggleSpritePropertiesOnHovered;
/** Properties to use on the toggle sprite in disabled on state. */
@property (nonatomic) SKUButtonSpriteStateProperties* toggleSpritePropertiesOnDisabled;

/** Properties to use on the toggle sprite in default off state. */
@property (nonatomic) SKUButtonSpriteStateProperties* toggleSpritePropertiesOffDefault;
/** Properties to use on the toggle sprite in pressed off state. */
@property (nonatomic) SKUButtonSpriteStateProperties* toggleSpritePropertiesOffPressed;
/** Properties to use on the toggle sprite in hovered off state. */
@property (nonatomic) SKUButtonSpriteStateProperties* toggleSpritePropertiesOffHovered;
/** Properties to use on the toggle sprite in disabled off state. */
@property (nonatomic) SKUButtonSpriteStateProperties* toggleSpritePropertiesOffDisabled;

/** Boolean determining whether the button is in an on state or not. */
@property (nonatomic) BOOL on;


+(SKUToggleButton*)toggleButtonWithBackgroundPropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)backgroundPackage andForeGroundSpritePropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)foregroundPackage;

+(SKUToggleButton*)toggleButtonWithBackgroundPropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)backgroundPackage andTitleLabelPropertiesPackage:(SKUButtonLabelPropertiesPackage*)foregroundPackage;

+(SKUToggleButton*)toggleButtonWithBackgroundPropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)backgroundPackage andForeGroundSpritePropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)foregroundPackage andToggleOnPackage:(SKUButtonSpriteStatePropertiesPackage*)toggleSpriteOnPropertiesPackage andToggleOffPackage:(SKUButtonSpriteStatePropertiesPackage*)toggleSpriteOffPropertiesPackage;

+(SKUToggleButton*)toggleButtonWithBackgroundPropertiesPackage:(SKUButtonSpriteStatePropertiesPackage*)backgroundPackage andTitleLabelPropertiesPackage:(SKUButtonLabelPropertiesPackage*)foregroundPackage andToggleOnPackage:(SKUButtonSpriteStatePropertiesPackage*)toggleSpriteOnPropertiesPackage andToggleOffPackage:(SKUButtonSpriteStatePropertiesPackage*)toggleSpriteOffPropertiesPackage;


/** Toggles button on/off state. */
-(void)toggleOnOff;
-(void)setToggleSpriteOnStatesWithPackage:(SKUButtonSpriteStatePropertiesPackage*)package;
-(void)setToggleSpriteOffStatesWithPackage:(SKUButtonSpriteStatePropertiesPackage*)package;


@end

#pragma mark CLASS CATEGORIES

#pragma mark SKView Modifications

@interface SKView (AdditionalMouseSupport)

@end


#pragma mark SKNode Modifications

@interface SKNode (ConsolidatedInput)

#if TARGET_OS_TV

/** Call this method to set the currently highlighted node within the navNodes set. */
-(void)setCurrentSelectedNodeSKU:(SKNode*)node;
/** Call this method to add a node to the list of navigation nodes paired with this node. */
-(void)addNodeToNavNodesSKU:(SKNode*)node;
/** Call this method to remove a node from the list of navigation nodes paired with this node. */
-(void)removeNodeFromNavNodesSKU:(SKNode*)node;
/** Override this method to update visuals. */
-(void)currentSelectedNodeUpdatedSKU:(SKNode *)node;
/** Override this method to perform logic with non SKUButton nodes when pressed. */
-(void)nodePressedDownSKU:(SKNode*)node;
/** Override this method to perform logic with non SKUButton nodes when released. */
-(void)nodePressedUpSKU:(SKNode*)node;
#endif

/** Called when relative type input begins (Currently only AppleTV's Siri Remote touches) Remember to call [super relativeInputBeganSKU] when overrding. Harmless to include on other platforms. */
-(void)relativeInputBeganSKU:(CGPoint)location withEventDictionary:(NSDictionary*)eventDict;
/** Called when relative type input moves (Currently only AppleTV's Siri Remote touches). Remember to call [super relativeInputMovedSKU] when overrding. Harmless to include on other platforms. */
-(void)relativeInputMovedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary*)eventDict;
/** Called when relative type input ends (Currently only AppleTV's Siri Remote touches). Remember to call [super relativeInputEndedSKU] when overrding. Harmless to include on other platforms. */
-(void)relativeInputEndedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary*)eventDict;
/** Called when absolute type input begins (Currently iOS touches and Mac mouse clicks). Remember to call [super absoluteInputBeganSKU] when overrding. Harmless to include on other platforms. */
-(void)absoluteInputBeganSKU:(CGPoint)location withEventDictionary:(NSDictionary*)eventDict;
/** Called when absolute type input moves (Currently iOS touches and Mac mouse clicks). Remember to call [super absoluteInputMovedSKU] when overrding. Harmless to include on other platforms. */
-(void)absoluteInputMovedSKU:(CGPoint)location withEventDictionary:(NSDictionary*)eventDict;
/** Called when absolute type input ends (Currently iOS touches and Mac mouse clicks). Remember to call [super absoluteInputEndedSKU] when overrding. Harmless to include on other platforms. */
-(void)absoluteInputEndedSKU:(CGPoint)location withEventDictionary:(NSDictionary*)eventDict;
/** Called only on OSX when the mouse moves around the screen unclicked. Harmless to include on other platforms. */
-(void)mouseMovedSKU:(CGPoint)location withEventDictionary:(NSDictionary*)eventDict;
/** Called when any input location based input begins (Currently iOS touches, Mac mouse clicks, and AppleTV Siri Remote touches). */
-(void)inputBeganSKU:(CGPoint)location withEventDictionary:(NSDictionary*)eventDict;
/** Called when any input location based input moves (Currently iOS touches, Mac mouse clicks, and AppleTV Siri Remote touches). */
-(void)inputMovedSKU:(CGPoint)location withEventDictionary:(NSDictionary*)eventDict;
/** Called when any input location based input ends (Currently iOS touches, Mac mouse clicks, and AppleTV Siri Remote touches). */
-(void)inputEndedSKU:(CGPoint)location withEventDictionary:(NSDictionary*)eventDict;

@end

#pragma mark SKColor Modifications

@interface SKColor (Mixing)
/** Blends two colors together. May run into issues if using convenience methods (grayColor, whiteColor, etc). */
+(SKColor*)blendColorSKU:(SKColor*)color1 withColor:(SKColor*)color2 alpha:(CGFloat)alpha2;

@end

