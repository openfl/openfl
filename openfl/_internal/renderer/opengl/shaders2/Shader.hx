package openfl._internal.renderer.opengl.shaders2;

import lime.graphics.GLRenderContext;
import openfl._internal.renderer.opengl.utils.VertexArray;
import openfl._internal.renderer.opengl.utils.VertexAttribute;
import openfl.gl.GLProgram;
import openfl.gl.GLShader;
import openfl.gl.GLUniformLocation;

class Shader {
	
	private static var UID:Int = 0;
	
	public var gl:GLRenderContext;
	
	public var vertexSrc:Array<String>;
	public var fragmentSrc:Array<String>;
	public var attributes:Map<String, Int> = new Map();
	public var uniforms:Map<String, GLUniformLocation> = new Map();
	
	public var ID(default, null):Int;
	
	public var program:GLProgram;
	
	public function new(gl:GLRenderContext) {
		ID = UID++;
		this.gl = gl;
		
		program = null;
	}
	
	private function init() {
		program = Shader.compileProgram(gl, vertexSrc, fragmentSrc);
		gl.useProgram(program);
	}
	
	public function destroy() {
		if (program != null) {
			gl.deleteProgram(program);
		}
		
		attributes = null;
	}
	
	public function getAttribLocation(attribute:String):Int {
		if (program == null) {
			throw "Shader isn't initialized";
		}
		if (attributes.exists(attribute)) {
			return attributes.get(attribute);
		} else {
			var location = gl.getAttribLocation(program, attribute);
			attributes.set(attribute, location);
			return location;
		}
	}
	
	public function getUniformLocation(uniform:String):GLUniformLocation {
		if (program == null) {
			throw "Shader isn't initialized";
		}
		if (uniforms.exists(uniform)) {
			return uniforms.get(uniform);
		} else {
			var location = gl.getUniformLocation(program, uniform);
			uniforms.set(uniform, location);
			return location;
		}
	}
	
	public function enableVertexAttribute(attribute:VertexAttribute, stride:Int, offset:Int) {
		//trace("Enable vertex attribute " + attribute.name);
		var location = getAttribLocation(attribute.name);
		gl.enableVertexAttribArray(location);
		gl.vertexAttribPointer(location, attribute.components, attribute.type, attribute.normalized, stride, offset * 4);
	}
	
	public function disableVertexAttribute(attribute:VertexAttribute, setDefault:Bool = true) {
		var location = getAttribLocation(attribute.name);
		gl.disableVertexAttribArray(location);
		if (setDefault) {
			switch(attribute.components) {
				case 1:
					gl.vertexAttrib1fv(location, attribute.defaultValue.subarray(0, 1));
				case 2:
					gl.vertexAttrib2fv(location, attribute.defaultValue.subarray(0, 2));
				case 3:
					gl.vertexAttrib3fv(location, attribute.defaultValue.subarray(0, 3));
				case _:
					gl.vertexAttrib4fv(location, attribute.defaultValue.subarray(0, 4));
			}
		}
	}
	
	public function bindVertexArray(va:VertexArray) {
		var offset = 0;
		var stride = va.stride;
		
		for (attribute in va.attributes) {
			if (attribute.enabled) {
				enableVertexAttribute(attribute, stride, offset);
				offset += attribute.elements;
			} else {
				disableVertexAttribute(attribute, true);
			}
		}
	}
	
	public function unbindVertexArray(va:VertexArray) {
		for (attribute in va.attributes) {
			disableVertexAttribute(attribute, false);
		}
	}
	
	
	public static function compileProgram(gl:GLRenderContext, vertexSrc:Array<String>, fragmentSrc:Array<String>):GLProgram {
		var vertexShader = Shader.compileShader(gl, vertexSrc, gl.VERTEX_SHADER);
		var fragmentShader = Shader.compileShader(gl, fragmentSrc, gl.FRAGMENT_SHADER);
		var program = gl.createProgram();
		
		if (vertexShader != null && fragmentShader != null) {
			gl.attachShader(program, vertexShader);
			gl.attachShader(program, fragmentShader);
			gl.linkProgram(program);
			
			if (gl.getProgramParameter(program, gl.LINK_STATUS) == 0) {
				trace ("Could not initialize shaders");
			}
		}
		
		return program;
	}
	
	static function compileShader(gl:GLRenderContext, shaderSrc:Array<String>, type:Int):GLShader {
		var src = shaderSrc.join("\n");
		var shader = gl.createShader(type);
		gl.shaderSource(shader, src);
		gl.compileShader(shader);
		
		if (gl.getShaderParameter(shader, gl.COMPILE_STATUS) == 0) {
			trace (gl.getShaderInfoLog (shader));
			return null;
		}
		
		return shader;
	}
	
}
