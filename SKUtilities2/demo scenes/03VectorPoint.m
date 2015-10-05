//
//  03VectorPoint.m
//  SKUtilities2
//
//  Created by Michael Redig on 9/27/15.
//  Copyright © 2015 Michael Redig. All rights reserved.
//

#import "03VectorPoint.h"
#import "04BezierDemo.h"
#import "SKUtilities2.h"

@interface _3VectorPoint() {
	
	SKSpriteNode* spriteVectorInterval;
	SKSpriteNode* spriteVector;
	SKSpriteNode* spritePoint;
	
	SKSpriteNode* victim;
	SKLabelNode* victimLatLabel;
	NSMutableSet* setAroundVictim;
	CGFloat latValue;
	CGPoint previousLocation;
	
	SKUtilities2* sharedUtilities;
	
    SKSpriteNode* cursor;

}

@end

@implementation _3VectorPoint


-(void) didMoveToView:(SKView *)view {
	sharedUtilities = [SKUtilities2 sharedUtilities];
	
	NSLog(@"\n\n\n\n03VectorPoint: demos vector and point functions");
	
	
#pragma mark CGVector HELPERS
	
	CGPoint pointA = CGPointMake(150.5, 215.8);
	
	CGVector vectorA = vectorFromCGPoint(pointA);
	
	NSLog(@"vector from point: %f %f", vectorA.dx, vectorA.dy);
	
	CGSize sizeA = CGSizeMake(1024, 768);
	vectorA = vectorFromCGSize(sizeA);
	NSLog(@"vector from size: %f %f", vectorA.dx, vectorA.dy);

	
	CGVector inverse = vectorInverse(vectorA);
	
	NSLog(@"inversed: %f %f", inverse.dx, inverse.dy);
	
	CGVector normalized = vectorNormalize(inverse);
	CGPoint distanceTestPoint = CGPointMake(normalized.dx, normalized.dy);
	CGFloat distanceTest = distanceBetween(CGPointZero, distanceTestPoint);
	NSLog(@"normalized: %f %f - distance: %f", normalized.dx, normalized.dy, distanceTest);
	
	CGVector sum = vectorAdd(vectorA, inverse);
	NSLog(@"summed: %f %f", sum.dx, sum.dy);
	
	CGVector factor1, factor2;
	factor1 = CGVectorMake(5.0, 10.0);
	factor2 = CGVectorMake(2.0, 10.0);
	
	CGVector product = vectorMultiplyByVector(factor1, factor2);
	NSLog(@"multiplied by vector: %f %f", product.dx, product.dy);


	product = vectorMultiplyByFactor(product, 2.0);
	NSLog(@"multiplied by factor: %f %f", product.dx, product.dy);
	
	CGPoint destination, origin;
	destination = CGPointMake(100, -150);
	origin = CGPointZero;
	CGVector directionVect = vectorFacingPoint(destination, origin, NO);
	CGVector directionVectNorm = vectorFacingPoint(destination, origin, YES);
	NSLog(@"direction: %f %f normalized: %f %f", directionVect.dx, directionVect.dy, directionVectNorm.dx, directionVectNorm.dy);
	
	CGFloat radianValue = -45 * kSKUDegToRadConvFactor;
	CGFloat degreeValue = 0; //note that a value of 0 gives a vector of 0,1 - facing up
	
	CGVector radianVector, degreeVector;
	
	radianVector = vectorFromRadian(radianValue);
	degreeVector = vectorFromDegree(degreeValue);
	
	NSLog(@"radian vector: %f %f degree vector: %f %f", radianVector.dx, radianVector.dy, degreeVector.dx, degreeVector.dy);

	
#pragma mark CGPoint HELPERS

	CGPoint convPoint = pointFromCGVector(radianVector);
	NSLog(@"point from vector: %f %f", convPoint.x, convPoint.y);
	
	CGSize tempSize = CGSizeMake(10, 50);
	convPoint = pointFromCGSize(tempSize);
	NSLog(@"point from size: %f %f", convPoint.x, convPoint.y);
	
	convPoint = pointInverse(convPoint);
	NSLog(@"inverted point: %f %f", convPoint.x, convPoint.y);
	
	pointA = CGPointMake(5.0, 2.5);
	CGPoint pointB = CGPointMake(10.0, 5.0);
	CGPoint pointC = pointAdd(pointA, pointB);
	NSLog(@"point add: %f %f", pointC.x, pointC.y);

	pointC = pointAddValue(pointC, 5.0);
	NSLog(@"point add value: %f %f", pointC.x, pointC.y);

	pointC = pointInterpolationLinearBetweenTwoPoints(CGPointZero, pointC, 0.333);
	NSLog(@"0.33 linear point interpoltion: %f %f", pointC.x, pointC.y);
	
	NSLog(@"string from point: %@", getStringFromPoint(pointC));
	
	CGPoint stringPoint = getCGPointFromString(getStringFromPoint(pointC));
	NSLog(@"point from string: %f %f", stringPoint.x, stringPoint.y);
	
	
	[self setupSpriteDemos];
	[self setupButton];
}

