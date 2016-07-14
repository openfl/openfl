package openfl.display;


extern class Tilemap extends DisplayObject {
	
	
	public var pixelSnapping:PixelSnapping;
	public var smoothing:Bool;
	public var tilemapData (default, set):TilemapData;
	
	public function new (tilemapData:TilemapData = null, pixelSnapping:PixelSnapping = AUTO, smoothing:Bool = false);
	
	
}