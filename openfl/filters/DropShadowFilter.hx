package openfl.filters; #if (!display && !flash) #if !openfl_legacy


import openfl.display.Shader;
import openfl.geom.Rectangle;


@:final class DropShadowFilter extends BitmapFilter {
	
	
	public var alpha:Float;
	public var angle:Float;
	public var blurX:Float;
	public var blurY:Float;
	public var color:Int;
	public var distance:Float;
	public var hideObject (default, set):Bool;
	public var inner:Bool;
	public var knockout (default, set):Bool;
	public var quality (default, set):Int;
	public var strength:Float;
	
	//private var __dropShadowShader:DropShadowShader;
	
	
	public function new (distance:Float = 4, angle:Float = 45, color:Int = 0, alpha:Float = 1, blurX:Float = 4, blurY:Float = 4, strength:Float = 1, quality:Int = 1, inner:Bool = false, knockout:Bool = false, hideObject:Bool = false) {
		
		super ();
		
		this.distance = distance;
		this.angle = angle;
		this.color = color;
		this.alpha = alpha;
		this.blurX = blurX;
		this.blurY = blurY;
		this.strength = strength;
		this.quality = quality;
		this.inner = inner;
		this.knockout = knockout;
		this.hideObject = hideObject;
		
		//__dropShadowShader = new DropShadowShader ();
		//__dropShadowShader.smooth = true;
		
	}
	
	
	public override function clone ():BitmapFilter {
		
		return new DropShadowFilter (distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout, hideObject);
		
	}
	
	
	//private override function __growBounds (rect:Rectangle):Void {
		//
		//var sX = distance * Math.cos (angle * Math.PI / 180);
		//var sY = distance * Math.sin (angle * Math.PI / 180);
		//rect.x += -(Math.abs (sX) + (blurX * 0.5)) * quality;
		//rect.y += -(Math.abs (sY) + (blurY * 0.5)) * quality;
		//rect.width += (sX + (blurX * 0.5)) * quality;
		//rect.height += (sY + (blurY * 0.5))  * quality;
		//
	//}
	//
	//
	//private override function __preparePass (pass:Int):Shader {
		//
		//if (pass == __passes - 1) {
			//
			//return null;
			//
		//} else {
			//
			//var even = pass % 2 == 0;
			//var scale = Math.pow (0.5, pass >> 1);
			//__dropShadowShader.uRadius[0] = even ? scale * blurX : 0;
			//__dropShadowShader.uRadius[1] = even ? 0 : scale * blurY;
			//__dropShadowShader.uShift[0] = pass == 0 ? distance * Math.cos (angle * Math.PI / 180) : 0;
			//__dropShadowShader.uShift[1] = pass == 0 ? distance * Math.sin (angle * Math.PI / 180) : 0;
			//__dropShadowShader.uColor[0] = ((color >> 16) & 0xFF) / 255;
			//__dropShadowShader.uColor[1] = ((color >> 8) & 0xFF) / 255;
			//__dropShadowShader.uColor[2] = (color & 0xFF) / 255;
			//__dropShadowShader.uColor[3] = alpha;
			//
			//return __dropShadowShader;
			//
		//}
		//
	//}
	//
	//
	//private override function __useLastFilter (pass:Int):Bool {
		//
		//return pass == __passes - 1;
		//
	//}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private inline function set_knockout (value:Bool):Bool {
		
		__saveLastFilter = !value;
		return knockout = value;
		
	}
	
	
	private inline function set_hideObject (value:Bool):Bool {
		
		__saveLastFilter = !value;
		return hideObject = value;
		
	}
	
	
	private function set_quality (value:Int):Int {
		
		__passes = value * 2 + 1;
		return quality = value;
		
	}
	
	
}


