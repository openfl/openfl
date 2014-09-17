package openfl.display; #if (flash || next || js || display) 


import openfl.display.DisplayObject;
import openfl.display.Sprite;


class DirectRenderer extends #if flash Sprite #else DisplayObject #end {
	
	
	public var render (get, set):Dynamic;
	
	private var __render:Dynamic;
	
	
	public function new (type:String = "DirectRenderer") {
		
		super ();
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function get_render ():Dynamic {
		
		return __render;
		
	}
	
	
	private function set_render (value:Dynamic):Dynamic {
		
		return __render = value;
		
	}
	
	
}


#else
typedef DirectRenderer = openfl._v2.display.DirectRenderer;
#end