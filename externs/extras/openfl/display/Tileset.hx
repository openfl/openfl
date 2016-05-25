package openfl.display;


import openfl.geom.Rectangle;


extern class Tileset {
	
	
	public var bitmapData:BitmapData;
	
	public function new (bitmapData:BitmapData);
	
	public function addRect (rect:Rectangle):Int;
	
	
}