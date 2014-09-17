package openfl._v2.display;


import openfl.display.DisplayObject;
import openfl.events.Event;
import openfl.geom.Rectangle;
import openfl.Lib;


class DirectRenderer extends DisplayObject {
	
	
	public function new (type:String = "DirectRenderer") {
		
		super (lime_direct_renderer_create (), type);
		
		addEventListener (Event.ADDED_TO_STAGE, function(_) lime_direct_renderer_set (__handle, __onRender));
		addEventListener (Event.REMOVED_FROM_STAGE, function(_) lime_direct_renderer_set (__handle, null));
		
	}
	
	
	public dynamic function render (rect:Rectangle):Void {
		
		
		
	}
	
	
	@:noCompletion private function __onRender (rect:Dynamic):Void {
		
		if (render != null) render (new Rectangle (rect.x, rect.y, rect.width, rect.height));
		
	}
	
	
	
	
	// Native Methods
	
	
	
	
	private static var lime_direct_renderer_create = Lib.load ("lime", "lime_direct_renderer_create", 0);
	private static var lime_direct_renderer_set = Lib.load ("lime", "lime_direct_renderer_set", 2);
	
	
}