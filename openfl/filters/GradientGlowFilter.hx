package openfl.filters; #if !openfl_legacy

import lime.math.color.ARGB;

import openfl.display.BitmapData;
import openfl.display.Shader;
import openfl.geom.Rectangle;
import openfl.gl.GL;

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
	public var type:BitmapFilterType;
	public var knockout (default, set):Bool;
	public var quality (default, set):Int;
	public var strength:Float;
	
	private var __gradientGlowShader:GradientGlowShader;
	private var __gradientGlowShader2:GradientGlowShaderLookupPass;
	private var __gradientGlowShaderInner:GradientGlowShaderInner;
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
		
		__gradientGlowShader = new GradientGlowShader ();
		__gradientGlowShader.smooth = true;
		
		__gradientGlowShader2 = new GradientGlowShaderLookupPass ();
		__gradientGlowShader2.smooth = true;

		__gradientGlowShaderInner = new GradientGlowShaderInner ();
		__gradientGlowShaderInner.smooth = true;
	}
	
	
	public override function clone ():BitmapFilter {
		
		return new GradientGlowFilter (distance, angle, colors, alphas, ratios, blurX, blurY, strength, quality, type, knockout);
		
	}
	
	private function updateLookupTexture():Void {
		
		inline function alpha(color:UInt):Float {
			return (color >>> 24) / 255;
		}
		
		inline function rgb(color:UInt):UInt {
			return (color & 0xffffff);
		}
		
		inline function ri(color:UInt):UInt {
			return ((rgb(color) >> 16) & 0xff);
		}
		
		inline function gi(color:UInt):UInt {
			return ((rgb(color) >> 8) & 0xff);
		}
		
		inline function bi(color:UInt):UInt {
			return (rgb(color) & 0xff);
		}
		
		inline function r(color:UInt):Float {
			return ((rgb(color) >> 16) & 0xff) / 255;
		}
		
		inline function g(color:UInt):Float {
			return ((rgb(color) >> 8) & 0xff) / 255;
		}
		
		inline function b(color:UInt):Float {
			return (rgb(color) & 0xff) / 255;
		}
		
		inline function interpolate(color1:UInt, color2:UInt, ratio:Float):UInt {
			var r1:Float = r(color1);
			var g1:Float = g(color1);
			var b1:Float = b(color1);
			var alpha1:Float = alpha(color1);
			var ri:Int = Std.int((r1 + (r(color2) - r1) * ratio) * 255);
			var gi:Int = Std.int((g1 + (g(color2) - g1) * ratio) * 255);
			var bi:Int = Std.int((b1 + (b(color2) - b1) * ratio) * 255);
			var alphai:Int = Std.int((alpha1 + (alpha(color2) - alpha1) * ratio) * 255);
			return bi | (gi << 8) | (ri << 16) | (alphai << 24);
		}
		
		__lookupTexture = new BitmapData (256, 1);
		
		var upperBoundIndex = 0;
		var lowerBound = 0.0;
		var upperBound = Math.max(Math.min(ratios[0] / 0xFF, 1.0),0.0);
		var lowerBoundColor = ARGB.create(Math.round(alphas[0] * 255), ri(colors[0]), gi(colors[0]), bi(colors[0]));
		var upperBoundColor = ARGB.create(Math.round(alphas[0] * 255), ri(colors[0]), gi(colors[0]), bi(colors[0]));
		
		for( x in 0...__lookupTexture.width ) {
			var ratio = (x + 0.5) / __lookupTexture.width;
			
			if (ratio > upperBound) {
				
				while (ratio > upperBound ) {
					if ( upperBoundIndex < ratios.length - 1) {
						++upperBoundIndex;
						upperBound = Math.max(Math.min(ratios[upperBoundIndex] / 0xFF, 1.0),0.0);
					} else {
						upperBound = 1.0;
					}
				}
				
				var lowerBoundIndex = upperBoundIndex == 0 ? 0 : upperBoundIndex - 1;
				upperBoundColor.set(Math.round(alphas[upperBoundIndex] * 255), ri(colors[upperBoundIndex]), gi(colors[upperBoundIndex]), bi(colors[upperBoundIndex]));
				lowerBoundColor.set(Math.round(alphas[lowerBoundIndex] * 255), ri(colors[lowerBoundIndex]), gi(colors[lowerBoundIndex]), bi(colors[lowerBoundIndex]));
				lowerBound = Math.max(Math.min(ratios[lowerBoundIndex] / 0xFF, 1.0),0.0);
				
			}
			
			var lerpFactor = (ratio - lowerBound) / (upperBound - lowerBound);
			var color:ARGB = interpolate(lowerBoundColor, upperBoundColor, lerpFactor);
			
			for( y in 0...__lookupTexture.height ) {
				
				__lookupTexture.setPixel32(x, y, color);
				
			}
			
		}
		
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
			
			switch (type) {
				
				case BitmapFilterType.FULL:
					throw ":TODO: render full effect on top of object";
					return null;
				case BitmapFilterType.INNER:
					// :HACK: temporary hack until we switch to render commands for filters (blend mode manager must be reset in BitmapFilter)
					var renderSession = @:privateAccess openfl.Lib.current.stage.__renderer.renderSession;
					var gl = renderSession.gl;
					gl.blendEquation (GL.FUNC_ADD);
					gl.blendFunc (GL.DST_COLOR, GL.ZERO);
					__gradientGlowShaderInner.blendMode = renderSession.blendModeManager.currentBlendMode;
					return __gradientGlowShaderInner;
				case BitmapFilterType.OUTER:
					return null;
				default:
					return null;
				
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

private class GradientGlowShaderInner extends Shader {
	
	
	@vertex var vertex = [
		'void main(void)',
		'{',
		
			'${Shader.vTexCoord} = ${Shader.aTexCoord};',
			'${Shader.vColor} = ${Shader.aColor};',
			'gl_Position = vec4((${Shader.uProjectionMatrix} * vec3(${Shader.aPosition}, 1.0)).xy, 0.0, 1.0);',
		'}',
	];
	
	
	@fragment var fragment = [
		'void main(void)',
		'{',
			'float a = texture2D(${Shader.uSampler}, ${Shader.vTexCoord}).a;',
			'gl_FragColor = vec4(a, a, a, a);',
		'}',
	];
	
	
	public function new () {
		
		super ();
		
	}
	
	
}

#else
typedef GradientGlowFilter = openfl._legacy.filters.GradientGlowFilter;
#end
