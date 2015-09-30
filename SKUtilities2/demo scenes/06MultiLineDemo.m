//
//  06MultiLineDemo.m
//  SKUtilities2
//
//  Created by Michael Redig on 9/29/15.
//  Copyright © 2015 Michael Redig. All rights reserved.
//

#import "06MultiLineDemo.h"
#import "SKUtilities2.h"

@interface _6MultiLineDemo() {
	SKU_MultiLineLabelNode* multiLineLabel;
}

@end

@implementation _6MultiLineDemo

-(void)didMoveToView:(SKView *)view {
	
	NSLog(@"\n\n\n\n06MultiLineDemo: demos multiline label stuff");
	
	
#pragma mark BEZIER CALCUATIONS
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

-(void)mouseDown:(NSEvent *)theEvent {
	CGPoint location = [theEvent locationInNode:self];
	multiLineLabel.position = location;
}

-(void)mouseDragged:(NSEvent *)theEvent {
	CGPoint location = [theEvent locationInNode:self];
	multiLineLabel.position = location;
}


-(void)mouseUp:(NSEvent *)theEvent {
	CGPoint location = [theEvent locationInNode:self];
	NSArray* nodes = [self nodesAtPoint:location];
	for (SKNode* node in nodes) {
		if ([node.name isEqualToString:@"tempButton"]) {
			//next scene
			[self transferScene];
			break;
		}
	}
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
