package format.swf.lite.timeline;


import format.swf.exporters.core.FilterType;
import flash.geom.ColorTransform;
import flash.geom.Matrix;


class FrameObject {


	public var clipDepth:Int;
	public var colorTransform:ColorTransform;
	public var depth:Int;
	public var filters:Array<FilterType>;
	public var id:Int;
	public var matrix:Matrix;
	public var name:String;
	public var symbol:Int;
	public var type:FrameObjectType;
	public var blendMode: openfl.display.BlendMode;
	public var ratio:Null<Float>;


	public function new () {



	}


}
