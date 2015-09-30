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

@interface _4BezierDemo() {
	
	NSMutableArray* bezParts;
	
	SKSpriteNode* handle1, *handle2;
	
	SKNode* selectedNode;
	
	
	SKLabelNode* xAndTvalueLabel;
}

@end

@implementation _4BezierDemo

-(void) didMoveToView:(SKView *)view {
	
	NSLog(@"\n\n\n\n04Bezier demo: demos bezier stuff");
	
	
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
		[self addChild:part];
		[bezParts addObject:part];
	}

	[self updateBezierCurve];
	
	xAndTvalueLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
	xAndTvalueLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
	xAndTvalueLabel.position = CGPointMake(self.size.width/2, self.size.height * 0.2);
	xAndTvalueLabel.text = [NSString stringWithFormat:@"xVal: %f tVal:%f", self.size.width/2, bezierTValueAtXValue(self.size.width/2, 0.0, handle1.position.x, handle2.position.x, self.size.height)];
	xAndTvalueLabel.fontColor = [SKColor whiteColor];
	[self addChild:xAndTvalueLabel];
}


-(void)updateBezierCurve {
	
	for (NSInteger i = 0; i < bezParts.count; i++) {
		SKSpriteNode* part = bezParts[i];
		part.position = bezierPoint((CGFloat)i/bezParts.count, CGPointZero, handle1.position, handle2.position, pointFromCGSize(self.size));
	}
	
	
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

-(void)inputBegan:(CGPoint)location withEventDictionary:(NSDictionary *)eventDict {
	NSArray* nodes = [self nodesAtPoint:location];
	for (SKNode* node in nodes) {
		if ([node.name isEqualToString:@"tempButton"]) {
			selectedNode = [self childNodeWithName:@"tempButton"];
			break;
		} else if ([node isEqual:handle1]){
			selectedNode = handle1;
			break;
		} else if ([node isEqual:handle2]){
			selectedNode = handle2;
			break;
		}
	}
}

-(void)inputMoved:(CGPoint)location withEventDictionary:(NSDictionary *)eventDict {
	if (![selectedNode.name isEqualToString:@"tempButton"]) {
		selectedNode.position = location;
		[self updateBezierCurve];
	}
	
	xAndTvalueLabel.text = [NSString stringWithFormat:@"xVal: %f tVal:%f", location.x, bezierTValueAtXValue(location.x, 0.0, handle1.position.x, handle2.position.x, self.size.width)];
}

-(void)inputEnded:(CGPoint)location withEventDictionary:(NSDictionary *)eventDict {
	NSArray* nodes = [self nodesAtPoint:location];
	for (SKNode* node in nodes) {
		if ([node.name isEqualToString:@"tempButton"] && [selectedNode.name isEqualToString:@"tempButton"]) {
			//next scene
			[self transferScene];
			break;
		}
	}
	selectedNode = nil;
}



-(void)transferScene {
	
	_5ShapeDemo* scene = [[_5ShapeDemo alloc] initWithSize:self.size];
	scene.scaleMode = self.scaleMode;
	
	SKView* view = (SKView*)self.view;
	[view presentScene:scene];
	
}


-(void)update:(NSTimeInterval)currentTime {
}


@end
