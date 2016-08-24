package openfl.filters; #if !openfl_legacy


import openfl.display.Shader;
import openfl.geom.Rectangle;


@:final class DropShadowFilter extends BitmapFilter {
	
		public static inline var MAXIMUM_FETCH_COUNT = 20;
	
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
	
	private var __dropShadowShader:DropShadowShader;
	
	
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
		
		__dropShadowShader = new DropShadowShader ();
		__dropShadowShader.smooth = true;
		
	}
	
	
	public override function clone ():BitmapFilter {
		
		return new DropShadowFilter (distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout, hideObject);
		
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
			
			return null;
			
		} else {
			
			// :TODO: reduce the number of tex fetches  using texture HW filtering
			
			var horizontal_pass = pass % 2 == 0;
			var blur = horizontal_pass ? blurX : blurY;
			var fetch_count = Math.min(Math.ceil(blur), MAXIMUM_FETCH_COUNT);
			var pass_width = horizontal_pass ? blur - 1 : 0;
			var pass_height = horizontal_pass ? 0 : blur - 1;
			__dropShadowShader.uFetchCountInverseFetchCount[0] = fetch_count;
			__dropShadowShader.uFetchCountInverseFetchCount[1] = 1.0 / fetch_count;
			__dropShadowShader.uShift[0] = pass == 0 ? distance * Math.cos (angle * Math.PI / 180) : 0;
			__dropShadowShader.uShift[1] = pass == 0 ? distance * Math.sin (angle * Math.PI / 180) : 0;
			__dropShadowShader.uTexCoordDelta[0] = fetch_count > 1 ? pass_width / (fetch_count - 1) : 0;
			__dropShadowShader.uTexCoordDelta[1] = fetch_count > 1 ? pass_height / (fetch_count - 1) : 0;
			__dropShadowShader.uRadius[0] = 0.5 * pass_width;
			__dropShadowShader.uRadius[1] = 0.5 * pass_height;
			__dropShadowShader.uColor[0] = ((color >> 16) & 0xFF) / 255;
			__dropShadowShader.uColor[1] = ((color >> 8) & 0xFF) / 255;
			__dropShadowShader.uColor[2] = (color & 0xFF) / 255;
			__dropShadowShader.uColor[3] = alpha;
			__dropShadowShader.uStrength = (pass == __passes - 2) ? strength : 1.0;
			
			return __dropShadowShader;
			
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


private class DropShadowShader extends Shader {
	
	
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
		'uniform vec4 uColor;',
		'uniform float uStrength;',
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
			'a = clamp(a * uFetchCountInverseFetchCount.y * uStrength, 0.0, 1.0);',
			'a *= uColor.a;',
			
		'	gl_FragColor = vec4(uColor.rgb * a, a);',
		'}',
	];
	
	
	public function new () {
		
		super ();
		
	}
	
	
}


#else
typedef DropShadowFilter = openfl._legacy.filters.DropShadowFilter;
#end
