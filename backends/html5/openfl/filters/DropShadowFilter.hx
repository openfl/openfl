package openfl.filters;


class DropShadowFilter extends BitmapFilter {
	
	
	private var alpha:Float;
	private var angle:Float;
	private var blurX:Float;
	private var blurY:Float;
	private var color:Int;
	private var distance:Float;
	private var hideObject:Bool;
	private var inner:Bool;
	private var knockout:Bool;
	private var quality:Int;
	private var strength:Float;
	
	
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
		
	}
	
	
	public override function clone ():BitmapFilter {
		
		return new DropShadowFilter (distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout, hideObject);
		
	}
	
	
}