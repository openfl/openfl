package openfl.display;


import lime.graphics.GLRenderContext;
import lime.graphics.opengl.GLProgram;
import lime.utils.GLUtils;
import openfl.utils.ByteArray;


class Shader {
	
	
	public var byteCode (null, default):ByteArray;
	public var data:ShaderData;
	public var glFragmentSource:String;
	public var glProgram:GLProgram;
	public var glVertexSource:String;
	public var precisionHint:ShaderPrecision;
	
	private var gl:GLRenderContext;
	
	
	public function new (code:ByteArray = null) {
		
		byteCode = code;
		precisionHint = FULL;
		
		__init ();
		
	}
	
	
	private function __disable ():Void {
		
		
		
	}
	
	
	private function __enable ():Void {
		
		__init ();
		
	}
	
	
	private function __init ():Void {
		
		if (gl != null && glProgram == null) {
			
			var fragment = 
				
				"#ifdef GLES
				precision " + (precisionHint == FULL ? "mediump" : "lowp") + " float
				#endif
				" + glFragmentSource;
			
			glProgram = GLUtils.createProgram (glVertexSource, fragment);
			
		}
		
		if (data == null) {
			
			data = new ShaderData (null);
			
		}
		
	}
	
	
}