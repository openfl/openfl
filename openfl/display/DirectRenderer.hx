package openfl.display;


import openfl.display.DisplayObject;
import openfl.display.Sprite;


@:replacementPlanned class DirectRenderer extends #if flash Sprite #else DisplayObject #end {
	
	
	public var render (get, set):Dynamic;
	
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
	
	
}