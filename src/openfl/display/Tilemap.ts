
// import openfl._internal.renderer.flash.FlashRenderer;
// import openfl._internal.renderer.flash.FlashTilemap;
import Matrix from "../geom/Matrix";
import Rectangle from "../geom/Rectangle";
// #if!flash
// import openfl._internal.renderer.context3D.Context3DBuffer;
// #end

namespace openfl.display
{
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
	export class Tilemap extends DisplayObject implements ITileContainer
	{
		/**
			Returns the number of tiles of this object.
		**/
		public numTiles(get, never): number;

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
			Optionally define a default Tileset to be used for all contained tiles. Tile
			instances that do not have their `tileset` property defined will use this value.

			If a Tile object does not have a Tileset set, either using this property or using
			the Tile `tileset` property, it will not be rendered.
		**/
		public tileset(get, set): Tileset;

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

			__tileset = tileset;
			this.smoothing = smoothing;

			tileAlphaEnabled = true;
			tileBlendModeEnabled = true;
			tileColorTransformEnabled = true;

			__group = new TileContainer();
			__group.tileset = tileset;
		#if!flash
			__width = width;
			__height = height;
			__type = TILEMAP;
		#else
			bitmapData = new BitmapData(width, height, true, 0);
			this.smoothing = smoothing;
			FlashRenderer.register(this);
		#end
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
			return __group.addTile(tile);
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
			return __group.addTileAt(tile, index);
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
			return __group.addTiles(tiles);
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
			return __group.contains(tile);
		}

		/**
			Returns the tile instance that exists at the specified index.

			@param index The index position of the tile object.
			@return The tile object at the specified index position.
		**/
		public getTileAt(index: number): Tile
		{
			return __group.getTileAt(index);
		}

		/**
			Returns the index position of a contained Tile instance.

			@param child The Tile instance to identify.
			@return The index position of the tile object to identify.
		**/
		public getTileIndex(tile: Tile): number
		{
			return __group.getTileIndex(tile);
		}

		/**
			Returns a TileContainer with each of the tiles contained within this
			Tilemap.

			@return	A new TileContainer with the same Tile references as this Tilemap
		**/
		public getTiles(): TileContainer
		{
			return __group.clone();
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
			return __group.removeTile(tile);
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
			return __group.removeTileAt(index);
		}

		/**
			Removes all Tile instances from the tile list of the ITileContainer instance.

			@param	beginIndex	The beginning position.
			@param	endIndex	The ending position.
		**/
		public removeTiles(beginIndex: number = 0, endIndex: number = 0x7fffffff): void
		{
			return __group.removeTiles(beginIndex, endIndex);
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
			__group.setTileIndex(tile, index);
		}

		/**
			Sets all the Tile instances of this Tilemap instance.

			@param	beginIndex	The beginning position.
			@param	endIndex	The ending position.
		**/
		public setTiles(group: TileContainer): void
		{
			for (tile in __group.__tiles)
			{
				removeTile(tile);
			}

			for (tile in group.__tiles)
			{
				addTile(tile);
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
		public sortTiles(compareFunction: Tile -> Tile -> Int): void
			{
				__group.sortTiles(compareFunction);
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
			__group.swapTiles(tile1, tile2);
		}

	/**
		Swaps the z-order (front-to-back order) of the tile objects at the two
		specified index positions in the tile list. All other tile objects in
		the tile container remain in the same index positions.

		@param	index1	The index position of the first tile object.
		@param	index2	The index position of the second tile object.
	**/
	public swapTilesAt(index1 : number, index2 : number): void
		{
			__group.swapTilesAt(index1, index2);
		}

	#if!flash
	protected __getBounds(rect: Rectangle, matrix: Matrix): void
		{
			var bounds = Rectangle.__pool.get();
			bounds.setTo(0, 0, __width, __height);
			bounds.__transform(bounds, matrix);

			rect.__expand(bounds.x, bounds.y, bounds.width, bounds.height);

			Rectangle.__pool.release(bounds);
		}
	#end

	#if!flash
	protected __hitTest(x : number, y : number, shapeFlag : boolean, stack: Array < DisplayObject >, interactiveOnly : boolean,
			hitObject: DisplayObject) : boolean
	{
		if (!hitObject.visible || __isMask) return false;
		if (mask != null && !mask.__hitTestMask(x, y)) return false;

		__getRenderTransform();

		var px = __renderTransform.__transformInverseX(x, y);
		var py = __renderTransform.__transformInverseY(x, y);

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

	protected __renderFlash(): void
		{
			FlashTilemap.render(this);
		}

	// Get & Set Methods
	#if!flash
	public get height() : number
	{
		return __height * Math.abs(scaleY);
	}
	#end

	#if!flash
	public set height(value : number) : number
	{
		__height = Std.int(value);
		__localBoundsDirty = true;
		return __height * Math.abs(scaleY);
	}
	#else
	@: setter(height) private set_height(value : number): void
		{
			if(value != bitmapData.height)
	{
		var cacheSmoothing = smoothing;
		bitmapData = new BitmapData(bitmapData.width, Std.int(value), true, 0);
		smoothing = cacheSmoothing;
	}
}
	#end

	public get numTiles() : number
{
	return __group.__length;
}

	public get tileset(): Tileset
{
	return __tileset;
}

	public set tileset(value: Tileset): Tileset
{
	if (value != __tileset)
	{
		__tileset = value;
		__group.tileset = value;
		__group.__dirty = true;

			#if!flash
		__setRenderDirty();
			#end
	}

	return value;
}

	#if!flash
public get width() : number
{
	return __width * Math.abs(__scaleX);
}
	#end

	#if!flash
public set width(value : number) : number
{
	__width = Std.int(value);
	__localBoundsDirty = true;
	return __width * Math.abs(__scaleX);
}
	#else
@: setter(width) private set_width(value : number): void
	{
		if(value != bitmapData.width)
{
	var cacheSmoothing = smoothing;
	bitmapData = new BitmapData(Std.int(value), bitmapData.height, true, 0);
	smoothing = cacheSmoothing;
}
}
	#end
}
}

export default openfl.display.Tilemap;
