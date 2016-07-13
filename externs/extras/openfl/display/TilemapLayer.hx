package openfl.display;


extern class TilemapLayer {
	
	
	public var numTiles (default, null):Int;
	public var tileset:Tileset;
	
	public function new (tileset:Tileset);
	
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