-(void)setupSpriteDemos {
	
	
	//// movement demos
	spriteVectorInterval = [SKSpriteNode spriteNodeWithColor:[SKColor greenColor] size:CGSizeMake(200, 40)];
	spriteVectorInterval.position = CGPointMake(0, self.size.height * 0.85);
	[self addChild:spriteVectorInterval];
	
	SKLabelNode* spriteVectorIntervalLabel = [SKLabelNode labelNodeWithText:@"vector Interval"];
	spriteVectorIntervalLabel.fontColor = [SKColor blackColor];
	spriteVectorIntervalLabel.fontSize = 35;
	spriteVectorIntervalLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
	[spriteVectorInterval addChild:spriteVectorIntervalLabel];
	
	spriteVector = [SKSpriteNode spriteNodeWithColor:[SKColor greenColor] size:CGSizeMake(200, 40)];
	spriteVector.position = CGPointMake(0, self.size.height * 0.75);
	[self addChild:spriteVector];
	
	SKLabelNode* spriteVectorLabel = [SKLabelNode labelNodeWithText:@"vector"];
	spriteVectorLabel.fontColor = [SKColor blackColor];
	spriteVectorLabel.fontSize = 35;
	spriteVectorLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
	[spriteVector addChild:spriteVectorLabel];
	
	spritePoint = [SKSpriteNode spriteNodeWithColor:[SKColor greenColor] size:CGSizeMake(200, 40)];
	spritePoint.position = CGPointMake(0, self.size.height * 0.65);
	[self addChild:spritePoint];
	
	SKLabelNode* spritePointLabel = [SKLabelNode labelNodeWithText:@"point Interval"];
	spritePointLabel.fontColor = [SKColor blackColor];
	spritePointLabel.fontSize = 35;
	spritePointLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
	[spritePoint addChild:spritePointLabel];
	
	
	//// position behind demos
	victim = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5] size:CGSizeMake(100, 100)];
	victim.position = CGPointMake(self.size.width/2, self.size.height * 0.25);
	victim.zPosition = 10.0;
	[self addChild:victim];
	
	SKSpriteNode* directionIndicator = [SKSpriteNode spriteNodeWithColor:[SKColor blueColor] size:CGSizeMake(5.0, 60.0)];
	directionIndicator.anchorPoint = CGPointMake(0.5, 0.0);
	[victim addChild:directionIndicator];
	
	previousLocation = victim.position;
	
	latValue = 0.0;
	
	victimLatLabel = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"latitude: %.2f", latValue]];
	victimLatLabel.zPosition = 1.0;
	victimLatLabel.fontColor = [SKColor whiteColor];
	victimLatLabel.position = pointAdd(victim.position, CGPointMake(0, -135));
	[self addChild:victimLatLabel];
	
	SKLabelNode* explainLabel = [SKLabelNode labelNodeWithText:@"green indicates that it's behind in the example - drag mouse to change lat"];
	explainLabel.zPosition = 1.0;
	explainLabel.fontColor = [SKColor whiteColor];
	explainLabel.fontSize *= 0.7;
	explainLabel.position = pointAdd(victimLatLabel.position, CGPointMake(0, -40));
	[self addChild:explainLabel];

	
	setAroundVictim = [NSMutableSet set];
	
	NSInteger iterations = 10;
	CGFloat space = 20.0;
	CGFloat xStart = ((CGFloat)iterations / 2.0) * -space + space * 0.5;
	CGFloat yStart = ((CGFloat)iterations / 2.0) * space - space * 0.5;

	for (int y = 0; y < iterations; y++) {
		for (int x = 0; x < iterations; x++) {
			SKSpriteNode* part = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:CGSizeMake(10, 10)];
			part.position = CGPointMake(xStart + x * space, yStart - y * space);
			part.position = pointAdd(part.position, victim.position);
			[self addChild:part];
			[setAroundVictim addObject:part];
		}
	}
	
	[self updatePartColor];
    
