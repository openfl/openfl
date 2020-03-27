import Point from "../geom/Point";
import Rectangle from "../geom/Rectangle";
import Vector from "../Vector";

namespace openfl.display
{
	/**
		The Tileset class lets you specify logical rectangles within a larger
		BitmapData object, to be rendered using a Tilemap instance.

		The `Tileset()` constructor allows you to create a Tileset
		object that contains a reference to a BitmapData object. After you create a
		Tileset object, use the `addRect()` method to specify rectangles to be used
		for tile rendering.
	**/
	export class Tileset
	{
		/**
			The BitmapData object being referenced.
		**/
		public bitmapData(get, set): BitmapData;

		/**
			The rectangles contained in this Tileset, structured as a Vector object.

			You can use the Tileset `rectData` property alongside the Graphics
			`drawQuads` method as a convenient way of re-using a list of rectangles.
		**/
		public rectData: Vector<number>;

		/**
			Returns the number of rectangles defined in this Tileset.
		**/
		public numRects(get, never): number;

		protected __bitmapData: BitmapData;
		protected __data: Array<TileData>;

		#if openfljs
		protected static __init__()
		{
			untyped Object.defineProperties(Tileset.prototype, {
				"bitmapData": {
					get: untyped __js__("function () { return this.get_bitmapData (); }"),
					set: untyped __js__("function (v) { return this.set_bitmapData (v); }")
				},
				"numRects": { get: untyped __js__("function () { return this.get_numRects (); }") }
			});
		}
		#end

		/**
			Creates a new Tileset instance.

			@param	bitmapData	A BitmapData object to reference
			@param	rects	An optional array of rectangles to define with the referenced BitmapData
		**/
		public constructor(bitmapData: BitmapData, rects: Array<Rectangle> = null)
		{
			// TODO: Add support for adding uniform tile rectangles (margin, spacing, width, height)

			__bitmapData = bitmapData;
			rectData = new Vector<number>();

			__data = new Array();

			if (rects != null)
			{
				for (rect in rects)
				{
					addRect(rect);
				}
			}
		}

		/**
			Adds a new rectangle to this Tilemap object.

			@param	rect	A Rectangle represented a part of the referenced BitmapData object
			@returns	The assigned ID value for this new rectangle
		**/
		public addRect(rect: Rectangle): number
		{
			if (rect == null) return -1;

			rectData.push(rect.x);
			rectData.push(rect.y);
			rectData.push(rect.width);
			rectData.push(rect.height);

			var tileData = new TileData(rect);
			tileData.__update(__bitmapData);
			__data.push(tileData);

			return __data.length - 1;
		}

		/**
			Duplicates an instance of a Tileset subclass.

			@return A new Tileset object that is identical to the original.
		**/
		public clone(): Tileset
		{
			var tileset = new Tileset(__bitmapData, null);
			var rect = #if flash new Rectangle() #else Rectangle.__pool.get() #end;

			for (tileData in __data)
			{
				rect.setTo(tileData.x, tileData.y, tileData.width, tileData.height);
				tileset.addRect(rect);
			}

		#if!flash
			Rectangle.__pool.release(rect);
		#end

			return tileset;
		}

		/**
			Returns whether the current Tileset already has a rectangle
			defined that matches the dimensions of a specific rectangle
			object.

			@param	rect	A Rectangle object to compare against
			@returns	Whether the Tileset already contains the value of this rectangle
		**/
		public hasRect(rect: Rectangle): boolean
		{
			for (tileData in __data)
			{
				if (rect.x == tileData.x && rect.y == tileData.y && rect.width == tileData.width && rect.height == tileData.height)
				{
					return true;
				}
			}

			return false;
		}

		/**
			Get the rectangle value associated with a specific tile ID.

			If the ID is invalid, then a `null` value will be returned.

			@param	id	A tile ID
			@return	A new Rectangle containing the tile source rectangle, or `null` if the
			tile ID does not exist in this Tileset
		**/
		public getRect(id: number): Rectangle
		{
			if (id < __data.length && id >= 0)
			{
				return new Rectangle(__data[id].x, __data[id].y, __data[id].width, __data[id].height);
			}

			return null;
		}

		/**
			Gets the tile ID associated with a specified rectangle
			value, if it is defined in the Tileset. This will return
			`null` if the rectangle value is not defined in the Tileset.

			@param	rect	A Rectangle object to compare against
			@returns	The defined tile ID, or `null` if the rectangle
			value is not present in this Tileset
		**/
		public getRectID(rect: Rectangle): null | number
		{
			var tileData;

			for (i in 0...__data.length)
			{
				tileData = __data[i];

				if (rect.x == tileData.x && rect.y == tileData.y && rect.width == tileData.width && rect.height == tileData.height)
				{
					return i;
				}
			}

			return null;
		}

		// Get & Set Methods
		public get bitmapData(): BitmapData
		{
			return __bitmapData;
		}

		public set bitmapData(value: BitmapData): BitmapData
		{
			__bitmapData = value;

			for (data in __data)
			{
				data.__update(__bitmapData);
			}

			return value;
		}

		public get numRects(): number
		{
			return __data.length;
		}
	}

	private class TileData
	{
		public height: number;
		public width: number;
		public x: number;
		public y: number;
		public __bitmapData: BitmapData;
		public __uvHeight: number;
		public __uvWidth: number;
		public __uvX: number;
		public __uvY: number;

		public constructor(rect: Rectangle = null)
		{
			if (rect != null)
			{
				x = Std.int(rect.x);
				y = Std.int(rect.y);
				width = Std.int(rect.width);
				height = Std.int(rect.height);
			}
		}

		protected __update(bitmapData: BitmapData): void
		{
			if (bitmapData != null)
			{
				var bitmapWidth = bitmapData.width;
				var bitmapHeight = bitmapData.height;

			#if(openfl_power_of_two && !flash)
				var newWidth = 1;
				var newHeight = 1;

				while (newWidth < bitmapWidth)
				{
					newWidth <<= 1;
				}

				while (newHeight < bitmapHeight)
				{
					newHeight <<= 1;
				}

				bitmapWidth = newWidth;
				bitmapHeight = newHeight;
			#end

				__uvX = x / bitmapWidth;
				__uvY = y / bitmapHeight;
				__uvWidth = (x + width) / bitmapWidth;
				__uvHeight = (y + height) / bitmapHeight;
			}
		}
	}
}

export default openfl.display.Tileset;
