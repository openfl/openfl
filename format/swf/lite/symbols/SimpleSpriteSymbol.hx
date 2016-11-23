package format.swf.lite.symbols;


import format.swf.exporters.core.ShapeCommand;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

class SimpleSpriteSymbol extends SWFSymbol {


	public var bitmapID:Int;
	public var matrix:Matrix;
	public var bounds:Rectangle;

	public function new () {
		super ();
	}
}
