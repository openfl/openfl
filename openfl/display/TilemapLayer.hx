package openfl.display;


import lime.graphics.opengl.GLBuffer;
import lime.utils.Float32Array;


class TilemapLayer {
	
	
	// TODO: Handle dirty flag
	
	public var numTiles (default, null):Int;
	public var tileset:Tileset;
	
	private var __buffer:GLBuffer;
	private var __bufferData:Float32Array;
	private var __dirty:Bool;
	private var __tiles:Array<Tile>;
	
	
	public function new (tileset:Tileset) {
		
		this.tileset = tileset;
		
		__tiles = new Array ();
		numTiles = 0;
		
	}
	
	
	public function addTile (tile:Tile):Tile {
		
		__tiles.push (tile);
		__dirty = true;
		numTiles++;
		
		return tile;
		
	}
	
	
	public function addTiles (tiles:Array<Tile>):Array<Tile> {
		
		__tiles = __tiles.concat (tiles);
		__dirty = true;
		numTiles = __tiles.length;
		
		return tiles;
		
	}
	
	
	public function addTileAt (tile:Tile, index:Int):Tile {
		
		__tiles.remove (tile);
		__tiles.insert (index, tile);
		__dirty = true;
		numTiles = __tiles.length;
		
		return tile;
		
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
		
		__tiles.remove (tile);
		__dirty = true;
		numTiles = __tiles.length;
		
		return tile;
		
	}
	
	
	public function removeTileAt (index:Int):Tile {
		
		if (index >= 0 && index < numTiles) {
			
			return removeTile (__tiles[index]);
			
		}
		
		return null;
		
	}
	
	
}