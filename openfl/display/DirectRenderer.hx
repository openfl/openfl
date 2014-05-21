package openfl.display;
#if display


import openfl.display.DisplayObject;
import openfl.geom.Rectangle;


extern class DirectRenderer extends DisplayObject {

	function new(inType:String = "DirectRenderer"):Void;
	dynamic function render(inRect:Rectangle):Void;
	
}


#end