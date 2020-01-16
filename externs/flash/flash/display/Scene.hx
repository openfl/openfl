package flash.display;

#if flash
@:final extern class Scene
{
	public var labels(default, never):Array<FrameLabel>;
	public var name(default, never):String;
	public var numFrames(default, never):Int;
	public function new(name:String, labels:Array<FrameLabel>, numFrames:Int):Void;
}
#else
typedef Scene = openfl.display.Scene;
#end
