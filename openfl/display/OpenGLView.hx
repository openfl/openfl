package openfl.display;
#if display


extern class OpenGLView extends DirectRenderer {
	
	static inline var CONTEXT_LOST = "glcontextlost";
	static inline var CONTEXT_RESTORED = "glcontextrestored";
	
	static var isSupported(get_isSupported, null):Bool;
	
	function new():Void;
	
}


#end