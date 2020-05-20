package openfl.display;

import openfl.geom.Rectangle;

/**
	The TileContainer type is a special kind of Tile that can hold
	other tiles within it.

	Tile and TileContainer objects can be rendered by adding them to
	a Tilemap instance.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
class TileContainer extends Tile implements ITileContainer
{
	/**
		Returns the number of tiles of this object.
	**/
	public var numTiles(get, never):Int;

	@:noCompletion private var __tiles:Array<Tile>;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperty(TileContainer.prototype, "numTiles", {
			get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_numTiles (); }")
		});
	}
	#end

	public function new(x:Float = 0, y:Float = 0, scaleX:Float = 1, scaleY:Float = 1, rotation:Float = 0, originX:Float = 0, originY:Float = 0)
	{
		super(-1, x, y, scaleX, scaleY, rotation, originX, originY);

		__tiles = new Array();
		__length = 0;
	}

	/**
		Adds a Tile instance to this TileContainer instance. The tile is
		added to the front (top) of all other tiles in this TileContainer
		instance. (To add a tile to a specific index position, use the `addTileAt()`
		method.)

		@param tile The Tile instance to add to this TileContainer instance.
		@return The Tile instance that you pass in the `tile` parameter.
	**/
	public function addTile(tile:Tile):Tile
	{
		if (tile == null) return null;

		if (tile.parent == this)
		{
			__tiles.remove(tile);
			__length--;
		}

		__tiles[numTiles] = tile;
		tile.parent = this;
		__length++;

		__setRenderDirty();

		return tile;
	}

	/**
		Adds a Tile instance to this TileContainer instance. The tile is added
		at the index position specified. An index of 0 represents the back (bottom)
		of the rendered list for this TileContainer object.

		For example, the following example shows three tiles, labeled
		a, b, and c, at index positions 0, 2, and 1, respectively:

		![b over c over a](/images/DisplayObjectContainer_layers.jpg)

		@param tile The Tile instance to add to this TileContainer instance.
		@param index The index position to which the tile is added. If you
					 specify a currently occupied index position, the tile object
					 that exists at that position and all higher positions are
					 moved up one position in the tile list.
		@return The Tile instance that you pass in the `tile` parameter.
	**/
	public function addTileAt(tile:Tile, index:Int):Tile
	{
		if (tile == null) return null;

		if (tile.parent == this)
		{
			__tiles.remove(tile);
			__length--;
		}

		__tiles.insert(index, tile);
		tile.parent = this;
		__length++;

		__setRenderDirty();

		return tile;
	}

	/**
		Adds an Array of Tile instances to this TileContainer instance. The tiles
		are added to the front (top) of all other tiles in this TileContainer
		instance.

		@param tiles The Tile instances to add to this TileContainer instance.
		@return The Tile Array that you pass in the `tiles` parameter.
	**/
	public function addTiles(tiles:Array<Tile>):Array<Tile>
	{
		for (tile in tiles)
		{
			addTile(tile);
		}

		return tiles;
	}

	public override function clone():TileContainer
	{
		var group = new TileContainer();
		for (tile in __tiles)
		{
			group.addTile(tile.clone());
		}
		return group;
	}

	/**
		Determines whether the specified tile is contained within the
		TileContainer instance. The search includes the entire tile list including
		this TileContainer instance. Grandchildren, great-grandchildren, and so on
		each return `true`.

		@param	tile	The tile object to test.
		@return	`true` if the `tile` object is contained within the TileContainer;
		otherwise `false`.
	**/
	public function contains(tile:Tile):Bool
	{
		return (__tiles.indexOf(tile) > -1);
	}

	/**
		Override from tile. A single tile, just has his rectangle.
		A container must get a rectangle that contains all other rectangles.

		@param targetCoordinateSpace The tile that works as a coordinate system.
		@return Rectangle The bounding box. If no box found, this will return {0,0,0,0} rectangle instead of null.
	**/
	public override function getBounds(targetCoordinateSpace:Tile):Rectangle
	{
		var result = new Rectangle();
		var rect = null;

		for (tile in __tiles)
		{
			// TODO: Generate less Rectangle objects? Could be done with __getBounds but need a initial rectangle and the stack of transformations
			rect = tile.getBounds(targetCoordinateSpace);

			#if flash
			result = result.union(rect);
			#else
			result.__expand(rect.x, rect.y, rect.width, rect.height);
			#end
		}

		return result;
	}

	/**
		Returns the tile instance that exists at the specified index.

		@param index The index position of the tile object.
		@return The tile object at the specified index position.
	**/
	public function getTileAt(index:Int):Tile
	{
		if (index >= 0 && index < numTiles)
		{
			return __tiles[index];
		}

		return null;
	}

	/**
		Returns the index position of a contained Tile instance.

		@param child The Tile instance to identify.
		@return The index position of the tile object to identify.
	**/
	public function getTileIndex(tile:Tile):Int
	{
		for (i in 0...__tiles.length)
		{
			if (__tiles[i] == tile) return i;
		}

		return -1;
	}

	/**
		Removes the specified Tile instance from the tile list of the TileContainer
		instance. The index positions of any tile objects above the tile in the
		TileContainer are decreased by 1.

		@param	tile	The Tile instance to remove.
		@return	The Tile instance that you pass in the `tile` parameter.
	**/
	public function removeTile(tile:Tile):Tile
	{
		if (tile != null && tile.parent == this)
		{
			tile.parent = null;
			__tiles.remove(tile);
			__length--;
			__setRenderDirty();
		}

		return tile;
	}

	/**
		Removes a Tile from the specified `index` position in the tile list of the
		TileContainer. The index positions of any tile objects above the tile in
		the TileContainer are decreased by 1.

		@param	index	The index of the Tile to remove.
		@return	The Tile instance that was removed.
	**/
	public function removeTileAt(index:Int):Tile
	{
		if (index >= 0 && index < numTiles)
		{
			return removeTile(__tiles[index]);
		}

		return null;
	}

	/**
		Removes all Tile instances from the tile list of the TileContainer instance.

		@param	beginIndex	The beginning position.
		@param	endIndex	The ending position.
	**/
	public function removeTiles(beginIndex:Int = 0, endIndex:Int = 0x7fffffff):Void
	{
		if (beginIndex < 0) beginIndex = 0;
		if (endIndex > __tiles.length - 1) endIndex = __tiles.length - 1;

		var removed = __tiles.splice(beginIndex, endIndex - beginIndex + 1);
		for (tile in removed)
		{
			tile.parent = null;
		}
		__length = __tiles.length;

		__setRenderDirty();
	}

	/**
		Changes the position of an existing tile in the tile container.
		This affects the layering of tile objects. For example, the following
		example shows three tile objects, labeled a, b, and c, at index
		positions 0, 1, and 2, respectively:

		![c over b over a](/images/DisplayObjectContainerSetChildIndex1.jpg)

		When you use the `setTileIndex()` method and specify an
		index position that is already occupied, the only positions that change
		are those in between the tile object's former and new position. All
		others will stay the same. If a tile is moved to an index LOWER than its
		current index, all tiles in between will INCREASE by 1 for their index
		reference. If a tile is moved to an index HIGHER than its current index,
		all tiles in between will DECREASE by 1 for their index reference. For
		example, if the tile container in the previous example is named
		`container`, you can swap the position of the tile objects
		labeled a and b by calling the following code:

		```haxe
		container.setTileIndex(container.getTileAt(1), 0);
		```

		This code results in the following arrangement of objects:

		![c over a over b](/images/DisplayObjectContainerSetChildIndex2.jpg)

		@param	tile	The Tile instance for which you want to change the index
		number.
		@param	index	The resulting index number for the `tile` object.
	**/
	public function setTileIndex(tile:Tile, index:Int):Void
	{
		if (index >= 0 && index <= numTiles && tile.parent == this)
		{
			__tiles.remove(tile);
			__tiles.insert(index, tile);
			__setRenderDirty();
		}
	}

	/**
		Sorts the z-order (front-to-back order) of all the tile objects in this
		container based on a comparison function.

		A comparison function should take two arguments to compare. Given the elements
		A and B, the result of `compareFunction` can have a negative, 0, or positive value:

		* A negative return value specifies that A appears before B in the sorted sequence.
		* A return value of 0 specifies that A and B have the same sort order.
		* A positive return value specifies that A appears after B in the sorted sequence.

		The sort operation is not guaranteed to be stable, which means that the
		order of equal elements may not be retained.

		@param	compareFunction	A comparison function to use when sorting.
	**/
	#if (openfl < "9.0.0") @:dox(hide) #end public function sortTiles(compareFunction:Tile->Tile->Int):Void
	{
		__tiles.sort(compareFunction);
		__setRenderDirty();
	}

	/**
		Swaps the z-order (front-to-back order) of the two specified tile
		objects. All other tile objects in the tile container remain in
		the same index positions.

		@param	child1	The first tile object.
		@param	child2	The second tile object.
	**/
	public function swapTiles(tile1:Tile, tile2:Tile):Void
	{
		if (tile1.parent == this && tile2.parent == this)
		{
			var index1 = __tiles.indexOf(tile1);
			var index2 = __tiles.indexOf(tile2);

			__tiles[index1] = tile2;
			__tiles[index2] = tile1;

			__setRenderDirty();
		}
	}

	/**
		Swaps the z-order (front-to-back order) of the tile objects at the two
		specified index positions in the tile list. All other tile objects in
		the tile container remain in the same index positions.

		@param	index1	The index position of the first tile object.
		@param	index2	The index position of the second tile object.
	**/
	public function swapTilesAt(index1:Int, index2:Int):Void
	{
		var swap = __tiles[index1];
		__tiles[index1] = __tiles[index2];
		__tiles[index2] = swap;
		swap = null;

		__setRenderDirty();
	}

	// Event Handlers
	@:noCompletion private function get_numTiles():Int
	{
		return __length;
	}

	override function get_height():Float
	{
		var result:Rectangle = #if flash __tempRectangle #else Rectangle.__pool.get() #end;
		var rect = null;

		for (tile in __tiles)
		{
			// TODO: Generate less Rectangle objects? Could be done with __getBounds but need a initial rectangle and the stack of transformations
			rect = tile.getBounds(this);

			#if flash
			result = result.union(rect);
			#else
			result.__expand(rect.x, rect.y, rect.width, rect.height);
			#end
		}

		__getBounds(result, matrix);

		var h = result.height;
		#if !flash
		Rectangle.__pool.release(result);
		#end

		return h;
	}

	override function set_height(value:Float):Float
	{
		var result:Rectangle = #if flash __tempRectangle #else Rectangle.__pool.get() #end;
		var rect = null;

		for (tile in __tiles)
		{
			// TODO: Generate less Rectangle objects? Could be done with __getBounds but need a initial rectangle and the stack of transformations
			rect = tile.getBounds(this);

			#if flash
			result = result.union(rect);
			#else
			result.__expand(rect.x, rect.y, rect.width, rect.height);
			#end
		}

		if (result.height != 0)
		{
			scaleY = value / result.height;
		}

		#if !flash
		Rectangle.__pool.release(result);
		#end

		return value;
	}

	override function get_width():Float
	{
		var result:Rectangle = #if flash __tempRectangle #else Rectangle.__pool.get() #end;
		var rect = null;

		for (tile in __tiles)
		{
			// TODO: Generate less Rectangle objects? Could be done with __getBounds but need a initial rectangle and the stack of transformations
			rect = tile.getBounds(this);

			#if flash
			result = result.union(rect);
			#else
			result.__expand(rect.x, rect.y, rect.width, rect.height);
			#end
		}

		__getBounds(result, matrix);

		var w = result.width;
		#if !flash
		Rectangle.__pool.release(result);
		#end

		return w;
	}

	override function set_width(value:Float):Float
	{
		var result:Rectangle = #if flash __tempRectangle #else Rectangle.__pool.get() #end;
		var rect = null;

		for (tile in __tiles)
		{
			// TODO: Generate less Rectangle objects? Could be done with __getBounds but need a initial rectangle and the stack of transformations
			rect = tile.getBounds(this);

			#if flash
			result = result.union(rect);
			#else
			result.__expand(rect.x, rect.y, rect.width, rect.height);
			#end
		}

		if (result.width != 0)
		{
			scaleX = value / result.width;
		}

		#if !flash
		Rectangle.__pool.release(result);
		#end

		return value;
	}
}
