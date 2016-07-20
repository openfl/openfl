package openfl.display;


extern class Tilemap extends DisplayObject {
	
	
	public var numTiles (default, null):Int;
	public var smoothing:Bool;
	public var tileset (default, set):Tileset;
	
	public function new (width:Int, height:Int, tileset:Tileset = null, smoothing:Bool = true);
	
	public function addTile (tile:Tile):Tile;
	public function addTiles (tiles:Array<Tile>):Array<Tile>;
	public function addTileAt (tile:Tile, index:Int):Tile;
	public function contains (tile:Tile):Bool;
	public function getTileAt (index:Int):Tile;
	public function getTileIndex (tile:Tile):Int;
	public function removeTile (tile:Tile):Tile;
	public function removeTileAt (index:Int):Tile;
	public function removeTiles (beginIndex:Int = 0, endIndex:Int = 0x7fffffff):Void;
	
	
}