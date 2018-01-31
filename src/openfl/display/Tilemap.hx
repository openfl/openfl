package openfl.display;


import openfl._internal.renderer.flash.FlashRenderer;
import openfl._internal.renderer.flash.FlashTilemap;
import openfl._internal.renderer.RenderSession;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.Vector;

#if !flash
import openfl._internal.renderer.cairo.CairoBitmap;
import openfl._internal.renderer.cairo.CairoDisplayObject;
import openfl._internal.renderer.cairo.CairoTilemap;
import openfl._internal.renderer.canvas.CanvasBitmap;
import openfl._internal.renderer.canvas.CanvasDisplayObject;
import openfl._internal.renderer.canvas.CanvasTilemap;
import openfl._internal.renderer.dom.DOMBitmap;
import openfl._internal.renderer.dom.DOMDisplayObject;
import openfl._internal.renderer.dom.DOMTilemap;
import openfl._internal.renderer.opengl.GLBitmap;
import openfl._internal.renderer.opengl.GLDisplayObject;
import openfl._internal.renderer.opengl.GLTilemap;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.Tile)
@:access(openfl.display.TileArray)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Rectangle)


class Tilemap extends #if !flash DisplayObject #else Bitmap implements IDisplayObject #end implements IShaderDrawable {
	
	
	public var numTiles (default, null):Int;
	@:beta public var shader:Shader;
	public var tileset (get, set):Tileset;
	
	#if !flash
	public var smoothing:Bool;
	#end
	
	private var __tiles:Vector<Tile>;
	private var __tileset:Tileset;
	private var __tileArray:TileArray;
	private var __tileArrayDirty:Bool;
	
	#if !flash
	private var __height:Int;
	private var __width:Int;
	#end
	
	
	#if openfljs
	private static function __init__ () {
		
		untyped Object.defineProperty (Tilemap.prototype, "tileset", { get: untyped __js__ ("function () { return this.get_tileset (); }"), set: untyped __js__ ("function (v) { return this.set_tileset (v); }") });
		
	}
	#end
	
	
	public function new (width:Int, height:Int, tileset:Tileset = null, smoothing:Bool = true) {
		
		super ();
		
		__tileset = tileset;
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
		
		if (tile == null) return null;
		
		if (tile.parent == this) {
			
			removeTile (tile);
			
		}
		
		__tiles[numTiles] = tile;
		tile.parent = this;
		numTiles++;
		#if !flash
		__setRenderDirty ();
		#end
		
		return tile;
		
	}
	
	
	public function addTileAt (tile:Tile, index:Int):Tile {
		
		if (tile == null) return null;
		
		if (tile.parent == this) {
			
			var cacheLength = __tiles.length;
			
			removeTile (tile);
			
			if (cacheLength > __tiles.length) {
				index--;
			}
			
		}
		
		__tiles.insertAt (index, tile);
		tile.parent = this;
		__tileArrayDirty = true;
		numTiles++;
		
		#if !flash
		__setRenderDirty ();
		#end
		
		return tile;
		
	}
	
	
	public function addTiles (tiles:Array<Tile>):Array<Tile> {
		
		for (tile in tiles) {
			addTile (tile);
		}
		
		return tiles;
		
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
		
		if (tile != null && tile.parent == this)
		{
			var cacheLength = __tiles.length;

			for (i in 0...__tiles.length) {

				if (__tiles[i] == tile) {
					tile.parent = null;
					__tiles.splice (i, 1);
					break;
				}

			}

			__tileArrayDirty = true;

			if (cacheLength > __tiles.length) {
				numTiles--;
			}

			if (numTiles <= 0 && __tileArray != null) {
				__tileArray.length = 0;
			}

			#if !flash
			__setRenderDirty ();
			#end
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
		__tileArrayDirty = true;
		numTiles = __tiles.length;
		
		if (numTiles == 0 && __tileArray != null) {
			__tileArray.length = 0;
		}
		
		#if !flash
		__setRenderDirty ();
		#end
		
	}
	
	
	@:beta public function setTiles (tileArray:TileArray):Void {
		
		__tileArray = tileArray;
		numTiles = __tileArray.length;
		__tileArray.__bufferDirty = true;
		__tileArrayDirty = false;
		__tiles.length = 0;
		#if !flash
		__setRenderDirty ();
		#end
		
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
		__updateCacheBitmap (renderSession, !__worldColorTransform.__isDefault ());
		
		if (__cacheBitmap != null && !__cacheBitmapRender) {
			
			CairoBitmap.render (__cacheBitmap, renderSession);
			
		} else {
			
			CairoDisplayObject.render (this, renderSession);
			CairoTilemap.render (this, renderSession);
			
		}
		#end
		
	}
	
	
	private override function __renderCanvas (renderSession:RenderSession):Void {
		
		__updateCacheBitmap (renderSession, !__worldColorTransform.__isDefault ());
		
		if (__cacheBitmap != null && !__cacheBitmapRender) {
			
			CanvasBitmap.render (__cacheBitmap, renderSession);
			
		} else {
			
			CanvasDisplayObject.render (this, renderSession);
			CanvasTilemap.render (this, renderSession);
			
		}
		
	}
	
	
	private override function __renderDOM (renderSession:RenderSession):Void {
		
		__updateCacheBitmap (renderSession, !__worldColorTransform.__isDefault ());
		
		if (__cacheBitmap != null && !__cacheBitmapRender) {
			
			__renderDOMClear (renderSession);
			__cacheBitmap.stage = stage;
			
			DOMBitmap.render (__cacheBitmap, renderSession);
			
		} else {
			
			DOMDisplayObject.render (this, renderSession);
			DOMTilemap.render (this, renderSession);
			
		}
		
	}
	
	
	private override function __renderDOMClear (renderSession:RenderSession):Void {
		
		DOMTilemap.clear (this, renderSession);
		
	}
	#end
	
	
	private function __renderFlash ():Void {
		
		FlashTilemap.render (this);
		
	}
	
	
	#if !flash
	private override function __renderGL (renderSession:RenderSession):Void {
		
		__updateCacheBitmap (renderSession, false);
		
		if (__cacheBitmap != null && !__cacheBitmapRender) {
			
			GLBitmap.render (__cacheBitmap, renderSession);
			
		} else {
			
			GLDisplayObject.render (this, renderSession);
			GLTilemap.render (this, renderSession);
			
		}
		
	}
	
	
	private override function __renderGLMask (renderSession:RenderSession):Void {
		
		__updateCacheBitmap (renderSession, false);
		
		if (__cacheBitmap != null && !__cacheBitmapRender) {
			
			GLBitmap.renderMask (__cacheBitmap, renderSession);
			
		} else {
			
			GLDisplayObject.renderMask (this, renderSession);
			GLTilemap.renderMask (this, renderSession);
			
		}
		
	}
	#end
	
	
	#if !flash
	private override function __updateCacheBitmap (renderSession:RenderSession, force:Bool):Bool {
		
		if (filters == null) return false;
		return super.__updateCacheBitmap (renderSession, force);
		
	}
	#end
	
	
	private function __updateTileArray ():Void {
		
		if (__tiles.length > 0) {
			
			if (__tileArray == null) {
				__tileArray = new TileArray ();
			}
			
			//if (__tileArray.length < numTiles) {
				__tileArray.length = numTiles;
			//}
			
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
	
	
	private function get_tileset ():Tileset {
		
		return __tileset;
		
	}
	
	
	private function set_tileset (value:Tileset):Tileset {
		
		__tileArrayDirty = true;
		return __tileset = value;
		
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
