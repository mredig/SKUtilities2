//
//  02rotationScene.m
//  SKUtilities2
//
//  Created by Michael Redig on 9/26/15.
//  Copyright © 2015 Michael Redig. All rights reserved.
//

#import "02rotationScene.h"
#import "SKUtilities2.h"

@interface _2rotationScene() {
	
	SKSpriteNode* orientUpNode;
	SKSpriteNode* orientRightNode;
	SKSpriteNode* orientDownNode;
	SKSpriteNode* orientLeftNode;
}

@end

@implementation _2rotationScene

-(void) didMoveToView:(SKView *)view {
	
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
	
	
}

-(void)mouseDown:(NSEvent *)theEvent {
	CGPoint location = [theEvent locationInNode:self];
	
	orientUpNode.zRotation = orientToFromUpFace(location, orientUpNode.position);
	orientRightNode.zRotation = orientToFromRightFace(location, orientRightNode.position);
	orientLeftNode.zRotation = orientToFromLeftFace(location, orientLeftNode.position);
	orientDownNode.zRotation = orientToFromDownFace(location, orientDownNode.position);
}

-(void)mouseDragged:(NSEvent *)theEvent {
	CGPoint location = [theEvent locationInNode:self];
	orientUpNode.zRotation = orientToFromUpFace(location, orientUpNode.position);
	orientRightNode.zRotation = orientToFromRightFace(location, orientRightNode.position);
	orientLeftNode.zRotation = orientToFromLeftFace(location, orientLeftNode.position);
	orientDownNode.zRotation = orientToFromDownFace(location, orientDownNode.position);
}

-(void)update:(NSTimeInterval)currentTime {
	
	
	
}

@end
