package format.swf.lite.symbols;


import format.swf.exporters.core.ShapeCommand;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;
import openfl.display.Graphics;

class ShapeSymbol extends SWFSymbol {


	public var commands:Array<ShapeCommand>;
	public var bounds:Rectangle;
	public var graphics:Graphics;

	public var cachedBitmapData(default, null):BitmapData;
	public var cachedScaleX(default, null):Float;
	public var cachedScaleY(default, null):Float;

	public function new () {

		super ();

	}

	public function hasCachedBitmapData (scaleX:Float, scaleY:Float):Bool {

		return cachedBitmapData != null && Math.abs(cachedScaleX - scaleX) < 0.001 && Math.abs(cachedScaleY - scaleY) < 0.001;

	}


	public function setCachedBitmapData (bitmapData:BitmapData, scaleX:Float, scaleY:Float) {

		// only cache the first one for now... augment if required

		if (cachedBitmapData == null) {

			cachedBitmapData = bitmapData;
			cachedScaleX = scaleX;
			cachedScaleY = scaleY;

		}

	}
}
