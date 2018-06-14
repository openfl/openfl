package flash.display {
	
	
	/**
	 * @externs
	 * The Bitmap class represents display objects that represent bitmap images.
	 * These can be images that you load with the `flash.Assets` or 
	 * `flash.display.Loader` classes, or they can be images that you 
	 * create with the `Bitmap()` constructor.
	 *
	 * The `Bitmap()` constructor allows you to create a Bitmap
	 * object that contains a reference to a BitmapData object. After you create a
	 * Bitmap object, use the `addChild()` or `addChildAt()`
	 * method of the parent DisplayObjectContainer instance to place the bitmap on
	 * the display list.
	 *
	 * A Bitmap object can share its BitmapData reference among several Bitmap
	 * objects, independent of translation or rotation properties. Because you can
	 * create multiple Bitmap objects that reference the same BitmapData object,
	 * multiple display objects can use the same complex BitmapData object without
	 * incurring the memory overhead of a BitmapData object for each display
	 * object instance.
	 *
	 * A BitmapData object can be drawn to the screen by a Bitmap object in one
	 * of two ways: by using the default hardware renderer with a single hardware surface, 
	 * or by using the slower software renderer when 3D acceleration is not available.
	 * 
	 * If you would prefer to perform a batch rendering command, rather than using a
	 * single surface for each Bitmap object, you can also draw to the screen using the
	 * `flash.display.Tilemap` class.
	 *
	 * **Note:** The Bitmap class is not a subclass of the InteractiveObject
	 * class, so it cannot dispatch mouse events. However, you can use the
	 * `addEventListener()` method of the display object container that
	 * contains the Bitmap object.
	 */
	public class Bitmap extends DisplayObject {
		
		
		/**
		 * The BitmapData object being referenced.
		 */
		public var bitmapData:BitmapData;
		
		protected function get_bitmapData ():BitmapData { return null; }
		protected function set_bitmapData (value:BitmapData):BitmapData { return null; }
		
		/**
		 * Controls whether or not the Bitmap object is snapped to the nearest pixel.
		 * This value is ignored in the native and HTML5 targets.
		 * The PixelSnapping class includes possible values:
		 * 
		 *  * `PixelSnapping.NEVER` - No pixel snapping occurs.
		 *  * `PixelSnapping.ALWAYS` - The image is always snapped to
		 * the nearest pixel, independent of transformation.
		 *  * `PixelSnapping.AUTO` - The image is snapped to the
		 * nearest pixel if it is drawn with no rotation or skew and it is drawn at a
		 * scale factor of 99.9% to 100.1%. If these conditions are satisfied, the
		 * bitmap image is drawn at 100% scale, snapped to the nearest pixel.
		 * When targeting Flash Player, this value allows the image to be drawn as fast 
		 * as possible using the internal vector renderer.
		 * 
		 */
		public var pixelSnapping:String;
		
		/**
		 * Controls whether or not the bitmap is smoothed when scaled. If
		 * `true`, the bitmap is smoothed when scaled. If
		 * `false`, the bitmap is not smoothed when scaled.
		 */
		public var smoothing:Boolean;
		
		
		public function Bitmap (bitmapData:BitmapData = null, pixelSnapping:String = null, smoothing:Boolean = false) {}
		
		
	}
	
	
}