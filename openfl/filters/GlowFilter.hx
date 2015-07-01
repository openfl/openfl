package openfl.filters; #if !flash #if !openfl_legacy
import openfl.display.Shader;
import openfl.geom.Rectangle;


/**
 * The GlowFilter class lets you apply a glow effect to display objects. You
 * have several options for the style of the glow, including inner or outer
 * glow and knockout mode. The glow filter is similar to the drop shadow
 * filter with the <code>distance</code> and <code>angle</code> properties of
 * the drop shadow filter set to 0. You can apply the filter to any display
 * object(that is, objects that inherit from the DisplayObject class), such
 * as MovieClip, SimpleButton, TextField, and Video objects, as well as to
 * BitmapData objects.
 *
 * <p>The use of filters depends on the object to which you apply the
 * filter:</p>
 *
 * <ul>
 *   <li>To apply filters to display objects, use the <code>filters</code>
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
 * <p>If you apply a filter to a display object, the
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
 * limitation is 2,880 pixels in height and 2,880 pixels in width. For
 * example, if you zoom in on a large movie clip with a filter applied, the
 * filter is turned off if the resulting image exceeds the maximum
 * dimensions.</p>
 */
class GlowFilter extends BitmapFilter {
	
	
	/**
	 * The alpha transparency value for the color. Valid values are 0 to 1. For
	 * example, .25 sets a transparency value of 25%. The default value is 1.
	 */
	public var alpha:Float;
	
	/**
	 * The amount of horizontal blur. Valid values are 0 to 255(floating point).
	 * The default value is 6. Values that are a power of 2(such as 2, 4, 8, 16,
	 * and 32) are optimized to render more quickly than other values.
	 */
	public var blurX:Float;
	
	/**
	 * The amount of vertical blur. Valid values are 0 to 255(floating point).
	 * The default value is 6. Values that are a power of 2(such as 2, 4, 8, 16,
	 * and 32) are optimized to render more quickly than other values.
	 */
	public var blurY:Float;
	
	/**
	 * The color of the glow. Valid values are in the hexadecimal format
	 * 0x<i>RRGGBB</i>. The default value is 0xFF0000.
	 */
	public var color:Int;
	
	/**
	 * Specifies whether the glow is an inner glow. The value <code>true</code>
	 * indicates an inner glow. The default is <code>false</code>, an outer glow
	 * (a glow around the outer edges of the object).
	 */
	public var inner:Bool;
	
	/**
	 * Specifies whether the object has a knockout effect. A value of
	 * <code>true</code> makes the object's fill transparent and reveals the
	 * background color of the document. The default value is <code>false</code>
	 * (no knockout effect).
	 */
	public var knockout(default, set):Bool;
	
	/**
	 * The number of times to apply the filter. The default value is
	 * <code>BitmapFilterQuality.LOW</code>, which is equivalent to applying the
	 * filter once. The value <code>BitmapFilterQuality.MEDIUM</code> applies the
	 * filter twice; the value <code>BitmapFilterQuality.HIGH</code> applies it
	 * three times. Filters with lower values are rendered more quickly.
	 *
	 * <p>For most applications, a <code>quality</code> value of low, medium, or
	 * high is sufficient. Although you can use additional numeric values up to
	 * 15 to achieve different effects, higher values are rendered more slowly.
	 * Instead of increasing the value of <code>quality</code>, you can often get
	 * a similar effect, and with faster rendering, by simply increasing the
	 * values of the <code>blurX</code> and <code>blurY</code> properties.</p>
	 */
	public var quality(default, set):Int;
	
	/**
	 * The strength of the imprint or spread. The higher the value, the more
	 * color is imprinted and the stronger the contrast between the glow and the
	 * background. Valid values are 0 to 255. The default is 2.
	 */
	public var strength:Float;
	
	
	private var __glowShader:GlowShader;
	
