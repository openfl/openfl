package openfl.text;


import openfl.display.DisplayObject;
import openfl.display.Graphics;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.Graphics)


class StaticText extends DisplayObject {
	
	
	public var text (default, null):String;
	
	
	private function new () {
		
		super ();
		
		__graphics = new Graphics (this);
		
	}
	
	
}