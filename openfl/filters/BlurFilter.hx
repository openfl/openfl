package openfl.filters; #if !openfl_legacy


import openfl.display.BitmapData;
import openfl.filters.commands.*;
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


	private override function __growBounds (rect:Rectangle):Void {

		var halfBlurX = Math.ceil( (Math.ceil (blurX) - 1) / 2 * quality );
		var halfBlurY = Math.ceil( (Math.ceil (blurY) - 1) / 2 * quality );

		rect.x += -halfBlurX;
		rect.y += -halfBlurY;
		rect.width += 2.0 * halfBlurX;
		rect.height += 2.0 * halfBlurY;
	}


	private override function __getCommands (bitmap:BitmapData):Array<CommandType> {

		var commands:Array<CommandType> = [];

		if(blurX>0) {
			commands.push (Blur1D (bitmap, bitmap, blurX, quality, true, 1.0, 0.0, 0.0));
		}

		if(blurY>0){
			commands.push (Blur1D (bitmap, bitmap, blurY, quality, false, 1.0, 0.0, 0.0));
		}

		return commands;
	}


	// Get & Set Methods


	private function set_quality (value:Int):Int {

		return quality = value;

	}


}


#else
typedef BlurFilter = openfl._legacy.filters.BlurFilter;
#end
