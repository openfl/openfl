package openfl.filters; #if !openfl_legacy


import openfl.display.BitmapData;
import openfl.display.Shader;
import openfl.geom.Rectangle;

#if (js && html5)
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.Browser;
#end

@:final class GradientGlowFilter extends BitmapFilter {
	
	public static inline var MAXIMUM_FETCH_COUNT = 20;
	
	public var alpha:Float;
	public var angle:Float;
	public var blurX:Float;
	public var blurY:Float;
	public var colors:Array<Int>; // :TODO: use setter to invalidate and regenerate lookup texture
	public var alphas:Array<Float>; // :TODO: use setter to invalidate and regenerate lookup texture
	public var ratios:Array<Float>; // :TODO: use setter to invalidate and regenerate lookup texture
	public var color:Int;
	public var distance:Float;
	public var hideObject (default, set):Bool;
	public var type:BitmapFilterType;
	public var knockout (default, set):Bool;
	public var quality (default, set):Int;
	public var strength:Float;
	
	private var __gradientGlowShader:GradientGlowShader;
	private var __gradientGlowShader2:GradientGlowShaderLookupPass;
	private var __lookupTextureIsDirty:Bool = true;
	private var __lookupTexture:BitmapData;
	
	public function new (distance:Float = 4, angle:Float = 45, colors:Array<Int>, alphas:Array<Float>, ratios:Array<Float>, blurX:Float = 4, blurY:Float = 4, strength:Float = 1, quality:Int = 1, type:BitmapFilterType = BitmapFilterType.INNER, knockout:Bool = false) {
		
		super ();
		
		this.distance = distance;
		this.angle = angle;
		this.colors = colors;
		this.alphas = alphas;
		this.ratios = ratios;
		this.blurX = blurX;
		this.blurY = blurY;
		this.strength = strength;
		this.quality = quality;
		this.type = type;
		this.knockout = knockout;
		this.hideObject = hideObject;
		
		__gradientGlowShader = new GradientGlowShader ();
		__gradientGlowShader.smooth = true;
		
		__gradientGlowShader2 = new GradientGlowShaderLookupPass ();
		__gradientGlowShader2.smooth = true;
	}
	
	
	public override function clone ():BitmapFilter {
		
		return new GradientGlowFilter (distance, angle, colors, alphas, ratios, blurX, blurY, strength, quality, type, knockout);
		
	}
	
	private function updateLookupTexture():Void {
		#if (js && html5)
			var canvas:CanvasElement = cast Browser.document.createElement ("canvas");
			var context:CanvasRenderingContext2D = canvas.getContext ("2d");
			canvas.width = 256;
			canvas.height = 8;

			var gradientFill = context.createLinearGradient (0, 0, canvas.width, 0);
			for (i in 0...colors.length) {
				
				var rgb = colors[i];
				var alpha = alphas[i];
				var r = (rgb & 0xFF0000) >>> 16;
				var g = (rgb & 0x00FF00) >>> 8;
				var b = (rgb & 0x0000FF);
				
				r = Math.round(r * alpha);
				g = Math.round(g * alpha);
				b = Math.round(b * alpha);
				
				var ratio = ratios[i] / 0xFF;
				if (ratio < 0) ratio = 0;
				if (ratio > 1) ratio = 1;
				
				gradientFill.addColorStop (ratio, "rgba(" + r + ", " + g + ", " + b + ", " + alpha + ")");
				
			}
			
			context.rect (0, 0, canvas.width, canvas.height);
			context.fillStyle = gradientFill;
			context.fill ();
			
			__lookupTexture = BitmapData.fromCanvas (canvas);
		#end
	}

	
	private override function __growBounds (rect:Rectangle):Void {
		
		var halfBlurX = Math.ceil( blurX * 0.5 * quality );
		var halfBlurY = Math.ceil( blurY * 0.5 * quality );
		var sX = distance * Math.cos (angle * Math.PI / 180);
		var sY = distance * Math.sin (angle * Math.PI / 180);
		rect.x -= Math.abs (sX) + halfBlurX;
		rect.y -= Math.abs (sY) + halfBlurY;
		rect.width += 2.0 * (Math.abs (sX) + halfBlurX);
		rect.height += 2.0 * (Math.abs (sY) + halfBlurY);
		
	}
	
	
	private override function __preparePass (pass:Int):Shader {
		
		if (pass == __passes - 1) {
			
			if (type == BitmapFilterType.OUTER) {
				
				return null;
				
			} else {
				
				throw ':TODO: support ${type} filter type';
				
			}
			
		} else if (pass == __passes - 2) {
			
			if (__lookupTextureIsDirty) {
				
				updateLookupTexture();
				__lookupTextureIsDirty = false;
				
			}
			
			var horizontal_pass = pass % 2 == 0;
			var blur = horizontal_pass ? blurX : blurY;
			var fetch_count = Math.min(Math.ceil(blur), MAXIMUM_FETCH_COUNT);
			var pass_width = horizontal_pass ? blur - 1 : 0;
			var pass_height = horizontal_pass ? 0 : blur - 1;
			__gradientGlowShader2.uFetchCountInverseFetchCount[0] = fetch_count;
			__gradientGlowShader2.uFetchCountInverseFetchCount[1] = 1.0 / fetch_count;
			__gradientGlowShader2.uTexCoordDelta[0] = fetch_count > 1 ? pass_width / (fetch_count - 1) : 0;
			__gradientGlowShader2.uTexCoordDelta[1] = fetch_count > 1 ? pass_height / (fetch_count - 1) : 0;
			__gradientGlowShader2.uRadius[0] = 0.5 * pass_width;
			__gradientGlowShader2.uRadius[1] = 0.5 * pass_height;
			__gradientGlowShader2.uStrength = strength;
			__gradientGlowShader2.uColorLookupSampler = __lookupTexture;
			
			return __gradientGlowShader2;
			
		} else {
			
			// :TODO: reduce the number of tex fetches  using texture HW filtering
			
			var horizontal_pass = pass % 2 == 0;
			var blur = horizontal_pass ? blurX : blurY;
			var fetch_count = Math.min(Math.ceil(blur), MAXIMUM_FETCH_COUNT);
			var pass_width = horizontal_pass ? blur - 1 : 0;
			var pass_height = horizontal_pass ? 0 : blur - 1;
			__gradientGlowShader.uFetchCountInverseFetchCount[0] = fetch_count;
			__gradientGlowShader.uFetchCountInverseFetchCount[1] = 1.0 / fetch_count;
			__gradientGlowShader.uShift[0] = pass == 0 ? distance * Math.cos (angle * Math.PI / 180) : 0;
			__gradientGlowShader.uShift[1] = pass == 0 ? distance * Math.sin (angle * Math.PI / 180) : 0;
			__gradientGlowShader.uTexCoordDelta[0] = fetch_count > 1 ? pass_width / (fetch_count - 1) : 0;
			__gradientGlowShader.uTexCoordDelta[1] = fetch_count > 1 ? pass_height / (fetch_count - 1) : 0;
			__gradientGlowShader.uRadius[0] = 0.5 * pass_width;
			__gradientGlowShader.uRadius[1] = 0.5 * pass_height;
			
			return __gradientGlowShader;
			
		}
		
	}
	
	
	private override function __useLastFilter (pass:Int):Bool {
		
		return pass == __passes - 1;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function set_knockout (value:Bool):Bool {
		
		__saveLastFilter = !value;
		return knockout = value;
		
	}
	
	
	private function set_hideObject (value:Bool):Bool {
		
		__saveLastFilter = !value;
		return hideObject = value;
		
	}
	
	
	private function set_quality (value:Int):Int {
		
		__passes = value * 2 + 1;
		return quality = value;
		
	}
	
	
}


private class GradientGlowShader extends Shader {
	
	
	@vertex var vertex = [
		'uniform vec2 uRadius;',
		'uniform vec2 uShift;',
		
		'void main(void)',
		'{',
		
			'vec2 r = uRadius / ${Shader.uTextureSize};',
			'vec2 tc = ${Shader.aTexCoord} - (uShift / ${Shader.uTextureSize});',
			'${Shader.vTexCoord} = tc - r;',
			'${Shader.vColor} = ${Shader.aColor};',
			'gl_Position = vec4((${Shader.uProjectionMatrix} * vec3(${Shader.aPosition}, 1.0)).xy, 0.0, 1.0);',
		'}',
	];
	
	
	@fragment var fragment = [
		'uniform vec2 uTexCoordDelta;',
		'uniform vec2 uFetchCountInverseFetchCount;',
		
		'void main(void)',
		'{',
			'vec2 texcoord_delta = uTexCoordDelta / ${Shader.uTextureSize};', // :TODO: move to VS
			'int fetch_count = int(uFetchCountInverseFetchCount.x);',
			'float a = 0.0;',
			'for(int i = 0; i < ${GlowFilter.MAXIMUM_FETCH_COUNT}; ++i){',
			'    if (i >= fetch_count) break;',
			'    a += texture2D(${Shader.uSampler}, ${Shader.vTexCoord} + texcoord_delta * float(i)).a;',
			'}',
			'a = clamp(a * uFetchCountInverseFetchCount.y, 0.0, 1.0);',
			
		'	gl_FragColor = vec4(a, a, a, a);',
		'}',
	];
	
	
	public function new () {
		
		super ();
		
	}
	
	
}

// :TODO: factorize common code (need support from openfl._internal.macros.MacroShader)

private class GradientGlowShaderLookupPass extends Shader {
	
	
	@vertex var vertex = [
		'uniform vec2 uRadius;',
		
		'void main(void)',
		'{',
		
			'vec2 r = uRadius / ${Shader.uTextureSize};',
			'vec2 tc = ${Shader.aTexCoord};',
			'${Shader.vTexCoord} = tc - r;',
			'${Shader.vColor} = ${Shader.aColor};',
			'gl_Position = vec4((${Shader.uProjectionMatrix} * vec3(${Shader.aPosition}, 1.0)).xy, 0.0, 1.0);',
		'}',
	];
	
	
	@fragment var fragment = [
		'uniform float uStrength;',
		'uniform vec2 uTexCoordDelta;',
		'uniform vec2 uFetchCountInverseFetchCount;',
		'uniform sampler2D uColorLookupSampler;',
		
		'void main(void)',
		'{',
			'vec2 texcoord_delta = uTexCoordDelta / ${Shader.uTextureSize};', // :TODO: move to VS
			'int fetch_count = int(uFetchCountInverseFetchCount.x);',
			'float a = 0.0;',
			'for(int i = 0; i < ${GlowFilter.MAXIMUM_FETCH_COUNT}; ++i){',
			'    if (i >= fetch_count) break;',
			'    a += texture2D(${Shader.uSampler}, ${Shader.vTexCoord} + texcoord_delta * float(i)).a;',
			'}',
			'a = clamp(a * uFetchCountInverseFetchCount.y * uStrength, 0.0, 1.0);',
			
		'	gl_FragColor = texture2D(uColorLookupSampler, vec2(a, 0.5));',
		'}',
	];
	
	
	public function new () {
		
		super ();
		
	}
	
	
}


#else
typedef GradientGlowFilter = openfl._legacy.filters.GradientGlowFilter;
#end
