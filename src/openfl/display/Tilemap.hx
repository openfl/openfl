package openfl.display;


import openfl._internal.renderer.flash.FlashRenderer;
import openfl._internal.renderer.flash.FlashTilemap;
import openfl._internal.renderer.RenderSession;
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


class Tilemap extends #if !flash DisplayObject #else Bitmap implements IDisplayObject #end {
	
	
	public var numTiles (get, never):Int;
	public var tileAlphaEnabled:Bool;
	public var tileColorTransformEnabled:Bool;
	public var tileset (get, set):Tileset;
	
	#if !flash
	public var smoothing:Bool;
	#end
	
	private var __group:TileGroup;
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
		
		__group = new TileGroup ();
		
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
	public function getTiles ():TileGroup {
		
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
	public function setTiles (group:TileGroup):Void {
		
		__group.copyFrom (group);
		
	}
	#end
	
	
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
	private override function __renderCairo (renderSession:RenderSession):Void {
		
		#if lime_cairo
		__updateCacheBitmap (renderSession, !__worldColorTransform.__isDefault ());
		
		if (__cacheBitmap != null && !__cacheBitmapRender) {
			
			CairoBitmap.render (__cacheBitmap, renderSession);
			
		} else {
			
			CairoDisplayObject.render (this, renderSession);
			CairoTilemap.render (this, renderSession);
			
		}
		
		__renderEvent (renderSession);
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
		
		__renderEvent (renderSession);
		
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
		
		__renderEvent (renderSession);
		
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
		
		__renderEvent (renderSession);
		
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
		
		if (__filters == null) return false;
		return super.__updateCacheBitmap (renderSession, force);
		
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