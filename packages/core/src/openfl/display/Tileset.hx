package openfl.display;

import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Vector;

/**
	The Tileset class lets you specify logical rectangles within a larger
	BitmapData object, to be rendered using a Tilemap instance.

	The `Tileset()` constructor allows you to create a Tileset
	object that contains a reference to a BitmapData object. After you create a
	Tileset object, use the `addRect()` method to specify rectangles to be used
	for tile rendering.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Tileset
{
	/**
		The BitmapData object being referenced.
	**/
	public var bitmapData(get, set):BitmapData;

	/**
		The rectangles contained in this Tileset, structured as a Vector object.

		You can use the Tileset `rectData` property alongside the Graphics
		`drawQuads` method as a convenient way of re-using a list of rectangles.
	**/
	public var rectData(get, set):Vector<Float>;

	/**
		Returns the number of rectangles defined in this Tileset.
	**/
	public var numRects(get, never):Int;

	@:allow(openfl) @:noCompletion private var _:_Tileset;

	/**
		Creates a new Tileset instance.

		@param	bitmapData	A BitmapData object to reference
		@param	rects	An optional array of rectangles to define with the referenced BitmapData
	**/
	public function new(bitmapData:BitmapData, rects:Array<Rectangle> = null)
	{
		if (_ != null)
		{
			_ = new _Tileset(this, bitmapData, rects);
		}
	}

	/**
		Adds a new rectangle to this Tilemap object.

		@param	rect	A Rectangle represented a part of the referenced BitmapData object
		@returns	The assigned ID value for this new rectangle
	**/
	public function addRect(rect:Rectangle):Int
	{
		return _.addRect(rect);
	}

	/**
		Duplicates an instance of a Tileset subclass.

		@return A new Tileset object that is identical to the original.
	**/
	public function clone():Tileset
	{
		return _.clone();
	}

	/**
		Returns whether the current Tileset already has a rectangle
		defined that matches the dimensions of a specific rectangle
		object.

		@param	rect	A Rectangle object to compare against
		@returns	Whether the Tileset already contains the value of this rectangle
	**/
	public function hasRect(rect:Rectangle):Bool
	{
		return _.hasRect(rect);
	}

	/**
		Get the rectangle value associated with a specific tile ID.

		If the ID is invalid, then a `null` value will be returned.

		@param	id	A tile ID
		@return	A new Rectangle containing the tile source rectangle, or `null` if the
		tile ID does not exist in this Tileset
	**/
	public function getRect(id:Int):Rectangle
	{
		return _.getRect(id);
	}

	/**
		Gets the tile ID associated with a specified rectangle
		value, if it is defined in the Tileset. This will return
		`null` if the rectangle value is not defined in the Tileset.

		@param	rect	A Rectangle object to compare against
		@returns	The defined tile ID, or `null` if the rectangle
		value is not present in this Tileset
	**/
	public function getRectID(rect:Rectangle):Null<Int>
	{
		return _.getRectID(rect);
	}

	// Get & Set Methods

	@:noCompletion private function get_bitmapData():BitmapData
	{
		return _.bitmapData;
	}

	@:noCompletion private function set_bitmapData(value:BitmapData):BitmapData
	{
		return _.bitmapData = value;
	}

	@:noCompletion private function get_rectData():Vector<Float>
	{
		return _.rectData;
	}

	@:noCompletion private function set_rectData(value:Vector<Float>):Vector<Float>
	{
		return _.rectData = value;
	}

	@:noCompletion private function get_numRects():Int
	{
		return _.numRects;
	}
}
