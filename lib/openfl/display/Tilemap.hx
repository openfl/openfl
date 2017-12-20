package openfl.display;


@:jsRequire("openfl/display/Tilemap", "default")

extern class Tilemap extends DisplayObject {
	
	
	public var numTiles (default, null):Int;
	@:beta public var shader:Shader;
	public var smoothing:Bool;
	public var tileset (default, set):Tileset;
	
	public function new (width:Int, height:Int, tileset:Tileset = null, smoothing:Bool = true);
	
	public function addTile (tile:Tile):Tile;
	public function addTiles (tiles:Array<Tile>):Array<Tile>;
	public function addTileAt (tile:Tile, index:Int):Tile;
	public function contains (tile:Tile):Bool;
	public function getTileAt (index:Int):Tile;
	public function getTileIndex (tile:Tile):Int;
	@:beta public function getTiles ():TileArray;
	public function removeTile (tile:Tile):Tile;
	public function removeTileAt (index:Int):Tile;
	public function removeTiles (beginIndex:Int = 0, endIndex:Int = 0x7fffffff):Void;
	@:beta public function setTiles (tileArray:TileArray):Void;
	
	
}