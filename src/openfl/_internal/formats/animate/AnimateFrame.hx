package openfl._internal.formats.animate;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:keep class AnimateFrame
{
	public var label:String;
	public var objects:Array<AnimateFrameObject>;
	public var script:Void->Void;
	public var scriptSource:String;

	// public var scriptType:FrameScriptType;
	public function new() {}
}
