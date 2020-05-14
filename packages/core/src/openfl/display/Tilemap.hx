package openfl.display;

// import openfl.display._internal.FlashRenderer;
// import openfl.display._internal.FlashTilemap;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

#if !flash
// import openfl.display._internal.Context3DBuffer;
#end

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
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Tilemap extends #if !flash DisplayObject #else Bitmap implements IDisplayObject #end implements ITileContainer
{
	/**
		Returns the number of tiles of this object.
	**/
	public var numTiles(get, never):Int;

	/**
		Enable or disable support for the `alpha` property of contained tiles. Disabling
		this property can improve performance on certain renderers.
	**/
	public var tileAlphaEnabled(get, set):Bool;

	/**
		Enable or disable support for the `blendMode` property of contained tiles.
		Disabling this property can improve performance on certain renderers.
	**/
	public var tileBlendModeEnabled(get, set):Bool;

	/**
		Enable or disable support for the `colorTransform` property of contained tiles.
		Disabling this property can improve performance on certain renderers.
	**/
	public var tileColorTransformEnabled(get, set):Bool;

	/**
		Optionally define a default Tileset to be used for all contained tiles. Tile
		instances that do not have their `tileset` property defined will use this value.

		If a Tile object does not have a Tileset set, either using this property or using
		the Tile `tileset` property, it will not be rendered.
	**/
	public var tileset(get, set):Tileset;

	#if !flash
	/**
		Controls whether or not the tilemap is smoothed when scaled. If
		`true`, the bitmap is smoothed when scaled. If `false`, the tilemap is not
		smoothed when scaled.
	**/
	public var smoothing(get, set):Bool;
	#end

	/**
		Creates a new Tilemap object.

		@param	width	The width of the tilemap in pixels.
		@param	height	The height of the tilemap in pixels.
		@param	tileset	A Tileset being referenced.
		@param	smoothing	Whether or not the tilemap is smoothed when scaled. For example, the following examples
		show the same tilemap scaled by a factor of 3, with `smoothing` set to `false` (left) and `true` (right):

		![A bitmap without smoothing.](/images/bitmap_smoothing_off.jpg) ![A bitmap with smoothing.](/images/bitmap_smoothing_on.jpg)
	**/
	public function new(width:Int, height:Int, tileset:Tileset = null, smoothing:Bool = true)
	{
		if (_ == null)
		{
			_ = new _Tilemap(this, width, height, tileset, smoothing);
		}

		super();
	}

	/**
		Adds a Tile instance to this Tilemap instance. The tile is
		added to the front (top) of all other tiles in this Tilemap
		instance. (To add a tile to a specific index position, use the `addTileAt()`
		method.)

		@param tile The Tile instance to add to this Tilemap instance.
		@return The Tile instance that you pass in the `tile` parameter.
	**/
	public function addTile(tile:Tile):Tile
	{
		return (_ : _Tilemap).addTile(tile);
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
	public function addTileAt(tile:Tile, index:Int):Tile
	{
		return (_ : _Tilemap).addTileAt(tile, index);
	}

	/**
		Adds an Array of Tile instances to this Tilemap instance. The tiles
		are added to the front (top) of all other tiles in this Tilemap
		instance.

		@param tiles The Tile instances to add to this Tilemap instance.
		@return The Tile Array that you pass in the `tiles` parameter.
	**/
	public function addTiles(tiles:Array<Tile>):Array<Tile>
	{
		return (_ : _Tilemap).addTiles(tiles);
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
	public function contains(tile:Tile):Bool
	{
		return (_ : _Tilemap).contains(tile);
	}

	/**
		Returns the tile instance that exists at the specified index.

		@param index The index position of the tile object.
		@return The tile object at the specified index position.
	**/
	public function getTileAt(index:Int):Tile
	{
		return (_ : _Tilemap).getTileAt(index);
	}

	/**
		Returns the index position of a contained Tile instance.

		@param child The Tile instance to identify.
		@return The index position of the tile object to identify.
	**/
	public function getTileIndex(tile:Tile):Int
	{
		return (_ : _Tilemap).getTileIndex(tile);
	}

	/**
		Returns a TileContainer with each of the tiles contained within this
		Tilemap.

		@return	A new TileContainer with the same Tile references as this Tilemap
	**/
	public function getTiles():TileContainer
	{
		return (_ : _Tilemap).getTiles();
	}

	/**
		Removes the specified Tile instance from the tile list of the Tilemap
		instance. The index positions of any tile objects above the tile in the
		Tilemap are decreased by 1.

		@param	tile	The Tile instance to remove.
		@return	The Tile instance that you pass in the `tile` parameter.
	**/
	public function removeTile(tile:Tile):Tile
	{
		return (_ : _Tilemap).removeTile(tile);
	}

	/**
		Removes a Tile from the specified `index` position in the tile list of the
		Tilemap. The index positions of any tile objects above the tile in
		the Tilemap are decreased by 1.

		@param	index	The index of the Tile to remove.
		@return	The Tile instance that was removed.
	**/
	public function removeTileAt(index:Int):Tile
	{
		return (_ : _Tilemap).removeTileAt(index);
	}

	/**
		Removes all Tile instances from the tile list of the ITileContainer instance.

		@param	beginIndex	The beginning position.
		@param	endIndex	The ending position.
	**/
	public function removeTiles(beginIndex:Int = 0, endIndex:Int = 0x7fffffff):Void
	{
		return (_ : _Tilemap).removeTiles(beginIndex, endIndex);
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
		(_ : _Tilemap).setTileIndex(tile, index);
	}

	/**
		Sets all the Tile instances of this Tilemap instance.

		@param	beginIndex	The beginning position.
		@param	endIndex	The ending position.
	**/
	public function setTiles(group:TileContainer):Void
	{
		(_ : _Tilemap).setTiles(group);
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
	public function sortTiles(compareFunction:Tile->Tile->Int):Void
	{
		(_ : _Tilemap).sortTiles(compareFunction);
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
		(_ : _Tilemap).swapTiles(tile1, tile2);
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
		(_ : _Tilemap).swapTilesAt(index1, index2);
	}

	// Get & Set Methods

	@:noCompletion private function get_numTiles():Int
	{
		return (_ : _Tilemap).numTiles;
	}

	#if !flash
	@:noCompletion private function get_smoothing():Bool
	{
		return (_ : _Tilemap).smoothing;
	}

	@:noCompletion private function set_smoothing(value:Bool):Bool
	{
		return (_ : _Tilemap).smoothing = value;
	}
	#end

	@:noCompletion private function get_tileAlphaEnabled():Bool
	{
		return (_ : _Tilemap).tileAlphaEnabled;
	}

	@:noCompletion private function set_tileAlphaEnabled(value:Bool):Bool
	{
		return (_ : _Tilemap).tileAlphaEnabled = value;
	}

	@:noCompletion private function get_tileBlendModeEnabled():Bool
	{
		return (_ : _Tilemap).tileBlendModeEnabled;
	}

	@:noCompletion private function set_tileBlendModeEnabled(value:Bool):Bool
	{
		return (_ : _Tilemap).tileBlendModeEnabled = value;
	}

	@:noCompletion private function get_tileColorTransformEnabled():Bool
	{
		return (_ : _Tilemap).tileColorTransformEnabled;
	}

	@:noCompletion private function set_tileColorTransformEnabled(value:Bool):Bool
	{
		return (_ : _Tilemap).tileColorTransformEnabled = value;
	}

	@:noCompletion private function get_tileset():Tileset
	{
		return (_ : _Tilemap).tileset;
	}

	@:noCompletion private function set_tileset(value:Tileset):Tileset
	{
		return (_ : _Tilemap).tileset = value;
	}

	#if flash
	@:setter(height) private function set_height(value:Float):Void
	{
		(_ : _Tilemap).set_height(value);
	}

	@:setter(width) private function set_width(value:Float):Void
	{
		(_ : _Tilemap).set_width(value);
	}
	#end
}