#if TARGET_OS_TV
    
    [SKUtilities2 sharedUtilities].navMode = kSKUNavModeOff;
    cursor = [SKSpriteNode spriteNodeWithColor:[SKColor greenColor] size:CGSizeMake(20, 20)];
    cursor.position = pointMultiplyByPoint(CGPointMake(0.5, 0.25), pointFromCGSize(self.size));
    cursor.zPosition = 20;
    [self addChild:cursor];
#endif
	
}

-(void)checkPositions {
	
	if (spriteVectorInterval.position.x > self.size.width + 100) {
		spriteVectorInterval.position = CGPointMake(-100, spriteVectorInterval.position.y);
	}

	if (spriteVector.position.x > self.size.width + 100) {
		spriteVector.position = CGPointMake(-100, spriteVector.position.y);
	}
	
	if (spritePoint.position.x > self.size.width + 100) {
		spritePoint.position = CGPointMake(-100, spritePoint.position.y);
	}
}

-(void)moveNodes {
		
	spriteVectorInterval.position = pointStepVectorFromPointWithInterval(spriteVectorInterval.position, CGVectorMake(1.0, 0.0), sharedUtilities.deltaFrameTime, 5.0f/60.0f, 100.0f, 1.0f);
	
	spritePoint.position = pointStepTowardsPointWithInterval(spritePoint.position, CGPointMake(5000.0, spritePoint.position.y), sharedUtilities.deltaFrameTime, 5.0f/60.0f, 100.0f, 1.0f);
	
	spriteVector.position = pointStepVectorFromPoint(spriteVector.position, CGVectorMake(1.0, 0.0), 100.0f/60.0f);
	
	[self checkPositions];
	
	
	victim.zRotation += kSKUDegToRadConvFactor;
	[self updatePartColor];
}

-(void)setupButton {
	
	SKNode* tempButton = [SKNode node];
	tempButton.position = midPointOfRect(self.frame);
	tempButton.zPosition = 1.0;
	tempButton.name = @"tempButton";
	[self addChild:tempButton];
	
	SKSpriteNode* buttonBG = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:CGSizeMake(200, 50)];
	[tempButton addChild:buttonBG];
	
	SKLabelNode* buttonLabel = [SKLabelNode labelNodeWithText:@"Next Scene"];
	buttonLabel.fontColor = [SKColor blackColor];
	buttonLabel.fontSize = 28;
	buttonLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
	buttonLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
	buttonLabel.zPosition = 1.0;
	[tempButton addChild:buttonLabel];
	
	
}

-(void)inputMoved:(CGPoint)location withEventDictionary:(NSDictionary *)eventDict {
	
	CGFloat difference = 0.05;
	if (location.y > previousLocation.y) {
		latValue += difference;
	} else if (location.y < previousLocation.y) {
		latValue -= difference;
	}
	
	latValue = fmax(-1.0, latValue);
	latValue = fmin(1.0, latValue);
	previousLocation = location;
#if TARGET_OS_TV
    UITouch* touch = eventDict[@"touch"];
    CGPoint prevTouchLocation = [touch previousLocationInNode:self];
    cursor.position = pointAdd(pointAdd(pointInverse(prevTouchLocation), location), cursor.position);
#endif
}

-(void)inputEnded:(CGPoint)location withEventDictionary:(NSDictionary *)eventDict {

#if TARGET_OS_TV
	NSArray* nodes = [self nodesAtPoint:cursor.position];
#else
	NSArray* nodes = [self nodesAtPoint:location];
#endif
	for (SKNode* node in nodes) {
		if ([node.name isEqualToString:@"tempButton"]) {
			//next scene
			[self transferScene];
			break;
		}
	}
}

-(void)updatePartColor {
	
	victimLatLabel.text = [NSString stringWithFormat:@"latitude: %.2f", latValue];
	
	CGVector victimVector = vectorFromRadian(victim.zRotation);

	for (SKSpriteNode* part in setAroundVictim) {
		bool behind = pointIsBehindVictim(part.position, victim.position, victimVector, latValue);
		if (behind) {
			part.color = [SKColor greenColor];
		} else {
			part.color = [SKColor redColor];
		}
	}
}

-(void)transferScene {
	
	_4BezierDemo* scene = [[_4BezierDemo alloc] initWithSize:self.size];
	scene.scaleMode = self.scaleMode;
	
	SKView* view = (SKView*)self.view;
	[view presentScene:scene];
	
}


-(void)update:(NSTimeInterval)currentTime {
	[[SKUtilities2 sharedUtilities] updateCurrentTime:currentTime];
	
	[self moveNodes];
	
}

@end
