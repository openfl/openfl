import Tile from "../display/Tile";

/**
	ITileContainer is an interface implemented by compatible tile container
	objects, including the Tilemap and TileContainer classes.
**/
export default interface ITileContainer
{
	/**
		Returns the number of tiles of this object.
	**/
	numTiles: number;

	/**
		Adds a Tile instance to this ITileContainer instance. The tile is
		added to the front (top) of all other tiles in this ITileContainer
		instance. (To add a tile to a specific index position, use the `addTileAt()`
		method.)

		@param tile The Tile instance to add to this ITileContainer instance.
		@return The Tile instance that you pass in the `tile` parameter.
	**/
	addTile(tile: Tile): Tile;

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
	addTileAt(tile: Tile, index: number): Tile;

	/**
		Adds an Array of Tile instances to this ITileContainer instance. The tiles
		are added to the front (top) of all other tiles in this ITileContainer
		instance.

		@param tiles The Tile instances to add to this ITileContainer instance.
		@return The Tile Array that you pass in the `tiles` parameter.
	**/
	addTiles(tiles: Array<Tile>): Array<Tile>;

	/**
		Determines whether the specified tile is contained within the
		ITileContainer instance. The search includes the entire tile list including
		this ITileContainer instance. Grandchildren, great-grandchildren, and so on
		each return `true`.

		@param	tile	The tile object to test.
		@return	`true` if the `tile` object is contained within the ITileContainer;
		otherwise `false`.
	**/
	contains(tile: Tile): boolean;

	/**
		Returns the tile instance that exists at the specified index.

		@param index The index position of the tile object.
		@return The tile object at the specified index position.
	**/
	getTileAt(index: number): Tile;

	/**
		Returns the index position of a contained Tile instance.

		@param child The Tile instance to identify.
		@return The index position of the tile object to identify.
	**/
	getTileIndex(tile: Tile): number;

	/**
		Removes the specified Tile instance from the tile list of the ITileContainer
		instance. The index positions of any tile objects above the tile in the
		ITileContainer are decreased by 1.

		@param	tile	The Tile instance to remove.
		@return	The Tile instance that you pass in the `tile` parameter.
	**/
	removeTile(tile: Tile): Tile;

	/**
		Removes a Tile from the specified `index` position in the tile list of the
		ITileContainer. The index positions of any tile objects above the tile in
		the ITileContainer are decreased by 1.

		@param	index	The index of the Tile to remove.
		@return	The Tile instance that was removed.
	**/
	removeTileAt(index: number): Tile;

	/**
		Removes all Tile instances from the tile list of the ITileContainer instance.

		@param	beginIndex	The beginning position.
		@param	endIndex	The ending position.
	**/
	removeTiles(beginIndex?: number, endIndex?: number): void;

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
	setTileIndex(tile: Tile, index: number): void;

	/**
		Sorts the z-order (front-to-back order) of all the tile objects in this
		container based on a comparison function.

		A comparison should take two arguments to compare. Given the elements
		A and B, the result of `compareFunction` can have a negative, 0, or positive value:

		* A negative return value specifies that A appears before B in the sorted sequence.
		* A return value of 0 specifies that A and B have the same sort order.
		* A positive return value specifies that A appears after B in the sorted sequence.

		The sort operation is not guaranteed to be stable, which means that the
		order of equal elements may not be retained.

		@param	compareFunction	A comparison to use when sorting.
	**/
	sortTiles(compareFunction: (a: Tile, b: Tile) => number): void;

	/**
		Swaps the z-order (front-to-back order) of the two specified tile
		objects. All other tile objects in the tile container remain in
		the same index positions.

		@param	child1	The first tile object.
		@param	child2	The second tile object.
	**/
	swapTiles(tile1: Tile, tile2: Tile): void;

	/**
		Swaps the z-order (front-to-back order) of the tile objects at the two
		specified index positions in the tile list. All other tile objects in
		the tile container remain in the same index positions.

		@param	index1	The index position of the first tile object.
		@param	index2	The index position of the second tile object.
	**/
	swapTilesAt(index1: number, index2: number): void;
}
