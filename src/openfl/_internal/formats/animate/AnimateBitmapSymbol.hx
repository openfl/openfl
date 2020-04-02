package openfl._internal.formats.animate;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.PixelSnapping;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class AnimateBitmapSymbol extends AnimateSymbol
{
	public var alpha:String;
	public var path:String;
	public var smooth:Null<Bool>;

	public function new()
	{
		super();
	}

	private override function __createObject(library:AnimateLibrary):Bitmap
	{
		#if lime
		return new Bitmap(BitmapData.fromImage(library.getImage(path)), PixelSnapping.AUTO, smooth != false);
		#else
		return null;
		#end
	}
}
