package flash.display;
#if (flash || display)


/**
 * The Bitmap class represents display objects that represent bitmap images.
 * These can be images that you load with the <code>flash.Assets</code> or 
 * <code>flash.display.Loader</code> classes, or they can be images that you 
 * create with the <code>Bitmap()</code> constructor.
 *
 * <p>The <code>Bitmap()</code> constructor allows you to create a Bitmap
 * object that contains a reference to a BitmapData object. After you create a
 * Bitmap object, use the <code>addChild()</code> or <code>addChildAt()</code>
 * method of the parent DisplayObjectContainer instance to place the bitmap on
 * the display list.</p>
 *
 * <p>A Bitmap object can share its BitmapData reference among several Bitmap
 * objects, independent of translation or rotation properties. Because you can
 * create multiple Bitmap objects that reference the same BitmapData object,
 * multiple display objects can use the same complex BitmapData object without
 * incurring the memory overhead of a BitmapData object for each display
 * object instance.</p>
 *
 * <p>A BitmapData object can be drawn to the screen by a Bitmap object in one
 * of two ways: by using the default hardware renderer with a single hardware surface, 
 * or by using the slower software renderer when 3D acceleration is not available.</p>
 * 
 * <p>If you would prefer to perform a batch rendering command, rather than using a
 * single surface for each Bitmap object, you can also draw to the screen using the
 * <code>drawTiles()</code> or <code>drawTriangles()</code> methods which are
 * available to <code>flash.display.Tilesheet</code> and <code>flash.display.Graphics
 * objects.</code></p>
 *
 * <p><b>Note:</b> The Bitmap class is not a subclass of the InteractiveObject
 * class, so it cannot dispatch mouse events. However, you can use the
 * <code>addEventListener()</code> method of the display object container that
 * contains the Bitmap object.</p>
 */
extern class Bitmap extends DisplayObject {
	

	/**
	 * The BitmapData object being referenced.
	 */
	var bitmapData:BitmapData;
	

	/**
	 * Controls whether or not the Bitmap object is snapped to the nearest pixel.
	 * This value is ignored in the native and HTML5 targets.
	 * The PixelSnapping class includes possible values:
	 * <ul>
	 *   <li><code>PixelSnapping.NEVER</code> - No pixel snapping occurs.</li>
	 *   <li><code>PixelSnapping.ALWAYS</code> - The image is always snapped to
	 * the nearest pixel, independent of transformation.</li>
	 *   <li><code>PixelSnapping.AUTO</code> - The image is snapped to the
	 * nearest pixel if it is drawn with no rotation or skew and it is drawn at a
	 * scale factor of 99.9% to 100.1%. If these conditions are satisfied, the
	 * bitmap image is drawn at 100% scale, snapped to the nearest pixel.
	 * When targeting Flash Player, this value allows the image to be drawn as fast 
	 * as possible using the internal vector renderer.</li>
	 * </ul>
	 */
	var pixelSnapping:PixelSnapping;
	

	/**
	 * Controls whether or not the bitmap is smoothed when scaled. If
	 * <code>true</code>, the bitmap is smoothed when scaled. If
	 * <code>false</code>, the bitmap is not smoothed when scaled.
	 */
	var smoothing:Bool;
	
	function new(?bitmapData:BitmapData, ?pixelSnapping:PixelSnapping, smoothing:Bool = false):Void;
	
}


#end