/*
 * Copyright (C)2014-2017 Haxe Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

// package js.node;
import haxe.extern.EitherType;

/**
	This module is used for writing unit tests for your applications
**/
// @:jsRequire("assert")

@:native("chai.assert")
extern class Assert
{
	/**
		Throws an `AssertionError`. If `message` is falsy, the error message is set as the values of `actual` and `expected` separated by the provided `operator`.
		Otherwise, the error message is the value of `message`.
	**/
	static function fail<T>(actual:T, expected:T, message:String, _operator:String):Void;

	/**
		Tests if value is truthy.

		An alias of `ok`.
	**/
	@:selfCall
	static function assert(value:Bool, ?message:String):Void;

	/**
		Tests if value is truthy.

		If value is not truthy, an `AssertionError` is thrown with a `message` property set
		equal to the value of the `message` parameter. If the `message` parameter is undefined,
		a default error message is assigned.
	**/
	static function ok(value:Bool, ?message:String):Void;

	/**
		Tests shallow, coercive equality between the `actual` and `expected` parameters using the JavaScript equal comparison operator ( `==` ).

		If the values are not equal, an `AssertionError` is thrown with a `message` property set
		equal to the value of the `message` parameter. If the `message` parameter is undefined,
		a default error message is assigned.
	**/
	static function equal<T>(actual:T, expected:T, ?message:String):Void;

	/**
		Tests shallow, coercive inequality with the JavaScript not equal comparison operator ( `!=` ).

		If the values are equal, an `AssertionError` is thrown with a `message` property set
		equal to the value of the `message` parameter. If the `message` parameter is undefined,
		a default error message is assigned.
	**/
	static function notEqual<T>(actual:T, expected:T, ?message:String):Void;

	/**
		Tests for deep equality between the `actual` and `expected` parameters.
		Primitive values are compared with the JavaScript equal comparison operator ( `==` ).
	**/
	static function deepEqual<T>(actual:T, expected:T, ?message:String):Void;

	/**
		Generally identical to `deepEqual` with two exceptions.
		First, primitive values are compared using the JavaScript strict equality operator ( `===` ).
		Second, object comparisons include a strict equality check of their prototypes.
	**/
	static function deepStrictEqual<T>(actual:T, expected:T, ?message:String):Void;

	/**
		Tests for any deep inequality. Opposite of `deepEqual`.

		If the values are deeply equal, an `AssertionError` is thrown with a `message` property set
		equal to the value of the `message` parameter. If the `message` parameter is undefined,
		a default error message is assigned.
	**/
	static function notDeepEqual<T>(actual:T, expected:T, ?message:String):Void;

	/**
		Tests for deep strict inequality. Opposite of `deepStrictEqual`.

		If the values are deeply and strictly equal, an `AssertionError` is thrown with a `message` property set
		equal to the value of the `message` parameter. If the `message` parameter is undefined,
		a default error message is assigned.
	**/
	static function notDeepStrictEqual<T>(actual:T, expected:T, ?message:String):Void;

	/**
		Tests strict equality, as determined by the JavaScript strict equality operator (`===`)

		If the values are not strictly equal, an `AssertionError` is thrown with a `message` property set
		equal to the value of the `message` parameter. If the `message` parameter is undefined,
		a default error message is assigned.
	**/
	static function strictEqual<T>(actual:T, expected:T, ?message:String):Void;

	/**
		Tests strict non-equality, as determined by the strict not equal operator (`!==`)

		If the values are strictly equal, an `AssertionError` is thrown with a `message` property set
		equal to the value of the `message` parameter. If the `message` parameter is undefined,
		a default error message is assigned.
	**/
	static function notStrictEqual<T>(actual:T, expected:T, ?message:String):Void;

	/**
		Expects `block` to throw an error.

		If specified, `error` can be a class, javascript RegExp, or validation function.

		If specified, `message` will be the message provided by the `AssertionError` if the block fails to throw.

		Note that `error` can not be a string. If a string is provided as the second argument,
		then error is assumed to be omitted and the string will be used for `message` instead.
	**/
	@:overload(function(block:Void->Void, ?message:String):Void {})
	static function throws(block:Void->Void, error:ThrowsExpectedError, ?message:String):Void;

	/**
		Asserts that the function `block` does not throw an error.
		See `throws` for more details.

		Will immediately call the `block` function.

		If an error is thrown and it is the same type as that specified by the `error` parameter,
		then an `AssertionError` is thrown. If the error is of a different type, or if the `error`
		parameter is undefined, the error is propagated back to the caller.
	**/
	@:overload(function(block:Void->Void, ?message:String):Void {})
	static function doesNotThrow(block:Void->Void, error:ThrowsExpectedError, ?message:String):Void;

	/**
		Throws `value` if `value` is truthy.

		A falsy value in JavaScript is false, null, undefined and 0.

		Useful when testing the first argument, error in callbacks.
	**/
	static function ifError(value:Dynamic):Void;
}

/**
	a class, RegExp or function.
**/
private typedef ThrowsExpectedError = EitherType<Class<Dynamic>, EitherType<#if haxe4 js.lib.RegExp #else js.RegExp #end, Dynamic->Bool>>;
