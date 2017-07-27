package openfl.display;


import openfl._internal.renderer.flash.FlashRenderer;
import openfl._internal.renderer.flash.FlashTilemap;
import openfl._internal.renderer.RenderSession;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.Vector;

#if !flash
import openfl._internal.renderer.cairo.CairoTilemap;
import openfl._internal.renderer.canvas.CanvasTilemap;
import openfl._internal.renderer.dom.DOMTilemap;
import openfl._internal.renderer.opengl.GLTilemap;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.Tile)
@:access(openfl.display.TileArray)
@:access(openfl.geom.Rectangle)


class Tilemap extends #if !flash DisplayObject #else Bitmap implements IDisplayObject #end implements IShaderDrawable {
	
	
	public var numTiles (default, null):Int;
	@:beta public var shader:Shader;
	public var tileset (default, set):Tileset;
	
	#if !flash
	public var smoothing:Bool;
	#end
	
	private var __tiles:Vector<Tile>;
	private var __tileArray:TileArray;
	private var __tileArrayDirty:Bool;
	
	#if !flash
	private var __height:Int;
	private var __width:Int;
	#end
	
	
	public function new (width:Int, height:Int, tileset:Tileset = null, smoothing:Bool = true) {
		
		super ();
		
		this.tileset = tileset;
		this.smoothing = smoothing;
		
		__tiles = new Vector ();
		numTiles = 0;
		
		#if !flash
		__width = width;
		__height = height;
		#else
		bitmapData = new BitmapData (width, height, true, 0);
		this.smoothing = smoothing;
		FlashRenderer.register (this);
		#end
		
	}
	
	
	public function addTile (tile:Tile):Tile {
		
		__tiles[numTiles] = tile;
		numTiles++;
		
		return tile;
		
	}
	
	
	public function addTiles (tiles:Array<Tile>):Array<Tile> {
		
		for (tile in tiles) {
			addTile (tile);
		}
		
		return tiles;
		
	}
	
	
	public function addTileAt (tile:Tile, index:Int):Tile {
		
		var cacheLength = __tiles.length;
		
		removeTile (tile);
		
		if (cacheLength < __tiles.length) {
			index--;
		}
		
		__tiles.insertAt (index, tile);
		__tileArrayDirty = true;
		numTiles++;
		
		return tile;
		
	}
	
	
	public function contains (tile:Tile):Bool {
		
		return (__tiles.indexOf (tile) > -1);
		
	}
	
	
	public function getTileAt (index:Int):Tile {
		
		if (index >= 0 && index < numTiles) {
			
			var tile = __tiles[index];
			
			if (tile == null && __tileArray != null && index < __tileArray.length) {
				
				tile = Tile.__fromTileArray (index, __tileArray);
				__tiles[index] = tile;
				
			}
			
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
	
	
	@:beta public function getTiles ():TileArray {
		
		__updateTileArray ();
		
		if (__tileArray == null) {
			__tileArray = new TileArray ();
		}
		
		return __tileArray;
		
	}
	
	
	public function removeTile (tile:Tile):Tile {
		
		var cacheLength = __tiles.length;
		
		for (i in 0...__tiles.length) {
			
			if (__tiles[i] == tile) {
				__tiles[i] = null;
			}
			
		}
		
		__tileArrayDirty = true;
		
		if (cacheLength < __tiles.length) {
			numTiles--;
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
		
		__tiles.splice (beginIndex, endIndex - beginIndex + 1);
		__tileArrayDirty = true;
		numTiles = __tiles.length;
		
	}
	
	
	@:beta public function setTiles (tileArray:TileArray):Void {
		
		__tileArray = tileArray;
		numTiles = __tileArray.length;
		__tileArray.__bufferDirty = true;
		__tileArrayDirty = false;
		__tiles.length = 0;
		
	}
	
	
	#if !flash
	private override function __getBounds (rect:Rectangle, matrix:Matrix):Void {
		
		var bounds = Rectangle.__pool.get ();
		bounds.setTo (0, 0, __width, __height);
		bounds.__transform (bounds, matrix);
		
		rect.__expand (bounds.x, bounds.y, bounds.width, bounds.height);
		
		Rectangle.__pool.release (bounds);
		
	}
	#end
	
	
	#if !flash
	private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool {
		
		if (!hitObject.visible || __isMask) return false;
		if (mask != null && !mask.__hitTestMask (x, y)) return false;
		
		__getRenderTransform ();
		
		var px = __renderTransform.__transformInverseX (x, y);
		var py = __renderTransform.__transformInverseY (x, y);
		
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
	private override function __renderCairo (renderSession:RenderSession):Void {
		
		#if lime_cairo
		super.__renderCairo (renderSession);
		CairoTilemap.render (this, renderSession);
		#end
		
	}
	
	
	private override function __renderCanvas (renderSession:RenderSession):Void {
		
		super.__renderCanvas (renderSession);
		CanvasTilemap.render (this, renderSession);
		
	}
	
	
	private override function __renderDOM (renderSession:RenderSession):Void {
		
		#if dom
		super.__renderDOM (renderSession);
		DOMTilemap.render (this, renderSession);
		#end
		
	}
	
	
	private override function __renderDOMClear (renderSession:RenderSession):Void {
		
		#if dom
		DOMTilemap.clear (this, renderSession);
		#end
		
	}
	#end
	
	
	private function __renderFlash ():Void {
		
		FlashTilemap.render (this);
		
	}
	
	
	#if !flash
	private override function __renderGL (renderSession:RenderSession):Void {
		
		super.__renderGL (renderSession);
		GLTilemap.render (this, renderSession);
		
	}
	#end
	
	
	#if !flash
	private override function __updateCacheBitmap (renderSession:RenderSession, force:Bool):Void {
		
		return;
		
	}
	#end
	
	
	private function __updateTileArray ():Void {
		
		if (__tiles.length > 0) {
			
			if (__tileArray == null) {
				__tileArray = new TileArray ();
			}
			
			if (__tileArray.length < numTiles) {
				__tileArray.length = numTiles;
			}
			
			var tile:Tile;
			
			for (i in 0...__tiles.length) {
				
				tile = __tiles[i];
				if (tile != null) {
					tile.__updateTileArray (i, __tileArray, __tileArrayDirty);
				}
				
			}
			
		}
		
		__tileArrayDirty = false;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	#if !flash
	private override function get_height ():Float {
		
		return __height * Math.abs (scaleY);
		
	}
	#end
	
	
	#if !flash
	private override function set_height (value:Float):Float {
		
		__height = Std.int (value);
		return __height * Math.abs (scaleY);
		
	}
	#else
	@:setter(height) private function set_height (value:Float):Void {
		
		if (value != bitmapData.height) {
			
			var cacheSmoothing = smoothing;
			bitmapData = new BitmapData (bitmapData.width, Std.int (value), true, 0);
			smoothing = cacheSmoothing;
			
		}
		
	}
	#end
	
	
	private function set_tileset (value:Tileset):Tileset {
		
		__tileArrayDirty = true;
		return this.tileset = value;
		
	}
	
	
	#if !flash
	private override function get_width ():Float {
		
		return __width * Math.abs (__scaleX);
		
	}
	#end
	
	
	#if !flash
	private override function set_width (value:Float):Float {
		
		__width = Std.int (value);
		return __width * Math.abs (__scaleX);
		
	}
	#else
	@:setter(width) private function set_width (value:Float):Void {
		
		if (value != bitmapData.width) {
			
			var cacheSmoothing = smoothing;
			bitmapData = new BitmapData (Std.int (value), bitmapData.height, true, 0);
			smoothing = cacheSmoothing;
			
		}
		
	}
	#end
	
	
}