#!/bin/sh
haxelib run munit gen
openfl test neko
openfl test cpp
openfl build flash
openfl build html5
haxelib run munit test