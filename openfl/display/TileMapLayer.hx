package openfl.display;


import lime.graphics.opengl.GLBuffer;
import lime.utils.Float32Array;


class TileMapLayer {
	
	
	// TODO: Handle dirty flag
	
	public var tileSet:TileSet;
	
	private var __buffer:GLBuffer;
	private var __bufferData:Float32Array;
	private var __dirty:Bool;
	private var __tiles:Array<Tile>;
	
	
	public function new (tileSet:TileSet) {
		
		this.tileSet = tileSet;
		
		__tiles = new Array ();
		
	}
	
	
	public function addTile (tile:Tile):Void {
		
		__tiles.push (tile);
		__dirty = true;
		
	}
	
	
	public function removeTile (tile:Tile):Void {
		
		__tiles.remove (tile);
		__dirty = true;
		
	}
	
	
}