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
		
		if (gl != null && glFragmentSource != null && glVertexSource != null) {
			
			__init ();
			
		}
		
	}
	
	
	private function __disable ():Void {
		
		
		
	}
	
	
	private function __enable ():Void {
		
		
		
	}
	
	
	private function __init ():Void {
		
		if (gl != null && glProgram == null) {
			
			glProgram = GLUtils.createProgram (glVertexSource, glFragmentSource);
			
		}
		
		data = new ShaderData (null);
		
	}
	
	
}