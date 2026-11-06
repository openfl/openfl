package openfl.ui;

#if !flash
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.Vector;

/**
	The properties of a native cursor, registered with `Mouse.registerCursor()`.

	OpenFL has no native cursors (`Mouse.supportsNativeCursor` is false), so
	the class holds its properties only. It lets code written for Flash and
	AIR compile.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class MouseCursorData
{
	/**
		The bitmaps of the cursor, one per frame of an animated cursor.
	**/
	public var data:Vector<BitmapData>;

	/**
		The frame rate of an animated cursor.
	**/
	public var frameRate:Float = 0;

	/**
		The hot spot of the cursor, in pixels.
	**/
	public var hotSpot:Point;

	public function new()
	{
		hotSpot = new Point();
	}
}
#else
typedef MouseCursorData = flash.ui.MouseCursorData;
#end