	/**
	 * Initializes a new GlowFilter instance with the specified parameters.
	 * 
	 * @param color    The color of the glow, in the hexadecimal format
	 *                 0x<i>RRGGBB</i>. The default value is 0xFF0000.
	 * @param alpha    The alpha transparency value for the color. Valid values
	 *                 are 0 to 1. For example, .25 sets a transparency value of
	 *                 25%.
	 * @param blurX    The amount of horizontal blur. Valid values are 0 to 255
	 *                (floating point). Values that are a power of 2(such as 2,
	 *                 4, 8, 16 and 32) are optimized to render more quickly than
	 *                 other values.
	 * @param blurY    The amount of vertical blur. Valid values are 0 to 255
	 *                (floating point). Values that are a power of 2(such as 2,
	 *                 4, 8, 16 and 32) are optimized to render more quickly than
	 *                 other values.
	 * @param strength The strength of the imprint or spread. The higher the
	 *                 value, the more color is imprinted and the stronger the
	 *                 contrast between the glow and the background. Valid values
	 *                 are 0 to 255.
	 * @param quality  The number of times to apply the filter. Use the
	 *                 BitmapFilterQuality constants:
	 *                 <ul>
	 *                   <li><code>BitmapFilterQuality.LOW</code></li>
	 *                   <li><code>BitmapFilterQuality.MEDIUM</code></li>
	 *                   <li><code>BitmapFilterQuality.HIGH</code></li>
	 *                 </ul>
	 *
	 *                 <p>For more information, see the description of the
	 *                 <code>quality</code> property.</p>
	 * @param inner    Specifies whether the glow is an inner glow. The value
	 *                 <code> true</code> specifies an inner glow. The value
	 *                 <code>false</code> specifies an outer glow(a glow around
	 *                 the outer edges of the object).
	 * @param knockout Specifies whether the object has a knockout effect. The
	 *                 value <code>true</code> makes the object's fill
	 *                 transparent and reveals the background color of the
	 *                 document.
	 */
	public function new (color:Int = 0xFF0000, alpha:Float = 1, blurX:Float = 6, blurY:Float = 6, strength:Float = 2, quality:Int = 1, inner:Bool = false, knockout:Bool = false) {
		
		super ();
		
		this.color = color;
		this.alpha = alpha;
		this.blurX = blurX;
		this.blurY = blurY;
		this.strength = strength;
		this.quality = quality;
		this.inner = inner;
		this.knockout = knockout;
		
		__glowShader = new GlowShader();
		__glowShader.smooth = true;
		
	}
	
	
	public override function clone ():BitmapFilter {
		
		return new GlowFilter (color, alpha, blurX, blurY, strength, quality, inner, knockout);
		
	}
	
	override function __growBounds(rect:Rectangle) {
		rect.x += -blurX * 0.5 * quality;
		rect.y += -blurY * 0.5 * quality;
		rect.width += blurX * 0.5 * quality;
		rect.height += blurY * 0.5 * quality;
	}
	
	override function __useLastFilter(pass:Int):Bool {
		return pass == __passes - 1;
	}
	
	override function __preparePass(pass:Int):Shader {
		
		if (pass == __passes - 1) {
			return null;
		} else {
			var even = pass % 2 == 0;
			var scale = Math.pow(0.5, pass >> 1);
			__glowShader.uRadius[0] = even ? scale * blurX : 0;
			__glowShader.uRadius[1] = even ? 0 : scale * blurY;
			__glowShader.uColor[0] = ((color >> 16) & 0xFF) / 255;
			__glowShader.uColor[1] = ((color >> 8) & 0xFF) / 255;
			__glowShader.uColor[2] = (color & 0xFF) / 255;
			__glowShader.uColor[3] = alpha;
			
			return __glowShader;
		}
	}
	
	inline function set_knockout(v) {
		__saveLastFilter = !v;
		return knockout = v;
	}
	
	function set_quality(v) {
		
		__passes = v * 2 + 1;
		
		return quality = v;
	}
	
	
}

private class GlowShader extends Shader {
	
	@vertex var vertex = [
		'uniform vec2 uRadius;',
		'varying vec2 vBlurCoords[7];',
		
		'void main(void)',
		'{',
		
			'vec2 r = uRadius / ${Shader.uTextureSize};',
			'vBlurCoords[0] = ${Shader.aTexCoord} - r * 1.2;',
			'vBlurCoords[1] = ${Shader.aTexCoord} - r * 0.8;',
			'vBlurCoords[2] = ${Shader.aTexCoord} - r * 0.4;',
			'vBlurCoords[3] = ${Shader.aTexCoord};',
			'vBlurCoords[4] = ${Shader.aTexCoord} + r * 0.4;',
			'vBlurCoords[5] = ${Shader.aTexCoord} + r * 0.8;',
			'vBlurCoords[6] = ${Shader.aTexCoord} + r * 1.2;',
			
			'${Shader.vTexCoord} = ${Shader.aTexCoord};',
			'${Shader.vColor} = ${Shader.aColor};',
			'gl_Position = vec4((${Shader.uProjectionMatrix} * vec3(${Shader.aPosition}, 1.0)).xy, 0.0, 1.0);',
		'}',
	];
	
	@fragment var fragment = [
		'uniform vec4 uColor;',
		
		'varying vec2 vBlurCoords[7];',
		
		'void main(void)',
		'{',
			'float a = 0.0;',
			'a += texture2D(${Shader.uSampler}, vBlurCoords[0]).a * 0.00443;',
			'a += texture2D(${Shader.uSampler}, vBlurCoords[1]).a * 0.05399;',
			'a += texture2D(${Shader.uSampler}, vBlurCoords[2]).a * 0.24197;',
			'a += texture2D(${Shader.uSampler}, vBlurCoords[3]).a * 0.39894;',
			'a += texture2D(${Shader.uSampler}, vBlurCoords[4]).a * 0.24197;',
			'a += texture2D(${Shader.uSampler}, vBlurCoords[5]).a * 0.05399;',
			'a += texture2D(${Shader.uSampler}, vBlurCoords[6]).a * 0.00443;',
			'a *= uColor.a;',

		'	gl_FragColor = vec4(uColor.rgb * a, a);',
		'}',
	];
	
	public function new() {
		super();
	}
}


#else
typedef GlowFilter = openfl._legacy.filters.GlowFilter;
#end
#else
typedef GlowFilter = flash.filters.GlowFilter;
#end