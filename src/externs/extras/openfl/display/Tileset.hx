package openfl.display;


import openfl.geom.Rectangle;


extern class Tileset {
	
	
	public var bitmapData (default, set):BitmapData;
	
	public function new (bitmapData:BitmapData, rects:Array<Rectangle> = null);
	
	public function addRect (rect:Rectangle, offsetX:Int = 0, offsetY:Int = 0, rotated:Bool = false):Int;
	public function getRect (id:Int):Rectangle;
	
	
}