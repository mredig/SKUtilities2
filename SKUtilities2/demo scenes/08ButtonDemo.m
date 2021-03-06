//
//  08ButtonDemo.m
//  SKUtilities2
//
//  Created by Michael Redig on 10/25/15.
//  Copyright © 2015 Michael Redig. All rights reserved.
//

#import "08ButtonDemo.h"
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
	self.backgroundColor = [SKColor grayColor];

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
	[nextSlide disableButton];
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
	[labelPackToggle changeText:@"Adjust Slider Size"];
	
	toggleTest = [SKUToggleButton toggleButtonWithBackgroundPropertiesPackage:backgroundPack andTitleLabelPropertiesPackage:labelPackToggle];
	[toggleTest setUpAction:@selector(toggled:) toPerformOnTarget:self];
	toggleTest.zPosition = 1.0;
	toggleTest.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(0.66, 0.75));
	toggleTest.name = @"toggleTest";
	[self addChild:toggleTest];
	
// slider button
	
	
	SKUButtonSpriteStatePropertiesPackage* maxPackage = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:[SKUButtonSpriteStateProperties propertiesWithTexture:[SKTexture textureWithImageNamed:@"plusSKU"] andAlpha:1.0f]];
	SKUButtonSpriteStatePropertiesPackage* minPackage = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:[SKUButtonSpriteStateProperties propertiesWithTexture:[SKTexture textureWithImageNamed:@"minusSKU"] andAlpha:1.0f]];

	slider = [SKUSliderButton sliderButtonWithDefaults];
	slider.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(0.66, 0.5));
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

	
// custom art
	
	SKUButtonSpriteStateProperties* customBGDefault = [SKUButtonSpriteStateProperties propertiesWithTexture:[SKTexture textureWithImageNamed:@"demoNormal"] andAlpha:1.0];
	customBGDefault.centerRect = CGRectMake(40.0f / customBGDefault.texture.size.width, 65.0f / customBGDefault.texture.size.height, 40.0f / customBGDefault.texture.size.width, 30.0f / customBGDefault.texture.size.height);
	SKUButtonSpriteStateProperties* customBGHover = customBGDefault.copy;
	customBGHover.texture = [SKTexture textureWithImageNamed:@"demoHover"];
	SKUButtonSpriteStateProperties* customBGPush = customBGDefault.copy;
	customBGPush.texture = [SKTexture textureWithImageNamed:@"demoPush"];
	SKUButtonSpriteStateProperties* customBGDisabled = customBGDefault.copy;
	customBGDisabled.texture = [SKTexture textureWithImageNamed:@"demoDisabled"];
	
	SKUButtonSpriteStatePropertiesPackage* customBackgroundPackage = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:customBGDefault andPressedState:customBGPush andHoveredState:customBGHover andDisabledState:customBGDisabled];
	
	SKUButtonLabelPropertiesPackage* customButtonLabelPack = [SKUButtonLabelPropertiesPackage packageWithDefaultPropertiesWithText:@"Custom Button"];
	[customButtonLabelPack.propertiesHoveredState setScale:1.0];//comment and uncomment these to see how they affect the scaling of the background, even though the background is NOT set to scale.
	[customButtonLabelPack.propertiesPressedState setScale:1.0];
	
	
	SKUPushButton* customImageButtonExample = [SKUPushButton pushButtonWithBackgroundPropertiesPackage:customBackgroundPackage andTitleLabelPropertiesPackage:customButtonLabelPack];
	customImageButtonExample.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(0.5, 0.9));
	customImageButtonExample.name = @"customButtonExample";
	[customImageButtonExample setDownAction:@selector(pressed:) toPerformOnTarget:self];
	[customImageButtonExample setUpAction:@selector(released:) toPerformOnTarget:self];
	[self addChild:customImageButtonExample];
	
	
// delegate button
	
	SKUPushButton* delegateButton = [SKUPushButton pushButtonWithTitle:@"Delegate Button"];
	delegateButton.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(0.33, 0.5));
	delegateButton.name = @"delegateButton";
	delegateButton.delegate = self;
	[self addChild:delegateButton];
	
// notification button
	
	SKUPushButton* notificationButton = [SKUPushButton pushButtonWithTitle:@"Notification Button"];
	notificationButton.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(0.33, 0.75));
	notificationButton.name = @"notificationButton";
	notificationButton.notificationNameDown = @"notifyDown";
	notificationButton.notificationNameUp = @"notifyUp";
	[self addChild:notificationButton];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyDown:) name:@"notifyDown" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyUp:) name:@"notifyUp" object:nil];
	
	
	[self addNodeToNavNodesSKU:nextSlide];
	[self addNodeToNavNodesSKU:customImageButtonExample];
	[self addNodeToNavNodesSKU:notificationButton];
	[self addNodeToNavNodesSKU:slider];
	[self addNodeToNavNodesSKU:prevSlide];
	[self addNodeToNavNodesSKU:toggleTest];
	[self addNodeToNavNodesSKU:delegateButton];
	
	[SKUSharedUtilities setNavFocus:self];
	[self setCurrentFocusedNodeSKU:toggleTest];

}

-(void)notifyDown:(NSNotification*)notification {
	SKUButton* button = notification.object;
	SKULog(0, @"%@ pressed", button.name);
}

-(void)notifyUp:(NSNotification*)notification {
	SKUButton* button = notification.object;
	SKULog(0, @"%@ released", button.name);
}

-(void)pressed:(SKUButton*)button {
	SKULog(0, @"pressed: %@", button.name);
}

-(void)released:(SKUButton*)button {
	SKULog(0, @"released: %@", button.name);
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

-(void)doButtonDown:(SKUButton *)button {
	SKULog(0, @"%@ pressed", button.name);
}

-(void)doButtonUp:(SKUButton *)button inBounds:(BOOL)inBounds {
	SKULog(0, @"%@ released inbounds: %i", button.name, inBounds);
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
	[super update:currentTime];
}


@end
