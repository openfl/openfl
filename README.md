[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE.md) [![NPM Version](https://img.shields.io/npm/v/openfl.svg?style=flat)](http://npmjs.com/package/openfl) [![Haxelib Version](https://img.shields.io/github/tag/openfl/openfl.svg?style=flat&label=haxelib)](http://lib.haxe.org/p/openfl) [![Build Status](https://img.shields.io/circleci/project/github/openfl/openfl/develop.svg)](https://circleci.com/gh/openfl/openfl)


<br />
<p align="center"><img src="assets/openfl.png"/></p>


Purpose
=======

Interactive application and game developers need access to productive tools for forging bitmap, vector, text, sound and video together. The modern-day web browser provides many of these features, but performance for animated content, and support for hardware graphics (while still supporting software caching and fallback) is not readily available. OpenFL combines a proven set of tools for development of games and rich interactive content, going back to the first renaissance innovators on the web.


Two Versions
============

There are two versions of OpenFL, the first is primarily distributed using haxelib, and blends native support for Windows, macOS, Linux, iOS, Android, Flash, HTML5 and WebAssembly. You can read more about the haxelib distributed version of OpenFL, [here](README-haxelib.md).

The second edition of OpenFL is distributed using NPM, and is designed for use from TypeScript, JavaScript (EcmaScript 5 or 6+) or Haxe, the latter of which can be used in both versions of OpenFL. The NPM version of OpenFL is designed to be used in a browser environment.


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

The template project will include configuration files for Webpack, as well as a source code entry point where you can begin writing a new project. In order to begin using OpenFL, you can try adding support for loading and displaying an image.

## Displaying a Bitmap

First, download [openfl.png](assets/openfl.png) and save it your "dist" directory.

Next, use Visual Studio Code or another code editor to open "src/app.ts", "src/app.js" or "src/App.hx", depending upon the language type you used when you created the project. We will need to add a couple more imports, and a little code to load and display an image.

### TypeScript

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

### Haxe

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
		this.addChild (bitmap);
		
	});
	
}
```

### ES6 JavaScript

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

### ES5 JavaScript

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

## More Samples

There are more sample projects with additional features (such as sound, animation and video) in each of the OpenFL samples repositories:

 - https://github.com/openfl/openfl-samples-ts
 - https://github.com/openfl/openfl-samples
 - https://github.com/openfl/openfl-samples-es6
 - https://github.com/openfl/openfl-samples-es5

Each of the samples can be tested using `npm install` then `npm start`


More Reading
============

Go to http://www.openfl.org for more information on OpenFL, and visit http://community.openfl.org to ask questions and get help!


License
=======

OpenFL is free, open-source software under the [MIT license](LICENSE.md).


NPM Development Builds
======================

Clone the OpenFL repository:

```bash
git clone https://github.com/openfl/openfl
```

If you are using a development version of `hxgenjs` or `lime`, use `npm link`

```bash
cd path/to/lime
npm link
cd path/to/hxgenjs
npm link

cd path/to/openfl
npm link lime
npm link hxgenjs
```

Install development dependencies for OpenFL:

```bash
cd openfl
npm install
```

Generate ES6 modules for OpenFL:

```bash
npm run build
```

Then you may want to `npm link` OpenFL when testing other projects

```bash
npm link

cd path/to/other-project
npm link openfl
```
