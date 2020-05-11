package openfl.display;

import openfl.display._internal.FlashRenderer;
import openfl.display._internal.FlashTilemap;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
#if !flash
import openfl.display._internal.Context3DBuffer;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.Tile)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
@:noCompletion
class _Tilemap extends #if !flash _DisplayObject #else Bitmap #end
{
	public var numTiles(get, never):Int;
	public var tileAlphaEnabled:Bool;
	public var tileBlendModeEnabled:Bool;
	public var tileColorTransformEnabled:Bool;
	public var tileset(get, set):Tileset;

	#if !flash
	public var smoothing:Bool;
	#end

	public var __group:TileContainer;
	public var __tileset:Tileset;
	#if !flash
	public var __height:Int;
	public var __width:Int;
	#end

	public function new(width:Int, height:Int, tileset:Tileset = null, smoothing:Bool = true)
	{
		super();

		__tileset = tileset;
		this.smoothing = smoothing;

		tileAlphaEnabled = true;
		tileBlendModeEnabled = true;
		tileColorTransformEnabled = true;

		__group = new TileContainer();
		__group.tileset = tileset;
		#if !flash
		__width = width;
		__height = height;
		__type = TILEMAP;
		#else
		bitmapData = new BitmapData(width, height, true, 0);
		this.smoothing = smoothing;
		FlashRenderer.register(this);
		#end
	}

	public function addTile(tile:Tile):Tile
	{
		return __group.addTile(tile);
	}

	public function addTileAt(tile:Tile, index:Int):Tile
	{
		return __group.addTileAt(tile, index);
	}

	public function addTiles(tiles:Array<Tile>):Array<Tile>
	{
		return __group.addTiles(tiles);
	}

	public function contains(tile:Tile):Bool
	{
		return __group.contains(tile);
	}

	public function getTileAt(index:Int):Tile
	{
		return __group.getTileAt(index);
	}

	public function getTileIndex(tile:Tile):Int
	{
		return __group.getTileIndex(tile);
	}

	public function getTiles():TileContainer
	{
		return __group.clone();
	}

	public function removeTile(tile:Tile):Tile
	{
		return __group.removeTile(tile);
	}

	public function removeTileAt(index:Int):Tile
	{
		return __group.removeTileAt(index);
	}

	public function removeTiles(beginIndex:Int = 0, endIndex:Int = 0x7fffffff):Void
	{
		return __group.removeTiles(beginIndex, endIndex);
	}

	public function setTileIndex(tile:Tile, index:Int):Void
	{
		__group.setTileIndex(tile, index);
	}

	public function setTiles(group:TileContainer):Void
	{
		for (tile in __group._.__tiles)
		{
			removeTile(tile);
		}

		for (tile in group._.__tiles)
		{
			addTile(tile);
		}
	}

	public function sortTiles(compareFunction:Tile->Tile->Int):Void
	{
		__group.sortTiles(compareFunction);
	}

	public function swapTiles(tile1:Tile, tile2:Tile):Void
	{
		__group.swapTiles(tile1, tile2);
	}

	public function swapTilesAt(index1:Int, index2:Int):Void
	{
		__group.swapTilesAt(index1, index2);
	}

	#if !flash
	public override function __getBounds(rect:Rectangle, matrix:Matrix):Void
	{
		var bounds = _Rectangle.__pool.get();
		bounds.setTo(0, 0, __width, __height);
		bounds._.__transform(bounds, matrix);

		rect._.__expand(bounds.x, bounds.y, bounds.width, bounds.height);

		_Rectangle.__pool.release(bounds);
	}
	#end

	#if !flash
	public override function __hitTest(x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool
	{
		if (!hitObject.visible || __isMask) return false;
		if (mask != null && !mask._.__hitTestMask(x, y)) return false;

		__getRenderTransform();

		var px = __renderTransform._.__transformInverseX(x, y);
		var py = __renderTransform._.__transformInverseY(x, y);

		if (px > 0 && py > 0 && px <= __width && py <= __height)
		{
			if (stack != null && !interactiveOnly)
			{
				stack.push(hitObject);
			}

			return true;
		}

		return false;
	}
	#end

	public function __renderFlash():Void
	{
		FlashTilemap.render(this);
	}

	// Get & Set Methods
	#if !flash
	public override function get_height():Float
	{
		return __height * Math.abs(scaleY);
	}
	#end

	#if !flash
	public override function set_height(value:Float):Float
	{
		__height = Std.int(value);
		__localBoundsDirty = true;
		return __height * Math.abs(scaleY);
	}
	#else
	@:setter(height) private function set_height(value:Float):Void
	{
		if (value != bitmapData.height)
		{
			var cacheSmoothing = smoothing;
			bitmapData = new BitmapData(bitmapData.width, Std.int(value), true, 0);
			smoothing = cacheSmoothing;
		}
	}
	#end

	private function get_numTiles():Int
	{
		return __group._.__length;
	}

	private function get_tileset():Tileset
	{
		return __tileset;
	}

	private function set_tileset(value:Tileset):Tileset
	{
		if (value != __tileset)
		{
			__tileset = value;
			__group.tileset = value;
			__group._.__dirty = true;

			#if !flash
			__setRenderDirty();
			#end
		}

		return value;
	}

	#if !flash
	public override function get_width():Float
	{
		return __width * Math.abs(__scaleX);
	}
	#end

	#if !flash
	public override function set_width(value:Float):Float
	{
		__width = Std.int(value);
		__localBoundsDirty = true;
		return __width * Math.abs(__scaleX);
	}
	#else
	@:setter(width) private function set_width(value:Float):Void
	{
		if (value != bitmapData.width)
		{
			var cacheSmoothing = smoothing;
			bitmapData = new BitmapData(Std.int(value), bitmapData.height, true, 0);
			smoothing = cacheSmoothing;
		}
	}
	#end
}
