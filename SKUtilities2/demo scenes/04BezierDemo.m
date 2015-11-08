//
//  04BezierDemo.m
//  SKUtilities2
//
//  Created by Michael Redig on 9/28/15.
//  Copyright © 2015 Michael Redig. All rights reserved.
//

#import "04BezierDemo.h"
#import "SKUtilities2.h"
#import "05ShapeDemo.h"
#import "03VectorPoint.h"

@interface _4BezierDemo() {
	
	NSMutableArray* bezParts;
	
	SKSpriteNode* handle1, *handle2;
	
	SKNode* prevSelectedNode;
	
	
	SKLabelNode* xAndTvalueLabel;
	
	SKNode* lockedNode;

}

@end

@implementation _4BezierDemo

-(void) didMoveToView:(SKView *)view {
	
	SKULog(0,@"\n\n\n\n04Bezier demo: demos bezier stuff");
	self.name = @"bezier demo scene";
	self.backgroundColor = [SKColor grayColor];

#pragma mark BEZIER CALCUATIONS
	[self setupSpriteDemos];
	[self setupButton];
}

-(void)setupSpriteDemos {
	
	NSUInteger resolution = 100;
	bezParts = [NSMutableArray array];
	
	handle1 = [SKSpriteNode spriteNodeWithColor:[SKColor greenColor] size:CGSizeMake(20, 20)];
	handle1.position = pointMultiplyByFactor(pointFromCGSize(self.size), 0.1);
	handle1.zPosition = 10;
	handle1.name = @"handle1";
	[self addChild:handle1];
	
	handle2 = [SKSpriteNode spriteNodeWithColor:[SKColor greenColor] size:CGSizeMake(20, 20)];
	handle2.position = pointMultiplyByFactor(pointFromCGSize(self.size), 0.9);
	handle2.zPosition = 10;
	handle2.name = @"handle2";
	[self addChild:handle2];
	
	
	
	CGFloat sizeW = self.size.width / resolution;
	for (NSInteger i = 0; i < resolution; i++) {
		SKSpriteNode* part = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(sizeW, sizeW)];
		part.name = @"bezierPoint";
		[self addChild:part];
		[bezParts addObject:part];
	}

	[self updateBezierCurve];
	
	xAndTvalueLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
	xAndTvalueLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
	xAndTvalueLabel.position = CGPointMake(self.size.width/2, self.size.height * 0.2);
	xAndTvalueLabel.text = [NSString stringWithFormat:@"xVal: %f tVal:%f", self.size.width/2, bezierTValueAtXValue(self.size.width/2, 0.0, handle1.position.x, handle2.position.x, self.size.height)];
	xAndTvalueLabel.fontColor = [SKColor whiteColor];
	xAndTvalueLabel.name = @"xAndTvalueLabel";
	[self addChild:xAndTvalueLabel];
	
#if TARGET_OS_TV
	
	[self addNodeToNavNodesSKU:handle1];
	[self addNodeToNavNodesSKU:handle2];
	
	SKUSharedUtilities.navMode = kSKUNavModeOn;
	[SKUSharedUtilities setNavFocus:self];

	[self setCurrentSelectedNodeSKU:handle1];
#endif
}

#if TARGET_OS_TV
-(void)gestureTap:(UIGestureRecognizer*)gesture {
	if ([lockedNode.name containsString:@"handle"]) {
		SKSpriteNode* sprite = (SKSpriteNode*)lockedNode;
		sprite.color = [SKColor greenColor];
	}
	lockedNode = nil;
	SKUSharedUtilities.navMode = kSKUNavModeOn;
	[self.view removeGestureRecognizer:gesture];
}

-(void)nodePressedUpSKU:(SKNode *)node {
	if (!lockedNode) {
		lockedNode = node;
		if ([lockedNode.name containsString:@"handle"]) {
			SKSpriteNode* sprite = (SKSpriteNode*)lockedNode;
			sprite.color = [SKColor blueColor];
		}
		SKUSharedUtilities.navMode = kSKUNavModeOff;
		SKView* scnView = (SKView*)self.view;
		
		UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTap:)];
		tapGesture.allowedPressTypes = @[[NSNumber numberWithInteger:UIPressTypeSelect]];
		[scnView addGestureRecognizer:tapGesture]; //// have to add a gesture since nav mode is off in this case. we won't get navigation signals, including presses and press releases until nav mode is back on
	}
}
#endif


