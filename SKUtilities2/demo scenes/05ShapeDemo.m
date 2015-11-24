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
#import "shapeBenchmark.h"
#import "04BezierDemo.h"

@implementation _5ShapeDemo


-(void) didMoveToView:(SKView *)view {
	
	SKULog(0,@"\n\n\n\n05ShapeDemo demo: demos shape stuff");
	self.name = @"shape demo scene";
	self.backgroundColor = [SKColor grayColor];

	[self setupSpriteDemos];
	[self setupButton];
}

-(void)setupSpriteDemos {
	
	CGFloat sizes = 100.0;
	
	SKUShapeNode* circle = [SKUShapeNode circleWithRadius:sizes andColor:[SKColor whiteColor]];
	circle.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(0.25, 0.75));
	circle.name = @"circle";
	[self addChild:circle];
	
	SKUShapeNode* square = [SKUShapeNode squareWithWidth:sizes * 2.0 andColor:[SKColor redColor]];
	square.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(0.75, 0.75));
	square.name = @"square";
	[self addChild:square];
	
	
	SKUShapeNode* rectangle = [SKUShapeNode rectangleWithSize:CGSizeMake(sizes * 2.0, sizes) andColor:[SKColor blueColor]];
	rectangle.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(0.25, 0.25));
	rectangle.name = @"rectangle";
	[self addChild:rectangle];
	
	
	
	CGRect rect = CGRectMake(-sizes, -sizes / 2.0, sizes * 2.0, sizes);
	CGPathRef rectPathRef = CGPathCreateWithRoundedRect(rect, sizes * 0.2, sizes * 0.2, NULL);
	
	SKUShapeNode* roundedRectangleShape = [SKUShapeNode node];
	roundedRectangleShape.fillColor = [SKColor yellowColor];
	roundedRectangleShape.strokeColor = [SKColor greenColor];
	roundedRectangleShape.lineWidth = 20.0;
	roundedRectangleShape.path = rectPathRef;
	roundedRectangleShape.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(0.75, 0.25));
	roundedRectangleShape.zPosition = 2.0;
	roundedRectangleShape.name = @"roundedRectangleShape";
	[self addChild:roundedRectangleShape];
	
	CGPathRelease(rectPathRef);
}

-(void)setupButton {
	
	SKUButtonLabelPropertiesPackage* labelPack = SKUSharedUtilities.userData[@"buttonLabelPackage"];
	SKUButtonSpriteStatePropertiesPackage* backgroundPack = SKUSharedUtilities.userData[@"buttonBackgroundPackage"];
	SKUPushButton* nextSlide = [SKUPushButton pushButtonWithBackgroundPropertiesPackage:backgroundPack andTitleLabelPropertiesPackage:labelPack];
	nextSlide.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(0.66, 0.5)) ;
	nextSlide.zPosition = 1.0;
	[nextSlide setUpAction:@selector(transferScene:) toPerformOnTarget:self];
	nextSlide.name = @"next";
	[self addChild:nextSlide];
	

	
	SKUPushButton* prevSlide = [SKUPushButton pushButtonWithTitle:@"Previous Scene"];
	prevSlide.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(0.33, 0.5));
	prevSlide.zPosition = 1.0;
	[prevSlide setUpAction:@selector(transferScene:) toPerformOnTarget:self];
	prevSlide.name = @"prev";
	[self addChild:prevSlide];
	
	
	
	SKUButtonLabelPropertiesPackage* benchmarkLabel = labelPack.copy;
	[benchmarkLabel changeText:@"Benchmark Shapes"];
	SKUPushButton* benchmark = [SKUPushButton pushButtonWithBackgroundPropertiesPackage:backgroundPack andTitleLabelPropertiesPackage:benchmarkLabel];
	benchmark.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(0.5, 0.66)) ;
	benchmark.zPosition = 1.0;
	[benchmark setUpAction:@selector(transferScene:) toPerformOnTarget:self];
	benchmark.name = @"benchmark";
	[self addChild:benchmark];
	
	
	SKUSharedUtilities.navMode = kSKUNavModeOn;
	[self addNodeToNavNodesSKU:nextSlide];
	[self addNodeToNavNodesSKU:prevSlide];
	[self addNodeToNavNodesSKU:benchmark];
	[self setCurrentFocusedNodeSKU:nextSlide];
	
	[SKUSharedUtilities setNavFocus:self];
	
}

-(void)transferScene:(SKUButton*)button {
	SKScene* scene;
	if ([button.name isEqualToString:@"next"]) {
		scene = [[_6MultiLineDemo alloc] initWithSize:self.size];
		scene.scaleMode = self.scaleMode;
	} else if ([button.name isEqualToString:@"benchmark"]) {
		scene = [[shapeBenchmark alloc] initWithSize:self.size];
		scene.scaleMode = self.scaleMode;
	} else if ([button.name isEqualToString:@"prev"]) {
		scene = [[_4BezierDemo alloc] initWithSize:self.size];
		scene.scaleMode = self.scaleMode;
	}

	SKView* view = (SKView*)self.view;
	[view presentScene:scene];
	
}


-(void)update:(NSTimeInterval)currentTime {
}


@end
