package openfl.text; #if (display || !flash)


import openfl.display.DisplayObject;


@:final extern class StaticText extends DisplayObject {
	
	
	public var text (default, null):String;
	
	private function new ();
	
	
}


#else
typedef StaticText = flash.text.StaticText;
#end