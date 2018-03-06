package openfl.display;


extern class TileGroup extends Tile {
	
	
	public var numTiles (get, never):Int;
	
	public function new (x:Float = 0, y:Float = 0, scaleX:Float = 1, scaleY:Float = 1, rotation:Float = 0, originX:Float = 0, originY:Float = 0);
	public function addTile (tile:Tile):Tile;
	public function addTileAt (tile:Tile, index:Int):Tile;
	public function addTiles (tiles:Array<Tile>):Array<Tile>;
	public function contains (tile:Tile):Bool;
	public function copyFrom (other:TileGroup):Void;
	public function getTileAt (index:Int):Tile;
	public function getTileIndex (tile:Tile):Int;
	public function removeTile (tile:Tile):Tile;
	public function removeTileAt (index:Int):Tile;
	public function removeTiles (beginIndex:Int = 0, endIndex:Int = 0x7fffffff):Void;
	
	
}