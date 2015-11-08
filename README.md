# SKUtilities 2

## Overview

Intended to be an easy resource for SpriteKit projects to get quick access to common, cross platform functions. What’s easiest? Making a separate button for tvOS, iOS, and Mac OS, or just making one that works on all three? Manually typing in your distance equation every time, creating your own convenience method, or having it already created for you so all you have to do is call the function and input your coordinates?

I have learned a lot since I first started my original utilities package, and decided it'd be better to start anew than to try to fix things from the previous version. I intend to make a video series as a primer for intended usage, but the actual code is open source and available here.



### Documentation

Documentation is available [here](http://mredig.github.io/SKUtilities2_Doc/).

### Getting Started

Copy or link to the following files into your SpriteKit project. This is assuming you're using Objective C. Swift is coming later.

* SKUtilities2.h
* SKUtilities2.m
* SKUtilities2.xcassets

Add this line to the list of import statements at the top of your files

	#import "SKUtilties2.h"

Add the line "[SKUSharedUtilities updateCurrentTime:currentTime];" to the update statement of your scenes similar to this:

	-(void)update:(NSTimeInterval)currentTime {
		[SKUSharedUtilities updateCurrentTime:currentTime];
	}

Add a button like this:

	SKUPushButton* buttonExample = [SKUPushButton pushButtonWithTitle:@"Button Title"];
	buttonExample.position = CGPointMake(0.66, 0.25);
	buttonExample.zPosition = 1.0;
	[buttonExample setUpAction:@selector(doSomething:) toPerformOnTarget:self];
	buttonExample.name = @"buttonExample";
	[self addChild:buttonExample];

Setup the method it calls like this:

	-(void)doSomething:(SKUButton*)button {
		SKULog(0, @"pressed: %@", button.name);
	}

Be able to use it on iOS, Mac OS, and tvOS (with minor additional code) from the same code!

Get input from all three platforms like this:

	-(void)inputBeganSKU:(CGPoint)location withEventDictionary:(NSDictionary *)eventDict {
		//do something with input here
	}

New classes are:

* SKUtilities2
* SKU_MultiLineLabelNode
* SKU_PositionObject
* SKU_ShapeNode
* SKUPushButton
* SKUSliderButton
* SKUToggleButton

With support classes for some of them.

Categories to expand upon default functionality on these classes:

* SKColor(Mixing)
* SKNode(ConsolidatedInput)
* SKView(AdditionalMouseSupport)

And built in support to handle tvOS menu navigation!

See the demo files for examples and [documentation](http://mredig.github.io/SKUtilities2_Doc/) for more detail. Videos coming soon!