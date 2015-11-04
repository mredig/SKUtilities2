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
#import "01NumbersDemo.h"

@interface _2rotationScene() {
	
	SKSpriteNode* orientUpNode;
	SKSpriteNode* orientRightNode;
	SKSpriteNode* orientDownNode;
	SKSpriteNode* orientLeftNode;
	
	SKSpriteNode* cursor;
	
	NSInteger verbosityLevelRequired;
}

@end

@implementation _2rotationScene

-(void) didMoveToView:(SKView *)view {
	
	self.name = @"02RotationScene";
	self.backgroundColor = [SKColor grayColor];

	verbosityLevelRequired = 0;
	
	SKULog( verbosityLevelRequired, @"\n\n\n\n02RotationScene: demos orientation functions");

	
	orientUpNode = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
	orientUpNode.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.25);
	orientUpNode.name = @"orientUpNode";
	[self addChild:orientUpNode];
	
	SKLabelNode* upLabel = [SKLabelNode labelNodeWithText:@"upFace"];
	upLabel.fontSize = 40;
	upLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
	upLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
	upLabel.zPosition = 1;
	upLabel.fontColor = [SKColor blackColor];
	upLabel.name = @"upLabel";
	[orientUpNode addChild:upLabel];
	
	SKSpriteNode* upDirectionSprite = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(10.0, 200.0)];
	upDirectionSprite.anchorPoint = CGPointMake(0.5, 0.0);
	upDirectionSprite.zPosition = 0.5;
	upDirectionSprite.name = @"upDirectionSprite";
	[orientUpNode addChild:upDirectionSprite];
	
	
	orientRightNode = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
	orientRightNode.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.25);
	orientRightNode.name = @"orientRightNode";
	[self addChild:orientRightNode];
	
	SKLabelNode* rightLabel = [SKLabelNode labelNodeWithText:@"rightFace"];
	rightLabel.fontSize = 40;
	rightLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
	rightLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
	rightLabel.zPosition = 1;
	rightLabel.fontColor = [SKColor blackColor];
	rightLabel.name = @"rightLabel";
	[orientRightNode addChild:rightLabel];
	
	SKSpriteNode* rightDirectionSprite = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(200.0, 10.0)];
	rightDirectionSprite.anchorPoint = CGPointMake(0.0, 0.5);
	rightDirectionSprite.zPosition = 0.5;
	rightDirectionSprite.name = @"rightDirectionSprite";
	[orientRightNode addChild:rightDirectionSprite];
	
	
	orientLeftNode = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
	orientLeftNode.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.75);
	orientLeftNode.name = @"orientLeftNode";
	[self addChild:orientLeftNode];
	
	SKLabelNode* leftLabel = [SKLabelNode labelNodeWithText:@"leftFace"];
	leftLabel.fontSize = 40;
	leftLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
	leftLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
	leftLabel.zPosition = 1;
	leftLabel.fontColor = [SKColor blackColor];
	leftLabel.name = @"leftLabel";
	[orientLeftNode addChild:leftLabel];
	
	
	SKSpriteNode* leftDirectionSprite = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(200.0, 10.0)];
	leftDirectionSprite.anchorPoint = CGPointMake(1.0, 0.5);
	leftDirectionSprite.zPosition = 0.5;
	leftDirectionSprite.name = @"leftDirectionSprite";
	[orientLeftNode addChild:leftDirectionSprite];
	
	
	orientDownNode = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
	orientDownNode.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.75);
	orientDownNode.name = @"orientDownNode";
	[self addChild:orientDownNode];
	
	SKLabelNode* downLabel = [SKLabelNode labelNodeWithText:@"downFace"];
	downLabel.fontSize = 40;
	downLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
	downLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
	downLabel.zPosition = 1;
	downLabel.fontColor = [SKColor blackColor];
	downLabel.name = @"downLabel";
	[orientDownNode addChild:downLabel];
	
	SKSpriteNode* downDirectionSprite = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(10.0, 200.0)];
	downDirectionSprite.anchorPoint = CGPointMake(0.5, 1.0);
	downDirectionSprite.zPosition = 0.5;
	downDirectionSprite.name = @"downDirectionSprite";
	[orientDownNode addChild:downDirectionSprite];
	
	[self setupButton];
}

