//
//  shapeBenchmark.m
//  SKUtilities2
//
//  Created by Michael Redig on 10/10/15.
//  Copyright © 2015 Michael Redig. All rights reserved.
//

#import "shapeBenchmark.h"
#import "SKUtilities2.h"

@interface shapeBenchmark() {
	NSMutableSet* shapesSet;
	
	NSTimeInterval startTime;
	
	NSUInteger squareBase;
}

@end

@implementation shapeBenchmark


-(void)didMoveToView:(SKView *)view {
	shapesSet = [NSMutableSet set];
	squareBase = 20;
	[self setupButton];
	
}

-(void)skuButtonUp:(SKUButton*)button {
	[self benchmarkSKUShapes];
}

-(void)skButtonUp:(SKUButton*)button {
	[self benchmarkSKShapeNodes];
}


-(void)setupButton {
	
	SKTexture* tex = [SKTexture textureWithImageNamed:@"Spaceship_small"];
	
	SKUButtonLabelProperties* labelProps = [SKUButtonLabelProperties propertiesWithText:@"SKUShapeNode" andColor:[SKColor whiteColor] andSize:50 andFontName:@"Helvetica Neue"];
	SKUButtonLabelPropertiesPackage* labelPack = [SKUButtonLabelPropertiesPackage packageWithPropertiesForDefaultState:labelProps];
	
	SKUButtonSpriteStateProperties* spriteProps = [SKUButtonSpriteStateProperties propertiesWithTexture:tex andAlpha:1.0];
	SKUButtonSpriteStatePropertiesPackage* spritePack = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:spriteProps];
	
	SKUPushButton* skuButton = [SKUPushButton pushButtonWithBackgroundPropertiesPackage:spritePack andTitleLabelPropertiesPackage:labelPack];
	skuButton.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(0.25, 0.5));
	[skuButton setUpAction:@selector(skuButtonUp:) toPerformOnTarget:self];
	skuButton.zPosition = 1.0;
	[self addChild:skuButton];
	
	SKUButtonLabelPropertiesPackage* labelPack2 = labelPack.copy;
	[labelPack2 changeText:@"SKShapeNode"];
	
	SKUPushButton* skButton = [SKUPushButton pushButtonWithBackgroundPropertiesPackage:spritePack andTitleLabelPropertiesPackage:labelPack2];
	skButton.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(0.75, 0.5));
	[skButton setUpAction:@selector(skButtonUp:) toPerformOnTarget:self];
	skButton.zPosition = 1.0;
	[self addChild:skButton];
	
}

-(void)clearNodes {
	for (SKNode* node in shapesSet) {
		[node removeFromParent];
	}
}

-(void)timerStart {
	startTime = CFAbsoluteTimeGetCurrent();
}

-(void)timerStop {
	NSTimeInterval endtime = CFAbsoluteTimeGetCurrent();
	NSTimeInterval total = endtime - startTime;
	NSLog(@"generation time: %f", total);
}

-(void)benchmarkSKUShapes {
	[self clearNodes];
	[self timerStart];
	
	for (int y = 0; y < squareBase; y ++) {
		for (int x = 0; x < squareBase; x++) {
			SKU_ShapeNode* shape = [SKU_ShapeNode circleWithRadius:fmin(self.size.width, self.size.height)/(squareBase*2.0) andColor:[SKColor redColor]];
			shape.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(x/(CGFloat)squareBase, y/(CGFloat)squareBase));
			shape.position = pointAdd(shape.position, CGPointMake( 0.5 * (1.0/(CGFloat)squareBase) * self.size.width,  0.5 * (1.0/(CGFloat)squareBase) * self.size.height));
			[self addChild:shape];
			[shapesSet addObject:shape];
		}
	}
	
	[self timerStop];
}


-(void)benchmarkSKShapeNodes {
	[self clearNodes];
	[self timerStart];
	for (int y = 0; y < squareBase; y ++) {
		for (int x = 0; x < squareBase; x++) {
//			SKU_ShapeNode* shape = [SKU_ShapeNode circleWithRadius:fmin(self.size.width, self.size.height)/(squareBase*2.0) andColor:[SKColor redColor]];
			SKShapeNode* shape = [SKShapeNode shapeNodeWithCircleOfRadius:fmin(self.size.width, self.size.height)/(squareBase*2.0)];
			shape.fillColor = [SKColor redColor];
			shape.strokeColor = [SKColor clearColor];
			shape.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(x/(CGFloat)squareBase, y/(CGFloat)squareBase));
			shape.position = pointAdd(shape.position, CGPointMake( 0.5 * (1.0/(CGFloat)squareBase) * self.size.width,  0.5 * (1.0/(CGFloat)squareBase) * self.size.height));
			[self addChild:shape];
			[shapesSet addObject:shape];
		}
	}
	[self timerStop];
}

#if TARGET_OS_TV
-(void)gestureTap:(UIGestureRecognizer*)gesture {
	if ([sharedUtilities.navFocus isEqual:self]) {
		if ([currentSelectedNode.name isEqualToString:@"tempButton"]) {
			[self transferScene];
		}
	}
}
#endif

-(void)currentSelectedNodeUpdated:(SKNode *)node {
//	indicator.position = node.position;
//	currentSelectedNode = node;
}


-(void)inputEnded:(CGPoint)location withEventDictionary:(NSDictionary *)eventDict {
	
	NSArray* nodes = [self nodesAtPoint:location];
	for (SKNode* node in nodes) {
		if ([node.name isEqualToString:@"tempButton"]) {
			//next scene
			[self transferScene];
			break;
		}
	}
}



-(void)transferScene {
	
//	_2rotationScene* scene = [[_2rotationScene alloc] initWithSize:self.size];
//	scene.scaleMode = self.scaleMode;
	
	SKView* view = (SKView*)self.view;
//	[view presentScene:scene];
	
}

-(void)distanceBenchmark {
	CGPoint pointA = CGPointMake(50.0, -20.5);
	CGPoint pointB = CGPointMake(-100.0, 50.0);
	
	NSTimeInterval start = CFAbsoluteTimeGetCurrent();
	
	u_int32_t iters = 10000;
	
	for (u_int32_t i = 0; i < iters; i++) {
		distanceBetween(pointA, pointB);
	}
	
	NSTimeInterval end = CFAbsoluteTimeGetCurrent();
	NSLog(@"time elapsed: %f", end - start);
	
}

-(void)update:(CFTimeInterval)currentTime {
	/* Called before each frame is rendered */
}


@end
