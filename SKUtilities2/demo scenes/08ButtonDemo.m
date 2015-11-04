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

@interface _8ButtonDemo() {
 
	SKUSliderButton* slider;
	SKUToggleButton* toggleTest;
}

@end


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
	
	SKUButtonLabelPropertiesPackage* labelPackToggle = labelPack.copy;
	[labelPackToggle changeText:@"toggle"];
	
	toggleTest = [SKUToggleButton toggleButtonWithBackgroundPropertiesPackage:backgroundPack andTitleLabelPropertiesPackage:labelPackToggle];
	[toggleTest setUpAction:@selector(toggled:) toPerformOnTarget:self];
	toggleTest.zPosition = 1.0;
	toggleTest.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(0.5, 0.75));
	toggleTest.name = @"toggleTest";
	[self addChild:toggleTest];
	
// slider button
	
	SKUButtonSpriteStatePropertiesPackage* knobPackage = [SKUButtonSpriteStatePropertiesPackage packageWithDefaultSliderKnobPropertiesSKU];
	SKUButtonSpriteStatePropertiesPackage* sliderPackage = [SKUButtonSpriteStatePropertiesPackage packageWithDefaultSliderSliderSlidePropertiesSKU];
	
	SKUButtonSpriteStatePropertiesPackage* maxPackage = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:[SKUButtonSpriteStateProperties propertiesWithTexture:[SKTexture textureWithImageNamed:@"plusSKU"] andAlpha:1.0f]];
	SKUButtonSpriteStatePropertiesPackage* minPackage = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:[SKUButtonSpriteStateProperties propertiesWithTexture:[SKTexture textureWithImageNamed:@"minusSKU"] andAlpha:1.0f]];
	
	slider = [SKUSliderButton node];
	[slider setSlideSpriteStatesWithPackage:sliderPackage];
	[slider setKnobSpriteStatesWithPackage:knobPackage];
	slider.position = pointAdd(nextSlide.position, CGPointMake(0, -70));
	slider.minimumValue = -10;
	slider.maximumValue = 100;
	slider.value = -150;
//	slider.delegate = self;
	[slider setChangedAction:@selector(sliderChanged:) toPerformOnTarget:self];
	[slider setUpAction:@selector(released:) toPerformOnTarget:self];
	[slider setDownAction:@selector(pressed:) toPerformOnTarget:self];
	slider.continuous = YES;
	slider.name = @"slider";
	slider.sliderWidth = 300;
	[slider setMaxValueSpriteStatesWithPackage:maxPackage];
	[slider setMinValueSpriteStatesWithPackage:minPackage];
	[self addChild:slider];

	
#if TARGET_OS_TV
	
	[self addNodeToNavNodesSKU:nextSlide];
	[self addNodeToNavNodesSKU:slider];
	[self addNodeToNavNodesSKU:prevSlide];
	[self addNodeToNavNodesSKU:toggleTest];
	[self setCurrentSelectedNodeSKU:nextSlide];
	
	[SKUSharedUtilities setNavFocus:self];
	
#endif
}

-(void)pressed:(SKUButton*)button {
	SKULog(0, @"pressed");
}

-(void)released:(SKUSliderButton*)button {
	SKULog(0, @"released: %f", button.value);
}

-(void)valueChanged:(SKUSliderButton *)button {
	SKULog(0, @"delegate: %f", button.value);
}

-(void)sliderChanged:(SKUSliderButton*)button {
	SKULog(0, @"value: %f", button.value);
}

-(void)toggled:(SKUToggleButton*)button {
//	SKULog(0, @"toggled: %i", button.on);
}


-(void)inputMovedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary *)eventDict {
	if (toggleTest.on) {
		slider.sliderWidth += delta.y;
	}

}

-(void)inputEndedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary *)eventDict {
	
}

-(void)prevScene:(SKUButton*)button {
	_7ColorBlending* scene = [_7ColorBlending sceneWithSize:self.size];
	scene.scaleMode = self.scaleMode;
	
	SKView* view = (SKView*)self.view;
	[view presentScene:scene];
}


-(void)transferScene:(SKUButton*)button {

//	SKUToggleButton* toggleButton = (SKUToggleButton*)[self childNodeWithName:@"toggleTest"];
//	[toggleButton changeTitleLabelText:[NSString stringWithFormat:@"%@+", toggleButton.labelPropertiesDefault.text] forStates:(kSKUButtonStateDefault | kSKUButtonStatePressed | kSKUButtonStateHovered | kSKUButtonStateDisabled)]; //use this for a future demo

	
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
