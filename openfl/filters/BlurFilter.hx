package openfl.filters;


import openfl.display.Shader;
import openfl.filters.BitmapFilter;
import openfl.geom.Rectangle;


@:final class BlurFilter extends BitmapFilter {
	
	
	public var blurX:Float;
	public var blurY:Float;
	public var quality (default, set):Int;
	
	
	public function new (blurX:Float = 4, blurY:Float = 4, quality:Int = 1) {
		
		super ();
		
		this.blurX = blurX;
		this.blurY = blurY;
		this.quality = quality;
		
	}
	
	
	public override function clone ():BitmapFilter {
		
		return new BlurFilter (blurX, blurY, quality);
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function set_quality (value:Int):Int {
		
		return quality = value;
		
	}
	
	
}