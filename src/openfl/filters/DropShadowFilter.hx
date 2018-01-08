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


@:final class DropShadowFilter extends BitmapFilter {
	
	
	public var alpha (get, set):Float;
	public var angle (get, set):Float;
	public var blurX (get, set):Float;
	public var blurY (get, set):Float;
	public var color (get, set):Int;
	public var distance (get, set):Float;
	public var hideObject (get, set):Bool;
	public var inner (get, set):Bool;
	public var knockout (get, set):Bool;
	public var quality (get, set):Int;
	public var strength (get, set):Float;
	
	private var __alpha:Float;
	private var __angle:Float;
	private var __blurX:Float;
	private var __blurY:Float;
	private var __color:Int;
	private var __distance:Float;
	private var __hideObject:Bool;
	private var __inner:Bool;
	private var __knockout:Bool;
	private var __offsetX:Float;
	private var __offsetY:Float;
	private var __quality:Int;
	private var __strength:Float;
	
	
	#if openfljs
	private static function __init__ () {
		
		untyped Object.defineProperties (DropShadowFilter.prototype, {
			"alpha": { get: untyped __js__ ("function () { return this.get_alpha (); }"), set: untyped __js__ ("function (v) { return this.set_alpha (v); }") },
			"angle": { get: untyped __js__ ("function () { return this.get_angle (); }"), set: untyped __js__ ("function (v) { return this.set_angle (v); }") },
			"blurX": { get: untyped __js__ ("function () { return this.get_blurX (); }"), set: untyped __js__ ("function (v) { return this.set_blurX (v); }") },
			"blurY": { get: untyped __js__ ("function () { return this.get_blurY (); }"), set: untyped __js__ ("function (v) { return this.set_blurY (v); }") },
			"color": { get: untyped __js__ ("function () { return this.get_color (); }"), set: untyped __js__ ("function (v) { return this.set_color (v); }") },
			"distance": { get: untyped __js__ ("function () { return this.get_distance (); }"), set: untyped __js__ ("function (v) { return this.set_distance (v); }") },
			"hideObject": { get: untyped __js__ ("function () { return this.get_hideObject (); }"), set: untyped __js__ ("function (v) { return this.set_hideObject (v); }") },
			"inner": { get: untyped __js__ ("function () { return this.get_inner (); }"), set: untyped __js__ ("function (v) { return this.set_inner (v); }") },
			"knockout": { get: untyped __js__ ("function () { return this.get_knockout (); }"), set: untyped __js__ ("function (v) { return this.set_knockout (v); }") },
			"quality": { get: untyped __js__ ("function () { return this.get_quality (); }"), set: untyped __js__ ("function (v) { return this.set_quality (v); }") },
			"strength": { get: untyped __js__ ("function () { return this.get_strength (); }"), set: untyped __js__ ("function (v) { return this.set_strength (v); }") },
		});
		
	}
	#end
	
	
	public function new (distance:Float = 4, angle:Float = 45, color:Int = 0, alpha:Float = 1, blurX:Float = 4, blurY:Float = 4, strength:Float = 1, quality:Int = 1, inner:Bool = false, knockout:Bool = false, hideObject:Bool = false) {
		
		super ();
		
		__offsetX = 0;
		__offsetY = 0;
		
		__distance = distance;
		__angle = angle;
		__color = color;
		__alpha = alpha;
		__blurX = blurX;
		__blurY = blurY;
		__strength = strength;
		__quality = quality;
		__inner = inner;
		__knockout = knockout;
		__hideObject = hideObject;
		
		__updateSize ();
		
		__needSecondBitmapData = true;
		__preserveObject = !__hideObject;
		__renderDirty = true;
		
	}
	
	
	public override function clone ():BitmapFilter {
		
		return new DropShadowFilter (__distance, __angle, __color, __alpha, __blurX, __blurY, __strength, __quality, __inner, __knockout, __hideObject);
		
	}
	
	
	private override function __applyFilter (bitmapData:BitmapData, sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point):BitmapData {
		
		// TODO: Support knockout, inner
		
		var a = (__color >> 24) & 0xFF;
		var r = (__color >> 16) & 0xFF;
		var g = (__color >> 8) & 0xFF;
		var b = __color & 0xFF;
		sourceBitmapData.colorTransform (sourceBitmapData.rect, new ColorTransform (0, 0, 0, 1, r, g, b, a));
		
		destPoint.x += __offsetX;
		destPoint.y += __offsetY;
		
		var finalImage = ImageDataUtil.gaussianBlur (bitmapData.image, sourceBitmapData.image, sourceRect.__toLimeRectangle (), destPoint.__toLimeVector2 (), __blurX, __blurY, __quality, __strength);
		
		if (finalImage == bitmapData.image) return bitmapData;
		return sourceBitmapData;
		
	}
	
	
	private function __updateSize ():Void {
		
		__offsetX = Std.int (__distance * Math.cos (__angle * Math.PI / 180));
		__offsetY = Std.int (__distance * Math.sin (__angle * Math.PI / 180));
		__topExtension = Math.ceil ((__offsetY < 0 ? -__offsetY : 0) + __blurY);
		__bottomExtension = Math.ceil ((__offsetY > 0 ? __offsetY : 0) + __blurY);
		__leftExtension = Math.ceil ((__offsetX < 0 ? -__offsetX : 0) + __blurX);
		__rightExtension = Math.ceil ((__offsetX > 0 ? __offsetX : 0) + __blurX);
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_alpha ():Float {
		
		return __alpha;
		
	}
	
	
	private function set_alpha (value:Float):Float {
		
		if (value != __alpha) __renderDirty = true;
		return __alpha = value;
		
	}
	
	
	private function get_angle ():Float {
		
		return __angle;
		
	}
	
	
	private function set_angle (value:Float):Float {
		
		if (value != __angle) {
			__angle = value;
			__renderDirty = true;
			__updateSize ();
		}
		return value;
		
	}
	
	
	private function get_blurX ():Float {
		
		return __blurX;
		
	}
	
	
	private function set_blurX (value:Float):Float {
		
		if (value != __blurX) {
			__blurX = value;
			__renderDirty = true;
			__updateSize ();
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
			__updateSize ();
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
	
	
	private function get_distance ():Float {
		
		return __distance;
		
	}
	
	
	private function set_distance (value:Float):Float {
		
		if (value != __distance) {
			__distance = value;
			__renderDirty = true;
			__updateSize ();
		}
		return value;
		
	}
	
	
	private function get_hideObject ():Bool {
		
		return __hideObject;
		
	}
	
	
	private function set_hideObject (value:Bool):Bool {
		
		if (value != __hideObject) {
			__renderDirty = true;
			__preserveObject = !value;
		}
		return __hideObject = value;
		
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