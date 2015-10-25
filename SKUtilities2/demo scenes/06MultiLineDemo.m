//
//  06MultiLineDemo.m
//  SKUtilities2
//
//  Created by Michael Redig on 9/29/15.
//  Copyright © 2015 Michael Redig. All rights reserved.
//

#import "06MultiLineDemo.h"
#import "SKUtilities2.h"
#import "07ColorBlending.h"

@interface _6MultiLineDemo() {
	SKU_MultiLineLabelNode* multiLineLabel;
}

@end

@implementation _6MultiLineDemo

-(void)didMoveToView:(SKView *)view {
	
	NSLog(@"\n\n\n\n06MultiLineDemo: demos multiline label stuff");
	
	
	[self setupSpriteDemos];
	[self setupButton];
	
}

-(void)setupSpriteDemos {
	
	multiLineLabel = [SKU_MultiLineLabelNode labelNodeWithFontNamed:@"Helvetica Neue"];
	multiLineLabel.paragraphWidth = 200.0;
	multiLineLabel.text = @"This is text and stuff and this\nis\na\nnewline\netc.";
	multiLineLabel.position = pointMultiplyByFactor(pointFromCGSize(self.size), 0.25);
	[self addChild:multiLineLabel];
	
}


-(void)setupButton {
	
	SKUButtonLabelPropertiesPackage* labelPack = SKUSharedUtilities.userData[@"buttonLabelPackage"];
	SKUButtonSpriteStatePropertiesPackage* backgroundPack = SKUSharedUtilities.userData[@"buttonBackgroundPackage"];
	SKUPushButton* nextSlide = [SKUPushButton pushButtonWithBackgroundPropertiesPackage:backgroundPack andTitleLabelPropertiesPackage:labelPack];
	nextSlide.position = midPointOfRect(self.frame);
	nextSlide.zPosition = 1.0;
	[nextSlide setUpAction:@selector(transferScene:) toPerformOnTarget:self];
	[self addChild:nextSlide];
	
	
#if TARGET_OS_TV
	
	SKUSharedUtilities.navMode = kSKUNavModeOn;
	[self addNodeToNavNodesSKU:nextSlide];
	[self setCurrentSelectedNodeSKU:nextSlide];
	
	[SKUSharedUtilities setNavFocus:self];
	
#endif
}

-(void)absoluteInputBeganSKU:(CGPoint)location withEventDictionary:(NSDictionary *)eventDict {
	multiLineLabel.position = location;
}

-(void)relativeInputMovedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary *)eventDict {
	multiLineLabel.position = pointAdd(delta, multiLineLabel.position);
}

-(void)absoluteInputMovedSKU:(CGPoint)location withEventDictionary:(NSDictionary *)eventDict {
	multiLineLabel.position = location;
}

-(void)inputEndedSKU:(CGPoint)location withEventDictionary:(NSDictionary *)eventDict {

}


-(void)transferScene:(SKUButton*)button {
	
	_7ColorBlending* scene = [_7ColorBlending sceneWithSize:self.size];
	scene.scaleMode = self.scaleMode;
	
	SKView* view = (SKView*)self.view;
	[view presentScene:scene];
	
}


-(void)update:(NSTimeInterval)currentTime {
}


@end
