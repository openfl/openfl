package openfl.filters; #if !flash #if (display || openfl_next || js)


class BlurFilter extends BitmapFilter {
	
	
	public var blurX:Float;
	public var blurY:Float;
	public var quality:Int;
	
	
	public function new (blurX:Float = 4, blurY:Float = 4, quality:Int = 1) {
		
		super ();
		
		this.blurX = blurX;
		this.blurY = blurY;
		this.quality = quality;
		
	}
	
	
	public override function clone ():BitmapFilter {
		
		return new BlurFilter (blurX, blurY, quality);
		
	}
	
	
}


#else
typedef BlurFilter = openfl._v2.filters.BlurFilter;
#end
#else
typedef BlurFilter = flash.filters.BlurFilter;
#end