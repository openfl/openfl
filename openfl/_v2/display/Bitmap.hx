package openfl._v2.display; #if lime_legacy


import openfl.display.DisplayObject;
import openfl.display.PixelSnapping;


class Bitmap extends DisplayObject {
	
	
	public var bitmapData (default, set):BitmapData;
	public var pixelSnapping (get, set):PixelSnapping;
	public var smoothing (default, set):Bool;
	
	
	public function new (bitmapData:BitmapData = null, pixelSnapping:PixelSnapping = null, smoothing:Bool = false):Void {
		
		super (DisplayObject.lime_create_display_object (), "Bitmap");
		
		this.pixelSnapping = (pixelSnapping == null ? PixelSnapping.AUTO : pixelSnapping);
		this.smoothing = smoothing;
		
		if (bitmapData != null) {
			
			this.bitmapData = bitmapData;
			
		} else if (this.bitmapData != null) {
			
			__rebuild ();
			
		}
		
	}
	
	
	@:noCompletion private function __rebuild ():Void {
		
		if (__handle != null) {
			
			var gfx = graphics;
			gfx.clear ();
			
			if (bitmapData != null) {
				
				gfx.beginBitmapFill (bitmapData, false, smoothing);
				gfx.drawRect (0, 0, bitmapData.width, bitmapData.height);
				gfx.endFill ();
				
			}
			
		}
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function set_bitmapData (value:BitmapData):BitmapData {
		
		bitmapData = value;
		__rebuild ();
		
		return value;
		
	}
	
	
	private function get_pixelSnapping ():PixelSnapping {
		
		var i:Int = lime_display_object_get_pixel_snapping (__handle);
		return Type.createEnumIndex (PixelSnapping, i);
		
	}
	
	
	private function set_pixelSnapping (value:PixelSnapping):PixelSnapping {
		
		if (value == null) {
			
			lime_display_object_set_pixel_snapping (__handle, 0);
			
		} else {
			
			lime_display_object_set_pixel_snapping (__handle, Type.enumIndex (value));
			
		}
		
		return value;
		
	}
	
	
	private function set_smoothing (value:Bool):Bool {
		
		smoothing = value;
		__rebuild ();
		
		return value;
		
	}
	
	
	
	
	// Native Methods
	
	
	
	
	private static var lime_display_object_get_pixel_snapping = Lib.load ("lime", "lime_display_object_get_pixel_snapping", 1);
	private static var lime_display_object_set_pixel_snapping = Lib.load ("lime", "lime_display_object_set_pixel_snapping", 2);
	
	
}


#end