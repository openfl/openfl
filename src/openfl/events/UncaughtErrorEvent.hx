package openfl.events;

#if !flash
// import openfl.utils.ObjectPool;

/**
	An UncaughtErrorEvent object is dispatched by an instance of the
	UncaughtErrorEvents class when an uncaught error occurs. An uncaught error
	happens when an error is thrown outside of any `try..catch` blocks or when
	an ErrorEvent object is dispatched with no registered listeners. The
	uncaught error event functionality is often described as a "global error
	handler."
	The UncaughtErrorEvents object that dispatches the event is associated
	with either a LoaderInfo object or a Loader object. Use the following
	properties to access an UncaughtErrorEvents instance:

	* `LoaderInfo.uncaughtErrorEvents`: to detect uncaught errors in code
	defined in the same SWF.
	* `Loader.uncaughtErrorEvents`: to detect uncaught errors in code defined
	in the SWF loaded by a Loader object.

	When an `uncaughtError` event happens, even if the event is handled,
	execution does not continue in the call stack that caused the error. If
	the error is a synchronous error, any code remaining in the function where
	the error happened is not executed. Consequently, it is likely that when
	an uncaught error event happens, your application is in an unstable state.
	Since there can be many causes for an uncaught error, it is impossible to
	predict what functionality is available. For example, your application may
	be able to execute network operations or file operations. However, those
	operations aren't necessarily available.

	When one SWF loads another, `uncaughtError` events bubble down and up
	again through the LoaderInfo heirarchy. For example, suppose A.swf loads
	B.swf using a Loader instance. If an uncaught error occurs in B.swf, an
	`uncaughtError` event is dispatched to LoaderInfo and Loader objects in
	the following sequence:

	1. (Capture phase) A.swf's LoaderInfo
	2. (Capture phase) Loader in A.swf
	3. (Target phase) B.swf's LoaderInfo
	4. (Bubble phase) Loader in A.swf
	5. (Bubble phase) A.swf's LoaderInfo

	A Loader object's `uncaughtErrorEvents` property never dispatches an
	`uncaughtErrorEvent` in the target phase. It only dispatches the event in
	the capture and bubbling phases.

	As with other event bubbling, calling `stopPropagation()` or
	`stopImmediatePropagation()` stops the event from being dispatched to any
	other listeners, with one important difference. A Loader object's
	UncaughtErrorEvents object is treated as a pair with the loaded SWF's
	`LoaderInfo.uncaughtErrorEvents` object for event propagation purposes. If
	a listener registered with one of those objects calls the
	`stopPropagation()` method, events are still dispatched to other listeners
	registered with that UncaughtErrorEvents object _and_ to listeners
	registered with its partner UncaughtErrorEvents object before event
	propagation ends. The `stopImmediatePropagation()` method still prevents
	events from being dispatched to all additional listeners.

	When content is running in a debugger version of the runtime, such as the
	debugger version of Flash Player or the AIR Debug Launcher (ADL), an
	uncaught error dialog appears when an uncaught error happens. For those
	runtime versions, the error dialog appears even when a listener is
	registered for the `uncaughtError` event. To prevent the dialog from
	appearing in that situation, call the UncaughtErrorEvent object's
	`preventDefault()` method.

	If the content loaded by a Loader object is an AVM1 (ActionScript 2) SWF
	file, uncaught errors in the AVM1 SWF file do not result in an
	`uncaughtError` event. In addition, JavaScript errors in HTML content
	loaded in an HTMLLoader object (including a Flex HTML control) do not
	result in an `uncaughtError` event.

**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class UncaughtErrorEvent extends ErrorEvent
{
	/**
		Defines the value of the `type` property of an `uncaughtError` event
		object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `true` |
		| `cancelable` | `true`; cancelling the event prevents the uncaught error dialog from appearing in debugger runtime versions |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `error` | The uncaught error. |
		| `target` | The LoaderInfo object associated with the SWF where the error happened. |
		| `text` | Text error message. |
	**/
	public static inline var UNCAUGHT_ERROR:EventType<UncaughtErrorEvent> = "uncaughtError";

	/**
		The error object associated with the uncaught error. Typically, this
		object's data type is one of the following:
		* An Error instance (or one of its subclasses), if the uncaught error
		is a synchronous error created by a `throw` statement, such as an
		error that could have been caught using a `try..catch` block
		* An ErrorEvent instance (or one of its subclasses), if the uncaught
		error is an asynchronous error that dispatches an error event when the
		error happens

		However, the `error` property can potentially be an object of any data
		type. ActionScript does not require a `throw` statement to be used
		only with Error objects. For example, the following code is legal both
		at compile time and run time:

		```haxe
		throw new Sprite();
		```

		If that `throw` statement is not caught by a `try..catch` block, the
		`throw` statement triggers an `uncaughtError` event. In that case, the
		`error` property of the UncaughtErrorEvent object that's dispatched is
		the Sprite object that's constructed in the `throw` statement.

		Consequently, in your `uncaughtError` listener, you should check the
		data type of the `error` property. The following example demonstrates
		this check:

		```haxe
		function uncaughtErrorHandler(event:UncaughtErrorEvent):Void {
			var message:String;
			if (Std.isOfType(event.error, Error)) {
				message = cast(event.error, Error).message;
			} else if (Std.isOfType(event.error, ErrorEvent)) {
				message = cast(event.error, ErrorEvent).text;
			} else {
				message = Std.string(event.error);
			}
		}
		```

		If the `error` property contains an Error instance (or Error
		subclass), the available error information varies depending on the
		version of the runtime in which the content is running. The following
		functionality is only available when content is running in a debugger
		version of the runtime, such as the debugger version of Flash Player
		or the AIR Debug Launcher (ADL):

		* `Error.getStackTrace()` to get the call stack that led to the error.
		In non-debugger runtime versions, this method returns `null`. Note
		that call stack information is never available when the `error`
		property is an ErrorEvent instance.
		* Complete `Error.message` text. In non-debugger runtime versions,
		this property contains a short version of the error message, which is
		often a combination of the `Error.errorID` and `Error.name`
		properties.

		All other properties and methods of the Error class are available in
		all runtime versions.
	**/
	public var error(default, null):Dynamic;

	// @:noCompletion private static var __pool:ObjectPool<UncaughtErrorEvent> = new ObjectPool<UncaughtErrorEvent>(function() return
	// 	new UncaughtErrorEvent(null), function(event) event.__init());

	/**
		Creates an UncaughtErrorEvent object that contains information about
		an `uncaughtError` event.

		@param type       The type of the event.
		@param bubbles    Determines whether the Event object participates in
						  the bubbling stage of the event flow. Event
						  listeners can access this information through the
						  inherited `bubbles` property.
		@param cancelable Determines whether the Event object can be canceled.
						  Event listeners can access this information through
						  the inherited `cancelable` property.
		@param error_in   The object associated with the error that was not
						  caught or handled (an Error or ErrorEvent object
						  under normal circumstances).
	**/
	public function new(type:String, bubbles:Bool = true, cancelable:Bool = true, error:Dynamic = null)
	{
		super(type, bubbles, cancelable);

		this.error = error;
	}

	public override function clone():UncaughtErrorEvent
	{
		var event = new UncaughtErrorEvent(type, bubbles, cancelable, error);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("UncaughtErrorEvent", ["type", "bubbles", "cancelable", "error"]);
	}

	@:noCompletion private override function __init():Void
	{
		super.__init();
		error = null;
	}
}
#else
typedef UncaughtErrorEvent = flash.events.UncaughtErrorEvent;
#end
