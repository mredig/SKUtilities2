//
//  shapeBenchmark.m
//  SKUtilities2
//
//  Created by Michael Redig on 10/10/15.
//  Copyright © 2015 Michael Redig. All rights reserved.
//

#import "shapeBenchmark.h"
#import "SKUtilities2.h"
#import "06MultiLineDemo.h"


#import <mach/mach.h>

float cpu_usage()
{
	kern_return_t kr;
	task_info_data_t tinfo;
	mach_msg_type_number_t task_info_count;
	
	task_info_count = TASK_INFO_MAX;
	kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
	if (kr != KERN_SUCCESS) {
		return -1;
	}
	
	task_basic_info_t      basic_info;
	thread_array_t         thread_list;
	mach_msg_type_number_t thread_count;
	
	thread_info_data_t     thinfo;
	mach_msg_type_number_t thread_info_count;
	
	thread_basic_info_t basic_info_th;
	uint32_t stat_thread = 0; // Mach threads
	
	basic_info = (task_basic_info_t)tinfo;
	
	// get threads in the task
	kr = task_threads(mach_task_self(), &thread_list, &thread_count);
	if (kr != KERN_SUCCESS) {
		return -1;
	}
	if (thread_count > 0)
		stat_thread += thread_count;
	
	long tot_sec = 0;
	long tot_usec = 0;
	float tot_cpu = 0;
	int j;
	
	for (j = 0; j < thread_count; j++)
	{
		thread_info_count = THREAD_INFO_MAX;
		kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
						 (thread_info_t)thinfo, &thread_info_count);
		if (kr != KERN_SUCCESS) {
			return -1;
		}
		
		basic_info_th = (thread_basic_info_t)thinfo;
		
		if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
			tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
			tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
			tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
		}
		
	} // for each thread
	
	kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
	assert(kr == KERN_SUCCESS);
	
	return tot_cpu;
}


@interface shapeBenchmark() {
	NSMutableSet* shapesSet;
	
	NSTimeInterval startTime;
	
	NSUInteger squareBase;
	
	SKLabelNode* renderTimeLabel;
	SKLabelNode* cpuUsageLabel;
	
	NSInteger frameStep;
	CGFloat frameTimeAccumulation;
}

@end

@implementation shapeBenchmark


-(void)didMoveToView:(SKView *)view {
	shapesSet = [NSMutableSet set];
	squareBase = 20;
	[self setupLabels];
	[self setupButton];
	
}

-(void)skuButtonUp:(SKUButton*)button {
	[self benchmarkSKUShapes];
}

-(void)skButtonUp:(SKUButton*)button {
	[self benchmarkSKShapeNodes];
}

-(void)setupLabels {
	
	SKSpriteNode* labelBackdrop = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5] size:CGSizeMake(350, 200)];
	labelBackdrop.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(0.5, 0.75));
	labelBackdrop.zPosition = 0.1;
	[self addChild:labelBackdrop];
	
	renderTimeLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue Light"];
	renderTimeLabel.position = CGPointMake(-170, 50.0);
	renderTimeLabel.fontColor = [SKColor whiteColor];
	renderTimeLabel.fontSize = 35.0f;
	renderTimeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
	renderTimeLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
	renderTimeLabel.text = @"RenderTime:";
	[labelBackdrop addChild:renderTimeLabel];
	
	cpuUsageLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue Light"];
	cpuUsageLabel.position = CGPointMake(-170, -50.0);
	cpuUsageLabel.fontColor = [SKColor whiteColor];
	cpuUsageLabel.fontSize = 35.0f;
	cpuUsageLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
	cpuUsageLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
	cpuUsageLabel.text = @"CPU: ";
	[labelBackdrop addChild:cpuUsageLabel];
}

