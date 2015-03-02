package openfl.display; #if !flash #if !lime_legacy


import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLTexture;
import lime.graphics.GLRenderContext;
import lime.graphics.Image;
import lime.graphics.ImageBuffer;
import lime.graphics.utils.ImageCanvasUtil;
import lime.math.ColorMatrix;
import lime.utils.Float32Array;
import lime.utils.UInt8Array;
import openfl._internal.renderer.RenderSession;
import openfl.errors.IOError;
import openfl.filters.BitmapFilter;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import openfl.Vector;

#if js
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.ImageData;
import js.html.ImageElement;
import js.html.Uint8ClampedArray;
import js.Browser;
#end


/**
 * The BitmapData class lets you work with the data(pixels) of a Bitmap
 * object. You can use the methods of the BitmapData class to create
 * arbitrarily sized transparent or opaque bitmap images and manipulate them
 * in various ways at runtime. You can also access the BitmapData for a bitmap
 * image that you load with the <code>openfl.Assets</code> or 
 * <code>openfl.display.Loader</code> classes.
 *
 * <p>This class lets you separate bitmap rendering operations from the
 * internal display updating routines of OpenFL. By manipulating a
 * BitmapData object directly, you can create complex images without incurring
 * the per-frame overhead of constantly redrawing the content from vector
 * data.</p>
 *
 * <p>The methods of the BitmapData class support effects that are not
 * available through the filters available to non-bitmap display objects.</p>
 *
 * <p>A BitmapData object contains an array of pixel data. This data can
 * represent either a fully opaque bitmap or a transparent bitmap that
 * contains alpha channel data. Either type of BitmapData object is stored as
 * a buffer of 32-bit integers. Each 32-bit integer determines the properties
 * of a single pixel in the bitmap.</p>
 *
 * <p>Each 32-bit integer is a combination of four 8-bit channel values(from
 * 0 to 255) that describe the alpha transparency and the red, green, and blue
 * (ARGB) values of the pixel.(For ARGB values, the most significant byte
 * represents the alpha channel value, followed by red, green, and blue.)</p>
 *
 * <p>The four channels(alpha, red, green, and blue) are represented as
 * numbers when you use them with the <code>BitmapData.copyChannel()</code>
 * method or the <code>DisplacementMapFilter.componentX</code> and
 * <code>DisplacementMapFilter.componentY</code> properties, and these numbers
 * are represented by the following constants in the BitmapDataChannel
 * class:</p>
 *
 * <ul>
 *   <li><code>BitmapDataChannel.ALPHA</code></li>
 *   <li><code>BitmapDataChannel.RED</code></li>
 *   <li><code>BitmapDataChannel.GREEN</code></li>
 *   <li><code>BitmapDataChannel.BLUE</code></li>
 * </ul>
 *
 * <p>You can attach BitmapData objects to a Bitmap object by using the
 * <code>bitmapData</code> property of the Bitmap object.</p>
 *
 * <p>You can use a BitmapData object to fill a Graphics object by using the
 * <code>Graphics.beginBitmapFill()</code> method.</p>
 * 
 * <p>You can also use a BitmapData object to perform batch tile rendering
 * using the <code>openfl.display.Tilesheet</code> class.</p>
 *
 * <p>In Flash Player 10, the maximum size for a BitmapData object
 * is 8,191 pixels in width or height, and the total number of pixels cannot
 * exceed 16,777,215 pixels.(So, if a BitmapData object is 8,191 pixels wide,
 * it can only be 2,048 pixels high.) In Flash Player 9 and earlier, the limitation 
 * is 2,880 pixels in height and 2,880 in width.</p>
 */

@:access(lime.graphics.Image)
@:access(lime.graphics.ImageBuffer)
@:access(lime.math.Rectangle)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Point)
@:access(openfl.geom.Rectangle)

@:autoBuild(openfl.Assets.embedBitmap())


class BitmapData implements IBitmapDrawable {
	
	
	/**
	 * The height of the bitmap image in pixels.
	 */
	public var height (default, null):Int;
	
	/**
	 * The rectangle that defines the size and location of the bitmap image. The
	 * top and left of the rectangle are 0; the width and height are equal to the
	 * width and height in pixels of the BitmapData object.
	 */
	public var rect (default, null):Rectangle;
	
	/**
	 * Defines whether the bitmap image supports per-pixel transparency. You can
	 * set this value only when you construct a BitmapData object by passing in
	 * <code>true</code> for the <code>transparent</code> parameter of the
	 * constructor. Then, after you create a BitmapData object, you can check
	 * whether it supports per-pixel transparency by determining if the value of
	 * the <code>transparent</code> property is <code>true</code>.
	 */
	public var transparent (default, null):Bool;
	
	/**
	 * The width of the bitmap image in pixels.
	 */
	public var width (default, null):Int;
	
	@:noCompletion @:dox(hide) public var __worldTransform:Matrix;
	
