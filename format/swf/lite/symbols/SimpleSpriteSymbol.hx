package format.swf.lite.symbols;


import format.swf.exporters.core.ShapeCommand;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

class SimpleSpriteSymbol extends SWFSymbol {


	@:s public var bitmapID:Int;
	@:s public var matrix:Matrix;
	@:s public var bounds:Rectangle;
	@:s public var smooth:Bool;

	public function new () {
		super ();
	}
}