//private class DropShadowShader extends Shader {
	//
	//
	//@vertex var vertex = [
		//'uniform vec2 uRadius;',
		//'uniform vec2 uShift;',
		//'varying vec2 vBlurCoords[7];',
		//
		//'void main(void)',
		//'{',
		//
			//'vec2 r = uRadius / ${Shader.uTextureSize};',
			//'vec2 tc = ${Shader.aTexCoord} - (uShift / ${Shader.uTextureSize});',
			//'vBlurCoords[0] = tc - r * 1.2;',
			//'vBlurCoords[1] = tc - r * 0.8;',
			//'vBlurCoords[2] = tc - r * 0.4;',
			//'vBlurCoords[3] = tc;',
			//'vBlurCoords[4] = tc + r * 0.4;',
			//'vBlurCoords[5] = tc + r * 0.8;',
			//'vBlurCoords[6] = tc + r * 1.2;',
			//
			//'${Shader.vTexCoord} = ${Shader.aTexCoord};',
			//'${Shader.vColor} = ${Shader.aColor};',
			//'gl_Position = vec4((${Shader.uProjectionMatrix} * vec3(${Shader.aPosition}, 1.0)).xy, 0.0, 1.0);',
		//'}',
	//];
	//
	//
	//@fragment var fragment = [
		//'uniform vec4 uColor;',
		//
		//'varying vec2 vBlurCoords[7];',
		//
		//'void main(void)',
		//'{',
			//'float a = 0.0;',
			//'a += texture2D(${Shader.uSampler}, vBlurCoords[0]).a * 0.00443;',
			//'a += texture2D(${Shader.uSampler}, vBlurCoords[1]).a * 0.05399;',
			//'a += texture2D(${Shader.uSampler}, vBlurCoords[2]).a * 0.24197;',
			//'a += texture2D(${Shader.uSampler}, vBlurCoords[3]).a * 0.39894;',
			//'a += texture2D(${Shader.uSampler}, vBlurCoords[4]).a * 0.24197;',
			//'a += texture2D(${Shader.uSampler}, vBlurCoords[5]).a * 0.05399;',
			//'a += texture2D(${Shader.uSampler}, vBlurCoords[6]).a * 0.00443;',
			//'a *= uColor.a;',
			//
		//'	gl_FragColor = vec4(uColor.rgb * a, a);',
		//'}',
	//];
	//
	//
	//public function new () {
		//
		//super ();
		//
	//}
	//
	//
//}


#else
typedef DropShadowFilter = openfl._legacy.filters.DropShadowFilter;
#end
#else


/**
 * The DropShadowFilter class lets you add a drop shadow to display objects.
 * The shadow algorithm is based on the same box filter that the blur filter
 * uses. You have several options for the style of the drop shadow, including
 * inner or outer shadow and knockout mode. You can apply the filter to any
 * display object(that is, objects that inherit from the DisplayObject
 * class), such as MovieClip, SimpleButton, TextField, and Video objects, as
 * well as to BitmapData objects.
 *
 * <p>The use of filters depends on the object to which you apply the
 * filter:</p>
 *
 * <ul>
 *   <li>To apply filters to display objects use the <code>filters</code>
 * property(inherited from DisplayObject). Setting the <code>filters</code>
 * property of an object does not modify the object, and you can remove the
 * filter by clearing the <code>filters</code> property. </li>
 *   <li>To apply filters to BitmapData objects, use the
 * <code>BitmapData.applyFilter()</code> method. Calling
 * <code>applyFilter()</code> on a BitmapData object takes the source
 * BitmapData object and the filter object and generates a filtered image as a
 * result.</li>
 * </ul>
 *
 * <p>If you apply a filter to a display object, the value of the
 * <code>cacheAsBitmap</code> property of the display object is set to
 * <code>true</code>. If you clear all filters, the original value of
 * <code>cacheAsBitmap</code> is restored.</p>
 *
 * <p>This filter supports Stage scaling. However, it does not support general
 * scaling, rotation, and skewing. If the object itself is scaled(if
 * <code>scaleX</code> and <code>scaleY</code> are set to a value other than
 * 1.0), the filter is not scaled. It is scaled only when the user zooms in on
 * the Stage.</p>
 *
 * <p>A filter is not applied if the resulting image exceeds the maximum
 * dimensions. In AIR 1.5 and Flash Player 10, the maximum is 8,191 pixels in
 * width or height, and the total number of pixels cannot exceed 16,777,215
 * pixels.(So, if an image is 8,191 pixels wide, it can only be 2,048 pixels
 * high.) In Flash Player 9 and earlier and AIR 1.1 and earlier, the
 * limitation is 2,880 pixels in height and 2,880 pixels in width. If, for
 * example, you zoom in on a large movie clip with a filter applied, the
 * filter is turned off if the resulting image exceeds the maximum
 * dimensions.</p>
 */

#if flash
@:native("flash.filters.DropShadowFilter")
#end

