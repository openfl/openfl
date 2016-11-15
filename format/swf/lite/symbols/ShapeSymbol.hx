package format.swf.lite.symbols;


import format.swf.exporters.core.ShapeCommand;
import openfl.geom.Rectangle;
import openfl.display.Graphics;

class ShapeSymbol extends SWFSymbol {


	public var commands:Array<ShapeCommand>;
	public var bounds:Rectangle;
	public var graphics:Graphics;

	public function new () {

		super ();

	}


}
