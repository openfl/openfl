[![MIT License](https://img.shields.io/github/license/openfl/openfl.svg?style=flat)](LICENSE.md) [![NPM Version](https://img.shields.io/npm/v/openfl.svg?style=flat)](http://npmjs.com/package/openfl) [![CDNJS version](https://img.shields.io/cdnjs/v/openfl.svg?style=flat)](https://cdnjs.com/libraries/openfl) [![Haxelib Version](https://img.shields.io/github/tag/openfl/openfl.svg?style=flat&label=haxelib)](http://lib.haxe.org/p/openfl) [![Build Status](https://img.shields.io/circleci/project/github/openfl/openfl/develop.svg?style=flat)](https://circleci.com/gh/openfl/openfl) [![Discord Server](https://img.shields.io/discord/415681294446493696.svg?logo=discord)](https://discordapp.com/invite/tDgq8EE)


<br />
<p align="center"><img src="assets/openfl.png"/></p>


Purpose
=======

Interactive application and game developers need access to productive tools for forging bitmap, vector, text, sound and video together. The modern-day web browser provides many of these features, but performance for animated content, and support for hardware graphics (while still supporting software caching and fallback) is not readily available. OpenFL combines a proven set of tools for development of games and rich interactive content, going back to the first renaissance innovators on the web.


Two Versions
============

There are two versions of OpenFL, the first is primarily distributed using haxelib, and blends native support for Windows, macOS, Linux, iOS, Android, Flash, HTML5 and WebAssembly. You can read more about the haxelib distributed version of OpenFL, [here](README-haxelib.md).

The second edition of OpenFL is distributed using NPM, and is designed for use from TypeScript, JavaScript (EcmaScript 5 or 6+) or Haxe, the latter of which can be used in both versions of OpenFL. The NPM version of OpenFL is designed to be used in a browser environment. The NPM version also has (beta) support for ActionScript 3.0.


Getting Started
===============

The simplest way to get started is to use Yeoman to create a new project:

```bash
npm install -g yo generator-openfl
mkdir NewProject
cd NewProject
yo openfl
```

You will have the opportunity to choose TypeScript, Haxe, ES6 or ES5 as the source language for your new project.

The template project will include configuration files for Webpack, as well as a source code entry point where you can begin writing a new project. In order to begin using OpenFL, you can try adding support for loading and displaying an image (_[continued below](#displaying-a-bitmap)_).


Features
========

The DOM (Document Object Model) is a convenient method of nesting and arranging visual content, but it is known to be slow. Use of the DOM is discouraged for animated content, unless steps are taken to limit the number of reflows. Normally to improve performance, a developer is forced to use either canvas 2D or WebGL, creating a new problem with writing new rendering code, and losing what made the DOM easy to work with.

OpenFL provides a standard object model, along with additional features useful for animation and interactive development.

## Rendering

 * WebGL 1 and 2
 * Canvas 2D
 * CSS 2D transforms (DOM)

## Object Model

 * Matrix transforms
 * Color transforms
 * Hit testing
 * Event propagation
 * Bitmap caching
 * Filters (limited)
 * Masking and scroll rectangles

## Vector Graphics

 * Solid, bitmap and gradient fills
 * Quadratic and cubic bézier curves
 * Ellipses, circles and paths
 * Rectangles and rounded rectangles
 * Lines with cap, joint and miter styles

## Bitmap Data

 * Seamless support for image, canvas and typed array pixel stores
 * Transparency and premultiplied alpha
 * Get, set and copy pixels
 * Fill and flood fill
 * Color bounds calculation
 * Threshold operations
 * Render-to-texture
 * Output PNG and JPEG bytes
 * Channel blending between images
 * Noise and perlin noise (limited)
 * Palette swapping
 * Difference images
 * Scrolling

## Text Support

 * Font, color and alignment
 * Selectable text input
 * Auto-size and alignment
 * Background and border
 * Plain or simple HTML text
 * Multi-line, restrict or password
 * Character metrics
 * Selection
 * Text replacement

## Sound Support

 * Sound playback
 * Global sound mixing
 * Time, loops, sound transforms

## Geometry Types

 * 2D (3x3) matrix
 * 3D (4x4) matrix
 * Orientation and perspective
 * Points and vectors
 * Rectangle

## Networking

 * Save data to disk
 * Local storage
 * Web sockets
 * HTTP requests

## Input

 * Mouse and touch
 * Keyboard
 * Gamepad

## Other Features

 * Batched tile rendering
 * Video rendering
 * Asset management
 * MovieClip animations


Displaying a Bitmap
===================

Create a new project using `yo openfl`

```bash
mkdir DisplayingABitmap
cd DisplayingABitmap
yo openfl
```

Next, download [openfl.png](assets/openfl.png) and save it your new "dist" directory.

Next, use Visual Studio Code or another code editor to open "src/app.ts", "src/app.js" or "src/App.hx", depending upon the language type you used when you created the project. We will need to add a couple more imports, and a little code to load and display an image.

## TypeScript

At the top of the file, add new imports:

```typescript
import Bitmap from "openfl/display/Bitmap";
import BitmapData from "openfl/display/BitmapData";
```

Then extend the `constructor` method so it looks like this:

```typescript
constructor () {
	
	super ();
	
	BitmapData.loadFromFile ("openfl.png").onComplete ((bitmapData) => {
		
		var bitmap = new Bitmap (bitmapData);
		this.addChild (bitmap);
		
	});
	
}
```

## Haxe

At the top of the file, add new imports:

```haxe
import openfl.display.Bitmap;
import openfl.display.BitmapData;
```

Then extend the `new` method so it looks like this:

```haxe
public function new () {
	
	super ();
	
	BitmapData.loadFromFile ("openfl.png").onComplete (function (bitmapData) {
		
		var bitmap = new Bitmap (bitmapData);
		addChild (bitmap);
		
	});
	
}
```

## ES6 JavaScript

At the top of the file, add new imports:

```typescript
import Bitmap from "openfl/display/Bitmap";
import BitmapData from "openfl/display/BitmapData";
```

Then extend the `constructor` method so it looks like this:

```typescript
constructor () {
	
	super ();
	
	BitmapData.loadFromFile ("openfl.png").onComplete ((bitmapData) => {
		
		var bitmap = new Bitmap (bitmapData);
		this.addChild (bitmap);
		
	});
	
}
```

## ES5 JavaScript

At the top of the file, add new require statements:

```typescript
var Bitmap = require ("openfl/display/Bitmap").default;
var BitmapData = require ("openfl/display/BitmapData").default;
```

Then extend the `App` constructor so it looks like this:

```typescript
var App = function () {
	
	Sprite.call (this);
	
	BitmapData.loadFromFile ("openfl.png").onComplete (function (bitmapData) {
		
		var bitmap = new Bitmap (bitmapData);
		this.addChild (bitmap);
		
	}.bind (this));
	
}
```

## Running the Project

You can start a development server by going to the root directory of your project, and running `npm start`. In addition to compiling your application, it will open a new window in your web browser, with hot reloading enabled. This means that if you edit the `app.ts`, `app.js` or `App.hx` source file, the server will automatically compile your changes, and reload the current window, speeding up development. Now we can making more changes.


## Adding Changes

You can continue make changes to your `app.ts`, `app.js` or `App.hx` file, to manipulate your bitmap after it is loaded.

For example:

```haxe
bitmap.x = 10;
bitmap.y = 200;
bitmap.rotation = 45;
bitmap.alpha = 0.5;
```

## Other Samples

There are more sample projects with additional features (such as sound, animation and video) in each of the OpenFL samples repositories:

 - https://github.com/openfl/openfl-samples-ts
 - https://github.com/openfl/openfl-samples-haxe
 - https://github.com/openfl/openfl-samples-es6
 - https://github.com/openfl/openfl-samples-es5
 - https://github.com/openfl/openfl-samples-as3

Each of the samples can be tested using `npm install` then `npm start`


Additional Reading
==================

Go to http://www.openfl.org for more information on OpenFL, and visit http://community.openfl.org to ask questions and get help!


License
=======

OpenFL is free, open-source software under the [MIT license](LICENSE.md).


Development Builds
==================

Clone the OpenFL repository:

```bash
git clone https://github.com/openfl/openfl
```

## Using OpenFL with NPM

First, install any NPM dependencies:

```bash
cd openfl
npm install
```

Optionally, you may choose to link with a clone of a dependency library (such as `lime`):

```bash
cd path/to/lime
npm link

cd path/to/openfl
npm link lime
```

Build OpenFL:

```bash
npm run build -s
```

Once built, you may want to `npm link` to use your version with other projects:

```bash
npm link

cd path/to/your-project
npm link openfl
```

## Using OpenFL with Haxelib

First, tell haxelib where your development copy of OpenFL is installed:

    haxelib dev openfl openfl

Second, you may want to build the OpenFL tools for processing SWF assets:

    openfl rebuild tools

Later, if you decide to return to release builds:

    haxelib dev openfl

_You may also need a development build of Lime installed._
