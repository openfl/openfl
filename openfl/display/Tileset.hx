package openfl.display;


import openfl.geom.Rectangle;


class Tileset {
	
	
	public var bitmapData (default, set):BitmapData;
	public var tileData:Array<TileData>;
	
	
	// TODO: Add support for adding uniform tile rectangles (margin, spacing, width, height)
	
	public function new (bitmapData:BitmapData) {
		
		tileData = new Array ();
		
		this.bitmapData = bitmapData;
		
	}
	
	
	public function addRect (rect:Rectangle):TileData {
		
		var data = new TileData (bitmapData, rect);
		tileData.push (data);
		
		return data;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function set_bitmapData (value:BitmapData):BitmapData {
		
		for (data in tileData) {
			
			data.bitmapData = value;
			
		}
		
		return this.bitmapData = value;
		
	}
	
	
}