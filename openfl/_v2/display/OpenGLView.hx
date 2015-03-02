package openfl._v2.display; #if lime_legacy


import openfl.geom.Matrix3D;
import openfl.gl.GL;


class OpenGLView extends DirectRenderer {
	
	
	public static inline var CONTEXT_LOST = "glcontextlost";
	public static inline var CONTEXT_RESTORED = "glcontextrestored";
	
	public static var isSupported (get_isSupported, null):Bool;
	
	
	public function new () {
		
		super ("OpenGLView");
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private static inline function get_isSupported ():Bool {
		
		return true;
		
	}
	
	
}


#end