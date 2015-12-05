//
//  07ColorBlending.m
//  SKUtilities2
//
//  Created by Michael Redig on 10/5/15.
//  Copyright © 2015 Michael Redig. All rights reserved.
//

#import "07ColorBlending.h"
#import "06MultiLineDemo.h"
#import "08ButtonDemo.h"

@interface _7ColorBlending() {
	
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
	
	SKUPushButton* prevSlide = [SKUPushButton pushButtonWithTitle:@"Previous Scene"];
	prevSlide.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(0.33, 0.5));
	prevSlide.zPosition = 1.0;
	[prevSlide setUpAction:@selector(prevScene:) toPerformOnTarget:self];
	prevSlide.name = @"prevSlide";
	[self addChild:prevSlide];
	
	
	SKUSharedUtilities.navMode = kSKUNavModeOn;
	[self addNodeToNavNodesSKU:nextSlide];
	[self addNodeToNavNodesSKU:prevSlide];
	
	[SKUSharedUtilities setNavFocus:self];
	[self setCurrentFocusedNodeSKU:nextSlide];

}

-(void)inputMovedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary *)eventDict {
	
	SKColor* redColor = [SKColor redColor];
	SKColor* greenColor = [SKColor greenColor];
	SKColor* blueColor = [SKColor blueColor];
	
	CGFloat difference = 0.025;

	if (delta.x > 0) {
		xAlpha += difference;
	} else if (delta.x < 0) {
		xAlpha -= difference;
	}
	
	if (delta.y > 0) {
		yAlpha += difference;
	} else if (delta.y < 0) {
		yAlpha -= difference;
	}

	yAlpha = clipFloatWithinRange(yAlpha, 0.0, 1.0);
	xAlpha = clipFloatWithinRange(xAlpha, 0.0, 1.0);
	
	self.backgroundColor = [SKColor blendColorSKU:blueColor withColor:greenColor alpha:xAlpha];
	self.backgroundColor = [SKColor blendColorSKU:self.backgroundColor withColor:redColor alpha:yAlpha];
	
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
	[super update:currentTime];
	
	SKUGameControllerState* controllerState = SKUSharedUtilities.gcController.controllerStates[4];
	if (controllerState.buttonsPressed & kSKUGamePadInputLeftThumbstick) {
		
		xAlpha += controllerState.vectorLThumbstick.dx * 0.05;
		yAlpha += controllerState.vectorLThumbstick.dy * 0.05;
		
		yAlpha = clipFloatWithinRange(yAlpha, 0.0, 1.0);
		xAlpha = clipFloatWithinRange(xAlpha, 0.0, 1.0);
		
		SKColor* redColor = [SKColor redColor];
		SKColor* greenColor = [SKColor greenColor];
		SKColor* blueColor = [SKColor blueColor];
		
		self.backgroundColor = [SKColor blendColorSKU:blueColor withColor:greenColor alpha:xAlpha];
		self.backgroundColor = [SKColor blendColorSKU:self.backgroundColor withColor:redColor alpha:yAlpha];

	}
}


@end
