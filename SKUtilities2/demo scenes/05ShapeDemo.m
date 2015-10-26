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
	
	NSLog(@"\n\n\n\n05ShapeDemo demo: demos shape stuff");
	
	
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
	

	
	SKUPushButton* prevSlide = [SKUPushButton pushButtonWithText:@"Previous Scene"];
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
	
	
#if TARGET_OS_TV
	
	SKUSharedUtilities.navMode = kSKUNavModeOn;
	[self addNodeToNavNodesSKU:nextSlide];
	[self addNodeToNavNodesSKU:prevSlide];
	[self addNodeToNavNodesSKU:benchmark];
	[self setCurrentSelectedNodeSKU:nextSlide];
	
	[SKUSharedUtilities setNavFocus:self];
	
#endif
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
