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
class TileContainer extends Tile implements ITileContainer
{
	/**
		Returns the number of tiles of this object.
	**/
	public var numTiles(get, never):Int;

	public function new(x:Float = 0, y:Float = 0, scaleX:Float = 1, scaleY:Float = 1, rotation:Float = 0, originX:Float = 0, originY:Float = 0)
	{
		if (_ == null)
		{
			_ = new _TileContainer(x, y, scaleX, scaleY, rotation, originX, originY);
		}

		super(-1, x, y, scaleX, scaleY, rotation, originX, originY);
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
		return (_ : _TileContainer).addTile(tile);
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
		return (_ : _TileContainer).addTileAt(tile, index);
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
		return (_ : _TileContainer).addTiles(tiles);
	}

	public override function clone():TileContainer
	{
		return (_ : _TileContainer).clone();
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
		return (_ : _TileContainer).contains(tile);
	}

	/**
		Returns the tile instance that exists at the specified index.

		@param index The index position of the tile object.
		@return The tile object at the specified index position.
	**/
	public function getTileAt(index:Int):Tile
	{
		return (_ : _TileContainer).getTileAt(index);
	}

	/**
		Returns the index position of a contained Tile instance.

		@param child The Tile instance to identify.
		@return The index position of the tile object to identify.
	**/
	public function getTileIndex(tile:Tile):Int
	{
		return (_ : _TileContainer).getTileIndex(tile);
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
		return (_ : _TileContainer).removeTile(tile);
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
		return (_ : _TileContainer).removeTileAt(index);
	}

	/**
		Removes all Tile instances from the tile list of the TileContainer instance.

		@param	beginIndex	The beginning position.
		@param	endIndex	The ending position.
	**/
	public function removeTiles(beginIndex:Int = 0, endIndex:Int = 0x7fffffff):Void
	{
		(_ : _TileContainer).removeTiles(beginIndex, endIndex);
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
		(_ : _TileContainer).setTileIndex(tile, index);
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
		(_ : _TileContainer).sortTiles(compareFunction);
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
		(_ : _TileContainer).swapTiles(tile1, tile2);
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
		(_ : _TileContainer).swapTilesAt(index1, index2);
	}

	// Get & Set Methods

	@:noCompletion private function get_numTiles():Int
	{
		return (_ : _TileContainer).numTiles;
	}
}
