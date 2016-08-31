package openfl.filters; #if !openfl_legacy


import openfl.display.BitmapData;
import openfl.filters.commands.*;
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
	
	private var __glowBitmapData:BitmapData;
	
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
		
		__glowBitmapData = @:privateAccess BitmapData.__asRenderTexture ();
		
	}
	
	
	public override function clone ():BitmapFilter {
		
		return new GlowFilter (color, alpha, blurX, blurY, strength, quality, inner, knockout);
		
	}
	
	
	private override function __growBounds (rect:Rectangle):Void {
		

		var halfBlurX = Math.ceil( blurX * 0.5 * quality );
		var halfBlurY = Math.ceil( blurY * 0.5 * quality );

		rect.x += -halfBlurX;
		rect.y += -halfBlurY;
		rect.width += 2.0 * halfBlurX;
		rect.height += 2.0 * halfBlurY;
	}
	
	
	private override function __getCommands (bitmap:BitmapData):Array<CommandType> {
		
		var commands:Array<CommandType> = [];
			
		@:privateAccess __glowBitmapData.__resize(bitmap.width, bitmap.height);
			
		for( quality_index in 0...quality ) {
			commands.push (Blur1D (__glowBitmapData, quality_index == 0 ? bitmap : __glowBitmapData, blurX, true, 1.0, 0.0, 0.0));
			commands.push (Blur1D (__glowBitmapData, __glowBitmapData, blurY, false, quality_index == quality - 1 ? strength : 1.0, 0.0, 0.0));
		}
			
		commands.push (Colorize (__glowBitmapData, __glowBitmapData, color, alpha));
			
		if (inner) {
			
			commands.push (CombineInner (bitmap, bitmap, __glowBitmapData));
			
		}
		else if (knockout) {
		
			throw ":TODO: support knockout command";
		}
		else {
	
			commands.push (Combine (bitmap, __glowBitmapData, bitmap));
	
		}

		return commands;
	
	}
	
	// Get & Set Methods
	
	
	
	
	private function set_knockout (value:Bool):Bool {
		
		return knockout = value;
		
	}
	
	
	private function set_quality (value:Int):Int {
		
		__passes = value * 2 + 1;
		return quality = value;
		
	}
	
	
}

#else
typedef GlowFilter = openfl._legacy.filters.GlowFilter;
#end
