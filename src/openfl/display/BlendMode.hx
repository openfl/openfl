package openfl.display; #if !openfljs


@:enum abstract BlendMode(Null<Int>) {
	
	public var ADD = 0;
	public var ALPHA = 1;
	public var DARKEN = 2;
	public var DIFFERENCE = 3;
	public var ERASE = 4;
	public var HARDLIGHT = 5;
	public var INVERT = 6;
	public var LAYER = 7;
	public var LIGHTEN = 8;
	public var MULTIPLY = 9;
	public var NORMAL = 10;
	public var OVERLAY = 11;
	public var SCREEN = 12;
	public var SHADER = 13;
	public var SUBTRACT = 14;
	
	@:from private static function fromString (value:String):BlendMode {
		
		return switch (value) {
			
			case "add": ADD;
			case "alpha": ALPHA;
			case "darken": DARKEN;
			case "difference": DIFFERENCE;
			case "erase": ERASE;
			case "hardlight": HARDLIGHT;
			case "invert": INVERT;
			case "layer": LAYER;
			case "lighten": LIGHTEN;
			case "multiply": MULTIPLY;
			case "normal": NORMAL;
			case "overlay": OVERLAY;
			case "screen": SCREEN;
			case "shader": SHADER;
			case "subtract": SUBTRACT;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case BlendMode.ADD: "add";
			case BlendMode.ALPHA: "alpha";
			case BlendMode.DARKEN: "darken";
			case BlendMode.DIFFERENCE: "difference";
			case BlendMode.ERASE: "erase";
			case BlendMode.HARDLIGHT: "hardlight";
			case BlendMode.INVERT: "invert";
			case BlendMode.LAYER: "layer";
			case BlendMode.LIGHTEN: "lighten";
			case BlendMode.MULTIPLY: "multiply";
			case BlendMode.NORMAL: "normal";
			case BlendMode.OVERLAY: "overlay";
			case BlendMode.SCREEN: "screen";
			case BlendMode.SHADER: "shader";
			case BlendMode.SUBTRACT: "subtract";
			default: null;
			
		}
		
	}
	
}


#else


@:enum abstract BlendMode(String) from String to String {
	
	public var ADD = "add";
	public var ALPHA = "alpha";
	public var DARKEN = "darken";
	public var DIFFERENCE = "difference";
	public var ERASE = "erase";
	public var HARDLIGHT = "hardlight";
	public var INVERT = "invert";
	public var LAYER = "layer";
	public var LIGHTEN = "lighten";
	public var MULTIPLY = "multiply";
	public var NORMAL = "normal";
	public var OVERLAY = "overlay";
	public var SCREEN = "screen";
	public var SHADER = "shader";
	public var SUBTRACT = "subtract";
	
}


#end