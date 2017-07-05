package format.swf.lite.symbols;


import format.swf.exporters.core.ShapeCommand;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

class SimpleSpriteSymbol extends SWFSymbol {


	@:s public var bitmapID:Int;
	@:s public var matrix:Matrix;
	@:s public var bounds:Rectangle;

	public function new () {
		super ();
	}
}