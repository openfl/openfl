package flash.display;

#if flash
extern class Bitmap extends DisplayObject
{
	#if (haxe_ver < 4.3)
	public var bitmapData:BitmapData;
	public var pixelSnapping:PixelSnapping;
	public var smoothing:Bool;
	#else
	@:flash.property var bitmapData(get, set):BitmapData;
	@:flash.property var pixelSnapping(get, set):PixelSnapping;
	@:flash.property var smoothing(get, set):Bool;
	#end

	public function new(bitmapData:BitmapData = null, ?pixelSnapping:PixelSnapping, smoothing:Bool = false);

	#if (haxe_ver >= 4.3)
	private function get_bitmapData():BitmapData;
	private function get_pixelSnapping():PixelSnapping;
	private function get_smoothing():Bool;
	private function set_bitmapData(value:BitmapData):BitmapData;
	private function set_pixelSnapping(value:PixelSnapping):PixelSnapping;
	private function set_smoothing(value:Bool):Bool;
	#end
}
#else
typedef Bitmap = openfl.display.Bitmap;
#end
