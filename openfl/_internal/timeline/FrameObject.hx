package openfl._internal.timeline;


import openfl._internal.swf.FilterType;
import openfl.display.BlendMode;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class FrameObject {
	
	
	public var blendMode:BlendMode;
	public var cacheAsBitmap:Null<Bool>;
	public var clipDepth:Int;
	public var colorTransform:ColorTransform;
	public var depth:Int;
	public var filters:Array<FilterType>;
	public var id:Int;
	public var matrix:Matrix;
	public var name:String;
	public var symbol:Int;
	public var type:FrameObjectType;
	public var visible:Null<Bool>;
	
	
	public function new () {
		
		
		
	}
	
	
}