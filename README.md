[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE.md) [![Haxelib Version](https://img.shields.io/github/tag/openfl/openfl.svg?style=flat&label=haxelib&color=df7900)](https://lib.haxe.org/p/openfl) [![Build Status](https://img.shields.io/github/actions/workflow/status/openfl/openfl/main.yml?branch=develop)](https://github.com/openfl/openfl/actions) [![Community](https://img.shields.io/discourse/posts?color=24afc4&server=https%3A%2F%2Fcommunity.openfl.org&label=community)](https://community.openfl.org) [![Discord Server](https://img.shields.io/discord/415681294446493696.svg?color=7289da)](https://discordapp.com/invite/tDgq8EE)


<br />
<p align="center"><img src="assets/openfl.png"/></p>


Introduction
============

The OpenFL project is an open-source answer to the needs of game and application developers everywhere, looking for a fast, simple approach to delivering creative masterpieces without relying on a specific implementation, such as a browser plugin.

Using the innovative [Haxe](http://haxe.org/) programming language, OpenFL supports wildly different platforms using one codebase. Transitioning from one target type to another is simple, and keeps the strengths of the target environment. OpenFL builds to native C++, Neko or Flash bytecode, or JavaScript, enabling maximum compatibility and runtime performance.

OpenFL depends on [Lime](https://github.com/openfl/lime), which has easy-to-use command-line tools, and provides backend support.


Platforms
=========

Currently, OpenFL supports the following platforms:

 * iOS
 * Android
 * HTML5
 * Windows
 * macOS
 * Linux
 * Flash
 * AIR

There is also a community effort to bring OpenFL to consoles, OpenFL is running on:

 * Switch
 * Wii U
 * PlayStation 4
 * PlayStation 3
 * PlayStation Vita
 * Xbox One

_Additional details on console support will be available in the future._

OpenFL is also being used in additional environments:

 * [TiVo](http://www.tivo.com) boxes
 * Raspberry Pi
 * Node.js


Libraries
=========

OpenFL is compatible with [many libraries](http://lib.haxe.org/all), ported from ActionScript or written originally in Haxe, including:

 * [Starling](https://github.com/openfl/starling)
 * [Away3D](https://github.com/openfl/away3d)
 * [DragonBones](https://github.com/openfl/dragonbones)
 * [Nape](https://github.com/deltaluca/nape)
 * [Box2D](https://github.com/jgranick/Box2D)
 * [Actuate](https://github.com/jgranick/Actuate)
 * [HaxeFlixel](https://github.com/haxeflixel/flixel)
 * [HaxePunk](https://github.com/HaxePunk/HaxePunk)

OpenFL also powers other platforms, such as [Stencyl](http://www.stencyl.com/).


Code Editors
============

Plugins have been written for many [code editors](http://haxe.org/documentation/introduction/editors-and-ides.html), but the most popular editors used for Haxe and OpenFL development are:

 * [Visual Studio Code](https://code.visualstudio.com/) (with [plugin](https://marketplace.visualstudio.com/items?itemName=openfl.lime-vscode-extension))
 * [HaxeDevelop](http://haxedevelop.org/)
 * [Sublime Text](http://www.sublimetext.com) (with [plugin](https://github.com/clemos/haxe-sublime-bundle))
 * [IntelliJ IDEA](http://www.jetbrains.com/idea/) (with [plugin](http://plugins.jetbrains.com/plugin/6873?pr=))


Easy Deployment
===============

OpenFL includes the tools you need to build, package, install and run on each target platform.

For example, `openfl test html5` will generate an HTML5 project, create a local web server and open your default browser.

Some platforms will require a standard SDK to build (such as Visual Studio C++ or Xcode). OpenFL includes "setup" commands to even help the install of these standard tools.


3D Support
==========

OpenFL is designed primarily for 2D development, but you can use the `OpenGLRenderer` API to write your own WebGL-style code, and mix it with the OpenFL display architecture.

OpenFL also has support for the Stage3D API. If you like you can use this directly, or you can also use libraries such as [Away3D](https://github.com/away3d/away3d-core-openfl/) or [Starling](https://github.com/openfl/starling).


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

When there are changes, OpenFL is built nightly. Builds are available for download [here](https://github.com/openfl/openfl/actions?query=branch%3Adevelop+is%3Asuccess).

To install a development build, use the "haxelib local" command:

    haxelib local openfl-haxelib.zip


Building from Source
====================

Clone the OpenFL repository:

    git clone https://github.com/openfl/openfl

Tell haxelib where your development copy of OpenFL is installed:

    haxelib dev openfl openfl

To return to release builds:

    haxelib dev openfl

You may also need a development build of Lime installed.
