//
//  05ShapeDemo.m
//  SKUtilities2
//
//  Created by Michael Redig on 9/29/15.
//  Copyright © 2015 Michael Redig. All rights reserved.
//

#import "05ShapeDemo.h"
#import "SKUtilities2.h"
#import "06MultiLineDemo.h"

@implementation _5ShapeDemo


-(void) didMoveToView:(SKView *)view {
	
	NSLog(@"\n\n\n\n05ShapeDemo demo: demos shape stuff");
	
	
#pragma mark BEZIER CALCUATIONS
	[self setupSpriteDemos];
	[self setupButton];
}

-(void)setupSpriteDemos {
	
	CGFloat sizes = 100.0;
	
	SKU_ShapeNode* circle = [SKU_ShapeNode circleWithRadius:sizes andColor:[SKColor whiteColor]];
	circle.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(0.25, 0.75));
	[self addChild:circle];
	
	SKU_ShapeNode* square = [SKU_ShapeNode squareWithWidth:sizes * 2.0 andColor:[SKColor redColor]];
	square.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(0.75, 0.75));
	[self addChild:square];
	
	
	SKU_ShapeNode* rectangle = [SKU_ShapeNode rectangleWithSize:CGSizeMake(sizes * 2.0, sizes) andColor:[SKColor blueColor]];
	rectangle.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(0.25, 0.25));
	[self addChild:rectangle];
	
	
	SKU_ShapeNode* roundedRect = [SKU_ShapeNode rectangleRoundedWithSize:CGSizeMake(sizes * 2.0, sizes) andCornerRadius:sizes * 0.2 andColor:[SKColor orangeColor]];
	roundedRect.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(0.75, 0.25));
	[self addChild:roundedRect];
	
	CGRect rect = CGRectMake(-sizes, -sizes / 2.0, sizes * 2.0, sizes);
	CGPathRef rectPathRef = CGPathCreateWithRoundedRect(rect, sizes * 0.2, sizes * 0.2, NULL);
	CGPathRef outlinePath = CGPathCreateCopyByStrokingPath(rectPathRef, NULL, 10.0, kCGLineCapButt, kCGLineJoinMiter, 10.0);;
	
	SKU_ShapeNode* amalgShape = [SKU_ShapeNode node];
	amalgShape.fillColor = [SKColor yellowColor];
	amalgShape.path = outlinePath;
	amalgShape.position = roundedRect.position;
	amalgShape.zPosition = 2.0;
	[self addChild:amalgShape];
	
	CGPathRelease(outlinePath);
	CGPathRelease(rectPathRef);
	
#if TARGET_OS_TV
	
	SKUSharedUtilities.navMode = kSKUNavModeOff;
	
	
	SKView* scnView = (SKView*)self.view;
	
	UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTap:)];
	[scnView addGestureRecognizer:tapGesture];
#endif
	
}

#if TARGET_OS_TV
-(void)gestureTap:(UIGestureRecognizer*)gesture {
	if (gesture.state == UIGestureRecognizerStateEnded) {
		[self transferScene];
		
	}
}
#endif


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

-(void)inputEnded:(CGPoint)location withEventDictionary:(NSDictionary *)eventDict {
#if TARGET_OS_TV
#else
	NSArray* nodes = [self nodesAtPoint:location];
	for (SKNode* node in nodes) {
		if ([node.name isEqualToString:@"tempButton"]) {
			//next scene
			[self transferScene];
			break;
		}
	}
#endif
}



-(void)transferScene {
	
	_6MultiLineDemo* scene = [[_6MultiLineDemo alloc] initWithSize:self.size];
	scene.scaleMode = self.scaleMode;
	
	SKView* view = (SKView*)self.view;
	[view presentScene:scene];
	
}


-(void)update:(NSTimeInterval)currentTime {
}


@end
