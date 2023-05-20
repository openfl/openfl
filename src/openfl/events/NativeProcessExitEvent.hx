package openfl.events;

#if (haxe4 && sys && !flash)
/**
	This event is dispatched by the NativeProcess object when the process exits.
	It is possible that this event will never be dispatched. For example, if the
	child process outlives the OpenFL application that created it, the event
	will not dispatch.

	@see `openfl.desktop.NativeProcess`
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class NativeProcessExitEvent extends Event
{
	/**
		Defines the value of the type property of a exit event object.
	**/
	public static inline var EXIT:EventType<NativeProcessExitEvent> = "exit";

	/**
		The exit code that the native process returned to the host operating
		system when exiting. If the OpenFL application terminates the process
		by calling the `exit()` method of the NativeProcess object, the
		`exitCode` property is set to `Math.NaN`.

		**NOTE:** On Windows operating systems, if the process has not exited
		but the runtime is exiting or an error occurred, this value may be set
		to `259` (STILL_ACTIVE). To avoid confusion of this condition, do not
		use `259` as a return code in a native process.
	**/
	public var exitCode:Float;

	/**
		Creates a NativeProcessExitEvent which contains specific information
		regarding a NativeProcess's exit code.

		@param type             The type of the event, accessible as `Event.type`.
		@param bubbles          Determines whether the Event object participates
								in the bubbling stage of the event flow.
		@param cancelable       Determines whether the Event object can be
								canceled.
		@param exitCodeValue    Number that the process returned to the
								operating system during exit.
	**/
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, ?exitCodeValue:Float)
	{
		super(type, bubbles, cancelable);

		if (exitCodeValue == null)
		{
			exitCode = Math.NaN;
		}
		else
		{
			exitCode = exitCodeValue;
		}
	}

	public override function clone():NativeProcessExitEvent
	{
		var event = new NativeProcessExitEvent(type, bubbles, cancelable, exitCode);

		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("NativeProcessExitEvent", ["type", "bubbles", "cancelable", "exitCode"]);
	}

	@:noCompletion private override function __init():Void
	{
		super.__init();
		exitCode = Math.NaN;
	}
}
#else
#if air
typedef NativeProcessExitEvent = flash.events.NativeProcessExitEvent;
#end
#end
