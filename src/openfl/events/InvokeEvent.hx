package openfl.events;

#if (sys && !flash)
import openfl.desktop.InvokeEventReason;
import openfl.filesystem.File;

/**

**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class InvokeEvent extends Event
{
	/**

	**/
	public static inline var INVOKE:EventType<InvokeEvent> = "invoke";

	/**

	**/
	public var arguments(default, null):Array<String>;

	/**

	**/
	public var currentDirectory(default, null):File;

	/**

	**/
	public var reason(default, null):InvokeEventReason;

	/**

	**/
	public function new(type:EventType<InvokeEvent>, bubbles:Bool = false, cancelable:Bool = false, ?dir:File, ?argv:Array<Dynamic>,
			reason:InvokeEventReason = STANDARD)
	{
		super(type, bubbles, cancelable);
		this.currentDirectory = dir;
		var stringArgs:Array<String> = [];
		for (arg in argv)
		{
			stringArgs.push(Std.string(arg));
		}
		this.arguments = stringArgs;
		this.reason = reason;
	}

	override public function clone():InvokeEvent
	{
		return new InvokeEvent(type, bubbles, cancelable, currentDirectory, arguments, reason);
	}
}
#else
#if air
typedef InvokeEvent = flash.events.InvokeEvent;
#end
#end
