import Context3DBuffer from "../_internal/renderer/context3D/Context3DBuffer";
import DisplayObjectType from "../_internal/renderer/DisplayObjectType";
import * as internal from "../_internal/utils/InternalAccess";
import DisplayObject from "../display/DisplayObject";
import ITileContainer from "../display/ITileContainer";
import Tile from "../display/Tile";
import TileContainer from "../display/TileContainer";
import Tileset from "../display/Tileset";
import Matrix from "../geom/Matrix";
import Rectangle from "../geom/Rectangle";

/**
	The Tilemap class represents a "quad batch", or series of objects that are
	rendered from the same bitmap. The Tilemap class is designed to encourage
	the use of a single Tileset reference for best performance, but it is possible
	to use unique Tileset references for each Tile or TileContainer within a
	Tilemap.

	On software renderered platforms, the Tilemap class uses a rendering method
	similar to BitmapData `copyPixels`, so it will perform fastest if tile objects
	do not use rotation or scale.

	On hardware rendered platforms, the Tilemap class uses a rendering method
	that is fast even with transforms, and allows support for additional features,
	such as custom `shader` references, and color transform. Using multiple Shader
	or Tileset references will require a new draw call each time there is a change.

	**Note:** The Tilemap class is not a subclass of the InteractiveObject
	class, so it cannot dispatch mouse events. However, you can use the
	`addEventListener()` method of the display object container that
	contains the Tilemap object.
**/
export default class Tilemap extends DisplayObject implements ITileContainer
{
	/**
		Enable or disable support for the `alpha` property of contained tiles. Disabling
		this property can improve performance on certain renderers.
	**/
	public tileAlphaEnabled: boolean;

	/**
		Enable or disable support for the `blendMode` property of contained tiles.
		Disabling this property can improve performance on certain renderers.
	**/
	public tileBlendModeEnabled: boolean;

	/**
		Enable or disable support for the `colorTransform` property of contained tiles.
		Disabling this property can improve performance on certain renderers.
	**/
	public tileColorTransformEnabled: boolean;

	/**
		Controls whether or not the tilemap is smoothed when scaled. If
		`true`, the bitmap is smoothed when scaled. If `false`, the tilemap is not
		smoothed when scaled.
	**/
	public smoothing: boolean;

	protected __group: TileContainer;
	protected __tileset: Tileset;
	protected __height: number;
	protected __width: number;

	/**
		Creates a new Tilemap object.

		@param	width	The width of the tilemap in pixels.
		@param	height	The height of the tilemap in pixels.
		@param	tileset	A Tileset being referenced.
		@param	smoothing	Whether or not the tilemap is smoothed when scaled. For example, the following examples
		show the same tilemap scaled by a factor of 3, with `smoothing` set to `false` (left) and `true` (right):

		![A bitmap without smoothing.](/images/bitmap_smoothing_off.jpg) ![A bitmap with smoothing.](/images/bitmap_smoothing_on.jpg)
	**/
	public constructor(width: number, height: number, tileset: Tileset = null, smoothing: boolean = true)
	{
		super();

		this.__tileset = tileset;
		this.smoothing = smoothing;

		this.tileAlphaEnabled = true;
		this.tileBlendModeEnabled = true;
		this.tileColorTransformEnabled = true;

		this.__group = new TileContainer();
		this.__group.tileset = tileset;

		this.__width = width;
		this.__height = height;
		this.__type = DisplayObjectType.TILEMAP;
	}

	/**
		Adds a Tile instance to this Tilemap instance. The tile is
		added to the front (top) of all other tiles in this Tilemap
		instance. (To add a tile to a specific index position, use the `addTileAt()`
		method.)

		@param tile The Tile instance to add to this Tilemap instance.
		@return The Tile instance that you pass in the `tile` parameter.
	**/
	public addTile(tile: Tile): Tile
	{
		return this.__group.addTile(tile);
	}

	/**
		Adds a Tile instance to this Tilemap instance. The tile is added
		at the index position specified. An index of 0 represents the back (bottom)
		of the rendered list for this Tilemap object.

		For example, the following example shows three tiles, labeled
		a, b, and c, at index positions 0, 2, and 1, respectively:

		![b over c over a](/images/DisplayObjectContainer_layers.jpg)

		@param tile The Tile instance to add to this Tilemap instance.
		@param index The index position to which the tile is added. If you
					 specify a currently occupied index position, the tile object
					 that exists at that position and all higher positions are
					 moved up one position in the tile list.
		@return The Tile instance that you pass in the `tile` parameter.
	**/
	public addTileAt(tile: Tile, index: number): Tile
	{
		return this.__group.addTileAt(tile, index);
	}

	/**
		Adds an Array of Tile instances to this Tilemap instance. The tiles
		are added to the front (top) of all other tiles in this Tilemap
		instance.

		@param tiles The Tile instances to add to this Tilemap instance.
		@return The Tile Array that you pass in the `tiles` parameter.
	**/
	public addTiles(tiles: Array<Tile>): Array<Tile>
	{
		return this.__group.addTiles(tiles);
	}

	/**
		Determines whether the specified tile is contained within the
		Tilemap instance. The search includes the entire tile list including
		this Tilemap instance. Grandchildren, great-grandchildren, and so on
		each return `true`.

		@param	tile	The tile object to test.
		@return	`true` if the `tile` object is contained within the Tilemap;
		otherwise `false`.
	**/
	public contains(tile: Tile): boolean
	{
		return this.__group.contains(tile);
	}

	/**
		Returns the tile instance that exists at the specified index.

		@param index The index position of the tile object.
		@return The tile object at the specified index position.
	**/
	public getTileAt(index: number): Tile
	{
		return this.__group.getTileAt(index);
	}