@:final extern class DropShadowFilter extends BitmapFilter {
	
	
	/**
	 * The alpha transparency value for the shadow color. Valid values are 0.0 to
	 * 1.0. For example, .25 sets a transparency value of 25%. The default value
	 * is 1.0.
	 */
	public var alpha:Float;
	
	/**
	 * The angle of the shadow. Valid values are 0 to 360 degrees(floating
	 * point). The default value is 45.
	 */
	public var angle:Float;
	
	/**
	 * The amount of horizontal blur. Valid values are 0 to 255.0(floating
	 * point). The default value is 4.0.
	 */
	public var blurX:Float;
	
	/**
	 * The amount of vertical blur. Valid values are 0 to 255.0(floating point).
	 * The default value is 4.0.
	 */
	public var blurY:Float;
	
	/**
	 * The color of the shadow. Valid values are in hexadecimal format
	 * <i>0xRRGGBB</i>. The default value is 0x000000.
	 */
	public var color:Int;
	
	/**
	 * The offset distance for the shadow, in pixels. The default value is 4.0
	 * (floating point).
	 */
	public var distance:Float;
	
	/**
	 * Indicates whether or not the object is hidden. The value <code>true</code>
	 * indicates that the object itself is not drawn; only the shadow is visible.
	 * The default is <code>false</code>(the object is shown).
	 */
	#if (flash && !display)
	public var hideObject:Bool;
	#else
	public var hideObject (default, set):Bool;
	#end
	
	/**
	 * Indicates whether or not the shadow is an inner shadow. The value
	 * <code>true</code> indicates an inner shadow. The default is
	 * <code>false</code>, an outer shadow(a shadow around the outer edges of
	 * the object).
	 */
	public var inner:Bool;
	
	/**
	 * Applies a knockout effect(<code>true</code>), which effectively makes the
	 * object's fill transparent and reveals the background color of the
	 * document. The default is <code>false</code>(no knockout).
	 */
	#if (flash && !display)
	public var knockout:Bool;
	#else
	public var knockout (default, set):Bool;
	#end
	
	/**
	 * The number of times to apply the filter. The default value is
	 * <code>BitmapFilterQuality.LOW</code>, which is equivalent to applying the
	 * filter once. The value <code>BitmapFilterQuality.MEDIUM</code> applies the
	 * filter twice; the value <code>BitmapFilterQuality.HIGH</code> applies it
	 * three times. Filters with lower values are rendered more quickly.
	 *
	 * <p>For most applications, a quality value of low, medium, or high is
	 * sufficient. Although you can use additional numeric values up to 15 to
	 * achieve different effects, higher values are rendered more slowly. Instead
	 * of increasing the value of <code>quality</code>, you can often get a
	 * similar effect, and with faster rendering, by simply increasing the values
	 * of the <code>blurX</code> and <code>blurY</code> properties.</p>
	 */
	#if (flash && !display)
	public var quality:Int;
	#else
	public var quality (default, set):Int;
	#end
	
	/**
	 * The strength of the imprint or spread. The higher the value, the more
	 * color is imprinted and the stronger the contrast between the shadow and
	 * the background. Valid values are from 0 to 255.0. The default is 1.0.
	 */
	public var strength:Float;
	
	
	/**
	 * Creates a new DropShadowFilter instance with the specified parameters.
	 * 
	 * @param distance   Offset distance for the shadow, in pixels.
	 * @param angle      Angle of the shadow, 0 to 360 degrees(floating point).
	 * @param color      Color of the shadow, in hexadecimal format
	 *                   <i>0xRRGGBB</i>. The default value is 0x000000.
	 * @param alpha      Alpha transparency value for the shadow color. Valid
	 *                   values are 0.0 to 1.0. For example, .25 sets a
	 *                   transparency value of 25%.
	 * @param blurX      Amount of horizontal blur. Valid values are 0 to 255.0
	 *                  (floating point).
	 * @param blurY      Amount of vertical blur. Valid values are 0 to 255.0
	 *                  (floating point).
	 * @param strength   The strength of the imprint or spread. The higher the
	 *                   value, the more color is imprinted and the stronger the
	 *                   contrast between the shadow and the background. Valid
	 *                   values are 0 to 255.0.
	 * @param quality    The number of times to apply the filter. Use the
	 *                   BitmapFilterQuality constants:
	 *                   <ul>
	 *                     <li><code>BitmapFilterQuality.LOW</code></li>
	 *                     <li><code>BitmapFilterQuality.MEDIUM</code></li>
	 *                     <li><code>BitmapFilterQuality.HIGH</code></li>
	 *                   </ul>
	 *
	 *                   <p>For more information about these values, see the
	 *                   <code>quality</code> property description.</p>
	 * @param inner      Indicates whether or not the shadow is an inner shadow.
	 *                   A value of <code>true</code> specifies an inner shadow.
	 *                   A value of <code>false</code> specifies an outer shadow
	 *                  (a shadow around the outer edges of the object).
	 * @param knockout   Applies a knockout effect(<code>true</code>), which
	 *                   effectively makes the object's fill transparent and
	 *                   reveals the background color of the document.
	 * @param hideObject Indicates whether or not the object is hidden. A value
	 *                   of <code>true</code> indicates that the object itself is
	 *                   not drawn; only the shadow is visible.
	 */
	public function new (distance:Float = 4, angle:Float = 45, color:Int = 0, alpha:Float = 1, blurX:Float = 4, blurY:Float = 4, strength:Float = 1, quality:Int = 1, inner:Bool = false, knockout:Bool = false, hideObject:Bool = false);
	
	
}


#end