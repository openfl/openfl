package openfl.display; #if !openfl_legacy


import openfl.display.DisplayObject;
import openfl.display.Sprite;


class DirectRenderer extends #if flash Sprite #else DisplayObject #end {
	
	
	public var render (get, set):Dynamic;
	
	var __width:Int;
	var __height:Int;

	@:noCompletion private var __render:Dynamic;
	
	
	public function new (type:String = "DirectRenderer") {
		
		super ();
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	@:noCompletion private function get_render ():Dynamic {
		
		return __render;
		
	}
	
	
	@:noCompletion private function set_render (value:Dynamic):Dynamic {
		
		return __render = value;
		
	}
	
	public override function set_width(value:Float) {
		return __width = Std.int(value);
	}

	public override function get_width() {
		return __width;
	}
	
	public override function set_height(value:Float) {
		return __height = Std.int(value);
	}

	public override function get_height() {
		return __height;
	}
}


#else
typedef DirectRenderer = openfl._legacy.display.DirectRenderer;
#end