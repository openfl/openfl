package openfl.display;


import lime.graphics.opengl.GLBuffer;
import lime.utils.Float32Array;
import openfl._internal.renderer.flash.FlashRenderer;
import openfl._internal.renderer.flash.FlashTilemap;
import openfl._internal.renderer.RenderSession;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

#if !flash
import openfl._internal.renderer.cairo.CairoTilemap;
import openfl._internal.renderer.canvas.CanvasTilemap;
import openfl._internal.renderer.dom.DOMTilemap;
import openfl._internal.renderer.opengl.GLTilemap;
#end

@:access(openfl.geom.Rectangle)


class Tilemap extends #if !flash DisplayObject #else Bitmap implements IDisplayObject #end {
	
	
	public var numTiles (default, null):Int;
	public var tileset (default, set):Tileset;
	
	#if !flash
	public var smoothing:Bool;
	#end
	
	private var __buffer:GLBuffer;
	private var __bufferData:Float32Array;
	private var __cacheAlpha:Float;
	private var __dirty:Bool;
	private var __tiles:Array<Tile>;
	
	#if !flash
	private var __height:Int;
	private var __width:Int;
	#end
	
	
	public function new (width:Int, height:Int, tileset:Tileset = null, smoothing:Bool = true) {
		
		super ();
		
		this.tileset = tileset;
		this.smoothing = smoothing;
		
		__tiles = new Array ();
		numTiles = 0;
		
		#if !flash
		__width = width;
		__height = height;
		#else
		bitmapData = new BitmapData (width, height, true, 0);
		FlashRenderer.register (this);
		#end
		
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
	
	
	public function removeTiles (beginIndex:Int = 0, endIndex:Int = 0x7fffffff):Void {
		
		if (beginIndex < 0) beginIndex = 0;
		if (endIndex > __tiles.length - 1) endIndex = __tiles.length - 1;
		
		__tiles.splice (beginIndex, endIndex - beginIndex + 1);
		__dirty = true;
		numTiles = __tiles.length;
		
	}
	
	
	#if !flash
	private override function __getBounds (rect:Rectangle, matrix:Matrix):Void {
		
		var bounds = Rectangle.__temp;
		bounds.setTo (0, 0, __width, __height);
		bounds.__transform (bounds, matrix);
		
		rect.__expand (bounds.x, bounds.y, bounds.width, bounds.height);
		
	}
	#end
	
	
	#if !flash
	private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool {
		
		if (!hitObject.visible || __isMask) return false;
		if (mask != null && !mask.__hitTestMask (x, y)) return false;
		
		__getWorldTransform ();
		
		var px = __worldTransform.__transformInverseX (x, y);
		var py = __worldTransform.__transformInverseY (x, y);
		
		if (px > 0 && py > 0 && px <= __width && py <= __height) {
			
			if (stack != null && !interactiveOnly) {
				
				stack.push (hitObject);
				
			}
			
			return true;
			
		}
		
		return false;
		
	}
	#end
	
	
	#if !flash
	public override function __renderCairo (renderSession:RenderSession):Void {
		
		CairoTilemap.render (this, renderSession);
		
	}
	
	
	public override function __renderCanvas (renderSession:RenderSession):Void {
		
		CanvasTilemap.render (this, renderSession);
		
	}
	
	
	public override function __renderDOM (renderSession:RenderSession):Void {
		
		DOMTilemap.render (this, renderSession);
		
	}
	#end
	
	
	public function __renderFlash ():Void {
		
		FlashTilemap.render (this);
		
	}
	
	
	#if !flash
	public override function __renderGL (renderSession:RenderSession):Void {
		
		GLTilemap.render (this, renderSession);
		
	}
	#end
	
	
	
	
	// Get & Set Methods
	
	
	
	
	#if !flash
	private override function get_height ():Float {
		
		return __height;
		
	}
	
	
	private override function set_height (value:Float):Float {
		
		return __height = Std.int (value);
		
	}
	#end
	
	
	private function set_tileset (value:Tileset):Tileset {
		
		__dirty = true;
		return this.tileset = value;
		
	}
	
	
	#if !flash
	private override function get_width ():Float {
		
		return __width;
		
	}
	
	
	private override function set_width (value:Float):Float {
		
		return __width = Std.int (value);
		
	}
	#end
	
	
}