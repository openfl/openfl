package openfl.display;

#if !flash
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class Scene
{
	public var labels(default, null):Array<FrameLabel>;
	public var name(default, null):String;
	public var numFrames(default, null):Int;

	public function new(name:String, labels:Array<FrameLabel>, numFrames:Int)
	{
		this.name = name;
		this.labels = labels;
		this.numFrames = numFrames;
	}
}
#else
typedef Scene = flash.display.Scene;
#end
