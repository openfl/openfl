package openfl.display;


import openfl.geom.Rectangle;


class Tileset {
	
	
	public var bitmapData:BitmapData;
	
	private var __rects:Array<Rectangle>;
	
	
	// TODO: Add support for adding uniform tile rectangles (margin, spacing, width, height)
	
	public function new (bitmapData:BitmapData) {
		
		this.bitmapData = bitmapData;
		
		__rects = new Array ();
		
	}
	
	
	public function addRect (rect:Rectangle):Int {
		
		__rects.push (rect);
		return __rects.length - 1;
		
	}
	
	
}