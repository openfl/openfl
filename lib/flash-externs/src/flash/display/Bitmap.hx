package flash.display;

#if flash
extern class Bitmap extends DisplayObject
{
	public var bitmapData:BitmapData;
	public var pixelSnapping:PixelSnapping;
	public var smoothing:Bool;
	public function new(bitmapData:BitmapData = null, ?pixelSnapping:PixelSnapping, smoothing:Bool = false);
}
#else
typedef Bitmap = openfl.display.Bitmap;
#end
