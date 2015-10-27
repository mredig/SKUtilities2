//
//  07ColorBlending.m
//  SKUtilities2
//
//  Created by Michael Redig on 10/5/15.
//  Copyright © 2015 Michael Redig. All rights reserved.
//

#import "07ColorBlending.h"
#import "SKUtilities2.h"
#import "06MultiLineDemo.h"
#import "08ButtonDemo.h"

@interface _7ColorBlending() {
	
	CGPoint prevLocation;
	CGFloat yAlpha, xAlpha;
}

@end


@implementation _7ColorBlending


-(void)didMoveToView:(SKView *)view {
	
	SKULog(0,@"\n\n\n\n07ColorBlending: demos color blending");
	self.name = @"ColorBlendScene";
	self.backgroundColor = [SKColor blueColor];
	
	[self setupSpriteDemos];
	[self setupButton];
}

-(void)setupSpriteDemos {
	

	
}


-(void)setupButton {
	
	SKUButtonLabelPropertiesPackage* labelPack = SKUSharedUtilities.userData[@"buttonLabelPackage"];
	SKUButtonSpriteStatePropertiesPackage* backgroundPack = SKUSharedUtilities.userData[@"buttonBackgroundPackage"];
	SKUPushButton* nextSlide = [SKUPushButton pushButtonWithBackgroundPropertiesPackage:backgroundPack andTitleLabelPropertiesPackage:labelPack];
	nextSlide.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(0.66, 0.5));
	nextSlide.zPosition = 1.0;
	[nextSlide setUpAction:@selector(transferScene:) toPerformOnTarget:self];
	nextSlide.name = @"nextSlideButton";
	[self addChild:nextSlide];
	
	SKUPushButton* prevSlide = [SKUPushButton pushButtonWithText:@"Previous Scene"];
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

-(void)inputMovedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary *)eventDict {
	
	SKColor* redColor = [SKColor redColor];
	SKColor* greenColor = [SKColor greenColor];
	SKColor* blueColor = [SKColor blueColor];
	
#if TARGET_OS_TV
	UITouch* touch = eventDict[@"touch"];
	prevLocation = [touch previousLocationInNode:self];
	
#endif
	CGFloat difference = 0.025;

	if (location.x > prevLocation.x) {
		xAlpha += difference;
	} else if (location.x < prevLocation.x) {
		xAlpha -= difference;
	}
	
	if (location.y > prevLocation.y) {
		yAlpha += difference;
	} else if (location.y < prevLocation.y) {
		yAlpha -= difference;
	}
	self.backgroundColor = [SKColor blendColorSKU:blueColor withColor:greenColor alpha:xAlpha];
	self.backgroundColor = [SKColor blendColorSKU:self.backgroundColor withColor:redColor alpha:yAlpha];

	yAlpha = clipFloatWithinRange(yAlpha, 0.0, 1.0);
	xAlpha = clipFloatWithinRange(xAlpha, 0.0, 1.0);
	
	prevLocation = location;
	
}

-(void)prevScene:(SKUButton*)button {
	
	_6MultiLineDemo* scene = [[_6MultiLineDemo alloc] initWithSize:self.size];
	scene.scaleMode = self.scaleMode;
	
	SKView* view = (SKView*)self.view;
	[view presentScene:scene];
	
}

-(void)transferScene:(SKUButton*)button {
	
	_8ButtonDemo* scene = [[_8ButtonDemo alloc] initWithSize:self.size];
	scene.scaleMode = self.scaleMode;
	
	SKView* view = (SKView*)self.view;
	[view presentScene:scene];
	
}


-(void)update:(NSTimeInterval)currentTime {
}


@end
