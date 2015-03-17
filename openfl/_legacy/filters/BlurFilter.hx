package openfl._legacy.filters; #if openfl_legacy


class BlurFilter extends BitmapFilter {
	
	
	public var blurX:Float;
	public var blurY:Float;
	public var quality:Int;
	
	
	public function new (blurX:Float = 4.0, blurY:Float = 4.0, quality:Int = 1) {
		
		super ("BlurFilter");

		this.blurX = blurX;
		this.blurY = blurY;
		this.quality = quality;
		
	}
	
	
	override public function clone ():BitmapFilter {
		
		return new BlurFilter (blurX, blurY, quality);
		
	}
	
	
}


#end