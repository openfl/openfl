package openfl._internal.symbols;


import lime.graphics.ImageChannel;
import lime.math.Vector2;
import lime.Assets in LimeAssets;
import openfl._internal.swf.SWFLite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.PixelSnapping;
import openfl.Assets;


class BitmapSymbol extends SWFSymbol {
	
	
	public var alpha:String;
	public var path:String;
	
	
	public function new () {
		
		super ();
		
	}
	
	
	private override function __createObject (swf:SWFLite):Bitmap {
		
		return new Bitmap (__getBitmap (swf), PixelSnapping.AUTO, true);
		
	}
	
	
	private function __getBitmap (swf:SWFLite):BitmapData {
		
		// TODO: Handle in library
		
		if (Assets.cache.hasBitmapData (path)) {
			
			return Assets.cache.getBitmapData (path);
			
		} else {
			
			var source = swf.library.getImage (path);
			
			if (source != null && alpha != null && alpha != "") {
				
				var alphaBitmapData = swf.library.getImage (alpha);
				source.copyChannel (alphaBitmapData, alphaBitmapData.rect, new Vector2 (), ImageChannel.RED, ImageChannel.ALPHA);
				
				//alpha = null;
				source.buffer.premultiplied = true;
				
				#if !sys
				source.premultiplied = false;
				#end
				
			}
			
			var bitmapData = BitmapData.fromImage (source);
			
			Assets.cache.setBitmapData (path, bitmapData);
			return bitmapData;
			
		}
		
	}
	
	
}