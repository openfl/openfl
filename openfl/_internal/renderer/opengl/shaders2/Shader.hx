package openfl._internal.renderer.opengl.shaders2;

import haxe.ds.Either;
import lime.graphics.GLRenderContext;
import openfl._internal.renderer.opengl.utils.VertexArray;
import openfl._internal.renderer.opengl.utils.VertexAttribute;
import openfl.display.BitmapData;
import openfl.display.GLShader.GLShaderData;
import openfl.display.GLShader.GLShaderParameter;
import openfl.display.ShaderData;
import openfl.display.ShaderParameter;
import openfl.display.ShaderParameterType;
import openfl.gl.GLProgram;
import openfl.gl.GLShader;
import openfl.gl.GLUniformLocation;
import openfl.utils.Float32Array;

class Shader {
	
	private static var UID:Int = 0;
	
	public var gl:GLRenderContext;
	
	public var vertexSrc:Array<String>;
	public var fragmentSrc:Array<String>;
	public var attributes:Map<String, Int> = new Map();
	public var uniforms:Map<String, GLUniformLocation> = new Map();
	public var compiled:Bool = false;
	public var ID(default, null):Int;
	
	public var program:GLProgram;
	
	private var vertexString:String;
	private var fragmentString:String;
	
	public function new(gl:GLRenderContext) {
		ID = UID++;
		this.gl = gl;
		
		program = null;
	}
	
	private function init(?force:Bool = false) {
		
		if (compiled && !force) return;
		
		if (vertexSrc != null) {
			vertexString = vertexSrc.join("\n");
		}
		if (fragmentSrc != null) {
			fragmentString = fragmentSrc.join("\n");
		}
		
		if (vertexString == null || fragmentString == null) {
			throw "No vertex or fragment source provided";
		}
		
		program = Shader.compileProgram(gl, vertexString, fragmentString);
		if (program != null) {
			compiled = true;
			gl.useProgram(program);
		}
	}
	
	public function destroy() {
		if (program != null) {
			gl.deleteProgram(program);
		}
		compiled = false;
		attributes = null;
	}
	
	public function applyData(shaderData:GLShaderData, renderSession:RenderSession) {
		if (shaderData == null) return;
		
		var param:GLShaderParameter;
		var u:GLUniformLocation;
		var v:Array<Float>;
		var bd:BitmapData;
		for (key in shaderData.keys()) {
			u = getUniformLocation(key);
			param = shaderData.get(key);
			if (param == null) continue;
			v = param.value;
			bd = param.bitmap;
			if (v == null && bd == null) continue;
			switch(@:privateAccess param.internalType) {
				case INT:
					switch(param.size) {
						case 1:	gl.uniform1i(u, Std.int(v[0]));
						case 2:	gl.uniform2i(u, Std.int(v[0]), Std.int(v[1]));
						case 3: gl.uniform3i(u, Std.int(v[0]), Std.int(v[1]), Std.int(v[2]));
						case 4:	gl.uniform4i(u, Std.int(v[0]), Std.int(v[1]), Std.int(v[2]), Std.int(v[3]));
						case _:
					}
				case FLOAT:
					switch(param.size) {
						case 1: gl.uniform1f(u, v[0]);
						case 2: gl.uniform2f(u, v[0], v[1]);
						case 3: gl.uniform3f(u, v[0], v[1], v[2]);
						case 4: gl.uniform4f(u, v[0], v[1], v[2], v[3]);
					}
				case MAT:
					switch(param.size) {
						case 2: gl.uniformMatrix2fv(u, param.transpose, new Float32Array(param.value));
						case 3: gl.uniformMatrix3fv(u, param.transpose, new Float32Array(param.value));
						case 4: gl.uniformMatrix4fv(u, param.transpose, new Float32Array(param.value));
					}
				case SAMPLER:
					if (bd == null ||  @:privateAccess !bd.__isValid) continue;
					gl.activeTexture(gl.TEXTURE0 + renderSession.activeTextures);
					gl.bindTexture(gl.TEXTURE_2D, bd.getTexture(gl));
					gl.uniform1i(u, renderSession.activeTextures);
					renderSession.activeTextures++;
				case _:
			}
		}
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
	
	
	public static function compileProgram(gl:GLRenderContext, vertexSrc:String, fragmentSrc:String):GLProgram {
		var vertexShader = Shader.compileShader(gl, vertexSrc, gl.VERTEX_SHADER);
		var fragmentShader = Shader.compileShader(gl, fragmentSrc, gl.FRAGMENT_SHADER);
		var program = gl.createProgram();
		
		if (vertexShader != null && fragmentShader != null) {
			gl.attachShader(program, vertexShader);
			gl.attachShader(program, fragmentShader);
			gl.linkProgram(program);
			
			if (gl.getProgramParameter(program, gl.LINK_STATUS) == 0) {
				trace ("Could not initialize shaders");
				return null;
			}
		}
		
		return program;
	}
	
	static function compileShader(gl:GLRenderContext, shaderSrc:String, type:Int):GLShader {
		var src = shaderSrc;
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
