package openfl.display;

import lime.graphics.GLRenderContext;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLUniformLocation;
import lime.utils.Float32Array;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

class ShaderParameter {
	var name:String;
	
	public function new (name:String) {
		this.name = name;
	}
	
	public function init (gl:GLRenderContext, program:GLProgram) {}
	public function update (gl:GLRenderContext, skipEnableVertexAttribArray:Bool) {}
	public function disable (gl:GLRenderContext) {}
}

class ShaderParameterUniform extends ShaderParameter {
	public var index (default,null):GLUniformLocation;

	override function init (gl:GLRenderContext, program:GLProgram) {
		index = gl.getUniformLocation (program, name);
	}
}

class ShaderParameterAttrib extends ShaderParameter {
	public var index (default,null):Int;

	override function init (gl:GLRenderContext, program:GLProgram) {
		index = gl.getAttribLocation (program, name);
	}

	override function update (gl:GLRenderContext, skipEnableVertexAttribArray:Bool) {
		if (!skipEnableVertexAttribArray) {
			gl.enableVertexAttribArray (index);
		}
	}

	override function disable (gl:GLRenderContext) {
		gl.disableVertexAttribArray (index);
	}
}

class ShaderParameterSampler extends ShaderParameterUniform {
	public var input:BitmapData;
	public var smoothing:Bool;
	var textureIndex:Int;
	
	public function new (name:String, textureIndex:Int) {
		super (name);
		this.textureIndex = textureIndex;
	}
	
	public function enable (gl:GLRenderContext) {
		gl.uniform1i (index, textureIndex);
	}
	
	override function update (gl:GLRenderContext, _) {
		if (input == null)
			return;
			
		gl.activeTexture (gl.TEXTURE0 + textureIndex);
		gl.bindTexture (gl.TEXTURE_2D, input.getTexture (gl).data.glTexture);
		
		if (smoothing) {
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
		} else {
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
		}
	}
}

class ShaderParameterBool extends ShaderParameterUniform {
	public var value:Bool;
	override function update (gl:GLRenderContext, _) {
		gl.uniform1i (index, value ? 1 : 0);
	}
}

class ShaderParameterBool2 extends ShaderParameterUniform {
	public var value0:Bool;
	public var value1:Bool;
	override function update (gl:GLRenderContext, _) {
		gl.uniform2i (index, value0 ? 1 : 0, value1 ? 1 : 0);
	}
}

class ShaderParameterBool3 extends ShaderParameterUniform {
	public var value0:Bool;
	public var value1:Bool;
	public var value2:Bool;
	override function update (gl:GLRenderContext, _) {
		gl.uniform3i (index, value0 ? 1 : 0, value1 ? 1 : 0, value2 ? 1 : 0);
	}
}

class ShaderParameterBool4 extends ShaderParameterUniform {
	public var value0:Bool;
	public var value1:Bool;
	public var value2:Bool;
	public var value3:Bool;
	override function update (gl:GLRenderContext, _) {
		gl.uniform4i (index, value0 ? 1 : 0, value1 ? 1 : 0, value2 ? 1 : 0, value3 ? 1 : 0);
	}
}


class ShaderParameterFloat extends ShaderParameterUniform {
	public var value:Float;
	override function update (gl:GLRenderContext, _) {
		gl.uniform1f (index, value);
	}
}

class ShaderParameterFloat2 extends ShaderParameterUniform {
	public var value0:Float;
	public var value1:Float;
	override function update (gl:GLRenderContext, _) {
		gl.uniform2f (index, value0, value1);
	}
}

class ShaderParameterFloat3 extends ShaderParameterUniform {
	public var value0:Float;
	public var value1:Float;
	public var value2:Float;
	override function update (gl:GLRenderContext, _) {
		gl.uniform3f (index, value0, value1, value2);
	}
}

class ShaderParameterFloat4 extends ShaderParameterUniform {
	public var value0:Float;
	public var value1:Float;
	public var value2:Float;
	public var value3:Float;
	override function update (gl:GLRenderContext, _) {
		gl.uniform4f (index, value0, value1, value2, value3);
	}
}


class ShaderParameterInt extends ShaderParameterUniform {
	public var value:Int;
	override function update (gl:GLRenderContext, _) {
		gl.uniform1i (index, value);
	}
}

class ShaderParameterInt2 extends ShaderParameterUniform {
	public var value0:Int;
	public var value1:Int;
	override function update (gl:GLRenderContext, _) {
		gl.uniform2i (index, value0, value1);
	}
}

class ShaderParameterInt3 extends ShaderParameterUniform {
	public var value0:Int;
	public var value1:Int;
	public var value2:Int;
	override function update (gl:GLRenderContext, _) {
		gl.uniform3i (index, value0, value1, value2);
	}
}

class ShaderParameterInt4 extends ShaderParameterUniform {
	public var value0:Int;
	public var value1:Int;
	public var value2:Int;
	public var value3:Int;
	override function update (gl:GLRenderContext, _) {
		gl.uniform4i (index, value0, value1, value2, value3);
	}
}


class ShaderParameterMatrix2 extends ShaderParameterUniform {
	public var value:Float32Array;
	override function update (gl:GLRenderContext, _) {
		gl.uniformMatrix2fv (index, 1, false, value);
	}
}

class ShaderParameterMatrix3 extends ShaderParameterUniform {
	public var value:Float32Array;
	override function update (gl:GLRenderContext, _) {
		gl.uniformMatrix3fv (index, 1, false, value);
	}
}

class ShaderParameterMatrix4 extends ShaderParameterUniform {
	public var value:Float32Array;
	override function update (gl:GLRenderContext, _) {
		gl.uniformMatrix4fv (index, 1, false, value);
	}
}
