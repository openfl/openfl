package openfl.display {
	
	
	/**
	 * @externs
	 */
	public interface ITileContainer {
		
		
		function get numTiles ():int;
		
		// @:noCompletion private function get_numTiles ():Int;
		
		function addTile (tile:Tile):Tile;
		function addTileAt (tile:Tile, index:int):Tile;
		function addTiles (tiles:Array):Array;
		function contains (tile:Tile):Boolean;
		function getTileAt (index:int):Tile;
		function getTileIndex (tile:Tile):int;
		function removeTile (tile:Tile):Tile;
		function removeTileAt (index:int):Tile;
		function removeTiles (beginIndex:int = 0, endIndex:int = 0x7fffffff):void;
		function setTileIndex (tile:Tile, index:int):void;
		function swapTiles (tile1:Tile, tile2:Tile):void;
		function swapTilesAt (index1:int, index2:int):void;
		
		
	}
	
	
}