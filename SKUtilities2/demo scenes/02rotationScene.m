//
//  02rotationScene.m
//  SKUtilities2
//
//  Created by Michael Redig on 9/26/15.
//  Copyright © 2015 Michael Redig. All rights reserved.
//

#import "02rotationScene.h"
#import "SKUtilities2.h"
#import "03VectorPoint.h"

@interface _2rotationScene() {
	
	SKSpriteNode* orientUpNode;
	SKSpriteNode* orientRightNode;
	SKSpriteNode* orientDownNode;
	SKSpriteNode* orientLeftNode;
	
	SKSpriteNode* cursor;
}

@end

@implementation _2rotationScene

-(void) didMoveToView:(SKView *)view {
	
	NSLog(@"\n\n\n\n02RotationScene: demos orientation functions");

	
	orientUpNode = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
	orientUpNode.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.25);
	[self addChild:orientUpNode];
	
	SKLabelNode* upLabel = [SKLabelNode labelNodeWithText:@"upFace"];
	upLabel.fontSize = 40;
	upLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
	upLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
	upLabel.zPosition = 1;
	upLabel.fontColor = [SKColor blackColor];
	[orientUpNode addChild:upLabel];
	
	SKSpriteNode* upDirectionSprite = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(10.0, 200.0)];
	upDirectionSprite.anchorPoint = CGPointMake(0.5, 0.0);
	upDirectionSprite.zPosition = 0.5;
	[orientUpNode addChild:upDirectionSprite];
	
	
	orientRightNode = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
	orientRightNode.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.25);
	[self addChild:orientRightNode];
	
	SKLabelNode* rightLabel = [SKLabelNode labelNodeWithText:@"rightFace"];
	rightLabel.fontSize = 40;
	rightLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
	rightLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
	rightLabel.zPosition = 1;
	rightLabel.fontColor = [SKColor blackColor];
	[orientRightNode addChild:rightLabel];
	
	SKSpriteNode* rightDirectionSprite = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(200.0, 10.0)];
	rightDirectionSprite.anchorPoint = CGPointMake(0.0, 0.5);
	rightDirectionSprite.zPosition = 0.5;
	[orientRightNode addChild:rightDirectionSprite];
	
	
	orientLeftNode = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
	orientLeftNode.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.75);
	[self addChild:orientLeftNode];
	
	SKLabelNode* leftLabel = [SKLabelNode labelNodeWithText:@"leftFace"];
	leftLabel.fontSize = 40;
	leftLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
	leftLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
	leftLabel.zPosition = 1;
	leftLabel.fontColor = [SKColor blackColor];
	[orientLeftNode addChild:leftLabel];
	
	
	SKSpriteNode* leftDirectionSprite = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(200.0, 10.0)];
	leftDirectionSprite.anchorPoint = CGPointMake(1.0, 0.5);
	leftDirectionSprite.zPosition = 0.5;
	[orientLeftNode addChild:leftDirectionSprite];
	
	
	orientDownNode = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
	orientDownNode.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.75);
	[self addChild:orientDownNode];
	
	SKLabelNode* downLabel = [SKLabelNode labelNodeWithText:@"downFace"];
	downLabel.fontSize = 40;
	downLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
	downLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
	downLabel.zPosition = 1;
	downLabel.fontColor = [SKColor blackColor];
	[orientDownNode addChild:downLabel];
	
	SKSpriteNode* downDirectionSprite = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(10.0, 200.0)];
	downDirectionSprite.anchorPoint = CGPointMake(0.5, 1.0);
	downDirectionSprite.zPosition = 0.5;
	[orientDownNode addChild:downDirectionSprite];
	
	[self setupButton];
	
#if TARGET_OS_TV
	
	[SKUtilities2 sharedUtilities].navMode = kSKUNavModeOff;
	cursor = [SKSpriteNode spriteNodeWithColor:[SKColor greenColor] size:CGSizeMake(20, 20)];
	cursor.position = pointMultiplyByPoint(CGPointMake(0.5, 0.25), pointFromCGSize(self.size));
	cursor.zPosition = 20;
	[self addChild:cursor];
#endif
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

-(void)inputBegan:(CGPoint)location withEventDictionary:(NSDictionary *)eventDict {
}

-(void)inputMoved:(CGPoint)location withEventDictionary:(NSDictionary *)eventDict {
#if TARGET_OS_TV
	UITouch* touch = eventDict[@"touch"];
	CGPoint prevLocation = [touch previousLocationInNode:self];
	cursor.position = pointAdd(pointAdd(pointInverse(prevLocation), location), cursor.position);
	[self rotations:cursor.position];
#else
	[self rotations:location];
#endif
}

-(void)rotations:(CGPoint)location {
	orientUpNode.zRotation = orientToFromUpFace(location, orientUpNode.position);
	orientRightNode.zRotation = orientToFromRightFace(location, orientRightNode.position);
	orientLeftNode.zRotation = orientToFromLeftFace(location, orientLeftNode.position);
	orientDownNode.zRotation = orientToFromDownFace(location, orientDownNode.position);
}

-(void)inputEnded:(CGPoint)location withEventDictionary:(NSDictionary *)eventDict {
#if TARGET_OS_TV
	NSArray* nodes = [self nodesAtPoint:cursor.position];
#else
	NSArray* nodes = [self nodesAtPoint:location];
#endif
	for (SKNode* node in nodes) {
		if ([node.name isEqualToString:@"tempButton"]) {
			//next scene
			[self transferScene];
			break;
		}
	}
	
}


-(void)transferScene {
	
	_3VectorPoint* scene = [[_3VectorPoint alloc] initWithSize:self.size];
	scene.scaleMode = self.scaleMode;
	
	SKView* view = (SKView*)self.view;
	[view presentScene:scene];
	
}


-(void)update:(NSTimeInterval)currentTime {
	
	
	
}

@end
