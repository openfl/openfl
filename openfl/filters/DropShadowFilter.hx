package openfl.filters; #if !openfl_legacy


import openfl.geom.Rectangle;
import openfl.display.BitmapData;
import openfl.filters.commands.*;


@:final class DropShadowFilter extends BitmapFilter {
	
	public var alpha:Float;
	public var angle:Float;
	public var blurX:Float;
	public var blurY:Float;
	public var color:Int;
	public var distance:Float;
	public var hideObject (default, set):Bool;
	public var inner:Bool;
	public var knockout (default, set):Bool;
	public var quality (default, set):Int;
	public var strength:Float;
	
	private var __shadowBitmapData:BitmapData;
	private static var __inverseAlphaMatrix = [ 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1.0, 255.0 ];
	
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
		
		__shadowBitmapData = @:privateAccess BitmapData.__asRenderTexture ();
	}
	
	
	public override function clone ():BitmapFilter {
		
		return new DropShadowFilter (distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout, hideObject);
		
	}
	
	
	private override function __growBounds (rect:Rectangle):Void {
		
		var halfBlurX = Math.ceil( blurX * 0.5 * quality );
		var halfBlurY = Math.ceil( blurY * 0.5 * quality );
		var sX = distance * Math.cos (angle * Math.PI / 180);
		var sY = distance * Math.sin (angle * Math.PI / 180);
		rect.x -= Math.abs (sX) + halfBlurX;
		rect.y -= Math.abs (sY) + halfBlurY;
		rect.width += 2.0 * (Math.abs (sX) + halfBlurX);
		rect.height += 2.0 * (Math.abs (sY) + halfBlurY);
		
	}
	
	private override function __getCommands (bitmap:BitmapData):Array<CommandType> {

		var commands:Array<CommandType> = [];
		var src = bitmap;
		
		@:privateAccess __shadowBitmapData.__resize(bitmap.width, bitmap.height);
		
		if (inner) {
			commands.push (ColorTransform (__shadowBitmapData, bitmap, __inverseAlphaMatrix));
			src = __shadowBitmapData;
		}
		
		for( quality_index in 0...quality ) {
			var first_pass = quality_index == 0;
			
			if (first_pass) {
				commands.push (Blur1D (__shadowBitmapData, src, blurX, true, 1.0, distance, angle));
			}
			else {
				commands.push (Blur1D (__shadowBitmapData, __shadowBitmapData, blurX, true, 1.0, 0.0, 0.0));
			}
			
			commands.push (Blur1D (__shadowBitmapData, __shadowBitmapData, blurY, false, quality_index == quality - 1 ? strength : 1.0, 0.0, 0.0));
		}

		commands.push (Colorize (__shadowBitmapData, __shadowBitmapData, color, alpha));

		if ( hideObject && !knockout && !inner ) {
			commands.push (Overwrite(bitmap, __shadowBitmapData ));

		} else if ( knockout || ( hideObject && inner ) ) {

			commands.push (Knockout(bitmap, bitmap, __shadowBitmapData, !inner ));

		} else if (inner) {

			commands.push (CombineInner (bitmap, bitmap, __shadowBitmapData));

		} else {
	
			commands.push (Combine (bitmap, __shadowBitmapData, bitmap));
	
		}

		return commands;
	
	}
	
	// Get & Set Methods
	
	
	
	
	private function set_knockout (value:Bool):Bool {
		
		return knockout = value;
		
	}
	
	
	private function set_hideObject (value:Bool):Bool {
		
		return hideObject = value;
		
	}
	
	
	private function set_quality (value:Int):Int {
		
		__passes = value * 2 + 1;
		return quality = value;
		
	}
	
	
}

#else
typedef DropShadowFilter = openfl._legacy.filters.DropShadowFilter;
#end
