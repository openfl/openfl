package openfl._internal.renderer.opengl;


import haxe.crypto.Md5;
import lime.graphics.GLRenderContext;
import openfl._internal.renderer.AbstractShader;
import openfl._internal.renderer.opengl.GLShaderManager;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.Shader.GLShaderData;
import openfl.display.Shader.GLShaderParameter;
import openfl.display.Shader.RepeatMode;
import openfl.gl.GLProgram;
import openfl.gl.GLShader in LimeGLShader;
import openfl.gl.GLUniformLocation;
import openfl.utils.Float32Array;

import lime.graphics.opengl.GL;
import openfl.gl.GLBuffer;
import openfl.utils.ArrayBuffer;
import openfl.utils.ArrayBufferView;

@:allow(openfl.display.Shader)
@:access(openfl._internal.renderer.opengl.GLShaderManager)


class GLShader extends AbstractShader {
	
	
	private static var UID:Int = 0;
	
	public var gl:GLRenderContext;
	
	public var vertexSrc:Array<String>;
	public var fragmentSrc:Array<String>;
	public var attributes:Map<String, Int> = new Map();
	public var uniforms:Map<String, GLUniformLocation> = new Map();
	public var compiled:Bool = false;
	public var ID(default, null):Int;
	
	public var program:GLProgram;
	
	public var wrapS:RepeatMode = NONE;
	public var wrapT:RepeatMode = NONE;
	public var smooth:Null<Bool>;
	public var blendMode:BlendMode;
	
	private var vertexString:String;
	private var fragmentString:String;
	
	
	public function new (gl:GLRenderContext) {
		
		super ();
		
		ID = UID++;
		this.gl = gl;
		
		program = null;
	}
	
	
	public function disable ():Void {
		
		
		
	}
	
	
	public function enable ():Void {
		
		
		
	}
	
	
	private function init(force:Bool = false) {
		
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
		
		program = GLShader.compileProgram(gl, vertexString, fragmentString);
		if (program != null) {
			compiled = true;
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
			// TODO Investigate Array support
			switch(@:privateAccess param.internalType) {
				case INT:
					switch(param.size) {
						case 1:	gl.uniform1i(u, Std.int(v[0]));
						case 2:	gl.uniform2i(u, Std.int(v[0]), Std.int(v[1]));
						case 3: gl.uniform3i(u, Std.int(v[0]), Std.int(v[1]), Std.int(v[2]));
						case 4:	gl.uniform4i(u, Std.int(v[0]), Std.int(v[1]), Std.int(v[2]), Std.int(v[3]));
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
					gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, param.smooth ? gl.LINEAR : gl.NEAREST);
					gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, param.smooth ? gl.LINEAR : gl.NEAREST);
					
					gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, param.repeatX);
					gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, param.repeatY);
					
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
		
		var cache = GLShaderManager.compiledShadersCache;
		var key = Md5.encode(vertexSrc + fragmentSrc);
		
		if (cache.exists(key)) {
			
			return cache.get(key);
			
		}
		
		var vertexShader = GLShader.compileShader(gl, vertexSrc, gl.VERTEX_SHADER);
		var fragmentShader = GLShader.compileShader(gl, fragmentSrc, gl.FRAGMENT_SHADER);
		var program = gl.createProgram();
		
		if (vertexShader != null && fragmentShader != null) {
			gl.attachShader(program, vertexShader);
			gl.attachShader(program, fragmentShader);
			gl.linkProgram(program);
			
			gl.deleteShader(vertexShader);
			gl.deleteShader(fragmentShader);
			
			if (gl.getProgramParameter(program, gl.LINK_STATUS) == 0) {
				trace ("Could not compile the program:\n\t" + gl.getProgramInfoLog(program));
				trace ("VERTEX:\n" + vertexSrc + "\nFRAGMENT:\n" + fragmentSrc);
				return null;
			}
		}
		
		cache.set(key, program);
		
		return program;
	}
	
	static function compileShader(gl:GLRenderContext, shaderSrc:String, type:Int):LimeGLShader {
		var src = shaderSrc;
		var shader = gl.createShader(type);
		gl.shaderSource(shader, src);
		gl.compileShader(shader);
		
		if (gl.getShaderParameter(shader, gl.COMPILE_STATUS) == 0) {
			trace ("Could not compile the shader:\n\t" + gl.getShaderInfoLog(shader));
			trace (shaderSrc);
			return null;
		}
		
		return shader;
	}
	
}


class VertexArray {

	public var gl:GLRenderContext;
	public var glBuffer:GLBuffer;
	public var attributes:Array<VertexAttribute> = [];
	public var buffer:ArrayBuffer;
	public var size:Int = 0;
	public var stride(get, never):Int;

	public var isStatic:Bool = false;
	
	public function new(attributes:Array<VertexAttribute>, ?size:Int = 0, isStatic:Bool = false) {
		this.size = size;
		this.attributes = attributes;
		
		if(size > 0) {
			buffer = new ArrayBuffer(size);
		}
		
		this.isStatic = isStatic;
	}
	
	public inline function bind() {
		gl.bindBuffer(gl.ARRAY_BUFFER, glBuffer);
	}
	
	public inline function unbind() {
		gl.bindBuffer(gl.ARRAY_BUFFER, null);
	}
	
	public function upload(view:ArrayBufferView) {
		gl.bufferSubData(gl.ARRAY_BUFFER, 0, view);
	}
	
	public function destroy() {
		gl.deleteBuffer(glBuffer);
		buffer = null;
	}
	
	public function setContext(gl:GLRenderContext, view:ArrayBufferView) {
		this.gl = gl;
		
		glBuffer = gl.createBuffer();
		
		gl.bindBuffer(gl.ARRAY_BUFFER, glBuffer);
		// TODO fix this, it should accept an ArrayBuffer
		gl.bufferData(gl.ARRAY_BUFFER, view, isStatic ? gl.STATIC_DRAW : gl.DYNAMIC_DRAW);
	}
	
	private function get_stride() {
		var s = 0;
		for (a in attributes) {
			if (a.enabled) s += a.elements * 4;
		}
		return s;
	}
}


class VertexAttribute {

	public var components:Int;
	public var normalized:Bool = false;
	public var type:ElementType;
	public var name:String;
	public var enabled:Bool = true;
	public var elements(get, never):Int;
	
	public var defaultValue:Float32Array;
	
	public function new(components:Int, type:ElementType, normalized:Bool = false, name:String, ?defaultValue:Float32Array) {
		this.components = components;
		this.type = type;
		this.normalized = normalized;
		this.name = name;
		
		if (defaultValue == null) {
			this.defaultValue = new Float32Array(components);
		} else {
			this.defaultValue = defaultValue;
		}
		
	}
	
	public function copy() {
		return new VertexAttribute(components, type, normalized, name, defaultValue);
	}
	
	private inline function getElementsBytes() {
		return switch(type) {
			case BYTE, UNSIGNED_BYTE: 1;
			case SHORT, UNSIGNED_SHORT: 2;
			default: 4;
		}
	}	
	
	private inline function get_elements():Int {
		return Math.floor((components * getElementsBytes()) / 4);
	}
	
}

@:enum abstract ElementType(Int) from Int to Int {
	var BYTE = GL.BYTE;
	var UNSIGNED_BYTE = GL.UNSIGNED_BYTE;
	var SHORT = GL.SHORT;
	var UNSIGNED_SHORT = GL.UNSIGNED_SHORT;
	var FLOAT = GL.FLOAT;
}