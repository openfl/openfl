package openfl.display;


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class TileContainer extends Tile implements ITileContainer {
	
	
	public var numTiles (get, never):Int;
	
	@:noCompletion private var __tiles:Array<Tile>;
	
	
	#if openfljs
	@:noCompletion private static function __init__ () {
		
		untyped Object.defineProperty (TileContainer.prototype, "numTiles", { get: untyped __js__ ("function () { return this.get_numTiles (); }") });
		
	}
	#end
	
	
	public function new (x:Float = 0, y:Float = 0, scaleX:Float = 1, scaleY:Float = 1, rotation:Float = 0, originX:Float = 0, originY:Float = 0) {
		
		super (-1, x, y, scaleX, scaleY, rotation, originX, originY);
		
		__tiles = new Array ();
		__length = 0;
		
	}
	
	
	public function addTile (tile:Tile):Tile {
		
		if (tile == null) return null;
		
		if (tile.parent == this) {
			
			__tiles.remove (tile);
			__length--;
			
		}
		
		__tiles[numTiles] = tile;
		tile.parent = this;
		__length++;
		
		__setRenderDirty ();
		
		return tile;
		
	}
	
	
	public function addTileAt (tile:Tile, index:Int):Tile {
		
		if (tile == null) return null;
		
		if (tile.parent == this) {
			
			__tiles.remove (tile);
			__length--;
			
		}
		
		__tiles.insert (index, tile);
		tile.parent = this;
		__length++;
		
		__setRenderDirty ();
		
		return tile;
		
	}
	
	
	public function addTiles (tiles:Array<Tile>):Array<Tile> {
		
		for (tile in tiles) {
			addTile (tile);
		}
		
		return tiles;
		
	}
	
	
	public override function clone ():TileContainer {
		
		var group = new TileContainer ();
		for (tile in __tiles) {
			group.addTile (tile.clone ());
		}
		return group;
		
	}
	
	
	public function contains (tile:Tile):Bool {
		
		return (__tiles.indexOf (tile) > -1);
		
	}
	
	
	public function getTileAt (index:Int):Tile {
		
		if (index >= 0 && index < numTiles) {
			
			return __tiles[index];
			
		}
		
		return null;
		
	}
	
	
	public function getTileIndex (tile:Tile):Int {
		
		for (i in 0...__tiles.length) {
			if (__tiles[i] == tile) return i;
		}
		
		return -1;
		
	}
	
	
	public function removeTile (tile:Tile):Tile {
		
		if (tile != null && tile.parent == this) {
			
			tile.parent = null;
			__tiles.remove (tile);
			__length--;
			__setRenderDirty ();
			
		}
		
		return tile;
		
	}
	
	
	public function removeTileAt (index:Int):Tile {
		
		if (index >= 0 && index < numTiles) {
			return removeTile (__tiles[index]);
		}
		
		return null;
		
	}
	
	
	public function removeTiles (beginIndex:Int = 0, endIndex:Int = 0x7fffffff):Void {
		
		if (beginIndex < 0) beginIndex = 0;
		if (endIndex > __tiles.length - 1) endIndex = __tiles.length - 1;
		
		var removed = __tiles.splice (beginIndex, endIndex - beginIndex + 1);
		for (tile in removed) {
			tile.parent = null;
		}
		__length = __tiles.length;
		
		__setRenderDirty ();
		
	}
	
	
	public function setTileIndex (tile:Tile, index:Int):Void {
		
		if (index >= 0 && index <= numTiles && tile.parent == this) {
			
			__tiles.remove (tile);
			__tiles.insert (index, tile);
			__setRenderDirty ();
			
		}
		
	}
	
	
	public function swapTiles (tile1:Tile, tile2:Tile):Void {
		
		if (tile1.parent == this && tile2.parent == this) {
			
			var index1 = __tiles.indexOf (tile1);
			var index2 = __tiles.indexOf (tile2);
			
			__tiles[index1] = tile2;
			__tiles[index2] = tile1;
			
			__setRenderDirty ();
			
		}
		
	}
	
	
	public function swapTilesAt (index1:Int, index2:Int):Void {
		
		var swap = __tiles[index1];
		__tiles[index1] = __tiles[index2];
		__tiles[index2] = swap;
		swap = null;
		
		__setRenderDirty ();
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	@:noCompletion private function get_numTiles ():Int {
		
		return __length;
		
	}
	
	
}