	@:noCompletion private var __buffer:GLBuffer;
	@:noCompletion private var __image:Image;
	@:noCompletion private var __isValid:Bool;
	@:noCompletion private var __texture:GLTexture;
	@:noCompletion private var __textureImage:Image;
	@:noCompletion private var __uvData:TextureUvs;
	
	
	/**
	 * Creates a BitmapData object with a specified width and height. If you specify a value for 
	 * the <code>fillColor</code> parameter, every pixel in the bitmap is set to that color. 
	 * 
	 * By default, the bitmap is created as transparent, unless you pass the value <code>false</code>
	 * for the transparent parameter. After you create an opaque bitmap, you cannot change it 
	 * to a transparent bitmap. Every pixel in an opaque bitmap uses only 24 bits of color channel 
	 * information. If you define the bitmap as transparent, every pixel uses 32 bits of color 
	 * channel information, including an alpha transparency channel.
	 * 
	 * @param	width		The width of the bitmap image in pixels. 
	 * @param	height		The height of the bitmap image in pixels. 
	 * @param	transparent		Specifies whether the bitmap image supports per-pixel transparency. The default value is <code>true</code>(transparent). To create a fully transparent bitmap, set the value of the <code>transparent</code> parameter to <code>true</code> and the value of the <code>fillColor</code> parameter to 0x00000000(or to 0). Setting the <code>transparent</code> property to <code>false</code> can result in minor improvements in rendering performance.
	 * @param	fillColor		A 32-bit ARGB color value that you use to fill the bitmap image area. The default value is 0xFFFFFFFF(solid white).
	 */
	public function new (width:Int, height:Int, transparent:Bool = true, fillColor:UInt = 0xFFFFFFFF) {
		
		this.transparent = transparent;
		
		if (width > 0 && height > 0) {
			
			this.width = width;
			this.height = height;
			rect = new Rectangle (0, 0, width, height);
			
			if (transparent) {

				if ((fillColor & 0xFF000000) == 0) {				
					fillColor = 0;
				}
                
			}
			else {
				
				fillColor = (0xFF << 24) | (fillColor & 0xFFFFFF);
				
			}
			
			__image = new Image (null, 0, 0, width, height, fillColor);
			__image.transparent = transparent;
			__isValid = true;
			
		}
		
		__createUVs ();
		
	}
	
	
	/**
	 * Takes a source image and a filter object and generates the filtered image. 
	 * 
	 * This method relies on the behavior of built-in filter objects, which determine the 
	 * destination rectangle that is affected by an input source rectangle.
	 * 
	 * After a filter is applied, the resulting image can be larger than the input image. 
	 * For example, if you use a BlurFilter class to blur a source rectangle of(50,50,100,100) 
	 * and a destination point of(10,10), the area that changes in the destination image is 
	 * larger than(10,10,60,60) because of the blurring. This happens internally during the 
	 * applyFilter() call.
	 * 
	 * If the <code>sourceRect</code> parameter of the sourceBitmapData parameter is an 
	 * interior region, such as(50,50,100,100) in a 200 x 200 image, the filter uses the source 
	 * pixels outside the <code>sourceRect</code> parameter to generate the destination rectangle.
	 * 
	 * If the BitmapData object and the object specified as the <code>sourceBitmapData</code> 
	 * parameter are the same object, the application uses a temporary copy of the object to 
	 * perform the filter. For best performance, avoid this situation.
	 * 
	 * @param	sourceBitmapData		The input bitmap image to use. The source image can be a different BitmapData object or it can refer to the current BitmapData instance.
	 * @param	sourceRect		A rectangle that defines the area of the source image to use as input.
	 * @param	destPoint		The point within the destination image(the current BitmapData instance) that corresponds to the upper-left corner of the source rectangle. 
	 * @param	filter		The filter object that you use to perform the filtering operation. 
	 */
	public function applyFilter (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, filter:BitmapFilter):Void {
		
		if (!__isValid || sourceBitmapData == null || !sourceBitmapData.__isValid) return;
		
		#if js
		ImageCanvasUtil.convertToCanvas (__image);
		ImageCanvasUtil.createImageData (__image);
		ImageCanvasUtil.convertToCanvas (sourceBitmapData.__image);
		ImageCanvasUtil.createImageData (sourceBitmapData.__image);
		#end
		
		#if js
		filter.__applyFilter (__image.buffer.__srcImageData, sourceBitmapData.__image.buffer.__srcImageData, sourceRect, destPoint);
		#end
		
		__image.dirty = true;
		
	}
	
	
	/**
	 * Returns a new BitmapData object that is a clone of the original instance with an exact copy of the contained bitmap. 
	 * @return		A new BitmapData object that is identical to the original.
	 */
	public function clone ():BitmapData {
		
		if (!__isValid) {
			
			return new BitmapData (width, height, transparent);
			
		} else {
			
			return BitmapData.fromImage (__image.clone (), transparent);
			
		}
		
	}
	
	
	/**
	 * Adjusts the color values in a specified area of a bitmap image by using a <code>ColorTransform</code>
	 * object. If the rectangle matches the boundaries of the bitmap image, this method transforms the color 
	 * values of the entire image. 
	 * @param	rect		A Rectangle object that defines the area of the image in which the ColorTransform object is applied.
	 * @param	colorTransform		A ColorTransform object that describes the color transformation values to apply.
	 */
	public function colorTransform (rect:Rectangle, colorTransform:ColorTransform):Void {
		
		__image.colorTransform (rect.__toLimeRectangle (), colorTransform.__toLimeColorMatrix ());
		
	}
	
	
	/**
	 * Transfers data from one channel of another BitmapData object or the
	 * current BitmapData object into a channel of the current BitmapData object.
	 * All of the data in the other channels in the destination BitmapData object
	 * are preserved.
	 *
	 * <p>The source channel value and destination channel value can be one of
	 * following values: </p>
	 *
	 * <ul>
	 *   <li><code>BitmapDataChannel.RED</code></li>
	 *   <li><code>BitmapDataChannel.GREEN</code></li>
	 *   <li><code>BitmapDataChannel.BLUE</code></li>
	 *   <li><code>BitmapDataChannel.ALPHA</code></li>
	 * </ul>
	 * 
	 * @param sourceBitmapData The input bitmap image to use. The source image
	 *                         can be a different BitmapData object or it can
	 *                         refer to the current BitmapData object.
	 * @param sourceRect       The source Rectangle object. To copy only channel
	 *                         data from a smaller area within the bitmap,
	 *                         specify a source rectangle that is smaller than
	 *                         the overall size of the BitmapData object.
	 * @param destPoint        The destination Point object that represents the
	 *                         upper-left corner of the rectangular area where
	 *                         the new channel data is placed. To copy only
	 *                         channel data from one area to a different area in
	 *                         the destination image, specify a point other than
	 *                        (0,0).
	 * @param sourceChannel    The source channel. Use a value from the
	 *                         BitmapDataChannel class
	 *                        (<code>BitmapDataChannel.RED</code>,
	 *                         <code>BitmapDataChannel.BLUE</code>,
	 *                         <code>BitmapDataChannel.GREEN</code>,
	 *                         <code>BitmapDataChannel.ALPHA</code>).
	 * @param destChannel      The destination channel. Use a value from the
	 *                         BitmapDataChannel class
	 *                        (<code>BitmapDataChannel.RED</code>,
	 *                         <code>BitmapDataChannel.BLUE</code>,
	 *                         <code>BitmapDataChannel.GREEN</code>,
	 *                         <code>BitmapDataChannel.ALPHA</code>).
	 * @throws TypeError The sourceBitmapData, sourceRect or destPoint are null.
	 */
	public function copyChannel (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, sourceChannel:Int, destChannel:Int):Void {
		
		if (!__isValid) return;
		
		var sourceChannel = switch (sourceChannel) {
			
			case 1: ImageChannel.RED;
			case 2: ImageChannel.GREEN;
			case 4: ImageChannel.BLUE;
			case 8: ImageChannel.ALPHA;
			default: return;
			
		}
		
		var destChannel = switch (destChannel) {
			
			case 1: ImageChannel.RED;
			case 2: ImageChannel.GREEN;
			case 4: ImageChannel.BLUE;
			case 8: ImageChannel.ALPHA;
			default: return;
			
		}
		
		__image.copyChannel (sourceBitmapData.__image, sourceRect.__toLimeRectangle (), destPoint.__toLimeVector2 (), sourceChannel, destChannel);
		
	}
	
	
	/**
	 * Provides a fast routine to perform pixel manipulation between images with
	 * no stretching, rotation, or color effects. This method copies a
	 * rectangular area of a source image to a rectangular area of the same size
	 * at the destination point of the destination BitmapData object.
	 *
	 * <p>If you include the <code>alphaBitmap</code> and <code>alphaPoint</code>
	 * parameters, you can use a secondary image as an alpha source for the
	 * source image. If the source image has alpha data, both sets of alpha data
	 * are used to composite pixels from the source image to the destination
	 * image. The <code>alphaPoint</code> parameter is the point in the alpha
	 * image that corresponds to the upper-left corner of the source rectangle.
	 * Any pixels outside the intersection of the source image and alpha image
	 * are not copied to the destination image.</p>
	 *
	 * <p>The <code>mergeAlpha</code> property controls whether or not the alpha
	 * channel is used when a transparent image is copied onto another
	 * transparent image. To copy pixels with the alpha channel data, set the
	 * <code>mergeAlpha</code> property to <code>true</code>. By default, the
	 * <code>mergeAlpha</code> property is <code>false</code>.</p>
	 * 
	 * @param sourceBitmapData The input bitmap image from which to copy pixels.
	 *                         The source image can be a different BitmapData
	 *                         instance, or it can refer to the current
	 *                         BitmapData instance.
	 * @param sourceRect       A rectangle that defines the area of the source
	 *                         image to use as input.
	 * @param destPoint        The destination point that represents the
	 *                         upper-left corner of the rectangular area where
	 *                         the new pixels are placed.
	 * @param alphaBitmapData  A secondary, alpha BitmapData object source.
	 * @param alphaPoint       The point in the alpha BitmapData object source
	 *                         that corresponds to the upper-left corner of the
	 *                         <code>sourceRect</code> parameter.
	 * @param mergeAlpha       To use the alpha channel, set the value to
	 *                         <code>true</code>. To copy pixels with no alpha
	 *                         channel, set the value to <code>false</code>.
	 * @throws TypeError The sourceBitmapData, sourceRect, destPoint are null.
	 */
	public function copyPixels (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, alphaBitmapData:BitmapData = null, alphaPoint:Point = null, mergeAlpha:Bool = false):Void {
		
		if (!__isValid || sourceBitmapData == null) return;
		
		__image.copyPixels (sourceBitmapData.__image, sourceRect.__toLimeRectangle (), destPoint.__toLimeVector2 (), alphaBitmapData != null ? alphaBitmapData.__image : null, alphaPoint != null ? alphaPoint.__toLimeVector2 () : null, mergeAlpha);
		
	}
	
	
	/**
	 * Frees memory that is used to store the BitmapData object.
	 *
	 * <p>When the <code>dispose()</code> method is called on an image, the width
	 * and height of the image are set to 0. All subsequent calls to methods or
	 * properties of this BitmapData instance fail, and an exception is thrown.
	 * </p>
	 *
	 * <p><code>BitmapData.dispose()</code> releases the memory occupied by the
	 * actual bitmap data, immediately(a bitmap can consume up to 64 MB of
	 * memory). After using <code>BitmapData.dispose()</code>, the BitmapData
	 * object is no longer usable and an exception may be thrown if
	 * you call functions on the BitmapData object. However,
	 * <code>BitmapData.dispose()</code> does not garbage collect the BitmapData
	 * object(approximately 128 bytes); the memory occupied by the actual
	 * BitmapData object is released at the time the BitmapData object is
	 * collected by the garbage collector.</p>
	 * 
	 */
	public function dispose ():Void {
		
		__image = null;
		
		width = 0;
		height = 0;
		rect = null;
		__isValid = false;
		
	}
	
	
	/**
	 * Draws the <code>source</code> display object onto the bitmap image, using
	 * the NME software renderer. You can specify <code>matrix</code>,
	 * <code>colorTransform</code>, <code>blendMode</code>, and a destination
	 * <code>clipRect</code> parameter to control how the rendering performs.
	 * Optionally, you can specify whether the bitmap should be smoothed when
	 * scaled(this works only if the source object is a BitmapData object).
	 *
	 * <p>The source display object does not use any of its applied
	 * transformations for this call. It is treated as it exists in the library
	 * or file, with no matrix transform, no color transform, and no blend mode.
	 * To draw a display object(such as a movie clip) by using its own transform
	 * properties, you can copy its <code>transform</code> property object to the
	 * <code>transform</code> property of the Bitmap object that uses the
	 * BitmapData object.</p>
	 * 
	 * @param source         The display object or BitmapData object to draw to
	 *                       the BitmapData object.(The DisplayObject and
	 *                       BitmapData classes implement the IBitmapDrawable
	 *                       interface.)
	 * @param matrix         A Matrix object used to scale, rotate, or translate
	 *                       the coordinates of the bitmap. If you do not want to
	 *                       apply a matrix transformation to the image, set this
	 *                       parameter to an identity matrix, created with the
	 *                       default <code>new Matrix()</code> constructor, or
	 *                       pass a <code>null</code> value.
	 * @param colorTransform A ColorTransform object that you use to adjust the
	 *                       color values of the bitmap. If no object is
	 *                       supplied, the bitmap image's colors are not
	 *                       transformed. If you must pass this parameter but you
	 *                       do not want to transform the image, set this
	 *                       parameter to a ColorTransform object created with
	 *                       the default <code>new ColorTransform()</code>
	 *                       constructor.
	 * @param blendMode      A string value, from the openfl.display.BlendMode
	 *                       class, specifying the blend mode to be applied to
	 *                       the resulting bitmap.
	 * @param clipRect       A Rectangle object that defines the area of the
	 *                       source object to draw. If you do not supply this
	 *                       value, no clipping occurs and the entire source
	 *                       object is drawn.
	 * @param smoothing      A Boolean value that determines whether a BitmapData
	 *                       object is smoothed when scaled or rotated, due to a
	 *                       scaling or rotation in the <code>matrix</code>
	 *                       parameter. The <code>smoothing</code> parameter only
	 *                       applies if the <code>source</code> parameter is a
	 *                       BitmapData object. With <code>smoothing</code> set
	 *                       to <code>false</code>, the rotated or scaled
	 *                       BitmapData image can appear pixelated or jagged. For
	 *                       example, the following two images use the same
	 *                       BitmapData object for the <code>source</code>
	 *                       parameter, but the <code>smoothing</code> parameter
	 *                       is set to <code>true</code> on the left and
	 *                       <code>false</code> on the right:
	 *
	 *                       <p>Drawing a bitmap with <code>smoothing</code> set
	 *                       to <code>true</code> takes longer than doing so with
	 *                       <code>smoothing</code> set to
	 *                       <code>false</code>.</p>
	 * @throws ArgumentError The <code>source</code> parameter is not a
	 *                       BitmapData or DisplayObject object.
	 * @throws ArgumentError The source is null or not a valid IBitmapDrawable
	 *                       object.
	 * @throws SecurityError The <code>source</code> object and(in the case of a
	 *                       Sprite or MovieClip object) all of its child objects
	 *                       do not come from the same domain as the caller, or
	 *                       are not in a content that is accessible to the
	 *                       caller by having called the
	 *                       <code>Security.allowDomain()</code> method. This
	 *                       restriction does not apply to AIR content in the
	 *                       application security sandbox.
	 */
	public function draw (source:IBitmapDrawable, matrix:Matrix = null, colorTransform:ColorTransform = null, blendMode:BlendMode = null, clipRect:Rectangle = null, smoothing:Bool = false):Void {
		
		if (!__isValid) return;
		
		switch (__image.type) {
			
			case CANVAS:
				
				ImageCanvasUtil.convertToCanvas (__image);
				ImageCanvasUtil.sync (__image);
				
				#if js
				var buffer = __image.buffer;
				
				var renderSession = new RenderSession ();
				renderSession.context = cast buffer.__srcContext;
				renderSession.roundPixels = true;
				
				if (!smoothing) {
					
					untyped (buffer.__srcContext).mozImageSmoothingEnabled = false;
					untyped (buffer.__srcContext).webkitImageSmoothingEnabled = false;
					buffer.__srcContext.imageSmoothingEnabled = false;
					
				}
				
				var matrixCache = source.__worldTransform;
				source.__worldTransform = matrix != null ? matrix : new Matrix ();
				source.__updateChildren (false);
				source.__renderCanvas (renderSession);
				source.__worldTransform = matrixCache;
				source.__updateChildren (true);
				
				if (!smoothing) {
					
					untyped (buffer.__srcContext).mozImageSmoothingEnabled = true;
					untyped (buffer.__srcContext).webkitImageSmoothingEnabled = true;
					buffer.__srcContext.imageSmoothingEnabled = true;
					
				}
				
				buffer.__srcContext.setTransform (1, 0, 0, 1, 0, 0);
				#end
				
			default:
				
				// TODO
			
		}
		
	}
	
	
	public function encode (rect:Rectangle, compressor:Dynamic, byteArray:ByteArray = null):ByteArray {
		
		// TODO: Support rect
		
		if (!__isValid || rect == null) return byteArray = null;
		
		if (Std.is (compressor, PNGEncoderOptions)) {
			
			return byteArray = __image.encode ("png");
			
		} else if (Std.is (compressor, JPEGEncoderOptions)) {
			
			return byteArray = __image.encode ("jpg", cast (compressor, JPEGEncoderOptions).quality);
			
		}
		
		return byteArray = null;
		
	}
	
	
	/**
	 * Fills a rectangular area of pixels with a specified ARGB color.
	 * 
	 * @param rect  The rectangular area to fill.
	 * @param color The ARGB color value that fills the area. ARGB colors are
	 *              often specified in hexadecimal format; for example,
	 *              0xFF336699.
	 * @throws TypeError The rect is null.
	 */
	public function fillRect (rect:Rectangle, color:Int):Void {
		
		if (!__isValid || rect == null) return;
		__image.fillRect (rect.__toLimeRectangle (), color);
		
	}
	
	
	/**
	 * Performs a flood fill operation on an image starting at an(<i>x</i>,
	 * <i>y</i>) coordinate and filling with a certain color. The
	 * <code>floodFill()</code> method is similar to the paint bucket tool in
	 * various paint programs. The color is an ARGB color that contains alpha
	 * information and color information.
	 * 
	 * @param x     The <i>x</i> coordinate of the image.
	 * @param y     The <i>y</i> coordinate of the image.
	 * @param color The ARGB color to use as a fill.
	 */
	public function floodFill (x:Int, y:Int, color:Int):Void {
		
		if (!__isValid) return;
		__image.floodFill (x, y, color);
		
	}
	
	
	public static function fromBase64 (base64:String, type:String, onload:BitmapData -> Void = null):BitmapData {
		
		var bitmapData = new BitmapData (0, 0, true);
		bitmapData.__loadFromBase64 (base64, type, onload);
		return bitmapData;
		
	}
	
	
	public static function fromBytes (bytes:ByteArray, rawAlpha:ByteArray = null, onload:BitmapData -> Void = null):BitmapData {
		
		var bitmapData = new BitmapData (0, 0, true);
		bitmapData.__loadFromBytes (bytes, rawAlpha, onload);
		return bitmapData;
		
	}
	
	
	#if js
	public static function fromCanvas (canvas:CanvasElement, transparent:Bool = true):BitmapData {
		
		var bitmapData = new BitmapData (0, 0, transparent);
		bitmapData.__loadFromImage (Image.fromCanvas (canvas));
		bitmapData.__image.transparent = transparent;
		return bitmapData;
		
	}
	#end
	
	
	public static function fromFile (path:String, onload:BitmapData -> Void = null, onerror:Void -> Void = null):BitmapData {
		
		var bitmapData = new BitmapData (0, 0, true);
		bitmapData.__loadFromFile (path, onload, onerror);
		return bitmapData;
		
	}
	
	
	public static function fromImage (image:Image, transparent:Bool = true):BitmapData {
		
		var bitmapData = new BitmapData (0, 0, transparent);
		bitmapData.__loadFromImage (image);
		bitmapData.__image.transparent = transparent;
		return bitmapData;
		
	}
	
	
	/**
	 * Determines the destination rectangle that the <code>applyFilter()</code>
	 * method call affects, given a BitmapData object, a source rectangle, and a
	 * filter object.
	 *
	 * <p>For example, a blur filter normally affects an area larger than the
	 * size of the original image. A 100 x 200 pixel image that is being filtered
	 * by a default BlurFilter instance, where <code>blurX = blurY = 4</code>
	 * generates a destination rectangle of <code>(-2,-2,104,204)</code>. The
	 * <code>generateFilterRect()</code> method lets you find out the size of
	 * this destination rectangle in advance so that you can size the destination
	 * image appropriately before you perform a filter operation.</p>
	 *
	 * <p>Some filters clip their destination rectangle based on the source image
	 * size. For example, an inner <code>DropShadow</code> does not generate a
	 * larger result than its source image. In this API, the BitmapData object is
	 * used as the source bounds and not the source <code>rect</code>
	 * parameter.</p>
	 * 
	 * @param sourceRect A rectangle defining the area of the source image to use
	 *                   as input.
	 * @param filter     A filter object that you use to calculate the
	 *                   destination rectangle.
	 * @return A destination rectangle computed by using an image, the
	 *         <code>sourceRect</code> parameter, and a filter.
	 * @throws TypeError The sourceRect or filter are null.
	 */
	public function generateFilterRect (sourceRect:Rectangle, filter:BitmapFilter):Rectangle {
		
		return sourceRect.clone ();
		
	}
	
	
	public function getBuffer (gl:GLRenderContext):GLBuffer {
		
		if (__buffer == null) {
			
			var data = [
				
				width, height, 0, 1, 1, 
				0, height, 0, 0, 1, 
				width, 0, 0, 1, 0, 
				0, 0, 0, 0, 0
				
			];
			
			__buffer = gl.createBuffer ();
			gl.bindBuffer (gl.ARRAY_BUFFER, __buffer);
			gl.bufferData (gl.ARRAY_BUFFER, new Float32Array (cast data), gl.STATIC_DRAW);
			gl.bindBuffer (gl.ARRAY_BUFFER, null);
			
		}
		
		return __buffer;
		
	}
	
	
	/**
	 * Determines a rectangular region that either fully encloses all pixels of a
	 * specified color within the bitmap image(if the <code>findColor</code>
	 * parameter is set to <code>true</code>) or fully encloses all pixels that
	 * do not include the specified color(if the <code>findColor</code>
	 * parameter is set to <code>false</code>).
	 *
	 * <p>For example, if you have a source image and you want to determine the
	 * rectangle of the image that contains a nonzero alpha channel, pass
	 * <code>{mask: 0xFF000000, color: 0x00000000}</code> as parameters. If the
	 * <code>findColor</code> parameter is set to <code>true</code>, the entire
	 * image is searched for the bounds of pixels for which <code>(value & mask)
	 * == color</code>(where <code>value</code> is the color value of the
	 * pixel). If the <code>findColor</code> parameter is set to
	 * <code>false</code>, the entire image is searched for the bounds of pixels
	 * for which <code>(value & mask) != color</code>(where <code>value</code>
	 * is the color value of the pixel). To determine white space around an
	 * image, pass <code>{mask: 0xFFFFFFFF, color: 0xFFFFFFFF}</code> to find the
	 * bounds of nonwhite pixels.</p>
	 * 
	 * @param mask      A hexadecimal value, specifying the bits of the ARGB
	 *                  color to consider. The color value is combined with this
	 *                  hexadecimal value, by using the <code>&</code>(bitwise
	 *                  AND) operator.
	 * @param color     A hexadecimal value, specifying the ARGB color to match
	 *                 (if <code>findColor</code> is set to <code>true</code>)
	 *                  or <i>not</i> to match(if <code>findColor</code> is set
	 *                  to <code>false</code>).
	 * @param findColor If the value is set to <code>true</code>, returns the
	 *                  bounds of a color value in an image. If the value is set
	 *                  to <code>false</code>, returns the bounds of where this
	 *                  color doesn't exist in an image.
	 * @return The region of the image that is the specified color.
	 */
	public function getColorBoundsRect (mask:Int, color:Int, findColor:Bool = true):Rectangle {
		
		return __image.rect.__toFlashRectangle ();
		
	}
	
	
	/**
	 * Returns an integer that represents an RGB pixel value from a BitmapData
	 * object at a specific point(<i>x</i>, <i>y</i>). The
	 * <code>getPixel()</code> method returns an unmultiplied pixel value. No
	 * alpha information is returned.
	 *
	 * <p>All pixels in a BitmapData object are stored as premultiplied color
	 * values. A premultiplied image pixel has the red, green, and blue color
	 * channel values already multiplied by the alpha data. For example, if the
	 * alpha value is 0, the values for the RGB channels are also 0, independent
	 * of their unmultiplied values. This loss of data can cause some problems
	 * when you perform operations. All BitmapData methods take and return
	 * unmultiplied values. The internal pixel representation is converted from
	 * premultiplied to unmultiplied before it is returned as a value. During a
	 * set operation, the pixel value is premultiplied before the raw image pixel
	 * is set.</p>
	 * 
	 * @param x The <i>x</i> position of the pixel.
	 * @param y The <i>y</i> position of the pixel.
	 * @return A number that represents an RGB pixel value. If the(<i>x</i>,
	 *         <i>y</i>) coordinates are outside the bounds of the image, the
	 *         method returns 0.
	 */
	public function getPixel (x:Int, y:Int):Int {
		
		if (!__isValid) return 0;
		return __image.getPixel (x, y);
		
	}
	
	
	/**
	 * Returns an ARGB color value that contains alpha channel data and RGB data.
	 * This method is similar to the <code>getPixel()</code> method, which
	 * returns an RGB color without alpha channel data.
	 *
	 * <p>All pixels in a BitmapData object are stored as premultiplied color
	 * values. A premultiplied image pixel has the red, green, and blue color
	 * channel values already multiplied by the alpha data. For example, if the
	 * alpha value is 0, the values for the RGB channels are also 0, independent
	 * of their unmultiplied values. This loss of data can cause some problems
	 * when you perform operations. All BitmapData methods take and return
	 * unmultiplied values. The internal pixel representation is converted from
	 * premultiplied to unmultiplied before it is returned as a value. During a
	 * set operation, the pixel value is premultiplied before the raw image pixel
	 * is set.</p>
	 * 
	 * @param x The <i>x</i> position of the pixel.
	 * @param y The <i>y</i> position of the pixel.
	 * @return A number representing an ARGB pixel value. If the(<i>x</i>,
	 *         <i>y</i>) coordinates are outside the bounds of the image, 0 is
	 *         returned.
	 */
	public function getPixel32 (x:Int, y:Int):Int {
		
		if (!__isValid) return 0;
		return __image.getPixel32 (x, y);
		
	}
	
	
	/**
	 * Generates a byte array from a rectangular region of pixel data. Writes an
	 * unsigned integer(a 32-bit unmultiplied pixel value) for each pixel into
	 * the byte array.
	 * 
	 * @param rect A rectangular area in the current BitmapData object.
	 * @return A ByteArray representing the pixels in the given Rectangle.
	 * @throws TypeError The rect is null.
	 */
	public function getPixels (rect:Rectangle):ByteArray {
		
		if (!__isValid) return null;
		if (rect == null) rect = this.rect;
		return __image.getPixels (rect.__toLimeRectangle ());
		
	}
	
	
	public function getTexture (gl:GLRenderContext):GLTexture {
		
		if (__texture == null) {
			
			__texture = gl.createTexture ();
			gl.bindTexture (gl.TEXTURE_2D, __texture);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
			__image.dirty = true;
			
		}
		
		if (__image.dirty) {
			
			gl.bindTexture (gl.TEXTURE_2D, __texture);
			var textureImage = __image.clone ();
			textureImage.premultiplied = true;
			gl.texImage2D (gl.TEXTURE_2D, 0, gl.RGBA, width, height, 0, gl.RGBA, gl.UNSIGNED_BYTE, textureImage.data);
			gl.bindTexture (gl.TEXTURE_2D, null);
			__image.dirty = false;
			
		}
		
		return __texture;
		
	}
	
	
	/**
	 * Generates a vector array from a rectangular region of pixel data. Returns
	 * a Vector object of unsigned integers(a 32-bit unmultiplied pixel value)
	 * for the specified rectangle.
	 * 
	 * @param rect A rectangular area in the current BitmapData object.
	 * @return A Vector representing the given Rectangle.
	 * @throws TypeError The rect is null.
	 */
	public function getVector (rect:Rectangle) {
		
		var pixels = getPixels (rect);
		var length = Std.int (pixels.length / 4);
		var result = new Vector<UInt> (length, true);
		
		for (i in 0...length) {
			
			result[i] = pixels.readUnsignedInt ();
			
		}
		
		return result;
		
	}
	
	
	public function histogram (hRect:Rectangle = null) {
		
		var rect = hRect != null ? hRect : new Rectangle (0, 0, width, height);
		var pixels = getPixels (rect);
		var result = [for (i in 0...4) [for (j in 0...256) 0]];
		
		for (i in 0...pixels.length) {
			
			++result[i % 4][pixels.readUnsignedByte ()];
			
		}
		
		return result;
		
	}
	
	
	public function hitTest (firstPoint:Point, firstAlphaThreshold:Int, secondObject:Dynamic, secondBitmapDataPoint:Point = null, secondAlphaThreshold:Int = 1):Bool {
		
		if (!__isValid) return false;
		
		openfl.Lib.notImplemented ("BitmapData.hitTest");
		
		return false;
		
	}
	
	
	/**
	 * Locks an image so that any objects that reference the BitmapData object,
	 * such as Bitmap objects, are not updated when this BitmapData object
	 * changes. To improve performance, use this method along with the
	 * <code>unlock()</code> method before and after numerous calls to the
	 * <code>setPixel()</code> or <code>setPixel32()</code> method.
	 * 
	 */
	public function lock ():Void {
		
		
		
	}
	
	
	public function merge (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, redMultiplier:UInt, greenMultiplier:UInt, blueMultiplier:UInt, alphaMultiplier:UInt):Void {
		
		if (!__isValid || sourceBitmapData == null || !sourceBitmapData.__isValid || sourceRect == null || destPoint == null) return;
		__image.merge (sourceBitmapData.__image, sourceRect.__toLimeRectangle (), destPoint.__toLimeVector2 (), redMultiplier, greenMultiplier, blueMultiplier, alphaMultiplier);
		
	}
	
	
	/**
	 * Fills an image with pixels representing random noise.
	 * 
	 * @param randomSeed     The random seed number to use. If you keep all other
	 *                       parameters the same, you can generate different
	 *                       pseudo-random results by varying the random seed
	 *                       value. The noise function is a mapping function, not
	 *                       a true random-number generation function, so it
	 *                       creates the same results each time from the same
	 *                       random seed.
	 * @param low            The lowest value to generate for each channel(0 to
	 *                       255).
	 * @param high           The highest value to generate for each channel(0 to
	 *                       255).
	 * @param channelOptions A number that can be a combination of any of the
	 *                       four color channel values
	 *                      (<code>BitmapDataChannel.RED</code>,
	 *                       <code>BitmapDataChannel.BLUE</code>,
	 *                       <code>BitmapDataChannel.GREEN</code>, and
	 *                       <code>BitmapDataChannel.ALPHA</code>). You can use
	 *                       the logical OR operator(<code>|</code>) to combine
	 *                       channel values.
	 * @param grayScale      A Boolean value. If the value is <code>true</code>,
	 *                       a grayscale image is created by setting all of the
	 *                       color channels to the same value. The alpha channel
	 *                       selection is not affected by setting this parameter
	 *                       to <code>true</code>.
	 */
	public function noise (randomSeed:Int, low:Int = 0, high:Int = 255, channelOptions:Int = 7, grayScale:Bool = false):Void {
		
		if (!__isValid) return;
		
		openfl.Lib.notImplemented ("BitmapData.noise");
		
	}
	
	
	public function paletteMap (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, redArray:Array<Int> = null, greenArray:Array<Int> = null, blueArray:Array<Int> = null, alphaArray:Array<Int> = null):Void {
		
		var sw:Int = Std.int (sourceRect.width);
		var sh:Int = Std.int (sourceRect.height);
		
		var pixels = getPixels (sourceRect);
		pixels.position = 0;
		
		var pixelValue:Int, r:Int, g:Int, b:Int, a:Int, color:Int, c1:Int, c2:Int, c3:Int, c4:Int;
		
		for (i in 0...(sh * sw)) {
			
			pixelValue = pixels.readUnsignedInt ();
			
			c1 = (alphaArray == null) ? pixelValue & 0xFF000000 : alphaArray[(pixelValue >> 24) & 0xFF];
			c2 = (redArray == null) ? pixelValue & 0x00FF0000 : redArray[(pixelValue >> 16) & 0xFF];
			c3 = (greenArray == null) ? pixelValue & 0x0000FF00 : greenArray[(pixelValue >> 8) & 0xFF];
			c4 = (blueArray == null) ? pixelValue & 0x000000FF : blueArray[(pixelValue) & 0xFF];
			
			a = ((c1 >> 24) & 0xFF) + ((c2 >> 24) & 0xFF) + ((c3 >> 24) & 0xFF) + ((c4 >> 24) & 0xFF);
			if (a > 0xFF) a == 0xFF;
			
			r = ((c1 >> 16) & 0xFF) + ((c2 >> 16) & 0xFF) + ((c3 >> 16) & 0xFF) + ((c4 >> 16) & 0xFF);
			if (r > 0xFF) r == 0xFF;
			
			g = ((c1 >> 8) & 0xFF) + ((c2 >> 8) & 0xFF) + ((c3 >> 8) & 0xFF) + ((c4 >> 8) & 0xFF);
			if (g > 0xFF) g == 0xFF;
			
			b = ((c1) & 0xFF) + ((c2) & 0xFF) + ((c3) & 0xFF) + ((c4) & 0xFF);
			if (b > 0xFF) b == 0xFF;
			
			color = a << 24 | r << 16 | g << 8 | b;
			
			pixels.position = i * 4;
			pixels.writeUnsignedInt (color);
			
		}
		
		pixels.position = 0;
		var destRect = new Rectangle (destPoint.x, destPoint.y, sw, sh);
		setPixels (destRect, pixels);
		
	}
	
	
	/**
	 * Generates a Perlin noise image.
	 *
	 * <p>The Perlin noise generation algorithm interpolates and combines
	 * individual random noise functions(called octaves) into a single function
	 * that generates more natural-seeming random noise. Like musical octaves,
	 * each octave function is twice the frequency of the one before it. Perlin
	 * noise has been described as a "fractal sum of noise" because it combines
	 * multiple sets of noise data with different levels of detail.</p>
	 *
	 * <p>You can use Perlin noise functions to simulate natural phenomena and
	 * landscapes, such as wood grain, clouds, and mountain ranges. In most
	 * cases, the output of a Perlin noise function is not displayed directly but
	 * is used to enhance other images and give them pseudo-random
	 * variations.</p>
	 *
	 * <p>Simple digital random noise functions often produce images with harsh,
	 * contrasting points. This kind of harsh contrast is not often found in
	 * nature. The Perlin noise algorithm blends multiple noise functions that
	 * operate at different levels of detail. This algorithm results in smaller
	 * variations among neighboring pixel values.</p>
	 * 
	 * @param baseX          Frequency to use in the <i>x</i> direction. For
	 *                       example, to generate a noise that is sized for a 64
	 *                       x 128 image, pass 64 for the <code>baseX</code>
	 *                       value.
	 * @param baseY          Frequency to use in the <i>y</i> direction. For
	 *                       example, to generate a noise that is sized for a 64
	 *                       x 128 image, pass 128 for the <code>baseY</code>
	 *                       value.
	 * @param numOctaves     Number of octaves or individual noise functions to
	 *                       combine to create this noise. Larger numbers of
	 *                       octaves create images with greater detail. Larger
	 *                       numbers of octaves also require more processing
	 *                       time.
	 * @param randomSeed     The random seed number to use. If you keep all other
	 *                       parameters the same, you can generate different
	 *                       pseudo-random results by varying the random seed
	 *                       value. The Perlin noise function is a mapping
	 *                       function, not a true random-number generation
	 *                       function, so it creates the same results each time
	 *                       from the same random seed.
	 * @param stitch         A Boolean value. If the value is <code>true</code>,
	 *                       the method attempts to smooth the transition edges
	 *                       of the image to create seamless textures for tiling
	 *                       as a bitmap fill.
	 * @param fractalNoise   A Boolean value. If the value is <code>true</code>,
	 *                       the method generates fractal noise; otherwise, it
	 *                       generates turbulence. An image with turbulence has
	 *                       visible discontinuities in the gradient that can
	 *                       make it better approximate sharper visual effects
	 *                       like flames and ocean waves.
	 * @param channelOptions A number that can be a combination of any of the
	 *                       four color channel values
	 *                      (<code>BitmapDataChannel.RED</code>,
	 *                       <code>BitmapDataChannel.BLUE</code>,
	 *                       <code>BitmapDataChannel.GREEN</code>, and
	 *                       <code>BitmapDataChannel.ALPHA</code>). You can use
	 *                       the logical OR operator(<code>|</code>) to combine
	 *                       channel values.
	 * @param grayScale      A Boolean value. If the value is <code>true</code>,
	 *                       a grayscale image is created by setting each of the
	 *                       red, green, and blue color channels to identical
	 *                       values. The alpha channel value is not affected if
	 *                       this value is set to <code>true</code>.
	 */
	public function perlinNoise (baseX:Float, baseY:Float, numOctaves:UInt, randomSeed:Int, stitch:Bool, fractalNoise:Bool, channelOptions:UInt = 7, grayScale:Bool = false, offsets:Array<Point> = null):Void {
		
		openfl.Lib.notImplemented ("BitmapData.perlinNoise");
		
	}
	
	
	/**
	 * Scrolls an image by a certain(<i>x</i>, <i>y</i>) pixel amount. Edge
	 * regions outside the scrolling area are left unchanged.
	 * 
	 * @param x The amount by which to scroll horizontally.
	 * @param y The amount by which to scroll vertically.
	 */
	public function scroll (x:Int, y:Int):Void {
		
		openfl.Lib.notImplemented ("BitmapData.scroll");
		
	}
	
	
	/**
	 * Sets a single pixel of a BitmapData object. The current alpha channel
	 * value of the image pixel is preserved during this operation. The value of
	 * the RGB color parameter is treated as an unmultiplied color value.
	 *
	 * <p><b>Note:</b> To increase performance, when you use the
	 * <code>setPixel()</code> or <code>setPixel32()</code> method repeatedly,
	 * call the <code>lock()</code> method before you call the
	 * <code>setPixel()</code> or <code>setPixel32()</code> method, and then call
	 * the <code>unlock()</code> method when you have made all pixel changes.
	 * This process prevents objects that reference this BitmapData instance from
	 * updating until you finish making the pixel changes.</p>
	 * 
	 * @param x     The <i>x</i> position of the pixel whose value changes.
	 * @param y     The <i>y</i> position of the pixel whose value changes.
	 * @param color The resulting RGB color for the pixel.
	 */
	public function setPixel (x:Int, y:Int, color:Int):Void {
		
		if (!__isValid) return;
		__image.setPixel (x, y, color);
		
	}
	
	
	/**
	 * Sets the color and alpha transparency values of a single pixel of a
	 * BitmapData object. This method is similar to the <code>setPixel()</code>
	 * method; the main difference is that the <code>setPixel32()</code> method
	 * takes an ARGB color value that contains alpha channel information.
	 *
	 * <p>All pixels in a BitmapData object are stored as premultiplied color
	 * values. A premultiplied image pixel has the red, green, and blue color
	 * channel values already multiplied by the alpha data. For example, if the
	 * alpha value is 0, the values for the RGB channels are also 0, independent
	 * of their unmultiplied values. This loss of data can cause some problems
	 * when you perform operations. All BitmapData methods take and return
	 * unmultiplied values. The internal pixel representation is converted from
	 * premultiplied to unmultiplied before it is returned as a value. During a
	 * set operation, the pixel value is premultiplied before the raw image pixel
	 * is set.</p>
	 *
	 * <p><b>Note:</b> To increase performance, when you use the
	 * <code>setPixel()</code> or <code>setPixel32()</code> method repeatedly,
	 * call the <code>lock()</code> method before you call the
	 * <code>setPixel()</code> or <code>setPixel32()</code> method, and then call
	 * the <code>unlock()</code> method when you have made all pixel changes.
	 * This process prevents objects that reference this BitmapData instance from
	 * updating until you finish making the pixel changes.</p>
	 * 
	 * @param x     The <i>x</i> position of the pixel whose value changes.
	 * @param y     The <i>y</i> position of the pixel whose value changes.
	 * @param color The resulting ARGB color for the pixel. If the bitmap is
	 *              opaque(not transparent), the alpha transparency portion of
	 *              this color value is ignored.
	 */
	public function setPixel32 (x:Int, y:Int, color:Int):Void {
		
		if (!__isValid) return;
		__image.setPixel32 (x, y, color);
		
	}
	
	
	/**
	 * Converts a byte array into a rectangular region of pixel data. For each
	 * pixel, the <code>ByteArray.readUnsignedInt()</code> method is called and
	 * the return value is written into the pixel. If the byte array ends before
	 * the full rectangle is written, the function returns. The data in the byte
	 * array is expected to be 32-bit ARGB pixel values. No seeking is performed
	 * on the byte array before or after the pixels are read.
	 * 
	 * @param rect           Specifies the rectangular region of the BitmapData
	 *                       object.
	 * @param inputByteArray A ByteArray object that consists of 32-bit
	 *                       unmultiplied pixel values to be used in the
	 *                       rectangular region.
	 * @throws EOFError  The <code>inputByteArray</code> object does not include
	 *                   enough data to fill the area of the <code>rect</code>
	 *                   rectangle. The method fills as many pixels as possible
	 *                   before throwing the exception.
	 * @throws TypeError The rect or inputByteArray are null.
	 */
	public function setPixels (rect:Rectangle, byteArray:ByteArray):Void {
		
		if (!__isValid || rect == null) return;
		__image.setPixels (rect.__toLimeRectangle (), byteArray);
		
	}
	
	
	/**
	 * Converts a Vector into a rectangular region of pixel data. For each pixel,
	 * a Vector element is read and written into the BitmapData pixel. The data
	 * in the Vector is expected to be 32-bit ARGB pixel values.
	 * 
	 * @param rect Specifies the rectangular region of the BitmapData object.
	 * @throws RangeError The vector array is not large enough to read all the
	 *                    pixel data.
	 */
	public function setVector (rect:Rectangle, inputVector:Vector<UInt>) {
		
		var byteArray = new ByteArray ();
		#if js
		byteArray.length = inputVector.length * 4;
		#end
		
		for (color in inputVector) {
			
			byteArray.writeUnsignedInt (color);
			
		}
		
		byteArray.position = 0;
		setPixels (rect, byteArray);
		
	}
	
	
	/**
	 * Tests pixel values in an image against a specified threshold and sets
	 * pixels that pass the test to new color values. Using the
	 * <code>threshold()</code> method, you can isolate and replace color ranges
	 * in an image and perform other logical operations on image pixels.
	 *
	 * <p>The <code>threshold()</code> method's test logic is as follows:</p>
	 *
	 * <ol>
	 *   <li>If <code>((pixelValue & mask) operation(threshold & mask))</code>,
	 * then set the pixel to <code>color</code>;</li>
	 *   <li>Otherwise, if <code>copySource == true</code>, then set the pixel to
	 * corresponding pixel value from <code>sourceBitmap</code>.</li>
	 * </ol>
	 *
	 * <p>The <code>operation</code> parameter specifies the comparison operator
	 * to use for the threshold test. For example, by using "==" as the
	 * <code>operation</code> parameter, you can isolate a specific color value
	 * in an image. Or by using <code>{operation: "<", mask: 0xFF000000,
	 * threshold: 0x7F000000, color: 0x00000000}</code>, you can set all
	 * destination pixels to be fully transparent when the source image pixel's
	 * alpha is less than 0x7F. You can use this technique for animated
	 * transitions and other effects.</p>
	 * 
	 * @param sourceBitmapData The input bitmap image to use. The source image
	 *                         can be a different BitmapData object or it can
	 *                         refer to the current BitmapData instance.
	 * @param sourceRect       A rectangle that defines the area of the source
	 *                         image to use as input.
	 * @param destPoint        The point within the destination image(the
	 *                         current BitmapData instance) that corresponds to
	 *                         the upper-left corner of the source rectangle.
	 * @param operation        One of the following comparison operators, passed
	 *                         as a String: "<", "<=", ">", ">=", "==", "!="
	 * @param threshold        The value that each pixel is tested against to see
	 *                         if it meets or exceeds the threshhold.
	 * @param color            The color value that a pixel is set to if the
	 *                         threshold test succeeds. The default value is
	 *                         0x00000000.
	 * @param mask             The mask to use to isolate a color component.
	 * @param copySource       If the value is <code>true</code>, pixel values
	 *                         from the source image are copied to the
	 *                         destination when the threshold test fails. If the
	 *                         value is <code>false</code>, the source image is
	 *                         not copied when the threshold test fails.
	 * @return The number of pixels that were changed.
	 * @throws ArgumentError The operation string is not a valid operation
	 * @throws TypeError     The sourceBitmapData, sourceRect destPoint or
	 *                       operation are null.
	 */
	public function threshold (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, operation:String, threshold:Int, color:Int = 0x00000000, mask:Int = 0xFFFFFFFF, copySource:Bool = false):Int {
		
		if (sourceBitmapData == this && sourceRect.equals(rect) && destPoint.x == 0 && destPoint.y == 0) {
			
			var hits = 0;
			
			threshold = __flipPixel (threshold);
			color = __flipPixel (color);
			
			var memory = new ByteArray ();
			#if js
			memory.length  = width * height * 4;
			#end
			memory = getPixels (rect);
			memory.position = 0;
			Memory.select (memory);
			
			var thresholdMask:Int = cast threshold & mask;
			
			var width_yy:Int, position:Int, pixelMask:Int, pixelValue, i, test;
			
			for (yy in 0...height) {
				
				width_yy = width * yy;
				
				for (xx in 0...width) {
					
					position = (width_yy + xx) * 4;
					pixelValue = Memory.getI32 (position);
					pixelMask = cast pixelValue & mask;
					
					i = __ucompare (pixelMask, thresholdMask);
					test = false;
					
					if (operation == "==") { test = (i == 0); }
					else if (operation == "<") { test = (i == -1);}
					else if (operation == ">") { test = (i == 1); }
					else if (operation == "!=") { test = (i != 0); }
					else if (operation == "<=") { test = (i == 0 || i == -1); }
					else if (operation == ">=") { test = (i == 0 || i == 1); }
					
					if (test) {
						
						Memory.setI32 (position, color);
						hits++;
						
					}
					
				}
				
			}
			
			memory.position = 0;
			setPixels (rect, memory);
			Memory.select (null);
			return hits;
			
		} else {
			
			var sx = Std.int (sourceRect.x);
			var sy = Std.int (sourceRect.y);
			var sw = Std.int (sourceBitmapData.width);
			var sh = Std.int (sourceBitmapData.height);
			
			var dx = Std.int (destPoint.x);
			var dy = Std.int (destPoint.y);
			
			var bw:Int = width - sw - dx;
			var bh:Int = height - sh - dy;
			
			var dw:Int = (bw < 0) ? sw + (width - sw - dx) : sw;
			var dh:Int = (bw < 0) ? sh + (height - sh - dy) : sh;
			
			var hits = 0;
			
			threshold = __flipPixel (threshold);
			color = __flipPixel (color);
			
			var canvasMemory = (sw * sh) * 4;
			var sourceMemory = 0;
			
			if (copySource) {
				
				sourceMemory = (sw * sh) * 4;
				
			}
			
			var totalMemory = (canvasMemory + sourceMemory);
			var memory = new ByteArray ();
			#if js
			memory.length = totalMemory;
			#end
			memory.position = 0;
			var bitmapData = sourceBitmapData.clone ();
			var pixels = bitmapData.getPixels (sourceRect);
			memory.writeBytes (pixels);
			memory.position = canvasMemory;
			
			if (copySource) {
				
				memory.writeBytes (pixels);
				
			}
			
			memory.position = 0;
			Memory.select (memory);
			
			var thresholdMask:Int = cast threshold & mask;
			
			var position:Int, pixelMask:Int, pixelValue, i, test;
			
			for (yy in 0...dh) {
				
				for (xx in 0...dw) {
					
					position = ((xx + sx) + (yy + sy) * sw) * 4;
					pixelValue = Memory.getI32 (position);
					pixelMask = cast pixelValue & mask;
					
					i = __ucompare (pixelMask, thresholdMask);
					test = false;
					
					if (operation == "==") { test = (i == 0); }
					else if (operation == "<") { test = (i == -1);}
					else if (operation == ">") { test = (i == 1); }
					else if (operation == "!=") { test = (i != 0); }
					else if (operation == "<=") { test = (i == 0 || i == -1); }
					else if (operation == ">=") { test = (i == 0 || i == 1); }
					
					if (test) {
						
						Memory.setI32 (position, color);
						hits++;
						
					} else if (copySource) {
						
						Memory.setI32 (position, Memory.getI32 (canvasMemory + position));
						
					}
					
				}
				
			}
			
			memory.position = 0;	
			bitmapData.setPixels (sourceRect, memory);
			copyPixels (bitmapData, bitmapData.rect, destPoint);
			Memory.select (null);
			return hits;
			
		}
		
	}
	
	
	/**
	 * Unlocks an image so that any objects that reference the BitmapData object,
	 * such as Bitmap objects, are updated when this BitmapData object changes.
	 * To improve performance, use this method along with the <code>lock()</code>
	 * method before and after numerous calls to the <code>setPixel()</code> or
	 * <code>setPixel32()</code> method.
	 * 
	 * @param changeRect The area of the BitmapData object that has changed. If
	 *                   you do not specify a value for this parameter, the
	 *                   entire area of the BitmapData object is considered
	 *                   changed.
	 */
	public function unlock (changeRect:Rectangle = null):Void {
		
		
		
	}
	
	
	@:noCompletion private function __createUVs ():Void {
		
		if (__uvData == null) __uvData = new TextureUvs();
		
		__uvData.x0 = 0;
		__uvData.y0 = 0;
		__uvData.x1 = 1;
		__uvData.y1 = 0;
		__uvData.x2 = 1;
		__uvData.y2 = 1;
		__uvData.x3 = 0;
		__uvData.y3 = 1;
		
	}
	
	
	@:noCompletion private static inline function __flipPixel (pixel:Int):Int {
		
		return (pixel & 0xFF) << 24 | (pixel >>  8 & 0xFF) << 16 | (pixel >> 16 & 0xFF) <<  8 | (pixel >> 24 & 0xFF);
		
	}
	
	
	@:noCompletion private inline function __loadFromBase64 (base64:String, type:String, ?onload:BitmapData -> Void):Void {
		
		Image.fromBase64 (base64, type, function (image) {
			
			__loadFromImage (image);
			
			if (onload != null) {
				
				onload (this);
				
			}
			
		});
		
	}
	
	
	@:noCompletion private inline function __loadFromBytes (bytes:ByteArray, rawAlpha:ByteArray = null, ?onload:BitmapData -> Void):Void {
		
		Image.fromBytes (bytes, function (image) {
			
			__loadFromImage (image);
			
			if (rawAlpha != null) {
				
				#if js
				ImageCanvasUtil.convertToCanvas (__image);
				ImageCanvasUtil.createImageData (__image);
				#end
				
				var data = __image.buffer.data;
				
				for (i in 0...rawAlpha.length) {
					
					data[i * 4 + 3] = rawAlpha.readUnsignedByte ();
					
				}
				
				__image.dirty = true;
				
			}
			
			if (onload != null) {
				
				onload (this);
				
			}
			
		});
		
	}
	
	
	@:noCompletion private function __loadFromFile (path:String, onload:BitmapData -> Void, onerror:Void -> Void):Void {
		
		Image.fromFile (path, function (image) {
			
			__loadFromImage (image);
			
			if (onload != null) {
				
				onload (this);
				
			}
			
		}, onerror);
		
	}
	
	
	@:noCompletion private function __loadFromImage (image:Image):Void {
		
		__image = image;
		
		width = image.width;
		height = image.height;
		rect = new Rectangle (0, 0, image.width, image.height);
		__isValid = true;
		
	}
	
	
	@:noCompletion @:dox(hide) public function __renderCanvas (renderSession:RenderSession):Void {
		
		#if js
		if (!__isValid) return;
		
		ImageCanvasUtil.sync (__image);
		
		var context = renderSession.context;
		
		if (__worldTransform == null) __worldTransform = new Matrix ();
		
		context.globalAlpha = 1;
		var transform = __worldTransform;
		
		if (renderSession.roundPixels) {
			
			context.setTransform (transform.a, transform.b, transform.c, transform.d, Std.int (transform.tx), Std.int (transform.ty));
			
		} else {
			
			context.setTransform (transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
			
		}
		
		context.drawImage (__image.buffer.src, 0, 0);
		#end
		
	}
	
	
	@:noCompletion @:dox(hide) public function __renderMask (renderSession:RenderSession):Void {
		
		
		
	}
	
	
	@:noCompletion private function __sync ():Void {
		
		#if js
		ImageCanvasUtil.sync (__image);
		#end
		
	}
	
	
	@:noCompletion private static function __ucompare (n1:Int, n2:Int) : Int {
		
		var tmp1 : Int;
		var tmp2 : Int;
		
		tmp1 = (n1 >> 24) & 0x000000FF;
		tmp2 = (n2 >> 24) & 0x000000FF;
		
		if (tmp1 != tmp2) {
			
			return (tmp1 > tmp2 ? 1 : -1);
			
		} else {
			
			tmp1 = (n1 >> 16) & 0x000000FF;
			tmp2 = (n2 >> 16) & 0x000000FF;
			
			if (tmp1 != tmp2) {
				
				return (tmp1 > tmp2 ? 1 : -1);
				
			} else {
				
				tmp1 = (n1 >> 8) & 0x000000FF;
				tmp2 = (n2 >> 8) & 0x000000FF;
				
				if (tmp1 != tmp2) {
					
					return (tmp1 > tmp2 ? 1 : -1);
					
				} else {
					
					tmp1 = n1 & 0x000000FF;
					tmp2 = n2 & 0x000000FF;
					
					if (tmp1 != tmp2) {
						
						return (tmp1 > tmp2 ? 1 : -1);
						
					} else {
						
						return 0;
						
					}
					
				}
				
			}
			
		}
		
	}
	
	
	@:noCompletion @:dox(hide) public function __updateChildren (transformOnly:Bool):Void {
		
		
		
	}
	
	
}


@:noCompletion @:dox(hide) class TextureUvs {
	
	
	public var x0:Float = 0;
	public var x1:Float = 0;
	public var x2:Float = 0;
	public var x3:Float = 0;
	public var y0:Float = 0;
	public var y1:Float = 0;
	public var y2:Float = 0;
	public var y3:Float = 0;
	
	
	public function new () {
		
	}
	
	
}


#else
typedef BitmapData = openfl._v2.display.BitmapData;
#end
#else
typedef BitmapData = flash.display.BitmapData;
#end