	/**
		Returns the index position of a contained Tile instance.

		@param child The Tile instance to identify.
		@return The index position of the tile object to identify.
	**/
	public getTileIndex(tile: Tile): number
	{
		return this.__group.getTileIndex(tile);
	}

	/**
		Returns a TileContainer with each of the tiles contained within this
		Tilemap.

		@return	A new TileContainer with the same Tile references as this Tilemap
	**/
	public getTiles(): TileContainer
	{
		return this.__group.clone();
	}

	/**
		Removes the specified Tile instance from the tile list of the Tilemap
		instance. The index positions of any tile objects above the tile in the
		Tilemap are decreased by 1.

		@param	tile	The Tile instance to remove.
		@return	The Tile instance that you pass in the `tile` parameter.
	**/
	public removeTile(tile: Tile): Tile
	{
		return this.__group.removeTile(tile);
	}

	/**
		Removes a Tile from the specified `index` position in the tile list of the
		Tilemap. The index positions of any tile objects above the tile in
		the Tilemap are decreased by 1.

		@param	index	The index of the Tile to remove.
		@return	The Tile instance that was removed.
	**/
	public removeTileAt(index: number): Tile
	{
		return this.__group.removeTileAt(index);
	}

	/**
		Removes all Tile instances from the tile list of the ITileContainer instance.

		@param	beginIndex	The beginning position.
		@param	endIndex	The ending position.
	**/
	public removeTiles(beginIndex: number = 0, endIndex: number = 0x7fffffff): void
	{
		return this.__group.removeTiles(beginIndex, endIndex);
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
	public setTileIndex(tile: Tile, index: number): void
	{
		this.__group.setTileIndex(tile, index);
	}

	/**
		Sets all the Tile instances of this Tilemap instance.

		@param	beginIndex	The beginning position.
		@param	endIndex	The ending position.
	**/
	public setTiles(group: TileContainer): void
	{
		for (var tile of (<internal.TileContainer><any>this.__group).__tiles)
		{
			this.removeTile(tile);
		}

		for (tile of (<internal.TileContainer><any>group).__tiles)
		{
			this.addTile(tile);
		}
	}

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
	public sortTiles(compareFunction: (a: Tile, b: Tile) => number): void
	{
		this.__group.sortTiles(compareFunction);
	}

	/**
		Swaps the z-order (front-to-back order) of the two specified tile
		objects. All other tile objects in the tile container remain in
		the same index positions.

		@param	child1	The first tile object.
		@param	child2	The second tile object.
	**/
	public swapTiles(tile1: Tile, tile2: Tile): void
	{
		this.__group.swapTiles(tile1, tile2);
	}

	/**
		Swaps the z-order (front-to-back order) of the tile objects at the two
		specified index positions in the tile list. All other tile objects in
		the tile container remain in the same index positions.

		@param	index1	The index position of the first tile object.
		@param	index2	The index position of the second tile object.
	**/
	public swapTilesAt(index1: number, index2: number): void
	{
		this.__group.swapTilesAt(index1, index2);
	}

	protected __getBounds(rect: Rectangle, matrix: Matrix): void
	{
		var bounds = (<internal.Rectangle><any>Rectangle).__pool.get();
		bounds.setTo(0, 0, this.__width, this.__height);
		(<internal.Rectangle><any>bounds).__transform(bounds, matrix);

		(<internal.Rectangle><any>rect).__expand(bounds.x, bounds.y, bounds.width, bounds.height);

		(<internal.Rectangle><any>Rectangle).__pool.release(bounds);
	}

	protected __hitTest(x: number, y: number, shapeFlag: boolean, stack: Array<DisplayObject>, interactiveOnly: boolean,
		hitObject: DisplayObject): boolean
	{
		if (!hitObject.visible || this.__isMask) return false;
		if (this.mask != null && !(<internal.DisplayObject><any>this.mask).__hitTestMask(x, y)) return false;

		this.__getRenderTransform();

		var px = (<internal.Matrix><any>this.__renderTransform).__transformInverseX(x, y);
		var py = (<internal.Matrix><any>this.__renderTransform).__transformInverseY(x, y);

		if (px > 0 && py > 0 && px <= this.__width && py <= this.__height)
		{
			if (stack != null && !interactiveOnly)
			{
				stack.push(hitObject);
			}

			return true;
		}

		return false;
	}

	// Get & Set Methods

	public get height(): number
	{
		return this.__height * Math.abs(this.__scaleY);
	}

	public set height(value: number)
	{
		this.__height = Math.round(value);
		this.__localBoundsDirty = true;
	}

	/**
		Returns the number of tiles of this object.
	**/
	public get numTiles(): number
	{
		return (<internal.Tile><any>this.__group).__length;
	}

	/**
		Optionally define a default Tileset to be used for all contained tiles. Tile
		instances that do not have their `tileset` property defined will use this value.

		If a Tile object does not have a Tileset set, either using this property or using
		the Tile `tileset` property, it will not be rendered.
	**/
	public get tileset(): Tileset
	{
		return this.__tileset;
	}

	public set tileset(value: Tileset)
	{
		if (value != this.__tileset)
		{
			this.__tileset = value;
			this.__group.tileset = value;
			(<internal.Tile><any>this.__group).__dirty = true;

			this.__setRenderDirty();
		}
	}

	public get width(): number
	{
		return this.__width * Math.abs(this.__scaleX);
	}

	public set width(value: number)
	{
		this.__width = Math.round(value);
		this.__localBoundsDirty = true;
	}
}