-(void)setupButton {
	SKUButtonLabelPropertiesPackage* labelPack = SKUSharedUtilities.userData[@"buttonLabelPackage"];
	SKUButtonSpriteStatePropertiesPackage* backgroundPack = SKUSharedUtilities.userData[@"buttonBackgroundPackage"];
	SKUPushButton* nextSlide = [SKUPushButton pushButtonWithBackgroundPropertiesPackage:backgroundPack andTitleLabelPropertiesPackage:labelPack];
	nextSlide.position = pointMultiplyByPoint(midPointOfRect(self.frame), CGPointMake(1.0, 0.5));
	nextSlide.zPosition = 1.0;
	[nextSlide setUpAction:@selector(transferScene:) toPerformOnTarget:self];
	[self addChild:nextSlide];
	
	SKUPushButton* prevSlide = [SKUPushButton pushButtonWithText:@"Previous Scene"];
	prevSlide.position = pointAdd(nextSlide.position, CGPointMake(0, 100));
	prevSlide.zPosition = 1.0;
	[prevSlide setUpAction:@selector(prevScene:) toPerformOnTarget:self];
	[self addChild:prevSlide];
	
#if TARGET_OS_TV
	
	SKUSharedUtilities.navMode = kSKUNavModeOn;
	cursor = [SKSpriteNode spriteNodeWithColor:[SKColor greenColor] size:CGSizeMake(20, 20)];
	cursor.position = pointMultiplyByPoint(CGPointMake(0.5, 0.5), pointFromCGSize(self.size));
	cursor.zPosition = 20;
	cursor.hidden = HIDDEN;
	[self addChild:cursor];
	
	SKLabelNode* menuNotice = [SKLabelNode labelNodeWithText:@"Press Menu to return to nav mode"];
	menuNotice.fontSize = 28.0;
	menuNotice.position = midPointOfRect(self.frame);
	menuNotice.name = @"menuNotice";
	[self addChild:menuNotice];
	menuNotice.hidden = HIDDEN;
	
	SKUButtonLabelPropertiesPackage* labelPack2 = labelPack.copy;
	[labelPack2 changeText:@"Demo Rotation"];
	SKUPushButton* activateCursor = [SKUPushButton pushButtonWithBackgroundPropertiesPackage:backgroundPack andTitleLabelPropertiesPackage:labelPack2];
	activateCursor.position = pointAdd(nextSlide.position, CGPointMake(0, -100));
	activateCursor.zPosition = 1.0;
	[activateCursor setUpAction:@selector(toggleDemoMode:) toPerformOnTarget:self];
	[self addChild:activateCursor];
	
	[self addNodeToNavNodesSKU:nextSlide];
	[self addNodeToNavNodesSKU:prevSlide];
	[self addNodeToNavNodesSKU:activateCursor];
	[self setCurrentSelectedNodeSKU:nextSlide];
	
	[SKUSharedUtilities setNavFocus:self];
	
}

-(void)menuPressed:(UIGestureRecognizer*)gesture {
	[self toggleDemoMode:nil];
	[self.view removeGestureRecognizer:gesture];
}

-(void)toggleDemoMode:(SKUButton*)button {
	if (SKUSharedUtilities.navMode == kSKUNavModeOn) {
		SKUSharedUtilities.navMode = kSKUNavModeOff;
		cursor.hidden = VISIBLE;
		[self childNodeWithName:@"menuNotice"].hidden = VISIBLE;
		UITapGestureRecognizer* menuPressed = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuPressed:)];
		menuPressed.allowedPressTypes = @[[NSNumber numberWithInteger:UIPressTypeMenu]];
		[self.view addGestureRecognizer:menuPressed];
	} else {
		SKUSharedUtilities.navMode = kSKUNavModeOn;
		cursor.hidden = HIDDEN;
		[self childNodeWithName:@"menuNotice"].hidden = HIDDEN;
	}
#endif
}



-(void)relativeInputMovedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary *)eventDict {
	[super relativeInputMovedSKU:location withDelta:delta withEventDictionary:eventDict];
	if (cursor.hidden == VISIBLE) {
		cursor.position = pointAdd(delta, cursor.position);
		[self rotations:cursor.position];
	}
}

-(void)absoluteInputMovedSKU:(CGPoint)location withDelta:(CGPoint)delta withEventDictionary:(NSDictionary *)eventDict {
	[self rotations:location];
}


-(void)rotations:(CGPoint)location {
	orientUpNode.zRotation = orientToFromUpFace(location, orientUpNode.position);
	orientRightNode.zRotation = orientToFromRightFace(location, orientRightNode.position);
	orientLeftNode.zRotation = orientToFromLeftFace(location, orientLeftNode.position);
	orientDownNode.zRotation = orientToFromDownFace(location, orientDownNode.position);
}


-(void)prevScene:(SKUButton*)button {
	
	_1NumbersDemo* scene = [[_1NumbersDemo alloc] initWithSize:self.size];
	scene.scaleMode = self.scaleMode;
	
	SKView* view = (SKView*)self.view;
	[view presentScene:scene];
	
}

-(void)transferScene:(SKUButton*)button {
	
	_3VectorPoint* scene = [[_3VectorPoint alloc] initWithSize:self.size];
	scene.scaleMode = self.scaleMode;
	
	SKView* view = (SKView*)self.view;
	[view presentScene:scene];
	
}


-(void)update:(NSTimeInterval)currentTime {
	
	
	
}

@end
