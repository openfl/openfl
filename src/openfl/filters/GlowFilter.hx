package openfl.filters;


import lime.graphics.utils.ImageDataUtil;
import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.display.Shader;
import openfl.geom.ColorTransform;
import openfl.geom.Point;
import openfl.geom.Rectangle;

@:access(openfl.geom.Point)
@:access(openfl.geom.Rectangle)


@:final class GlowFilter extends BitmapFilter {
	
	
	//private static var __glowShader = new GlowShader ();
	
	public var alpha (get, set):Float;
	public var blurX (get, set):Float;
	public var blurY (get, set):Float;
	public var color (get, set):Int;
	public var inner (get, set):Bool;
	public var knockout (get, set):Bool;
	public var quality (get, set):Int;
	public var strength (get, set):Float;
	
	private var __alpha:Float;
	private var __blurX:Float;
	private var __blurY:Float;
	private var __color:Int;
	private var __horizontalPasses:Int;
	private var __inner:Bool;
	private var __knockout:Bool;
	private var __quality:Int;
	private var __strength:Float;
	private var __verticalPasses:Int;
	
	
	#if openfljs
	private static function __init__ () {
		
		untyped Object.defineProperties (GlowFilter.prototype, {
			"alpha": { get: untyped __js__ ("function () { return this.get_alpha (); }"), set: untyped __js__ ("function (v) { return this.set_alpha (v); }") },
			"blurX": { get: untyped __js__ ("function () { return this.get_blurX (); }"), set: untyped __js__ ("function (v) { return this.set_blurX (v); }") },
			"blurY": { get: untyped __js__ ("function () { return this.get_blurY (); }"), set: untyped __js__ ("function (v) { return this.set_blurY (v); }") },
			"color": { get: untyped __js__ ("function () { return this.get_color (); }"), set: untyped __js__ ("function (v) { return this.set_color (v); }") },
			"inner": { get: untyped __js__ ("function () { return this.get_inner (); }"), set: untyped __js__ ("function (v) { return this.set_inner (v); }") },
			"knockout": { get: untyped __js__ ("function () { return this.get_knockout (); }"), set: untyped __js__ ("function (v) { return this.set_knockout (v); }") },
			"quality": { get: untyped __js__ ("function () { return this.get_quality (); }"), set: untyped __js__ ("function (v) { return this.set_quality (v); }") },
			"strength": { get: untyped __js__ ("function () { return this.get_strength (); }"), set: untyped __js__ ("function (v) { return this.set_strength (v); }") },
		});
		
	}
	#end
	
	
	public function new (color:Int = 0xFF0000, alpha:Float = 1, blurX:Float = 6, blurY:Float = 6, strength:Float = 2, quality:Int = 1, inner:Bool = false, knockout:Bool = false) {
		
		super ();
		
		__color = color;
		__alpha = alpha;
		this.blurX = blurX;
		this.blurY = blurY;
		__strength = strength;
		this.quality = quality;
		__inner = inner;
		__knockout = knockout;
		
		__needSecondBitmapData = true;
		__preserveObject = true;
		__renderDirty = true;
		
	}
	
	
	public override function clone ():BitmapFilter {
		
		return new GlowFilter (__color, __alpha, __blurX, __blurY, __strength, __quality, __inner, __knockout);
		
	}
	
	
	private override function __applyFilter (bitmapData:BitmapData, sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point):BitmapData {
		
		// TODO: Support knockout, inner
		
		var r = (__color >> 16) & 0xFF;
		var g = (__color >> 8) & 0xFF;
		var b = __color & 0xFF;
		sourceBitmapData.colorTransform (sourceBitmapData.rect, new ColorTransform (0, 0, 0, 1, r, g, b, __alpha * 0xFF));
		
		var finalImage = ImageDataUtil.gaussianBlur (bitmapData.image, sourceBitmapData.image, sourceRect.__toLimeRectangle (), destPoint.__toLimeVector2 (), __blurX, __blurY, __quality, __strength);
		
		if (finalImage == bitmapData.image) return bitmapData;
		return sourceBitmapData;
		
	}
	
	
	private override function __initShader (renderSession:RenderSession, pass:Int):Shader {
		
		// var data = __glowShader.data;
		
		// if (pass <= horizontalPasses) {
			
		// 	var scale = Math.pow (0.5, pass >> 1);
		// 	data.uRadius.value[0] = blurX * scale;
		// 	data.uRadius.value[1] = 0;
			
		// } else {
			
		// 	var scale = Math.pow (0.5, (pass - horizontalPasses) >> 1);
		// 	data.uRadius.value[0] = 0;
		// 	data.uRadius.value[1] = blurY * scale;
			
		// }
		
		// data.uColor.value[0] = ((color >> 16) & 0xFF) / 255;
		// data.uColor.value[1] = ((color >> 8) & 0xFF) / 255;
		// data.uColor.value[2] = (color & 0xFF) / 255;
		// data.uColor.value[3] = alpha;
		
		// return __glowShader;
		
		return null;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_alpha ():Float {
		
		return __alpha;
		
	}
	
	
	private function set_alpha (value:Float):Float {
		
		if (value != __alpha) __renderDirty = true;
		return __alpha = value;
		
	}
	
	
	private function get_blurX ():Float {
		
		return __blurX;
		
	}
	
	
	private function set_blurX (value:Float):Float {
		
		if (value != __blurX) {
			__blurX = value;
			__renderDirty = true;
			__leftExtension = (value > 0 ? Math.ceil (value) : 0);
			__rightExtension = __leftExtension;
		}
		return value;
		
	}
	
	
	private function get_blurY ():Float {
		
		return __blurY;
		
	}
	
	
	private function set_blurY (value:Float):Float {
		
		if (value != __blurY) {
			__blurY = value;
			__renderDirty = true;
			__topExtension = (value > 0 ? Math.ceil (value) : 0);
			__bottomExtension = __topExtension;
		}
		return value;
		
	}
	
	
	private function get_color ():Int {
		
		return __color;
		
	}
	
	
	private function set_color (value:Int):Int {
		
		if (value != __color) __renderDirty = true;
		return __color = value;
		
	}
	
	
	private function get_inner ():Bool {
		
		return __inner;
		
	}
	
	
	private function set_inner (value:Bool):Bool {
		
		if (value != __inner) __renderDirty = true;
		return __inner = value;
		
	}
	
	
	private function get_knockout ():Bool {
		
		return __knockout;
		
	}
	
	
	private function set_knockout (value:Bool):Bool {
		
		if (value != __knockout) __renderDirty = true;
		return __knockout = value;
		
	}
	
	
	private function get_quality ():Int {
		
		return __quality;
		
	}
	
	
	private function set_quality (value:Int):Int {
		
		// TODO: Quality effect with fewer passes?
		
		__horizontalPasses = (__blurX <= 0) ? 0 : Math.round (__blurX * (value / 4)) + 1;
		__verticalPasses = (__blurY <= 0) ? 0 : Math.round (__blurY * (value / 4)) + 1;
		
		__numShaderPasses = __horizontalPasses + __verticalPasses;
		
		if (value != __quality) __renderDirty = true;
		return __quality = value;
		
	}
	
	
	private function get_strength ():Float {
		
		return __strength;
		
	}
	
	
	private function set_strength (value:Float):Float {
		
		if (value != __strength) __renderDirty = true;
		return __strength = value;
		
	}
	
	
}


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


private class GlowShader extends Shader {
	
	
	@:glFragmentSource( 
		
		"varying float vAlpha;
		varying vec2 vTexCoord;
		uniform sampler2D uImage0;
		
		uniform vec4 uColor;
		
		varying vec2 vBlurCoords[7];
		
		void main(void) {
			
			float a = 0.0;
			a += texture2D(uImage0, vBlurCoords[0]).a * 0.00443;
			a += texture2D(uImage0, vBlurCoords[1]).a * 0.05399;
			a += texture2D(uImage0, vBlurCoords[2]).a * 0.24197;
			a += texture2D(uImage0, vBlurCoords[3]).a * 0.39894;
			a += texture2D(uImage0, vBlurCoords[4]).a * 0.24197;
			a += texture2D(uImage0, vBlurCoords[5]).a * 0.05399;
			a += texture2D(uImage0, vBlurCoords[6]).a * 0.00443;
			a *= uColor.a;
			
			gl_FragColor = vec4(uColor.rgb * a, a);
			
		}"
		
	)
	
	
	@:glVertexSource(
		
		"attribute float aAlpha;
		attribute vec4 aPosition;
		attribute vec2 aTexCoord;
		varying float vAlpha;
		varying vec2 vTexCoord;
		
		uniform mat4 uMatrix;
		
		uniform vec2 uRadius;
		varying vec2 vBlurCoords[7];
		uniform vec2 uTextureSize;
		
		void main(void) {
			
			vAlpha = aAlpha;
			vTexCoord = aTexCoord;
			gl_Position = uMatrix * aPosition;
			
			vec2 r = uRadius / uTextureSize;
			vBlurCoords[0] = aTexCoord - r * 1.0;
			vBlurCoords[1] = aTexCoord - r * 0.75;
			vBlurCoords[2] = aTexCoord - r * 0.5;
			vBlurCoords[3] = aTexCoord;
			vBlurCoords[4] = aTexCoord + r * 0.5;
			vBlurCoords[5] = aTexCoord + r * 0.75;
			vBlurCoords[6] = aTexCoord + r * 1.0;
			
		}"
		
	)
	
	
	public function new () {
		
		super ();
		
		#if !macro
		data.uRadius.value = [ 0, 0 ];
		data.uColor.value = [ 0, 0, 0, 0 ];
		#end
		
	}
	
	
	private override function __update ():Void {
		
		data.uTextureSize.value = [ data.uImage0.input.width, data.uImage0.input.height ];
		
		super.__update ();
		
	}
	
	
}