-(void)setupButton {
	
	SKTexture* tex = [SKTexture textureWithImageNamed:@"Spaceship_small"];
	
	SKUButtonLabelProperties* labelProps = [SKUButtonLabelProperties propertiesWithText:@"SKUShapeNode" andColor:[SKColor whiteColor] andSize:50 andFontName:@"Helvetica Neue"];
	SKUButtonLabelPropertiesPackage* labelPack = [SKUButtonLabelPropertiesPackage packageWithPropertiesForDefaultState:labelProps];
	
	SKUButtonSpriteStateProperties* spriteProps = [SKUButtonSpriteStateProperties propertiesWithTexture:tex andAlpha:1.0];
	SKUButtonSpriteStatePropertiesPackage* spritePack = [SKUButtonSpriteStatePropertiesPackage packageWithPropertiesForDefaultState:spriteProps];
	
	SKUPushButton* skuButton = [SKUPushButton pushButtonWithBackgroundPropertiesPackage:spritePack andTitleLabelPropertiesPackage:labelPack];
	skuButton.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(0.25, 0.5));
	[skuButton setUpAction:@selector(skuButtonUp:) toPerformOnTarget:self];
	skuButton.zPosition = 1.0;
	[self addChild:skuButton];
	
	SKUButtonLabelPropertiesPackage* labelPack2 = labelPack.copy;
	[labelPack2 changeText:@"SKShapeNode"];
	
	SKUPushButton* skButton = [SKUPushButton pushButtonWithBackgroundPropertiesPackage:spritePack andTitleLabelPropertiesPackage:labelPack2];
	skButton.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(0.75, 0.5));
	[skButton setUpAction:@selector(skButtonUp:) toPerformOnTarget:self];
	skButton.zPosition = 1.0;
	[self addChild:skButton];
	
	SKUButtonLabelPropertiesPackage* labelPackNext = SKUSharedUtilities.userData[@"buttonLabelPackage"];
	SKUButtonSpriteStatePropertiesPackage* backgroundPack = SKUSharedUtilities.userData[@"buttonBackgroundPackage"];
	SKUPushButton* nextSlide = [SKUPushButton pushButtonWithBackgroundPropertiesPackage:backgroundPack andTitleLabelPropertiesPackage:labelPackNext];
	nextSlide.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(0.5, 0.33)) ;
	nextSlide.zPosition = 1.0;
	[nextSlide setUpAction:@selector(transferScene:) toPerformOnTarget:self];
	nextSlide.name = @"next";
	[self addChild:nextSlide];
	
	SKUButtonLabelPropertiesPackage* labelPackClear = labelPackNext.copy;
	[labelPackClear changeText:@"Clear Nodes"];
	SKUPushButton* clearNodes = [SKUPushButton pushButtonWithBackgroundPropertiesPackage:backgroundPack andTitleLabelPropertiesPackage:labelPackClear];
	clearNodes.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(0.5, 0.2)) ;
	clearNodes.zPosition = 1.0;
	[clearNodes setUpAction:@selector(clearNodes:) toPerformOnTarget:self];
	clearNodes.name = @"clearNodes";
	[self addChild:clearNodes];
	
#if TARGET_OS_TV
	
	SKUSharedUtilities.navMode = kSKUNavModeOn;
	[self addNodeToNavNodesSKU:skuButton];
	[self addNodeToNavNodesSKU:skButton];
	[self addNodeToNavNodesSKU:nextSlide];
	[self addNodeToNavNodesSKU:clearNodes];
	
	[self setCurrentSelectedNodeSKU:nextSlide];
	
	[SKUSharedUtilities setNavFocus:self];
	
#endif
	
}

-(void)clearNodes:(SKUButton*)button {
	for (SKNode* node in shapesSet) {
		[node removeFromParent];
	}
	[shapesSet removeAllObjects];
}

-(void)timerStart {
	startTime = CFAbsoluteTimeGetCurrent();
}

-(void)timerStop {
	NSTimeInterval endtime = CFAbsoluteTimeGetCurrent();
	NSTimeInterval total = endtime - startTime;
	NSLog(@"generation time: %f", total);
	renderTimeLabel.text = [NSString stringWithFormat:@"RenderTime: %.5f", total];

}

-(void)benchmarkSKUShapes {
	[self clearNodes:nil];
	[self timerStart];
	
	for (int y = 0; y < squareBase; y ++) {
		for (int x = 0; x < squareBase; x++) {
			SKU_ShapeNode* shape = [SKU_ShapeNode circleWithRadius:fmin(self.size.width, self.size.height)/(squareBase*2.0) andColor:[SKColor redColor]];
			shape.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(x/(CGFloat)squareBase, y/(CGFloat)squareBase));
			shape.position = pointAdd(shape.position, CGPointMake( 0.5 * (1.0/(CGFloat)squareBase) * self.size.width,  0.5 * (1.0/(CGFloat)squareBase) * self.size.height));
			[self addChild:shape];
			[shapesSet addObject:shape];
		}
	}
	
	[self timerStop];
}


-(void)benchmarkSKShapeNodes {
	[self clearNodes:nil];
	[self timerStart];
	for (int y = 0; y < squareBase; y ++) {
		for (int x = 0; x < squareBase; x++) {
			SKShapeNode* shape = [SKShapeNode shapeNodeWithCircleOfRadius:fmin(self.size.width, self.size.height)/(squareBase*2.0)];
			shape.fillColor = [SKColor redColor];
			shape.strokeColor = [SKColor clearColor];
			shape.position = pointMultiplyByPoint(pointFromCGSize(self.size), CGPointMake(x/(CGFloat)squareBase, y/(CGFloat)squareBase));
			shape.position = pointAdd(shape.position, CGPointMake( 0.5 * (1.0/(CGFloat)squareBase) * self.size.width,  0.5 * (1.0/(CGFloat)squareBase) * self.size.height));
			[self addChild:shape];
			[shapesSet addObject:shape];
		}
	}
	[self timerStop];
}


-(void)transferScene:(SKUButton*)button {
	
	_6MultiLineDemo* scene = [[_6MultiLineDemo alloc] initWithSize:self.size];
	scene.scaleMode = self.scaleMode;
	
	SKView* view = (SKView*)self.view;
	[view presentScene:scene];
	
}


-(void)update:(CFTimeInterval)currentTime {
	/* Called before each frame is rendered */
	[SKUSharedUtilities updateCurrentTime:currentTime];
	
	frameStep ++;
	if (frameStep == 30) {
		float cpu = cpu_usage();
		cpuUsageLabel.text = [NSString stringWithFormat:@"CPU: %.3f", cpu];
		frameStep = 0;
	}
}



@end
