package format.swf.lite.timeline;


import format.swf.exporters.core.FilterType;
import flash.geom.ColorTransform;
import flash.geom.Matrix;


class FrameObject implements hxbit.Serializable {


	@:s public var cacheAsBitmap:Bool = false;
	@:s public var clipDepth:Null<Int>;
	@:s public var colorTransform:ColorTransform;
	@:s public var depth:Null<Int>;
	@:s public var filters:Array<FilterType>;
	@:s public var id:Int;
	@:s public var matrix:Matrix;
	@:s public var name:String;
	@:s public var symbol:Null<Int>;
	@:s public var type:FrameObjectType;
	@:s public var blendMode: openfl.display.BlendMode;
	@:s public var ratio:Null<Float>;


	public function new () {



	}


}
