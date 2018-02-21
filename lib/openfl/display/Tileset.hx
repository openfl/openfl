package openfl.display;


import openfl.geom.Rectangle;

@:jsRequire("openfl/display/Tileset", "default")


extern class Tileset {
	
	
	public var bitmapData (default, set):BitmapData;
	
	public function new (bitmapData:BitmapData, rects:Array<Rectangle> = null);
	
	public function addRect (rect:Rectangle):Int;
	public function getRect (id:Int):Rectangle;
	
	
}