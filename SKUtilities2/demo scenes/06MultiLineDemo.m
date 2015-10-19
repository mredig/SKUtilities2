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

-(void)setupSpriteDemos {
	
	multiLineLabel = [SKU_MultiLineLabelNode labelNodeWithFontNamed:@"Helvetica Neue"];
	multiLineLabel.paragraphWidth = 200.0;
	multiLineLabel.text = @"This is text and stuff and this\nis\na\nnewline\netc.";
	multiLineLabel.position = pointMultiplyByFactor(pointFromCGSize(self.size), 0.25);
	[self addChild:multiLineLabel];
	
}


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
-(void)inputBeganSKU:(CGPoint)location withEventDictionary:(NSDictionary *)eventDict {
	multiLineLabel.position = location;
}

-(void)inputMovedSKU:(CGPoint)location withEventDictionary:(NSDictionary *)eventDict {
	multiLineLabel.position = location;
}

-(void)inputEndedSKU:(CGPoint)location withEventDictionary:(NSDictionary *)eventDict {
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
	
	_7ColorBlending* scene = [_7ColorBlending sceneWithSize:self.size];
	scene.scaleMode = self.scaleMode;
	
	SKView* view = (SKView*)self.view;
	[view presentScene:scene];
	
}


-(void)update:(NSTimeInterval)currentTime {
}


@end
