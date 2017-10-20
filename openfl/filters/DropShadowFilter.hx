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
	
	
	public var alpha (default, set):Float;
	public var angle (default, set):Float = 45;
	public var blurX (default, set):Float = 0;
	public var blurY (default, set):Float = 0;
	public var color (default, set):Int;
	public var distance (default, set):Float = 4;
	public var hideObject (default, set):Bool;
	public var inner (default, set):Bool;
	public var knockout (default, set):Bool;
	public var quality (default, set):Int;
	public var strength (default, set):Float;
	
	private var __offsetX:Float;
	private var __offsetY:Float;
	
	
	public function new (distance:Float = 4, angle:Float = 45, color:Int = 0, alpha:Float = 1, blurX:Float = 4, blurY:Float = 4, strength:Float = 1, quality:Int = 1, inner:Bool = false, knockout:Bool = false, hideObject:Bool = false) {
		
		super ();
		
		__offsetX = 0;
		__offsetY = 0;
		__updateSize ();
		
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
		
		__needSecondBitmapData = true;
		__preserveObject = !hideObject;
		
	}
	
	
	public override function clone ():BitmapFilter {
		
		return new DropShadowFilter (distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout, hideObject);
		
	}
	
	
	private override function __applyFilter (bitmapData:BitmapData, sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point):BitmapData {
		
		// TODO: Support knockout, inner
		
		var a = (color >> 24) & 0xFF;
		var r = (color >> 16) & 0xFF;
		var g = (color >> 8) & 0xFF;
		var b = color & 0xFF;
		sourceBitmapData.colorTransform (sourceBitmapData.rect, new ColorTransform (0, 0, 0, 1, r, g, b, a));
		
		destPoint.x += __offsetX;
		destPoint.y += __offsetY;
		
		var finalImage = ImageDataUtil.gaussianBlur (bitmapData.image, sourceBitmapData.image, sourceRect.__toLimeRectangle (), destPoint.__toLimeVector2 (), blurX, blurY, quality, strength);
		
		if (finalImage == bitmapData.image) return bitmapData;
		return sourceBitmapData;
		
	}
	
	
	private function __updateSize ():Void {
		
		__offsetX = Std.int (distance * Math.cos (angle * Math.PI / 180));
		__offsetY = Std.int (distance * Math.sin (angle * Math.PI / 180));
		__topExtension = Math.ceil ((__offsetY < 0 ? -__offsetY : 0) + blurY);
		__bottomExtension = Math.ceil ((__offsetY > 0 ? __offsetY : 0) + blurY);
		__leftExtension = Math.ceil ((__offsetX < 0 ? -__offsetX : 0) + blurX);
		__rightExtension = Math.ceil ((__offsetX > 0 ? __offsetX : 0) + blurX);
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function set_alpha (value:Float):Float {
		
		if (value != alpha) __renderDirty = true;
		return this.alpha = value;
		
	}
	
	
	private function set_angle (value:Float):Float {
		
		if (value != angle) {
			this.angle = value;
			__renderDirty = true;
			__updateSize ();
		}
		return value;
		
	}
	
	
	private function set_blurX (value:Float):Float {
		
		if (value != blurX) {
			this.blurX = value;
			__renderDirty = true;
			__updateSize ();
		}
		return value;
		
	}
	
	
	private function set_blurY (value:Float):Float {
		
		if (value != blurY) {
			this.blurY = value;
			__renderDirty = true;
			__updateSize ();
		}
		return value;
		
	}
	
	
	private function set_color (value:Int):Int {
		
		if (value != color) __renderDirty = true;
		return this.color = value;
		
	}
	
	
	private function set_distance (value:Float):Float {
		
		if (value != distance) {
			this.distance = value;
			__renderDirty = true;
			__updateSize ();
		}
		return value;
		
	}
	
	
	private function set_hideObject (value:Bool):Bool {
		
		if (value != hideObject) {
			__renderDirty = true;
			__preserveObject = !value;
		}
		return this.hideObject = value;
		
	}
	
	
	private function set_inner (value:Bool):Bool {
		
		if (value != inner) __renderDirty = true;
		return this.inner = value;
		
	}
	
	
	private function set_knockout (value:Bool):Bool {
		
		if (value != knockout) __renderDirty = true;
		return this.knockout = value;
		
	}
	
	
	private function set_quality (value:Int):Int {
		
		if (value != quality) __renderDirty = true;
		return this.quality = value;
		
	}
	
	
	private function set_strength (value:Float):Float {
		
		if (value != strength) __renderDirty = true;
		return this.strength = value;
		
	}
	
	
}