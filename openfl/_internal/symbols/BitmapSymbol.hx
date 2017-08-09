package openfl._internal.symbols;


import lime.graphics.ImageChannel;
import lime.math.Vector2;
import lime.Assets in LimeAssets;
import openfl._internal.swf.SWFLite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.PixelSnapping;
import openfl.Assets;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class BitmapSymbol extends SWFSymbol {
	
	
	public var alpha:String;
	public var path:String;
	public var smooth:Null<Bool>;
	
	
	public function new () {
		
		super ();
		
	}
	
	
	private override function __createObject (swf:SWFLite):Bitmap {
		
		return new Bitmap (BitmapData.fromImage (swf.library.getImage (path)), PixelSnapping.AUTO, smooth != false);
		
	}
	
	
}