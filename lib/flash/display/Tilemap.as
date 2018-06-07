package flash.display {
	
	
	/**
	 * @externs
	 */
	public class Tilemap extends DisplayObject implements ITileContainer {
		
		
		public function get numTiles ():int { return 0; }
		
		protected function get_numTiles ():int { return 0; }
		
		public var smoothing:Boolean;
		public var tileAlphaEnabled:Boolean;
		public var tileColorTransformEnabled:Boolean;
		public var tileset:Tileset;
		
		protected function get_tileset ():Tileset { return null; }
		protected function set_tileset (value:Tileset):Tileset { return null; }
		
		public function Tilemap (width:int, height:int, tileset:Tileset = null, smoothing:Boolean = true) {}
		
		public function addTile (tile:Tile):Tile { return null; }
		public function addTiles (tiles:Array):Array { return null; }
		public function addTileAt (tile:Tile, index:int):Tile { return null; }
		public function contains (tile:Tile):Boolean { return false; }
		public function getTileAt (index:int):Tile { return null; }
		public function getTileIndex (tile:Tile):int { return 0; }
		public function getTiles ():TileContainer { return null; }
		public function removeTile (tile:Tile):Tile { return null; }
		public function removeTileAt (index:int):Tile { return null; }
		public function removeTiles (beginIndex:int = 0, endIndex:int = 0x7fffffff):void {}
		public function setTileIndex (tile:Tile, index:int):void {}
		public function setTiles (group:TileContainer):void {}
		public function swapTiles (tile1:Tile, tile2:Tile):void {}
		public function swapTilesAt (index1:int, index2:int):void {}
		
		
	}
	
	
}