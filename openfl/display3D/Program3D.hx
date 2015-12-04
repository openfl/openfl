package openfl.display3D; #if (!display && !flash)


import openfl.gl.GL;
import openfl.gl.GLProgram;
import openfl.gl.GLShader;


@:final class Program3D {
	
	
	public var context:Context3D;
	public var glProgram:GLProgram;
	
	
	public function new (context:Context3D, program:GLProgram) {
		
		this.context = context;
		this.glProgram = program;
		
	}
	
	
	public function dispose ():Void {
		
		context.__deleteProgram (this);
		
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


import openfl.utils.ByteArray;

#if flash
@:native("flash.display3D.Program3D")
#end


@:final extern class Program3D {
	
	
	public function dispose () : Void;
	public function upload (vertexProgram:ByteArray, fragmentProgram:ByteArray):Void;
	
	
}


#end