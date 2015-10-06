//
//  SKUtilities2.h
//  SKUtilities2
//
//  Created by Michael Redig on 9/26/15.
//  Copyright © 2015 Michael Redig. All rights reserved.
//

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


#pragma mark SKUTILITES SINGLETON

#if TARGET_OS_TV

typedef enum {
	kSKUNavModeOn = 1,
	kSKUNavModeOff,
} kSKUNavModes;

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
 Amount of time passed since last frame. This value is capped by deltaMaxTime.
Vulnerable to lag spikes if used.
 */
@property (nonatomic, readonly) CFTimeInterval deltaFrameTimeUncapped;
/**
 Defaults to 1.0f.
 */
@property (nonatomic) CGFloat deltaMaxTime;

#if TARGET_OS_TV


@property (nonatomic) kSKUNavModes navMode;
@property (nonatomic, readonly) SKNode* navFocus;
@property (nonatomic, strong) NSMutableSet* touchTracker;
@property (nonatomic) CGFloat navThresholdDistance;

-(SKNode*)handleSubNodeMovement:(CGPoint)location withCurrentSelection:(SKNode*)currentSelectedNode inSet:(NSSet*)navNodeSet inScene:(SKScene*)scene;
-(void)setNavFocus:(SKNode *)navFocus;

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
@interface SKU_PositionObject : NSObject

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
 Apple's first shape generator for SpriteKit (OS 10.9) caused performance issues. It might have been addressed in later versions of SpriteKit, but it appeared that the shapes were rerendered each frame, despite a lack of change in appearance. This method uses CAShapeLayer to render a shape, which is slightly more costly than the rendering of the SKShapeNode, but once it's rendered, is cached as a bitmap and renders very quickly in SpriteKit thereafter.
 */
@interface SKU_ShapeNode : SKNode

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


/* The fill rule used when filling the path. Options are `non-zero' and
 * `even-odd'. Defaults to `non-zero'. */
@property (nonatomic, assign) NSString* fillRule;


@property (nonatomic, assign) NSString* lineCap;
@property (nonatomic, assign) NSArray* lineDashPattern;
@property (nonatomic, assign) CGFloat lineDashPhase;
@property (nonatomic, assign) NSString* lineJoin;
@property (nonatomic, assign) CGFloat miterLimit;
@property (nonatomic, assign) CGFloat strokeEnd;
@property (nonatomic, assign) CGFloat strokeStart;
@property (nonatomic, assign) CGPoint anchorPoint;

+(SKU_ShapeNode*)circleWithRadius:(CGFloat)radius andColor:(SKColor*)color;
+(SKU_ShapeNode*)squareWithWidth:(CGFloat)width andColor:(SKColor*)color;
+(SKU_ShapeNode*)rectangleWithSize:(CGSize)size andColor:(SKColor*)color;
+(SKU_ShapeNode*)rectangleRoundedWithSize:(CGSize)size andCornerRadius:(CGFloat)radius andColor:(SKColor*)color;
+(SKU_ShapeNode*)shapeWithPath:(CGPathRef)path andColor:(SKColor*)color;


@end

#pragma mark SKU_MultiLineLabelNode

@interface SKU_MultiLineLabelNode : SKSpriteNode

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

#pragma mark SKButton

typedef enum { //// might not use this
	kSKButtonMethodPostNotification = 1,
	kSKButtonMethodDelegate = 1 << 1,
	kSKButtonMethodRunActions = 1 << 2,
} kSKButtonMethods;

typedef enum {
	kSKButtonTypeToggle,
	kSKButtonTypePush,
	kSKButtonTypeSlider,
} kSKButtonTypes;

typedef enum {
	kSKButtonDisableTypeDim,
	kSKButtonDisableTypeOpacityHalf,
	kSKButtonDisableTypeOpacityNone,
	kSKButtonDisableTypeAlternateTexture,
	kSKButtonDisableTypeNoDifference,
} kSKButtonDisableTypes;

@class SKButton;

@protocol SKButtonDelegate   //define delegate protocol
-(void)doButtonDown:(SKButton*)button;
-(void)doButtonUp:(SKButton*)button inBounds:(BOOL)inBounds;
@end //end protocol

@interface SKButton : SKNode



/* Used for enumeration of button ids */
@property (nonatomic) NSInteger whichButton;
/* Used for enumeration of button ids */
@property (nonatomic) uint32_t buttonMethod;
/* If button is set to call delegate, this is the delegate used. */
@property (nonatomic, weak) id <SKButtonDelegate> delegate;
/* Readonly: tells you if button is enabled or not */
@property (nonatomic, readonly) BOOL isEnabled;
/* Determines how disabling button is displayed. */
@property (nonatomic, readonly) kSKButtonDisableTypes disableType;
/* If button is set to send notifications, this is the name of the notification. */
@property (nonatomic) NSString* notificationNameDown;
/* If button is set to send notifications, this is the name of the notification. */
@property (nonatomic) NSString* notificationNameUp;
/* Use this to set the base sprite texture. */
@property (nonatomic) SKTexture* baseTexture;
/* Use this to set the base sprite texture for its pressed state. */
@property (nonatomic) SKTexture* baseTexturePressed;
/* Use this to set the base sprite texture for its disabled state. */
@property (nonatomic) SKTexture* baseTextureDisabled;
/* Readonly: access to the base sprite. */
@property (nonatomic, readonly) SKSpriteNode* baseSprite;
/* Readonly: access to the base sprite pressed state. */
@property (nonatomic, readonly) SKSpriteNode* baseSpritePressed;
/* Readonly: access to the base sprite disabled state. */
@property (nonatomic, readonly) SKSpriteNode* baseSpriteDisabled;

+(SKButton*)buttonWithTextureNamed:(NSString*)name;
/* This SHOULD be called after either raw init or initWithCoder. Meant to be overridden with post initialization purposes. */
-(void)didInitialize;

/* If button is set to call actions, set method and target to call on method when pressed down. Sets flag on self.buttonMethods to run actions. */
-(void)setDownAction:(SEL)selector toPerformOnTarget:(NSObject*)target;
/* If button is set to call actions, set method and target to call on method when released. Sets flag on self.buttonMethods to run actions. */
-(void)setUpAction:(SEL)selector toPerformOnTarget:(NSObject*)target;

/* Call to explicitly enable button (meant to reverse the state of being disabled). Be sure to call super method if you override. */
-(void)enableButton;
/* Call to explicitly disable button (meant to reverse the state of being enabled). Be sure to call super method if you override. */
-(void)disableButton;


@end

#pragma mark CLASS CATEGORIES
#pragma mark SKNode Modifications

@interface SKNode (ConsolidatedInput)

#if TARGET_OS_TV

-(void)setCurrentSelectedNode:(SKNode*)node;
-(void)addNodeToNavNodes:(SKNode*)node;
-(void)currentSelectedNodeUpdated:(SKNode *)node; //override this method to update visuals

#endif

-(void)inputBegan:(CGPoint)location withEventDictionary:(NSDictionary*)eventDict ;
-(void)inputMoved:(CGPoint)location withEventDictionary:(NSDictionary*)eventDict ;
-(void)inputEnded:(CGPoint)location withEventDictionary:(NSDictionary*)eventDict ;

@end

#pragma mark SKColor Modifications

@interface SKColor (Mixing)

+(SKColor*)blendColor:(SKColor*)color1 withColor:(SKColor*)color2 alpha:(CGFloat)alpha2;

@end

