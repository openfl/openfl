package openfl.display;

#if !flash
import openfl.events.EventDispatcher;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class FrameLabel extends EventDispatcher
{
	public var frame(default, null):Int;
	public var name(default, null):String;

	public function new(name:String, frame:Int)
	{
		super();

		this.name = name;
		this.frame = frame;
	}
}
#else
typedef FrameLabel = flash.display.FrameLabel;
#end
