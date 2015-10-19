//
//  07ColorBlending.m
//  SKUtilities2
//
//  Created by Michael Redig on 10/5/15.
//  Copyright © 2015 Michael Redig. All rights reserved.
//

#import "07ColorBlending.h"
#import "SKUtilities2.h"


@interface _7ColorBlending() {
	
	CGPoint prevLocation;
	CGFloat yAlpha, xAlpha;
}

@end


@implementation _7ColorBlending


-(void)didMoveToView:(SKView *)view {
	
	NSLog(@"\n\n\n\n07ColorBlending: demos color blending");
	
	self.backgroundColor = [SKColor blueColor];
	
	[self setupSpriteDemos];
	[self setupButton];
}

-(void)setupSpriteDemos {
	

	
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
}

-(void)inputMovedSKU:(CGPoint)location withEventDictionary:(NSDictionary *)eventDict {
	
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
	self.backgroundColor = [SKColor blendColor:blueColor withColor:greenColor alpha:xAlpha];
	self.backgroundColor = [SKColor blendColor:self.backgroundColor withColor:redColor alpha:yAlpha];

	yAlpha = fmin(yAlpha, 1.0);
	yAlpha = fmax(yAlpha, 0.0);
	
	xAlpha = fmin(xAlpha, 1.0);
	xAlpha = fmax(xAlpha, 0.0);
	
	prevLocation = location;
	
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
	
	_7ColorBlending* scene = [[_7ColorBlending alloc] initWithSize:self.size];
	scene.scaleMode = self.scaleMode;
	
	SKView* view = (SKView*)self.view;
	[view presentScene:scene];
	
}


-(void)update:(NSTimeInterval)currentTime {
}


@end
