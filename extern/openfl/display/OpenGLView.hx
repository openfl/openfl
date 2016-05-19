package openfl.display; #if (display || !flash)


extern class OpenGLView extends DirectRenderer {
	
	
	public static inline var CONTEXT_LOST = "glcontextlost";
	public static inline var CONTEXT_RESTORED = "glcontextrestored";
	
	public static var isSupported (get, null):Bool;
	
	public function new ();
	
	
}


#end