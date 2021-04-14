package openfl.system;

#if !flash
#if lime
import lime.system.Clipboard;
import lime.system.System as LimeSystem;
#end
#if neko
import neko.vm.Gc;
#elseif cpp
import cpp.vm.Gc;
#end

/**
	The System class contains properties related to local settings and
	operations. Among these are settings for camers and microphones, operations
	with shared objects and the use of the Clipboard.

	Additional properties and methods are in other classes within the
	openfl.system package: the Capabilities class, the IME class, and the
	Security class.

	This class contains only static methods and properties. You cannot
	create new instances of the System class.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class System
{
	#if false
	/**
		The amount of memory (in bytes) that is allocated to
		Adobe<sup>஼/sup> Flash<sup>஼/sup> Player or Adobe<sup>஼/sup>
		AIR<sup>஼/sup> and that is not in use. This unused portion of
		allocated memory (`System.totalMemory`) fluctuates as garbage
		collection takes place. Use this property to monitor garbage
		collection.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10_1) public static var freeMemory (default, null):Float;
	#end

	#if false
	/**
		The currently installed system IME. To register for imeComposition
		events, call `addEventListener()` on this instance.
	**/
	// @:noCompletion @:dox(hide) public static var ime (default, null):openfl.system.IME;
	#end

	#if false
	/**
		The entire amount of memory (in bytes) used by an application. This is
		the amount of resident private memory for the entire process.
		AIR developers should use this property to determine the entire memory
		consumption of an application.

		For Flash Player, this includes the memory used by the container
		application, such as the web browser.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10_1) public static var privateMemory (default, null):Float;
	#end
	// @:noCompletion @:dox(hide) @:require(flash11) public static var processCPUUsage (default, null):Float;

	/**
		The amount of memory(in bytes) currently in use that has been directly
		allocated by Flash Player or AIR.

		This property does not return _all_ memory used by an Adobe AIR
		application or by the application(such as a browser) containing Flash
		Player content. The browser or operating system may consume other memory.
		The `System.privateMemory` property reflects _all_ memory
		used by an application.

		If the amount of memory allocated is greater than the maximum value for
		a uint object(`uint.MAX_VALUE`, or 4,294,967,295), then this
		property is set to 0. The `System.totalMemoryNumber` property
		allows larger values.
	**/
	public static var totalMemory(get, never):Int;

	// @:noCompletion @:dox(hide) @:require(flash10_1) public static var totalMemoryNumber (default, null):Float;

	/**
		A Boolean value that determines which code page to use to interpret
		external text files. When the property is set to `false`,
		external text files are interpretted as Unicode.(These files must be
		encoded as Unicode when you save them.) When the property is set to
		`true`, external text files are interpretted using the
		traditional code page of the operating system running the application. The
		default value of `useCodePage` is `false`.

		Text that you load as an external file(using
		`Loader.load()`, the URLLoader class or URLStream) must have
		been saved as Unicode in order for the application to recognize it as
		Unicode. To encode external files as Unicode, save the files in an
		application that supports Unicode, such as Notepad on Windows.

		If you load external text files that are not Unicode-encoded, set
		`useCodePage` to `true`. Add the following as the
		first line of code of the file that is loading the data(for Flash
		Professional, add it to the first frame):
		`System.useCodePage = true;`

		When this code is present, the application interprets external text
		using the traditional code page of the operating system. For example, this
		is generally CP1252 for an English Windows operating system and Shift-JIS
		for a Japanese operating system.

		If you set `useCodePage` to `true`, Flash Player
		6 and later treat text as Flash Player 5 does.(Flash Player 5 treated all
		text as if it were in the traditional code page of the operating system
		running the player.)

		If you set `useCodePage` to `true`, remember that
		the traditional code page of the operating system running the application
		must include the characters used in your external text file in order to
		display your text. For example, if you load an external text file that
		contains Chinese characters, those characters cannot display on a system
		that uses the CP1252 code page because that code page does not include
		Chinese characters.

		To ensure that users on all platforms can view external text files used
		in your application, you should encode all external text files as Unicode
		and leave `useCodePage` set to `false`. This way,
		the application(Flash Player 6 and later, or AIR) interprets the text as
		Unicode.
	**/
	public static var useCodePage:Bool = false;

	/**
		Undocumented property
	**/
	@:noCompletion @:dox(hide) public static var vmVersion(get, never):String;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperties(System, {
			"totalMemory": {
				get: function()
				{
					return System.get_totalMemory();
				}
			},
			"vmVersion": {
				get: function()
				{
					return System.get_vmVersion();
				}
			},
		});
	}
	#end

	/**
		Makes the specified XML object immediately available for garbage
		collection. This method will remove parent and child connections
		between all the nodes for the specified XML node.

		@param node XML reference that should be made available for garbage
					collection.
	**/
	@:noCompletion @:dox(hide) public static function disposeXML(node:Dynamic):Void {}

	/**
		Closes Flash Player.

		_For the standalone Flash Player debugger version only._

		AIR applications should call the `NativeApplication.exit()`
		method to exit the application.

		@param code A value to pass to the operating system. Typically, if the
					process exits normally, the value is 0.
	**/
	public static function exit(code:Int):Void
	{
		#if lime
		LimeSystem.exit(code);
		#end
	}

	/**
		Forces the garbage collection process.

		_For the Flash Player debugger version and AIR applications only._
		In an AIR application, the `System.gc()` method is only enabled
		in content running in the AIR Debug Launcher(ADL) or, in an installed
		applcation, in content in the application security sandbox.

	**/
	public static function gc():Void
	{
		#if (cpp || neko)
		return Gc.run(true);
		#end
	}

	#if !openfl_strict
	/**
		Pauses Flash Player or the AIR Debug Launcher(ADL). After calling this
		method, nothing in the application continues except the delivery of Socket
		events.

		_For the Flash Player debugger version or the AIR Debug Launcher
		(ADL) only._

	**/
	public static function pause():Void
	{
		openfl.utils._internal.Lib.notImplemented();
	}
	#end

	// @:noCompletion @:dox(hide) @:require(flash11) public static function pauseForGCIfCollectionImminent (imminence:Float = 0.75):Void;

	#if !openfl_strict
	/**
		Resumes the application after calling `System.pause()`.

		_For the Flash Player debugger version or the AIR Debug Launcher
		(ADL) only._

	**/
	public static function resume():Void
	{
		openfl.utils._internal.Lib.notImplemented();
	}
	#end

	/**
		Replaces the contents of the Clipboard with a specified text string. This
		method works from any security context when called as a result of a user
		event(such as a keyboard or input device event handler).

		This method is provided for SWF content running in Flash Player 9. It
		allows only adding String content to the Clipboard.

		Flash Player 10 content and content in the application security sandbox
		in an AIR application can call the `Clipboard.setData()`
		method.

		@param string A plain-text string of characters to put on the system
					  Clipboard, replacing its current contents(if any).
	**/
	public static function setClipboard(string:String):Void
	{
		#if lime
		Clipboard.text = string;
		#end
	}

	// Getters & Setters
	@:noCompletion private static function get_totalMemory():Int
	{
		#if neko
		return Gc.stats().heap;
		#elseif cpp
		return untyped __global__.__hxcpp_gc_used_bytes();
		#elseif (js && html5)
		return
			untyped #if haxe4 js.Syntax.code #else __js__ #end ("(window.performance && window.performance.memory) ? window.performance.memory.usedJSHeapSize : 0");
		#else
		return 0;
		#end
	}

	@:noCompletion private static function get_vmVersion():String
	{
		return "1.0.0";
	}
}
#else
typedef System = flash.system.System;
#end
