package openfl.filters; #if !flash #if (display || openfl_next || js)


class GlowFilter extends BitmapFilter {
	
	
	public var alpha:Float;
	public var blurX:Float;
	public var blurY:Float;
	public var color:Int;
	public var inner:Bool;
	public var knockout:Bool;
	public var quality:Int;
	public var strength:Float;
	
	
	public function new (color:Int = 0, alpha:Float = 1, blurX:Float = 6, blurY:Float = 6, strength:Float = 2, quality:Int = 1, inner:Bool = false, knockout:Bool = false) {
		
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
	
	
}


#else
typedef GlowFilter = openfl._v2.filters.GlowFilter;
#end
#else
typedef GlowFilter = flash.filters.GlowFilter;
#end