package openfl.display;


import openfl.geom.Rectangle;


class Tileset {
	
	
	public var bitmapData (default, set):BitmapData;
	
	private var __data:Array<TileData>;
	
	
	// TODO: Add support for adding uniform tile rectangles (margin, spacing, width, height)
	
	public function new (bitmapData:BitmapData, rects:Array<Rectangle> = null) {
		
		__data = new Array ();
		
		this.bitmapData = bitmapData;
		
		if (rects != null) {
			
			for (rect in rects) {
				
				addRect (rect);
				
			}
			
		}
		
	}
	
	
	public function addRect (rect:Rectangle):Int {
		
		if (rect == null) return -1;
		
		var tileData = new TileData (rect);
		tileData.__update (bitmapData);
		__data.push (tileData);
		
		return __data.length - 1;
		
	}
	
	
	public function getRect (id:Int):Rectangle {
		
		if (id < __data.length && id >= 0) {
			
			return new Rectangle (__data[id].x, __data[id].y, __data[id].width, __data[id].height);
			
		}
		
		return null;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function set_bitmapData (value:BitmapData):BitmapData {
		
		bitmapData = value;
		
		for (data in __data) {
			
			data.__update (bitmapData);
			
		}
		
		return value;
		
	}
	
	
}


@:allow(openfl.display.Tileset) @:dox(hide) private class TileData {
	
	
	public var height:Int;
	public var width:Int;
	public var x:Int;
	public var y:Int;
	
	public var __uvHeight:Float;
	public var __uvWidth:Float;
	public var __uvX:Float;
	public var __uvY:Float;
	
	
	public function new (rect:Rectangle = null) {
		
		if (rect != null) {
			
			x = Std.int (rect.x);
			y = Std.int (rect.y);
			width = Std.int (rect.width);
			height = Std.int (rect.height);
			
		}
		
	}
	
	
	private function __update (bitmapData:BitmapData):Void {
		
		if (bitmapData != null) {
			
			__uvX = x / bitmapData.width;
			__uvY = y / bitmapData.height;
			__uvWidth = (x + width) / bitmapData.width;
			__uvHeight = (y + height) / bitmapData.height;
			
		}
		
	}
	
	
}