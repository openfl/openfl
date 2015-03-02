package openfl._v2.filters; #if lime_legacy


class GlowFilter extends BitmapFilter {
	
	
	public var alpha:Float;
	public var blurX:Float;
	public var blurY:Float;
	public var color:Int;
	public var inner:Bool;
	public var knockout:Bool;
	public var quality:Int;
	public var strength:Float;
	
	private var angle:Float;
	private var distance:Float;
	public var hideObject:Bool;
	
	
	public function new (color:Int = 0, alpha:Float = 1.0, blurX:Float = 4.0, blurY:Float = 4.0, strength:Float = 1.0, quality:Int = 1, inner:Bool = false, knockout:Bool = false) {
		
		super ("DropShadowFilter");
		
		this.distance = 0;
		this.angle = 0;
		this.color = color;
		this.alpha = alpha;
		this.blurX = blurX;
		this.blurY = blurY;
		this.strength = strength;
		this.quality = quality;
		this.inner = inner;
		this.knockout = knockout;
		this.hideObject = false;
		
	}
	
	
	override public function clone ():BitmapFilter {
		
		return new GlowFilter (color, alpha, blurX, blurY, strength, quality, inner, knockout);
		
	}
	
	
}


#end