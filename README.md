[![Stories in Ready](https://badge.waffle.io/openfl/openfl.png?label=ready)](https://waffle.io/openfl/openfl)

<p align="center"><img src="openfl.png"/></p>

Introduction
============

OpenFL (Open Flash Library) is a fast, open-source implementation of the industry-standard Flash API. Unlike the Adobe implementation, OpenFL uses hardware rendering, compiles to native C++ for target platforms and reaches many more platforms than Adobe AIR. OpenFL is also 100% compatible with Flash Player, so you can still target Flash in the browser, or even AIR if you want.

Also unlike Adobe Flash, OpenFL uses the [Haxe](http://haxe.org/) programming language. Before Adobe abandoned the "ActionScript Next" project, they detailed the pitfalls of ActionScript, and how they felt the language needed to improve. If you have a history performing ActionScript 3 development, you can almost approach Haxe as if it were ActionScript 4. It is powerful, flexible, has many more features and the first version of Haxe (with AVM2 support) was even released before ActionScript 3 -- Haxe (and before it, MTASC) has a long history of supporting Flash.

Platforms
=========

OpenFL officially supports the following platforms:

 * Windows
 * Mac
 * Linux
 * iOS
 * Android
 * BlackBerry
 * Tizen
 * Flash 

There are also complementary projects that target HTML5 canvas, including [openfl-html5-dom](https://github.com/openfl/openfl-html5-dom) and [openfl-bitfive](https://github.com/YellowAfterlife/openfl-bitfive), but we would love to see continued innovation in this space, such as an expanded version of pixi.js, or seamless StageXL support, since Haxe compiles directly to clean JavaScript.

Libraries
=========

OpenFL is compatible with [many libraries](http://lib.haxe.org/all), ported from ActionScript or written especially in Haxe, including:

 * [HaxeFlixel](https://github.com/haxeflixel/flixel)
 * [HaxePunk](https://github.com/HaxePunk/HaxePunk)
 * [NAPE](https://github.com/deltaluca/nape)
 * [Box2D](https://github.com/jgranick/Box2D)
 * [Actuate](https://github.com/jgranick/Actuate)

OpenFL also powers other platforms, such as [Stencyl](http://www.stencyl.com/) 3.

In order to support SWF assets, you can use the OpenFL [SWF](http://www.openfl.org/marketplace/premium/swf-free) library, but many developers use image assets or libraries for spritesheet/tilesheet assets instead, as they can perform faster on mobile.

Code Editors
============

Plugins have been written for many [code editors](http://haxe.org/com/ide), but the most popular editors used for Haxe and OpenFL development are:

 * [FlashDevelop](http://www.flashdevelop.org)
 * [Sublime Text](http://www.sublimetext.com) (with [plugin](https://github.com/clemos/haxe-sublime-bundle))
 * [IntelliJ IDEA](http://www.jetbrains.com/idea/) (with [plugin](http://plugins.jetbrains.com/plugin/6873?pr=))

Easy Deployment
===============

OpenFL is powered by [Lime](https://github.com/openfl/lime), which includes powerful command-line tools to make cross-platform deployment sensible.

"lime test <target>" is usually all that is required to build, package, install and run your project on the platform of your choice, assuming you have the standard target SDK installed (such as Xcode or Visual Studio C++). Lime includes "setup" commands to even help the install of these standard tools.

3D Support
==========

Although we believe the Flash API is perfect for 2D development, there is some debate over the Stage3D (released in Flash Player 11), particularly regarding AGAL shaders. We have asked leading Flash developers, whether they would prefer an analog for Stage3D, or if they would prefer an OpenGL-based approach instead, and the answer has overwhelmingly been to support OpenGL-style APIs instead.

In addition to the standard Flash display list APIs, OpenFL includes batch tile rendering and "OpenGLView" for cross-platform OpenGL rendering for native and HTML5 targets. This does not have the limitions of Stage3D, and can be placed above, below or mixed with other DisplayObjects, and uses standard GLSL shaders, and follows the WebGL API.

Native Extensions
=================

When you target a native platform, the output is true native C++, enabling deep integration with platform features and third-party SDKs. There is a standard Haxe "CFFI" API for connecting Haxe classes directly to C++ libraries.

We have also developed a straightforward Android library project API for adding Java-based extensions, too. Native extensions can also use the standard Lime project format, for flexible control over dependencies, adding additional assets or tuning the output of your project.

The result are native extensions that can be made to interchangeably drop into projects, without breaking one another. We have made no attempt to emulate the system for AIR native extensions, which are much more difficult to create and less flexible.

Core Components
===============

 * [openfl](https://github.com/openfl/openfl)
 * [openfl-native](https://github.com/openfl/openfl-native)
 * [lime](https://github.com/openfl/lime)
 * [lime-tools](https://github.com/openfl/lime-tools)
 * [hxlibc](https://github.com/openfl/hxlibc)

OpenFL relies upon [Lime](https://github.com/openfl/lime), a foundation for easy, cross-platform development. Lime includes both the native code that powers most the OpenFL targets, as well as the command-line tools that knit all the pieces together.

When you target the Flash target, or when you receive code completion, the [openfl](https://github.com/openfl/openfl) library provides inline documentation and definitions for the supported Flash API. This also includes some unique OpenFL features, such as "openfl.Assets" which far simplifies asset access over the flash.display.Loader/flash.net.URLLoader system.

When you target a native platform, these classes are overridden with those from [openfl-native](https://github.com/openfl/openfl-native), which includes the native implementation of these features. These classes will be compiled to C++ at runtime, but these primarily act as a wrapper for the handwritten C++ code that makes up the Lime native backend.

When targeting HTML5, the classes are overridden instead with those from [openfl-html5-dom](https://github.com/openfl/openfl-html5-dom) or another HTML5 backend (the OpenFL backends are replaceable). This would include the Flash API implementation for use with canvas or another browser-based API.

[hxlibc](https://github.com/openfl/hxlibc) is used automatically by the Lime tools to manage the C++ compilation process for each platform, and to provide the Haxe standard library for C++ support.

License
=======

OpenFL is free, open-source software under the [MIT license](LICENSE.md).

Installing OpenFL
=================

To begin using OpenFL, you need to first install Haxe 3.0 for [Windows](http://haxe.org/file/haxe-3.0.0-win.exe), [Mac](http://haxe.org/file/haxe-3.0.0-osx-installer.dmg) or [Linux](http://www.openfl.org/download_file/view/726/12426/).

Once Haxe has been installed, you can install a release version of [Lime](https://github.com/openfl/lime) from a terminal or command-prompt with these commands:

    haxelib install lime
    haxelib run lime setup
    
Then you can install OpenFL like this:

    lime install openfl

Some platforms will require some additional setup before you can use them. For example, you must have Visual Studio C++ in order to build native applications for Windows. Lime includes a "setup" command that can help you walk through the process for each target:

    lime setup windows
    lime setup android
    lime setup blackberry
    lime setup tizen

In order to build for Mac or iOS, you should already have a recent version of Xcode installed. In order to build for Linux, usually only g++ is required, which may be installed with your distribution already. No setup is required for these platforms.

Getting Started
===============

The easiest way to get started is to create one of the OpenFL samples:

    lime create openfl:PiratePig
    cd PiratePig
    lime test neko
    
There are many targets you can try:

    lime test windows
    lime test windows -neko
    lime test mac
    lime test mac -neko
    lime test linux
    lime test linux -neko
    lime test ios
    lime test ios -simulator
    lime test android
    lime test blackberry
    lime test blackberry -simulator
    lime test tizen
    lime test tizen -simulator
    lime test flash
    lime test html5
    
Not all targets are available from all host platforms. For example, Apple does not provide tools for building iOS projects, unless you are running OS X.

You can create a blank project using:

    lime create openfl:project NameOfYourProject
    
You can learn about more Lime commands using:

    lime help

Development Builds
==================

If you would like to use development builds of OpenFL, first determine which component (or components) of OpenFL you will need. It is usually wise to keep with release builds for as many components as you can, for example, if you want to improve native platform support, you may decide to use "lime" and "openfl-native" from the source, but you can keep "lime-tools" and other elements stable. Each project includes documentation for how to use it from the source.

For the "openfl" library, you can use a development build like this:

    git clone https://github.com/openfl/openfl
    haxelib dev openfl openfl

To return to release builds:

    haxelib dev openfl
