package openfl.display3D._shaders;


// TODO: Refactor

import openfl.utils.AGALMiniAssembler;
import openfl._internal.aglsl.AGLSLCompiler;
import openfl.display3D.Context3DProgramType;
import openfl.utils.ByteArray;

#if (cpp || neko || js)
import openfl.gl.GL;
#end


class AGLSLShaderUtils {
	
	
	inline public static function compile (programType:String, source:String):ByteArray {
		
		var agalMiniAssembler:AGALMiniAssembler = new AGALMiniAssembler ();
		var data:ByteArray = null;
		var concatSource:String;
		
		switch (programType) {
			
			case "vertex":
				
				concatSource = "part vertex 1 \n" + source + "endpart";
				agalMiniAssembler.assemble (concatSource);
				data = agalMiniAssembler.r.get ("vertex").data;
			
			case "fragment":
				
				concatSource = "part fragment 1 \n" + source + "endpart";
				agalMiniAssembler.assemble (concatSource);
				data = agalMiniAssembler.r.get ("fragment").data;
			
			default:
				
				throw "Unknown Context3DProgramType";
			
		}
		
		return data;
		
	}
	
	
	inline public static function createShader (type:Context3DProgramType, shaderSource:String):Shader {
		
		#if flash
		
			return compile (cast (type, String), shaderSource);
			
		#elseif (cpp || neko || js)
			
			var aglsl:AGLSLCompiler = new AGLSLCompiler ();	
			var glType:Int;
			var shaderType:String;
			
			switch (type) {
				
				case Context3DProgramType.VERTEX:
					
					glType = GL.VERTEX_SHADER;
					shaderType = "vertex";
				
				case Context3DProgramType.FRAGMENT:
					
					glType = GL.FRAGMENT_SHADER;
					shaderType = "fragment";
				
			}
			
			//trace("--- AGAL ---\n" + shaderSource);
			
			var shaderSourceString:String = aglsl.compile (shaderType, shaderSource);
			var shader = GL.createShader (glType);
			GL.shaderSource (shader, shaderSourceString);
			GL.compileShader (shader);
			
			if (GL.getShaderParameter (shader, GL.COMPILE_STATUS) == 0) {
				
				trace("--- ERR ---\n" + shaderSourceString);
				var err = GL.getShaderInfoLog (shader);
				if (err != "") throw err;
				
			} 
			
			//trace("--- GLSL ---\n" + shaderSourceString);
			return shader;
			
		#else
			
			return null;
			
		#end
		
	}
	
	
}