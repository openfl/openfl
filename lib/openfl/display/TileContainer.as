package openfl.display {
	
	
	/**
	 * @externs
	 */
	public class TileContainer extends Tile implements ITileContainer {
		
		
		public function get numTiles ():int { return 0; }
		
		protected function get_numTiles ():int { return 0; }
		
		public function TileContainer (x:Number = 0, y:Number = 0, scaleX:Number = 1, scaleY:Number = 1, rotation:Number = 0, originX:Number = 0, originY:Number = 0) {}
		public function addTile (tile:Tile):Tile { return null; }
		public function addTileAt (tile:Tile, index:int):Tile { return null; }
		public function addTiles (tiles:Array):Array { return null; }
		public function contains (tile:Tile):Boolean { return false; }
		public function getTileAt (index:int):Tile { return null; }
		public function getTileIndex (tile:Tile):int { return 0; }
		public function removeTile (tile:Tile):Tile { return null; }
		public function removeTileAt (index:int):Tile { return null; }
		public function removeTiles (beginIndex:int = 0, endIndex:int = 0x7fffffff):void {}
		public function setTileIndex (tile:Tile, index:int):void {}
		public function swapTiles (tile1:Tile, tile2:Tile):void {}
		public function swapTilesAt (index1:int, index2:int):void {}
		
		
	}
	
	
}