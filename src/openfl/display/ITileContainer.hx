package openfl.display;

/**
	ITileContainer is an interface implemented by compatible tile container
	objects, including the Tilemap and TileContainer classes.
**/
interface ITileContainer
{
	/**
		Returns the number of tiles of this object.
	**/
	public var numTiles(get, never):Int;

	/**
		Adds a Tile instance to this ITileContainer instance. The tile is
		added to the front (top) of all other tiles in this ITileContainer
		instance. (To add a tile to a specific index position, use the `addTileAt()`
		method.)

		@param tile The Tile instance to add to this ITileContainer instance.
		@return The Tile instance that you pass in the `tile` parameter.
	**/
	public function addTile(tile:Tile):Tile;

	/**
		Adds a Tile instance to this ITileContainer instance. The tile is added
		at the index position specified. An index of 0 represents the back (bottom)
		of the rendered list for this ITileContainer object.

		For example, the following example shows three tiles, labeled
		a, b, and c, at index positions 0, 2, and 1, respectively:

		![b over c over a](/images/DisplayObjectContainer_layers.jpg)

		@param tile The Tile instance to add to this ITileContainer instance.
		@param index The index position to which the tile is added. If you
					 specify a currently occupied index position, the tile object
					 that exists at that position and all higher positions are
					 moved up one position in the tile list.
		@return The Tile instance that you pass in the `tile` parameter.
	**/
	public function addTileAt(tile:Tile, index:Int):Tile;

	/**
		Adds an Array of Tile instances to this ITileContainer instance. The tiles
		are added to the front (top) of all other tiles in this ITileContainer
		instance.

		@param tiles The Tile instances to add to this ITileContainer instance.
		@return The Tile Array that you pass in the `tiles` parameter.
	**/
	public function addTiles(tiles:Array<Tile>):Array<Tile>;

	/**
		Determines whether the specified tile is contained within the
		ITileContainer instance. The search includes the entire tile list including
		this ITileContainer instance. Grandchildren, great-grandchildren, and so on
		each return `true`.

		@param	tile	The tile object to test.
		@return	`true` if the `tile` object is contained within the ITileContainer;
		otherwise `false`.
	**/
	public function contains(tile:Tile):Bool;

	/**
		Returns the tile instance that exists at the specified index.

		@param index The index position of the tile object.
		@return The tile object at the specified index position.
	**/
	public function getTileAt(index:Int):Tile;

	/**
		Returns the index position of a contained Tile instance.

		@param child The Tile instance to identify.
		@return The index position of the tile object to identify.
	**/
	public function getTileIndex(tile:Tile):Int;

	/**
		Removes the specified Tile instance from the tile list of the ITileContainer
		instance. The index positions of any tile objects above the tile in the
		ITileContainer are decreased by 1.

		@param	tile	The Tile instance to remove.
		@return	The Tile instance that you pass in the `tile` parameter.
	**/
	public function removeTile(tile:Tile):Tile;

	/**
		Removes a Tile from the specified `index` position in the tile list of the
		ITileContainer. The index positions of any tile objects above the tile in
		the ITileContainer are decreased by 1.

		@param	index	The index of the Tile to remove.
		@return	The Tile instance that was removed.
	**/
	public function removeTileAt(index:Int):Tile;

	/**
		Removes all Tile instances from the tile list of the ITileContainer instance.

		@param	beginIndex	The beginning position.
		@param	endIndex	The ending position.
	**/
	public function removeTiles(beginIndex:Int = 0, endIndex:Int = 0x7fffffff):Void;

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
	public function setTileIndex(tile:Tile, index:Int):Void;

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
	public function sortTiles(compareFunction:Tile->Tile->Int):Void;

	/**
		Swaps the z-order (front-to-back order) of the two specified tile
		objects. All other tile objects in the tile container remain in
		the same index positions.

		@param	child1	The first tile object.
		@param	child2	The second tile object.
	**/
	public function swapTiles(tile1:Tile, tile2:Tile):Void;

	/**
		Swaps the z-order (front-to-back order) of the tile objects at the two
		specified index positions in the tile list. All other tile objects in
		the tile container remain in the same index positions.

		@param	index1	The index position of the first tile object.
		@param	index2	The index position of the second tile object.
	**/
	public function swapTilesAt(index1:Int, index2:Int):Void;
}
