package openfl.display;

@:jsRequire("openfl/display/ITileContainer", "default")
extern interface ITileContainer
{
	public var numTiles(get, never):Int;
	@:noCompletion private function get_numTiles():Int;
	public function addTile(tile:Tile):Tile;
	public function addTileAt(tile:Tile, index:Int):Tile;
	public function addTiles(tiles:Array<Tile>):Array<Tile>;
	public function contains(tile:Tile):Bool;
	public function getTileAt(index:Int):Tile;
	public function getTileIndex(tile:Tile):Int;
	public function removeTile(tile:Tile):Tile;
	public function removeTileAt(index:Int):Tile;
	public function removeTiles(beginIndex:Int = 0, endIndex:Int = 0x7fffffff):Void;
	public function setTileIndex(tile:Tile, index:Int):Void;
	public function swapTiles(tile1:Tile, tile2:Tile):Void;
	public function swapTilesAt(index1:Int, index2:Int):Void;
}
