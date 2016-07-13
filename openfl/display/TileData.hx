package openfl.display;


import openfl.geom.Rectangle;


class TileData {
	
	
	public var bitmapData (default, set):BitmapData;
	public var height (default, set):Int;
	public var width (default, set):Int;
	public var x (default, set):Int;
	public var y (default, set):Int;
	
	private var __uvHeight:Float;
	private var __uvWidth:Float;
	private var __uvX:Float;
	private var __uvY:Float;
	
	
	public function new (bitmapData:BitmapData, rect:Rectangle = null) {
		
		if (rect != null) {
			
			x = Std.int (rect.x);
			y = Std.int (rect.y);
			width = Std.int (rect.width);
			height = Std.int (rect.height);
			
		} else {
			
			x = 0;
			y = 0;
			width = 0;
			height = 0;
			
		}
		
		this.bitmapData = bitmapData;
		//__updateUVs ();
		
	}
	
	
	@:noCompletion private function __updateUVs ():Void {
		
		if (bitmapData != null) {
			
			__uvX = x / bitmapData.width;
			__uvY = y / bitmapData.height;
			__uvWidth = (x + width) / bitmapData.width;
			__uvHeight = (y + height) / bitmapData.height;
			
		}
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private function set_bitmapData (value:BitmapData):BitmapData {
		
		this.bitmapData = value;
		__updateUVs ();
		return value;
		
	}
	
	
	@:noCompletion private function set_height (value:Int):Int {
		
		this.height = value;
		__updateUVs ();
		return value;
		
	}
	
	
	@:noCompletion private function set_width (value:Int):Int {
		
		this.width = value;
		__updateUVs ();
		return value;
		
	}
	
	
	@:noCompletion private function set_x (value:Int):Int {
		
		this.x = value;
		__updateUVs ();
		return value;
		
	}
	
	
	@:noCompletion private function set_y (value:Int):Int {
		
		this.y = value;
		__updateUVs ();
		return value;
		
	}
	
	
}