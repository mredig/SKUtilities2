//
//  08ButtonDemo.m
//  SKUtilities2
//
//  Created by Michael Redig on 10/25/15.
//  Copyright © 2015 Michael Redig. All rights reserved.
//

#import "08ButtonDemo.h"
#import "SKUtilities2.h"
#import "07ColorBlending.h"

@implementation _8ButtonDemo


-(void)didMoveToView:(SKView *)view {
	self.backgroundColor = [SKColor colorWithWhite:0.7 alpha:1.0];
	SKULog(0,@"08ButtonDemo: demos different button types");
	self.name = @"ButtonDemoScene";
	
	[self setupButton];
}

-(void)setupButton {
	SKUButtonLabelPropertiesPackage* labelPack = SKUSharedUtilities.userData[@"buttonLabelPackage"];
	SKUButtonSpriteStatePropertiesPackage* backgroundPack = SKUSharedUtilities.userData[@"buttonBackgroundPackage"];
	SKUPushButton* nextSlide = [SKUPushButton pushButtonWithBackgroundPropertiesPackage:backgroundPack andTitleLabelPropertiesPackage:labelPack];
	nextSlide.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(0.66, 0.25));
	nextSlide.zPosition = 1.0;
	[nextSlide setUpAction:@selector(transferScene:) toPerformOnTarget:self];
	nextSlide.name = @"nextSlideButton";
	[self addChild:nextSlide];
	
	SKUButtonLabelPropertiesPackage* labelPackPrev = labelPack.copy;
	[labelPackPrev changeText:@"Previous Scene"];
	SKUPushButton* prevSlide = [SKUPushButton pushButtonWithBackgroundPropertiesPackage:backgroundPack andTitleLabelPropertiesPackage:labelPackPrev];
	prevSlide.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(0.33, 0.25));
	prevSlide.zPosition = 1.0;
	[prevSlide setUpAction:@selector(prevScene:) toPerformOnTarget:self];
	prevSlide.name = @"prevSlideButton";
	[self addChild:prevSlide];
	
	
// toggle button
	SKTexture* toggleOnTex = [SKTexture textureWithImageNamed:@"checkBoxOnSKU"];
	
	SKUButtonSpriteStateProperties* toggleOnProps = [SKUButtonSpriteStateProperties propertiesWithTexture:toggleOnTex andAlpha:1.0f];
	SKUButtonSpriteStatePropertiesPackage* toggleOnPackage = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:toggleOnProps];
	
	SKTexture* toggleOffTex = [SKTexture textureWithImageNamed:@"checkBoxOffSKU"];
	
	SKUButtonSpriteStateProperties* toggleOffProps = [SKUButtonSpriteStateProperties propertiesWithTexture:toggleOffTex andAlpha:1.0f];
	SKUButtonSpriteStatePropertiesPackage* toggleOffPackage = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:toggleOffProps];
	
	SKUButtonLabelPropertiesPackage* labelPackToggle = labelPack.copy;
	[labelPackToggle changeText:@"toggle"];
	
	SKUToggleButton* toggleTest = [SKUToggleButton toggleButtonWithBackgroundPropertiesPackage:backgroundPack andTitleLabelPropertiesPackage:labelPackToggle];
//	[toggleTest setBaseStatesWithPackage:backgroundPack];
//	[toggleTest setTitleLabelStatesWithPackage:labelPackToggle];
//	[toggleTest setToggleSpriteOnStatesWithPackage:toggleOnPackage];
//	[toggleTest setToggleSpriteOffStatesWithPackage:toggleOffPackage];
	[toggleTest setUpAction:@selector(toggled:) toPerformOnTarget:self];
	toggleTest.zPosition = 1.0;
	toggleTest.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(0.5, 0.75));
	toggleTest.name = @"toggleTest";
	[self addChild:toggleTest];
	
#if TARGET_OS_TV
	
	[self addNodeToNavNodesSKU:nextSlide];
	[self addNodeToNavNodesSKU:prevSlide];
	[self addNodeToNavNodesSKU:toggleTest];
	[self setCurrentSelectedNodeSKU:nextSlide];
	
	[SKUSharedUtilities setNavFocus:self];
	
#endif
}

-(void)toggled:(SKUToggleButton*)button {
	SKULog(0, @"toggled: %i", button.on);
}


-(void)inputEndedSKU:(CGPoint)location withEventDictionary:(NSDictionary *)eventDict {
	
}

-(void)prevScene:(SKUButton*)button {
	_7ColorBlending* scene = [_7ColorBlending sceneWithSize:self.size];
	scene.scaleMode = self.scaleMode;
	
	SKView* view = (SKView*)self.view;
	[view presentScene:scene];
}


-(void)transferScene:(SKUButton*)button {

//	_2rotationScene* scene = [[_2rotationScene alloc] initWithSize:self.size];
//	scene.scaleMode = self.scaleMode;
//	
//	SKView* view = (SKView*)self.view;
//	[view presentScene:scene];
	
}


-(void)update:(CFTimeInterval)currentTime {
	/* Called before each frame is rendered */
}


@end
