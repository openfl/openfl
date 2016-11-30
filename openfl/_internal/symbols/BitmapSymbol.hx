package openfl._internal.symbols;


import lime.graphics.ImageChannel;
import lime.math.Vector2;
import lime.Assets in LimeAssets;
import openfl._internal.swf.SWFLite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.PixelSnapping;
import openfl.Assets;


class BitmapSymbol extends SWFSymbol {
	
	
	public var alpha:String;
	public var path:String;
	public var hasAlpha (get,never) : Bool;
	
	
	public function new () {
		
		super ();
		
	}
	
	
	private override function __createObject (swf:SWFLite):Bitmap {
		
		return new Bitmap (getBitmapData (), PixelSnapping.AUTO, true);
		
	}
	
	
	public function getBitmapDataFromCache () : Null<BitmapData> {
		
		if (Assets.cache.hasBitmapData (path)) {
			
			var bitmap = Assets.cache.getBitmapData (path);
			
			if (bitmap != null && this.hasAlpha && !(bitmap.image.buffer.premultiplied #if sys && bitmap.image.premultiplied #end))
			{
				throw bitmap + " alpha channel should be premultiplied";
			}
			
			return bitmap;
		
		} else {
		
			return null;
		
		}
		
	}
	
	
	public function getBitmapData () : BitmapData {
		
		var bitmap = getBitmapDataFromCache ();
		
		if (bitmap != null) {
		
			return bitmap;
			
		} else {
			
			var source = LimeAssets.getImage (path, false);
			var alphaBitmapData = null;
			
			if (source != null && this.hasAlpha) {
				
				alphaBitmapData = LimeAssets.getImage (alpha, false);
				
			}
			
			return cachedAsBitmapData (source, alphaBitmapData);
			
		}
		
	}
	
	
	
	
	private function cachedAsBitmapData (image : Image, ?alpha : Image) : BitmapData {
		
		if (alpha != null) {
			
			image.copyChannel (alpha, alpha.rect, new Vector2 (), ImageChannel.RED, ImageChannel.ALPHA);
			image.buffer.premultiplied = true;
			
			#if !sys
			image.premultiplied = true;
			#end
			
		}
		
		var bitmapData = BitmapData.fromImage (image);
		Assets.cache.setBitmapData (path, bitmapData);
		
		return bitmapData;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private inline function get_hasAlpha () : Bool {
		
		return (alpha != null && alpha != "");
		
	}
	
	
}