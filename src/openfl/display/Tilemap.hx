package openfl.display;


import openfl._internal.renderer.flash.FlashRenderer;
import openfl._internal.renderer.flash.FlashTilemap;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

#if !flash
import lime.graphics.opengl.GLBuffer;
import lime.graphics.GLRenderContext;
import lime.utils.Float32Array;
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


class Tilemap extends #if !flash DisplayObject #else Bitmap implements IDisplayObject #end implements ITileContainer {
	
	
	public var numTiles (get, never):Int;
	public var tileAlphaEnabled:Bool;
	public var tileColorTransformEnabled:Bool;
	public var tileset (get, set):Tileset;
	
	#if !flash
	public var smoothing:Bool;
	#end
	
	private var __group:TileContainer;
	private var __tileset:Tileset;
	
	#if ((openfl < "9.0.0") && enable_tile_array)
	private var __tileArray:TileArray;
	#end
	
	#if !flash
	private var __buffer:GLBuffer;
	private var __bufferContext:GLRenderContext;
	private var __bufferData:Float32Array;
	private var __bufferLength:Int;
	private var __height:Int;
	private var __width:Int;
	#end
	
	
	#if openfljs
	private static function __init__ () {
		
		untyped Object.defineProperties (Tilemap.prototype, {
			"numTiles": { get: untyped __js__ ("function () { return this.get_numTiles (); }") },
			"tileset": { get: untyped __js__ ("function () { return this.get_tileset (); }"), set: untyped __js__ ("function (v) { return this.set_tileset (v); }") }
		});
		
	}
	#end
	
	
	public function new (width:Int, height:Int, tileset:Tileset = null, smoothing:Bool = true) {
		
		super ();
		
		__tileset = tileset;
		this.smoothing = smoothing;
		
		tileAlphaEnabled = true;
		tileColorTransformEnabled = true;
		
		__group = new TileContainer ();
		
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
		
		return __group.addTile (tile);
		
	}
	
	
	public function addTileAt (tile:Tile, index:Int):Tile {
		
		return __group.addTileAt (tile, index);
		
	}
	
	
	public function addTiles (tiles:Array<Tile>):Array<Tile> {
		
		return __group.addTiles (tiles);
		
	}
	
	
	public function contains (tile:Tile):Bool {
		
		return __group.contains (tile);
		
	}
	
	
	public function getTileAt (index:Int):Tile {
		
		return __group.getTileAt (index);
		
	}
	
	
	public function getTileIndex (tile:Tile):Int {
		
		return __group.getTileIndex (tile);
		
	}
	
	
	#if ((openfl < "9.0.0") && enable_tile_array)
	@:deprecated public function getTiles ():TileArray {
		
		if (__tileArray == null) {
			
			__tileArray = new TileArray ();
			
		}
		
		__tileArray.length = numTiles;
		var tile;
		
		for (i in 0...numTiles) {
			
			__tileArray.position = i;
			tile = __tiles[i];
			
			__tileArray.alpha = tile.__alpha;
			__tileArray.colorTransform = tile.__colorTransform;
			__tileArray.id = tile.__id;
			__tileArray.matrix = tile.__matrix;
			__tileArray.shader = tile.__shader;
			__tileArray.tileset = tile.__tileset;
			__tileArray.visible = tile.__visible;
			
		}
		
		return __tileArray;
		
	}
	#else
	public function getTiles ():TileContainer {
		
		return __group.clone ();
		
	}
	#end
	
	
	public function removeTile (tile:Tile):Tile {
		
		return __group.removeTile (tile);
		
	}
	
	
	public function removeTileAt (index:Int):Tile {
		
		return __group.removeTileAt (index);
		
	}
	
	
	public function removeTiles (beginIndex:Int = 0, endIndex:Int = 0x7fffffff):Void {
		
		return __group.removeTiles (beginIndex, endIndex);
		
	}
	
	
	public function setTileIndex (tile:Tile, index:Int):Void {
		
		__group.setTileIndex (tile, index);
		
	}
	
	
	#if ((openfl < "9.0.0") && enable_tile_array)
	@:deprecated public function setTiles (tileArray:TileArray):Void {
		
		if (tileArray != __tileArray) {
			
			__tileArray = tileArray;
			
		}
		
		var length = tileArray.length;
		
		for (i in numTiles...length) {
			
			addTile (new Tile ());
			
		}
		
		var tile, colorTransform;
		
		for (i in 0...length) {
			
			tileArray.position = i;
			tile = __tiles[i];
			
			tile.__alpha = tileArray.alpha;
			
			colorTransform = tileArray.colorTransform;
			
			if (colorTransform != null) {
				
				#if flash
				tile.__colorTransform = new ColorTransform (colorTransform.redMultiplier, colorTransform.greenMultiplier, colorTransform.blueMultiplier, colorTransform.alphaMultiplier, colorTransform.redOffset, colorTransform.greenOffset, colorTransform.blueOffset, colorTransform.alphaOffset);
				#else
				tile.__colorTransform = colorTransform.__clone ();
				#end
				
			}
			
			tile.__id = tileArray.id;
			tile.__matrix.copyFrom (tileArray.matrix);
			tile.__shader = tileArray.shader;
			tile.__tileset = tileArray.tileset;
			tile.__visible = tileArray.visible;
			
		}
		
		__setRenderDirty ();
		
	}
	#else
	public function setTiles (group:TileContainer):Void {
		
		for (tile in group.__tiles) {
			
			addTile (tile);
			
		}
		
	}
	#end
	
	
	public function swapTiles (tile1:Tile, tile2:Tile):Void {
		
		__group.swapTiles (tile1, tile2);
		
	}
	
	
	public function swapTilesAt (index1:Int, index2:Int):Void {
		
		__group.swapTilesAt (index1, index2);
		
	}
	
	
	#if !flash
	private override function __enterFrame (deltaTime:Int):Void {
		
		if (__group.__dirty) {
			
			__setRenderDirty ();
			
		}
		
	}
	#end
	
	
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
	private override function __renderCairo (renderer:CairoRenderer):Void {
		
		#if lime_cairo
		__updateCacheBitmap (renderer, !__worldColorTransform.__isDefault ());
		
		if (__cacheBitmap != null && !__isCacheBitmapRender) {
			
			CairoBitmap.render (__cacheBitmap, renderer);
			
		} else {
			
			CairoDisplayObject.render (this, renderer);
			CairoTilemap.render (this, renderer);
			
		}
		
		__renderEvent (renderer);
		#end
		
	}
	
	
	private override function __renderCanvas (renderer:CanvasRenderer):Void {
		
		__updateCacheBitmap (renderer, !__worldColorTransform.__isDefault ());
		
		if (__cacheBitmap != null && !__isCacheBitmapRender) {
			
			CanvasBitmap.render (__cacheBitmap, renderer);
			
		} else {
			
			CanvasDisplayObject.render (this, renderer);
			CanvasTilemap.render (this, renderer);
			
		}
		
		__renderEvent (renderer);
		
	}
	
	
	private override function __renderDOM (renderer:DOMRenderer):Void {
		
		__updateCacheBitmap (renderer, !__worldColorTransform.__isDefault ());
		
		if (__cacheBitmap != null && !__isCacheBitmapRender) {
			
			__renderDOMClear (renderer);
			__cacheBitmap.stage = stage;
			
			DOMBitmap.render (__cacheBitmap, renderer);
			
		} else {
			
			DOMDisplayObject.render (this, renderer);
			DOMTilemap.render (this, renderer);
			
		}
		
		__renderEvent (renderer);
		
	}
	
	
	private override function __renderDOMClear (renderer:DOMRenderer):Void {
		
		DOMTilemap.clear (this, renderer);
		
	}
	#end
	
	
	private function __renderFlash ():Void {
		
		FlashTilemap.render (this);
		
	}
	
	
	#if !flash
	private override function __renderGL (renderer:OpenGLRenderer):Void {
		
		__updateCacheBitmap (renderer, false);
		
		if (__cacheBitmap != null && !__isCacheBitmapRender) {
			
			GLBitmap.render (__cacheBitmap, renderer);
			
		} else {
			
			GLDisplayObject.render (this, renderer);
			GLTilemap.render (this, renderer);
			
		}
		
		__renderEvent (renderer);
		
	}
	
	
	private override function __renderGLMask (renderer:OpenGLRenderer):Void {
		
		__updateCacheBitmap (renderer, false);
		
		if (__cacheBitmap != null && !__isCacheBitmapRender) {
			
			GLBitmap.renderMask (__cacheBitmap, renderer);
			
		} else {
			
			GLDisplayObject.renderMask (this, renderer);
			GLTilemap.renderMask (this, renderer);
			
		}
		
	}
	
	
	private override function __shouldCacheHardware (value:Null<Bool>):Null<Bool> {
		
		return true;
		
	}
	
	
	private override function __updateCacheBitmap (renderer:DisplayObjectRenderer, force:Bool):Bool {
		
		if (__filters == null && renderer.__type == OPENGL && __cacheBitmap == null) return false;
		return super.__updateCacheBitmap (renderer, force);
		
	}
	#end
	
	
	
	
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
	
	
	private function get_numTiles ():Int {
		
		return __group.__length;
		
	}
	
	
	private function get_tileset ():Tileset {
		
		return __tileset;
		
	}
	
	
	private function set_tileset (value:Tileset):Tileset {
		
		if (value != __tileset) {
			
			__tileset = value;
			__group.__dirty = true;
			
			#if !flash
			__setRenderDirty ();
			#end
			
		}
		
		return value;
		
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