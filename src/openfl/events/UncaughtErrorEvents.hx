package openfl.events;

#if !flash
import openfl.events.UncaughtErrorEvent;

/**
	The UncaughtErrorEvents class provides a way to receive uncaught error
	events. An instance of this class dispatches an `uncaughtError` event when
	a runtime error occurs and the error isn't detected and handled in your
	code.
	Use the following properties to access an UncaughtErrorEvents instance:

	* `LoaderInfo.uncaughtErrorEvents`: to detect uncaught errors in code
	defined in the same SWF.
	* `Loader.uncaughtErrorEvents`: to detect uncaught errors in code defined
	in the SWF loaded by a Loader object.

	To catch an error directly and prevent an uncaught error event, do the
	following:

	* Use a `<a
	href="../../statements.html#try..catch..finally">try..catch</a>` block to
	isolate code that potentially throws a synchronous error
	* When performing an operation that dispatches an event when an error
	occurs, register a listener for that error event

	If the content loaded by a Loader object is an AVM1 (ActionScript 2) SWF
	file, uncaught errors in the AVM1 SWF file do not result in an
	`uncaughtError` event. In addition, JavaScript errors in HTML content
	loaded in an HTMLLoader object (including a Flex HTML control) do not
	result in an `uncaughtError` event.

	@event uncaughtError Dispatched when an error occurs and developer code
						 doesn't detect and handle the error.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class UncaughtErrorEvents extends EventDispatcher
{
	@:noCompletion private var __enabled:Bool;

	/**
		Creates an UncaughtErrorEvents instance. Developer code shouldn't
		create UncaughtErrorEvents instances directly. To access an
		UncaughtErrorEvents object, use one of the following properties:
		* `LoaderInfo.uncaughtErrorEvents`: to detect uncaught errors in code
		defined in the same SWF.
		* `Loader.uncaughtErrorEvents`: to detect uncaught errors in code
		defined in the SWF loaded by a Loader object.
	**/
	public function new()
	{
		super();
	}

	public override function addEventListener<T>(type:EventType<T>, listener:T->Void, useCapture:Bool = false, priority:Int = 0,
			useWeakReference:Bool = false):Void
	{
		super.addEventListener(type, listener, useCapture, priority, useWeakReference);

		#if !openfl_disable_handle_error
		if (__eventMap.exists(UncaughtErrorEvent.UNCAUGHT_ERROR))
		{
			__enabled = true;
		}
		#end
	}

	public override function removeEventListener<T>(type:EventType<T>, listener:T->Void, useCapture:Bool = false):Void
	{
		super.removeEventListener(type, listener, useCapture);

		if (!__eventMap.exists(UncaughtErrorEvent.UNCAUGHT_ERROR))
		{
			__enabled = false;
		}
	}
}
#else
typedef UncaughtErrorEvents = flash.events.UncaughtErrorEvents;
#end
