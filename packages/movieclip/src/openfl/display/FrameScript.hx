package openfl.display;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class FrameScript
{
	public var frame(default, null):Int;
	public var script(default, null):MovieClip->Void;

	public function new(script:MovieClip->Void, frame:Int)
	{
		this.script = script;
		this.frame = frame;
	}
}