-(void)updateBezierCurve {
	for (NSInteger i = 0; i < bezParts.count; i++) {
		SKSpriteNode* part = bezParts[i];
		part.position = bezierPoint((CGFloat)i/bezParts.count, CGPointZero, handle1.position, handle2.position, pointFromCGSize(self.size));
	}
}


-(void)setupButton {

	SKUButtonLabelPropertiesPackage* labelPack = SKUSharedUtilities.userData[@"buttonLabelPackage"];
	SKUButtonSpriteStatePropertiesPackage* backgroundPack = SKUSharedUtilities.userData[@"buttonBackgroundPackage"];
	SKUPushButton* nextSlide = [SKUPushButton pushButtonWithBackgroundPropertiesPackage:backgroundPack andTitleLabelPropertiesPackage:labelPack];
	nextSlide.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(0.66, 0.5));
	nextSlide.zPosition = 1.0;
	[nextSlide setUpAction:@selector(transferScene:) toPerformOnTarget:self];
	nextSlide.name = @"nextSlide";
	[self addChild:nextSlide];
	
	SKUPushButton* prevSlide = [SKUPushButton pushButtonWithTitle:@"Previous Scene"];
	prevSlide.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(0.33, 0.5));
	prevSlide.zPosition = 1.0;
	[prevSlide setUpAction:@selector(prevScene:) toPerformOnTarget:self];
	prevSlide.name = @"prevSlide";
	[self addChild:prevSlide];
	
	
#if TARGET_OS_TV
	
	SKUSharedUtilities.navMode = kSKUNavModeOn;
	[self addNodeToNavNodesSKU:nextSlide];
	[self addNodeToNavNodesSKU:prevSlide];
	[self setCurrentSelectedNodeSKU:nextSlide];
	
	[SKUSharedUtilities setNavFocus:self];
	
#endif
}

-(void)currentSelectedNodeUpdatedSKU:(SKNode *)node {
	if ([node.name containsString:@"handle"]) {
		[node setScale:3.0f];
	}
	[prevSelectedNode setScale:1.0f];
	prevSelectedNode = node;
}

-(void)absoluteInputBeganSKU:(CGPoint)location withEventDictionary:(NSDictionary *)eventDict {
	NSArray* nodes = [self nodesAtPoint:location];
	for (SKNode* node in nodes) {
		if ([node isEqual:handle1]){
			lockedNode = handle1;
			break;
		} else if ([node isEqual:handle2]){
			lockedNode = handle2;
			break;
		}
	}
}

-(void)absoluteInputMovedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary *)eventDict {
	if (lockedNode) {
		lockedNode.position = location;
	}
}

-(void)absoluteInputEndedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary *)eventDict {
	lockedNode = nil;
}

-(void)relativeInputMovedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary *)eventDict {
	if (lockedNode) {
		lockedNode.position = pointAdd(delta, lockedNode.position);
	}
}

-(void)inputMovedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary *)eventDict {
	[self updateBezierCurve];

	xAndTvalueLabel.text = [NSString stringWithFormat:@"xVal: %f tVal:%f", location.x, bezierTValueAtXValue(location.x, 0.0, handle1.position.x, handle2.position.x, self.size.width)];
}


-(void)prevScene:(SKUButton*)button {
	
	_3VectorPoint* scene = [[_3VectorPoint alloc] initWithSize:self.size];
	scene.scaleMode = self.scaleMode;
	
	SKView* view = (SKView*)self.view;
	[view presentScene:scene];
	
}

-(void)transferScene:(SKUButton*)button {
	
	_5ShapeDemo* scene = [[_5ShapeDemo alloc] initWithSize:self.size];
	scene.scaleMode = self.scaleMode;
	
	SKView* view = (SKView*)self.view;
	[view presentScene:scene];
	
}


-(void)update:(NSTimeInterval)currentTime {
}


@end
