import * as internal from "../_internal/utils/InternalAccess";
import BitmapData from "../display/BitmapData";
import Rectangle from "../geom/Rectangle";
import Vector from "../Vector";

/**
	The Tileset class lets you specify logical rectangles within a larger
	BitmapData object, to be rendered using a Tilemap instance.

	The `Tileset()` constructor allows you to create a Tileset
	object that contains a reference to a BitmapData object. After you create a
	Tileset object, use the `addRect()` method to specify rectangles to be used
	for tile rendering.
**/
export default class Tileset
{
	/**
		The rectangles contained in this Tileset, structured as a Vector object.

		You can use the Tileset `rectData` property alongside the Graphics
		`drawQuads` method as a convenient way of re-using a list of rectangles.
	**/
	public rectData: Vector<number>;

	protected __bitmapData: BitmapData;
	protected __data: Array<TileData>;

	/**
		Creates a new Tileset instance.

		@param	bitmapData	A BitmapData object to reference
		@param	rects	An optional array of rectangles to define with the referenced BitmapData
	**/
	public constructor(bitmapData: BitmapData, rects: Array<Rectangle> = null)
	{
		// TODO: Add support for adding uniform tile rectangles (margin, spacing, width, height)

		this.__bitmapData = bitmapData;
		this.rectData = new Vector<number>();

		this.__data = new Array();

		if (rects != null)
		{
			for (let rect of rects)
			{
				this.addRect(rect);
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

		this.rectData.push(rect.x);
		this.rectData.push(rect.y);
		this.rectData.push(rect.width);
		this.rectData.push(rect.height);

		var tileData = new TileData(rect);
		tileData.__update(this.__bitmapData);
		this.__data.push(tileData);

		return this.__data.length - 1;
	}

	/**
		Duplicates an instance of a Tileset subclass.

		@return A new Tileset object that is identical to the original.
	**/
	public clone(): Tileset
	{
		var tileset = new Tileset(this.__bitmapData, null);
		var rect = (<internal.Rectangle><any>Rectangle).__pool.get();

		for (let tileData of this.__data)
		{
			rect.setTo(tileData.x, tileData.y, tileData.width, tileData.height);
			tileset.addRect(rect);
		}

		(<internal.Rectangle><any>Rectangle).__pool.release(rect);

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
		for (let tileData of this.__data)
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
		if (id < this.__data.length && id >= 0)
		{
			return new Rectangle(this.__data[id].x, this.__data[id].y, this.__data[id].width, this.__data[id].height);
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

		for (let i = 0; i < this.__data.length; i++)
		{
			tileData = this.__data[i];

			if (rect.x == tileData.x && rect.y == tileData.y && rect.width == tileData.width && rect.height == tileData.height)
			{
				return i;
			}
		}

		return null;
	}

	// Get & Set Methods

	/**
		The BitmapData object being referenced.
	**/
	public get bitmapData(): BitmapData
	{
		return this.__bitmapData;
	}

	public set bitmapData(value: BitmapData)
	{
		this.__bitmapData = value;

		for (let data of this.__data)
		{
			data.__update(this.__bitmapData);
		}
	}

	/**
		Returns the number of rectangles defined in this Tileset.
	**/
	public get numRects(): number
	{
		return this.__data.length;
	}
}

class TileData
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
			this.x = Math.round(rect.x);
			this.y = Math.round(rect.y);
			this.width = Math.round(rect.width);
			this.height = Math.round(rect.height);
		}
	}

	public __update(bitmapData: BitmapData): void
	{
		if (bitmapData != null)
		{
			var bitmapWidth = bitmapData.width;
			var bitmapHeight = bitmapData.height;

			// #if(openfl_power_of_two && !flash)
			// var newWidth = 1;
			// var newHeight = 1;

			// while (newWidth < bitmapWidth)
			// {
			// 	newWidth <<= 1;
			// }

			// while (newHeight < bitmapHeight)
			// {
			// 	newHeight <<= 1;
			// }

			// bitmapWidth = newWidth;
			// bitmapHeight = newHeight;
			// #end

			this.__uvX = this.x / bitmapWidth;
			this.__uvY = this.y / bitmapHeight;
			this.__uvWidth = (this.x + this.width) / bitmapWidth;
			this.__uvHeight = (this.y + this.height) / bitmapHeight;
		}
	}
}
