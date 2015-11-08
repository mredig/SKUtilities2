# SKUtilities 2

## Overview

Intended to be an easy resource for SpriteKit projects to get quick access to common, cross platform functions.

I have learned a lot since I first started my original utilities package, and decided it'd be better to start anew than to try to fix things from the previous version. I intend to make a video series as a primer for intended usage, but the actual code is open source and available here.


### Documentation

Documentation is available [here](http://mredig.github.io/SKUtilities2_Doc/).

See [license](https://raw.githubusercontent.com/mredig/SKUtilities2/master/LICENSE.txt) for rights.

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

Now you can access frame delta times and the current time from anywhere in your code, not just the update statement!

	SKUSharedUtilities.currentTime
	SKUSharedUtilities.deltaFrameTime


Have an asset that persists through more than one scene? Store it in the singleton's dictionary!

	SKSpriteNode* sprite;
	SKUSharedUtilities.userData = [NSMutableDictionary dictionary]; //note that the dictionary is not initialized until you do it
	[SKUSharedUtilities.userData setObject:sprite forKey:@"sprite"];

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

* **SKUtilities2**
	* Singleton augmenting much functionality throughout this library. Wow.
* **SKUMultiLineLabelNode**
	* SKLabelNode-like interface allowing for multiline labels. Sourced from Chris Allwein of Downright Simple(c). Many thanks to him for open sourcing this code!
* **SKUPositionObject**
	* Allows for storing and passing some struct data as objects (useful for NSArray, NSDictionary, NSNotifications, etc)
* **SKUShapeNode**
	* Renders shapes into textures instead of rerendering the shape every frame
* **SKUPushButton**
	* Cross platform push button
* **SKUToggleButton**
	* Cross platform toggle button
* **SKUSliderButton**
	* Cross platform slider

With support classes for some of them.

Categories to expand upon default functionality on these classes:

* SKColor(Mixing)
* SKNode(ConsolidatedInput)
* SKView(AdditionalMouseSupport)

And built in support to handle tvOS menu navigation!

See the demo files for examples and [documentation](http://mredig.github.io/SKUtilities2_Doc/) for more detail. Videos coming soon!

### Requirements:

**Xcode 7+**

Target requirements:
**iOS 9+**
and/or 
**Mac OS X 10.11+** 
and/or
**tvOS 9+**

Honestly, I'm not 100% sure and I don't care enough to look them up just for this. I'm not your mom.
SpriteKit project