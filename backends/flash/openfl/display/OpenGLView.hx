package openfl.display;


class OpenGLView extends DirectRenderer {
	
	
	public static inline var CONTEXT_LOST = "glcontextlost";
	public static inline var CONTEXT_RESTORED = "glcontextrestored";
	
	public static var isSupported (get_isSupported, null):Bool;
	
	
	public function new ():Void {
		
		super ("OpenGLView");
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private static function get_isSupported ():Bool {
		
		return false;
		
	}
	
	
}