[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE.md) [![Haxelib Version](https://img.shields.io/github/tag/openfl/openfl.svg?style=flat&label=haxelib)](http://lib.haxe.org/p/openfl) [![Build Status](https://img.shields.io/travis/openfl/openfl.svg?style=flat)](https://travis-ci.org/openfl/openfl)


<br />
<p align="center"><img src="openfl.png"/></p>


Introduction
============

The OpenFL project is an open-source answer to the needs of game and application developers everywhere, looking for a fast, simple approach to delivering creative masterpieces without relying on a specific implementation, such as a browser plugin.

Using the innovative [Haxe](http://haxe.org/) programming language, OpenFL supports Windows, Mac, Linux, iOS, Android, Flash and HTML5 with one codebase. Transitioning from desktop, to mobile, to browser is simple, and maintains the strengths of each target environment. OpenFL compiles to native C++, Neko or Flash bytecode, or JavaScript, for maximum support across each environment.

OpenFL depends on [Lime](https://github.com/openfl/lime), which provides command-line tools, and backend support for each runtime environment.


Platforms
=========

Currently, OpenFL supports the following platforms:

 * Windows
 * Mac
 * Linux
 * iOS
 * Android
 * Firefox OS
 * HTML5
 * Flash

There is also a community effort to bring OpenFL to consoles, OpenFL is running on:

 * Sony PS4
 * Sony PS Vita
 * Sony PS3
 * Microsoft Xbox One
 * Nintendo Wii U

_Additional details will be available in the future_

The OpenFL v2 "legacy" codebase supports:

 * Windows
 * Mac
 * Linux
 * iOS
 * Android
 * BlackBerry
 * Tizen

You can switch to the legacy codebase by using `-Dlegacy` when you build

Libraries
=========

OpenFL is compatible with [many libraries](http://lib.haxe.org/all), ported from ActionScript or written originally in Haxe, including:

 * [HaxeFlixel](https://github.com/haxeflixel/flixel)
 * [HaxePunk](https://github.com/HaxePunk/HaxePunk)
 * [Nape](https://github.com/deltaluca/nape)
 * [Box2D](https://github.com/jgranick/Box2D)
 * [Actuate](https://github.com/jgranick/Actuate)

OpenFL also powers other platforms, such as [Stencyl](http://www.stencyl.com/) 3.

You can use the optional OpenFL [SWF](http://github.com/openfl/swf) library to use SWF assets


Code Editors
============

Plugins have been written for many [code editors](http://haxe.org/com/ide), but the most popular editors used for Haxe and OpenFL development are:

 * [FlashDevelop](http://www.flashdevelop.org)
 * [Sublime Text](http://www.sublimetext.com) (with [plugin](https://github.com/clemos/haxe-sublime-bundle))
 * [IntelliJ IDEA](http://www.jetbrains.com/idea/) (with [plugin](http://plugins.jetbrains.com/plugin/6873?pr=))


Easy Deployment
===============

OpenFL includes the tools you need to build, package, install and run on each target platform.

For example, `openfl test html5` will generate an HTML5 project, create a local web server and open your default browser.

Some platforms will require a standard SDK to build (such as Visual Studio C++ or Xcode). OpenFL includes "setup" commands to even help the install of these standard tools.


3D Support
==========

OpenFL is designed primarily for 2D development, but you can the `OpenGLView` API to write your own WebGL-style code, and mix it with the OpenFL display architecture. You can also use libraries such as [Away3D](https://github.com/away3d/away3d-core-openfl/).


Native Extensions
=================

When you target a native platform, the output is true native C++, enabling deep integration with platform features and third-party SDKs. There is a standard Haxe "CFFI" API for connecting Haxe classes directly to C++ libraries.

We have also developed a straight-forward Android library project API for adding Java-based extensions, too. Native extensions can also use the standard Lime project format, for flexible control over dependencies, adding additional assets or tuning the output of your project.

The result are native extensions that can be made to interchangeably drop into projects, without breaking one another. We have made no attempt to emulate the system for AIR native extensions, which are much more difficult to create and less flexible.


Core Components
===============

 * [openfl](https://github.com/openfl/openfl)
 * [lime](https://github.com/openfl/lime)
 * [hxcpp](https://github.com/HaxeFoundation/hxcpp)

OpenFL relies upon [Lime](https://github.com/openfl/lime), a foundation for cross-platform project development.

[hxcpp](https://github.com/HaxeFoundation/hxcpp) is used automatically by the Lime tools to manage the C++ compilation process for each platform, and to provide the Haxe standard library for C++ support.


License
=======

OpenFL is free, open-source software under the [MIT license](LICENSE.md).


Installing OpenFL
=================

Follow the directions at [openfl.org](http://www.openfl.org/download).


Development Builds
==================

Clone the OpenFL repository:

    git clone https://github.com/openfl/openfl

Tell haxelib where your development copy of OpenFL is installed:

    haxelib dev openfl openfl

To return to release builds:

    haxelib dev openfl

You may also need a development build of Lime installed
