# ![SKUtilities2 logo](https://raw.githubusercontent.com/mredig/SKUtilities2/master/SKUtilities2/OSX/osximages.xcassets/AppIcon.appiconset/Icon64.png) SKUtilities 2

* [Overview](#overview)
* [Features](#features)
* [Documentation](#documentation)
* [Getting Started](#getting-started)
	* [Objective C](#objective-c)
	* [Swift](#swift)
		* [Swift Notes](#swift-notes)
* [Requirements](#requirements)

## Overview

Intended to be an easy resource for SpriteKit projects to get quick access to common, cross platform functions.

I have learned a lot since I first started my original utilities package, and decided it'd be better to start anew than to try to fix things from the previous version. I intend to make a video series as a primer for intended usage, but the actual code is open source and available here.

## Features

* Tons of functions to automate things like:
	* Number interpolation
	* Random number generation
	* Distance calculations
	* Orientation between points
	* Various CGVector and CGPoint helpers
	* Bezier calculations (for both drawing curves and timing functions)
	* Logging assistance (Objective C only)
	* Cursor handling on OSX
* New classes to automate other things:
	* [**SKUtilities2**](http://mredig.github.io/SKUtilities2_Doc/SKUtilities2_h/index.html)
		* Singleton augmenting much functionality throughout this library. Wow.
	* [**SKUMultiLineLabelNode**](http://mredig.github.io/SKUtilities2_Doc/SKUtilities2_h/Classes/SKUMultiLineLabelNode/index.html)
		* SKLabelNode-like interface allowing for multiline labels. Sourced from Chris Allwein of Downright Simple(c). Many thanks to him for open sourcing this code!
	* [**SKUPositionObject**](http://mredig.github.io/SKUtilities2_Doc/SKUtilities2_h/Classes/SKUPositionObject/index.html)
		* Allows for storing and passing some struct data as objects (useful for NSArray, NSDictionary, NSNotifications, etc)
	* [**SKUShapeNode**](http://mredig.github.io/SKUtilities2_Doc/SKUtilities2_h/Classes/SKUShapeNode/index.html)
		* Renders shapes into textures instead of rerendering the shape every frame
	* [**SKUPushButton**](http://mredig.github.io/SKUtilities2_Doc/SKUtilities2_h/Classes/SKUPushButton/index.html)
		* Cross platform push button
	* [**SKUToggleButton**](http://mredig.github.io/SKUtilities2_Doc/SKUtilities2_h/Classes/SKUToggleButton/index.html)
		* Cross platform toggle button
	* [**SKUSliderButton**](http://mredig.github.io/SKUtilities2_Doc/SKUtilities2_h/Classes/SKUSliderButton/index.html)
		* Cross platform slider
* With support classes for some of them.
* Categories to expand upon default functionality on these classes:
	* SKColor(Mixing)
	* SKNode(ConsolidatedInput)
	* SKView(AdditionalMouseSupport)
* Built in support to handle tvOS menu navigation!

See the demo files for examples and [documentation](http://mredig.github.io/SKUtilities2_Doc/) for more detail. Videos coming soon!

### Documentation

Documentation is available [here](http://mredig.github.io/SKUtilities2_Doc/). See [Swift Notes](#swift-notes) for documentation catch.

See [license](https://raw.githubusercontent.com/mredig/SKUtilities2/master/LICENSE.txt) for rights.


### Getting Started
#### Objective C

Copy or link to the following files into your SpriteKit project (these files are conveniently located inside the folder titled "SKUtilities2-Include").

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
		SKULog(0, @"released: %@", button.name);
	}

Be able to use it on iOS, Mac OS, and tvOS (with minor additional code) from the same code!

Get input from all three platforms like this:

	-(void)inputBeganSKU:(CGPoint)location withEventDictionary:(NSDictionary *)eventDict {
		//do something with input here
	}


#### Swift

Copy or link to the following files into your SpriteKit project (these files are conveniently located inside the folder titled "SKUtilities2-Include").

* SKUtilities2.h
* SKUtilities2.m
* SKUtilities2.xcassets

Add this line to your [bridging header](https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html#//apple_ref/doc/uid/TP40014216-CH10-ID122).

	#import "SKUtilties2.h"

Add the following in a global scope in a swift file:

	let SKUSharedUtilities = SKUtilities2.sharedUtilities();

	#if os(OSX)
		typealias SKUImage = NSImage;
		typealias SKUFont = NSFont;
	#else
		typealias SKUImage = UIImage;
		typealias SKUFont = UIFont;
	#endif

Add the line "SKUSharedUtilities.updateCurrentTime(currentTime)" to the update statement of your scenes similar to this:

	override func update(currentTime: CFTimeInterval) {
		SKUSharedUtilities.updateCurrentTime(currentTime);
	}

Now you can access frame delta times and the current time from anywhere in your code, not just the update statement!

	SKUSharedUtilities.currentTime
	SKUSharedUtilities.deltaFrameTime


Have an asset that persists through more than one scene? Store it in the singleton's dictionary!


	let sprite = SKSpriteNode(color: SKColor.purpleColor(), size: CGSizeMake(10, 10));
	SKUSharedUtilities.userData = NSMutableDictionary(); //note that the dictionary is not initialized until you do it
	SKUSharedUtilities.userData["sprite"] = sprite;

Add a button like this:

	let buttonExample = SKUPushButton(title: "Button Title");
	buttonExample.position = CGPointMake(0.66, 0.25);
	buttonExample.zPosition = 1.0;
	buttonExample.setUpAction("doSomething:", toPerformOnTarget: self);
	buttonExample.name = "buttonExample";
	self.addChild(buttonExample);

Setup the method it calls like this:

	func doSomething(button: SKUButton) {
		print(button.name!, "released");
	}

Be able to use it on iOS, Mac OS, and tvOS (with minor additional code) from the same code!

Get input from all three platforms like this:

	override func inputBeganSKU(location: CGPoint, withEventDictionary eventDict: [NSObject : AnyObject]!) {
		//do something with input here
	}

#### Swift Notes:

This library was built in Objective C. While it should work in Swift just fine, there may be idiosyncrasies causing inconsistent behavior. For example:

* When using flag type enumerations, you need to use rawValue. 

		//In Objective C:
		SKUSharedUtilities.macButtonFlags = kSKUMouseButtonFlagLeft | kSKUMouseButtonFlagRight;
		//In Swift:
		SKUSharedUtilities.macButtonFlags.rawValue = kSKUMouseButtonFlagLeft.rawValue | kSKUMouseButtonFlagRight.rawValue;

* Some class methods don't import correctly and need to have [manual override](https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html#//apple_ref/doc/uid/TP40014216-CH10-ID122). I did my best to catch these, but I can't promise I caught them all. If you find any that I missed, please submit a pull request or open an issue detailing how to fix it.
	* Compatibilty with Swift caused some inconsistencies in the documentation for these methods. They appear to repeat the name twice in documentation, but don't in reality. I added a brief tag in the documentation to these offenders to help make the actual method call more readable.
	* Additionally, most initializers get automatically renamed when they contain the word "with". Example:


			//In Objective C:
			SKUPushButton* buttonExample = [SKUPushButton pushButtonWithTitle:@"Button Title"];
			//In Swift:
			let buttonExample = SKUPushButton(title: "Button Title");


* SKULog is not available in Swift.
* \#define macros don't work. To overcome the issue caused by this, you need to add some code to the swift project. Follow this [link](#swift) and use the section referring to the global scope.
* And finally, the catchall. There may be other issues I didn't experience or foresee. So other than everything, it should work right!


### Requirements:

**Xcode 7+**

Target requirements: **iOS 9+** and/or **Mac OS X 10.11+** and/or **tvOS 9+**

Honestly, I'm not 100% sure and I don't care enough to look them up just for this. I'm not your mom.
