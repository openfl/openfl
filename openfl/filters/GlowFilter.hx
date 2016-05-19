package openfl.filters;


import openfl.display.Shader;
import openfl.geom.Rectangle;


@:final class GlowFilter extends BitmapFilter {
	
	
	public var alpha:Float;
	public var blurX:Float;
	public var blurY:Float;
	public var color:Int;
	public var inner:Bool;
	public var knockout (default, set):Bool;
	public var quality (default, set):Int;
	public var strength:Float;
	
	
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
		
	}
	
	
	public override function clone ():BitmapFilter {
		
		return new GlowFilter (color, alpha, blurX, blurY, strength, quality, inner, knockout);
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function set_knockout (value:Bool):Bool {
		
		return knockout = value;
		
	}
	
	
	private function set_quality (value:Int):Int {
		
		return quality = value;
		
	}
	
	
}