package openfl.errors;

#if !flash
import haxe.CallStack;

/**
	The Error class contains information about an error that occurred in a script. In
	developing ActionScript 3.0 applications, when you run your compiled code in the
	debugger version of a Flash runtime, a dialog box displays exceptions of type Error,
	or of a subclass, to help you troubleshoot the code. You create an Error object by
	using the Error constructor function. Typically, you throw a new Error object from
	within a `try` code block that is caught by a `catch` code block.

	You can also create a subclass of the Error class and throw instances of that subclass.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Error #if (openfl_dynamic && haxe_ver < "4.0.0") implements Dynamic #end
{
	@:noCompletion private static inline var DEFAULT_TO_STRING:String = "Error";

	// @:noCompletion @:dox(hide) public static var length:Int;

	/**
		Contains the reference number associated with the specific error message. For a
		custom Error object, this number is the value from the id parameter supplied in the
		constructor.
	**/
	public var errorID(default, null):Int;

	/**
		Contains the message associated with the Error object. By default, the value of
		this property is "Error". You can specify a message property when you create an
		Error object by passing the error string to the Error constructor function.
	**/
	public var message:String;

	/**
		Contains the name of the Error object. By default, the value of this property is
		"Error".
	**/
	public var name:String;

	/**
		Creates a new Error object. If message is specified, its value is assigned to the
		object's Error.message property.

		@param	message	A string associated with the Error object; this parameter is optional.
		@param	id	A reference number to associate with the specific error message.
	**/
	public function new(message:String = "", id:Int = 0)
	{
		this.message = message;
		this.errorID = id;
		name = "Error";
	}

	// @:noCompletion @:dox(hide) public static function getErrorMessage (index:Int):String;

	/**
		Returns the call stack for an error at the time of the error's construction as a
		string. As shown in the following example, the first line of the return value is
		the string representation of the exception object, followed by the stack trace
		elements:

		```
		TypeError: Error #1009: Cannot access a property or method of a null object reference
			at com.xyz::OrderEntry/retrieveData()[/src/com/xyz/OrderEntry.as:995]
			at com.xyz::OrderEntry/init()[/src/com/xyz/OrderEntry.as:200]
			at com.xyz::OrderEntry()[/src/com/xyz/OrderEntry.as:148]
		```

		The preceding listing shows the value of this method when called in a debugger
		version of Flash Player or code running in the AIR Debug Launcher (ADL). When code
		runs in a release version of Flash Player or AIR, the stack trace is provided
		without the file path and line number information, as in the following example:

		```
		TypeError: Error #1009: Cannot access a property or method of a null object reference
			at com.xyz::OrderEntry/retrieveData()
			at com.xyz::OrderEntry/init()
			at com.xyz::OrderEntry()
		```

		For Flash Player 11.4 and earlier and AIR 3.4 and earlier, stack traces are only
		available when code is running in the debugger version of Flash Player or the AIR
		Debug Launcher (ADL). In non-debugger versions of those runtimes, calling this
		method returns `null`.

		@returns	A string representation of the call stack.
	**/
	public function getStackTrace():String
	{
		return CallStack.toString(CallStack.exceptionStack());
	}

	// @:noCompletion @:dox(hide) public static function throwError (type:Class<Dynamic>, index:UInt, ?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):Dynamic;

	/**
		Returns the string "Error" by default or the value contained in the `Error.message`
		property, if defined.

		@returns	The error message.
	**/
	public function toString():String
	{
		if (message != null)
		{
			return message;
		}
		else
		{
			return DEFAULT_TO_STRING;
		}
	}
}
#else
typedef Error = flash.errors.Error;
#end
