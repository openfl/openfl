package openfl.display3D; #if !flash


import openfl.gl.GL;
import openfl.gl.GLProgram;
import openfl.gl.GLShader;


class Program3D {
	
	
	public var glProgram:GLProgram;
	
	
	public function new (program:GLProgram) {
		
		this.glProgram = program;
		
	}
	
	
	public function dispose ():Void {
		
		GL.deleteProgram (glProgram);
		
	}
	
	
	public function upload (vertexShader:GLShader, fragmentShader:GLShader):Void {
		
		// TODO: Use ByteArray instead of Shader?
		
		GL.attachShader (glProgram, vertexShader);
		GL.attachShader (glProgram, fragmentShader);
		GL.linkProgram (glProgram);
		
		if (GL.getProgramParameter (glProgram, GL.LINK_STATUS) == 0) {
			
			var result = GL.getProgramInfoLog (glProgram);
			if (result != "") throw result;
			
		}
		
	}
	
	
}


#else
typedef Program3D = flash.display3D.Program3D;
#end