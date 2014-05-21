package openfl.filters;


class GlowFilter extends BitmapFilter {
	
	
	private var alpha:Float;
	private var blurX:Float;
	private var blurY:Float;
	private var color:Int;
	private var inner:Bool;
	private var knockout:Bool;
	private var quality:Int;
	private var strength:Float;
	
	
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