package openfl._internal.renderer;


import openfl.display.Shader;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class AbstractShaderManager {
	
	
	public var currentShader (default, null):Shader;
	public var currentShaderBuffer (default, null):ShaderBuffer;
	public var defaultShader:Shader;
	
	
	public function new () {
		
		
		
	}
	
	
	public function initShader (shader:Shader):Shader {
		
		return shader;
		
	}
	
	
	public function initShaderBuffer (shaderBuffer:ShaderBuffer):Shader {
		
		return shaderBuffer.shader;
		
	}
	
	
	public function setShader (shader:Shader):Void {
		
		
		
	}
	
	
	public function setShaderBuffer (shaderBuffer:ShaderBuffer):Void {
		
		
		
	}
	
	
	public function updateShader ():Void {
		
		
		
	}
	
	
	public function updateShaderBuffer ():Void {
		
		
		
	}
	
	
}