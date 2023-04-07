package flash.display;

#if flash
import openfl.events.EventDispatcher;

@:final extern class FrameLabel extends EventDispatcher
{
	#if (haxe_ver < 4.3)
	public var frame(default, never):Int;
	public var name(default, never):String;
	#else
	@:flash.property var frame(get, never):Int;
	@:flash.property var name(get, never):String;
	#end

	public function new(name:String, frame:Int):Void;

	#if (haxe_ver >= 4.3)
	private function get_frame():Int;
	private function get_name():String;
	#end
}
#else
typedef FrameLabel = openfl.display.FrameLabel;
#end
