package openfl.display;


import openfl.geom.Rectangle;


class Tileset {
	
	
	public var bitmapData:BitmapData;
	
	private var __rects:Array<Rectangle>;
	private var __uvs:Array<Rectangle>;
	
	
	// TODO: Add support for adding uniform tile rectangles (margin, spacing, width, height)
	
	public function new (bitmapData:BitmapData) {
		
		this.bitmapData = bitmapData;
		
		__rects = new Array ();
		__uvs = new Array ();
		
	}
	
	
	public function addRect (rect:Rectangle):Int {
		
		__rects.push (rect);
		__uvs.push (new Rectangle (rect.x / bitmapData.width, rect.y / bitmapData.height, rect.right / bitmapData.width, rect.bottom / bitmapData.height));
		return __rects.length - 1;
		
	}
	
	
}