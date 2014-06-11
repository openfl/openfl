package openfl.display;


import openfl.display.DisplayObject;


class DirectRenderer extends DisplayObject {
	
	
	public var render (get_render, set_render):Dynamic;

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