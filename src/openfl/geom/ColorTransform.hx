package openfl.geom;


import lime.math.ColorMatrix;
import lime.utils.Float32Array;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class ColorTransform {
	
	
	private static var __limeColorMatrix:Float32Array;
	
	public var alphaMultiplier:Float;
	public var alphaOffset:Float;
	public var blueMultiplier:Float;
	public var blueOffset:Float;
	public var color (get, set):Int;
	public var greenMultiplier:Float;
	public var greenOffset:Float;
	public var redMultiplier:Float;
	public var redOffset:Float;
	
	
	#if openfljs
	private static function __init__ () {
		
		untyped Object.defineProperty (ColorTransform.prototype, "color", { get: untyped __js__ ("function () { return this.get_color (); }"), set: untyped __js__ ("function (v) { return this.set_color (v); }") });
		
	}
	#end
	
	
	public function new (redMultiplier:Float = 1, greenMultiplier:Float = 1, blueMultiplier:Float = 1, alphaMultiplier:Float = 1, redOffset:Float = 0, greenOffset:Float = 0, blueOffset:Float = 0, alphaOffset:Float = 0):Void {
		
		this.redMultiplier = redMultiplier;
		this.greenMultiplier = greenMultiplier;
		this.blueMultiplier = blueMultiplier;
		this.alphaMultiplier = alphaMultiplier;
		this.redOffset = redOffset;
		this.greenOffset = greenOffset;
		this.blueOffset = blueOffset;
		this.alphaOffset = alphaOffset;
		
	}
	
	
	public function concat (second:ColorTransform):Void {
		
		redMultiplier *= second.redMultiplier;   
		greenMultiplier *= second.greenMultiplier;
		blueMultiplier *= second.blueMultiplier;
		alphaMultiplier *= second.alphaMultiplier;
		
		redOffset = second.redMultiplier * redOffset + second.redOffset;
		greenOffset = second.greenMultiplier * greenOffset + second.greenOffset;
		blueOffset = second.blueMultiplier * blueOffset + second.blueOffset;
		alphaOffset = second.alphaMultiplier * alphaOffset + second.alphaOffset;
		
	}
	
	
	public function toString ():String {
		
		return '(redMultiplier=$redMultiplier, greenMultiplier=$greenMultiplier, blueMultiplier=$blueMultiplier, alphaMultiplier=$alphaMultiplier, redOffset=$redOffset, greenOffset=$greenOffset, blueOffset=$blueOffset, alphaOffset=$alphaOffset)';
		
	}
	
	
	private function __clone ():ColorTransform {
		
		return new ColorTransform (redMultiplier, greenMultiplier, blueMultiplier, alphaMultiplier, redOffset, greenOffset, blueOffset, alphaOffset);
		
	}
	
	
	private function __copyFrom (ct:ColorTransform):Void {
		
		redMultiplier = ct.redMultiplier;
		greenMultiplier = ct.greenMultiplier;
		blueMultiplier = ct.blueMultiplier;
		alphaMultiplier = ct.alphaMultiplier;
		
		redOffset = ct.redOffset;
		greenOffset = ct.greenOffset;
		blueOffset = ct.blueOffset;
		alphaOffset = ct.alphaOffset;
		
	}
	
	
	private function __combine (ct:ColorTransform):Void {
		
		redMultiplier *= ct.redMultiplier;
		greenMultiplier *= ct.greenMultiplier;
		blueMultiplier *= ct.blueMultiplier;
		alphaMultiplier *= ct.alphaMultiplier;
		
		redOffset += ct.redOffset;
		greenOffset += ct.greenOffset;
		blueOffset += ct.blueOffset;
		alphaOffset += ct.alphaOffset;
		
	}
	
	
	private function __identity ():Void {
		
		redMultiplier = 1;
		greenMultiplier = 1;
		blueMultiplier = 1;
		alphaMultiplier = 1;
		redOffset = 0;
		greenOffset = 0;
		blueOffset = 0;
		alphaOffset = 0;
		
	}
	
	
	private function __equals (ct:ColorTransform, ?skipAlphaMultiplier:Bool = false):Bool {
		
		return (ct != null && redMultiplier == ct.redMultiplier && greenMultiplier == ct.greenMultiplier && blueMultiplier == ct.blueMultiplier && (skipAlphaMultiplier || alphaMultiplier == ct.alphaMultiplier) && redOffset == ct.redOffset && greenOffset == ct.greenOffset && blueOffset == ct.blueOffset && alphaOffset == ct.alphaOffset);
		
	}
	
	
	private function __isDefault ():Bool {
		
		return (redMultiplier == 1 && greenMultiplier == 1 && blueMultiplier == 1 && alphaMultiplier == 1 && redOffset == 0 && greenOffset == 0 && blueOffset == 0 && alphaOffset == 0);
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function get_color ():Int {
		
		return ((Std.int (redOffset) << 16) | (Std.int (greenOffset) << 8) | Std.int (blueOffset));
		
	}
	
	
	private function set_color (value:Int):Int {
		
		redOffset = (value >> 16) & 0xFF;
		greenOffset = (value >> 8) & 0xFF;
		blueOffset = value & 0xFF;
		
		redMultiplier = 0;
		greenMultiplier = 0;
		blueMultiplier = 0;
		
		return color;
		
	}
	
	
	private function __toLimeColorMatrix ():ColorMatrix {
		
		if (__limeColorMatrix == null) {
			
			__limeColorMatrix = new Float32Array (20);
			
		}
		
		__limeColorMatrix[0] = redMultiplier;
		__limeColorMatrix[4] = redOffset / 255;
		__limeColorMatrix[6] = greenMultiplier;
		__limeColorMatrix[9] = greenOffset / 255;
		__limeColorMatrix[12] = blueMultiplier;
		__limeColorMatrix[14] = blueOffset / 255;
		__limeColorMatrix[18] = alphaMultiplier;
		__limeColorMatrix[19] = alphaOffset / 255;
		
		return __limeColorMatrix;
		
	}
	
	
}