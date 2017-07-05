package format.swf.lite.symbols;


import flash.geom.Matrix;
import flash.geom.Rectangle;


class StaticTextSymbol extends SWFSymbol {


	@:s public var matrix:Matrix;
	@:s public var bounds:Rectangle;
	@:s public var records:Array<StaticTextRecord>;
	@:s public var shapeIsScaled : Bool;


	public function new () {

		super ();

	}


}


@:keep class StaticTextRecord implements hxbit.Serializable {


	@:s public var advances:Array<Int>;
	@:s public var color:Null<Int>;
	@:s public var fontHeight:Int;
	@:s public var fontID:Null<Int>;
	@:s public var glyphs:Array<Int>;
	@:s public var offsetX:Null<Int>;
	@:s public var offsetY:Null<Int>;


	public function new () {



	}


}