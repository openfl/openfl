package openfl._internal.renderer.opengl.shaders2;

import haxe.crypto.Md5;
import lime.math.Vector2;
import lime.math.Vector4;
import lime.graphics.GLRenderContext;
import openfl._internal.renderer.opengl.shaders2.DefaultShader;
import openfl._internal.renderer.opengl.shaders2.DefaultMaskedShader;
import openfl._internal.renderer.opengl.utils.ShaderManager;
import openfl._internal.renderer.opengl.utils.VertexArray;
import openfl._internal.renderer.opengl.utils.VertexAttribute;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.GLShaderData;
import openfl.display.Shader.GLShaderParameter;
import openfl.display.Shader.RepeatMode;
import openfl.geom.Matrix;
import openfl.gl.GLProgram;
import openfl.gl.GLShader;
import openfl.gl.GLUniformLocation;
import openfl.utils.Float32Array;
import openfl.utils.UnsafeStringMap;

@:allow(openfl.display.Shader)
@:access(openfl._internal.renderer.opengl.utils.ShaderManager)
class Shader {
	
	private static var UID:Int = 0;
	private static var currentVertexArray:VertexArray = null;
 
	public var gl:GLRenderContext;
	
	public var vertexSrc:Array<String>;
	public var fragmentSrc:Array<String>;
	public var attributes:UnsafeStringMap<Int> = new UnsafeStringMap();
	public var uniforms:UnsafeStringMap<GLUniformLocation> = new UnsafeStringMap();
	public var compiled:Bool = false;
	public var ID(default, null):Int;
	
	public var program:GLProgram;
	
	public var wrapS:RepeatMode = NONE;
	public var wrapT:RepeatMode = NONE;
	public var smooth:Null<Bool>;
	public var blendMode:BlendMode;
	
	private var vertexString:String;
	private var fragmentString:String;

	private var uniform1iCache:Map<GLUniformLocation, Int> = new Map();
	private var uniform2fCache:Map<GLUniformLocation, Vector2> = new Map();
	private var uniform4fCache:Map<GLUniformLocation, Vector4> = new Map();
	private var uniformMatrix3fCache:Map<GLUniformLocation, Matrix> = new Map();
	
	public function new(gl:GLRenderContext) {
		ID = UID++;
		this.gl = gl;
		
		program = null;
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
		
		program = Shader.compileProgram(gl, vertexString, fragmentString);
		if (program != null) {
			gl.useProgram (program);
		
			uniform1i (getUniformLocation (Uniform.Sampler), 0);
			uniform1i (getUniformLocation (MaskedUniform.MaskSampler), 1);
			
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
		var v:Float32Array;
		var bd:BitmapData;

		for(i in 0...shaderData.keys.length)
		{
			var key = shaderData.keys[i];

			u = getUniformLocation(key);

			param = shaderData.values[i];

			if (param == null) continue;
			v = param.value;
			bd = param.bitmap;
			if (v == null && bd == null) continue;
			// TODO Investigate Array support
			switch(@:privateAccess param.internalType) {
				case INT:
					switch(param.size) {
						case 1:	uniform1i(u, Std.int(v[0]));
						case 2:	gl.uniform2i(u, Std.int(v[0]), Std.int(v[1]));
						case 3: gl.uniform3i(u, Std.int(v[0]), Std.int(v[1]), Std.int(v[2]));
						case 4:	gl.uniform4i(u, Std.int(v[0]), Std.int(v[1]), Std.int(v[2]), Std.int(v[3]));
					}
				case FLOAT:
					switch(param.size) {
						case 1: gl.uniform1f(u, v[0]);
						case 2: uniform2f(u, v[0], v[1]);
						case 3: gl.uniform3f(u, v[0], v[1], v[2]);
						case 4: uniform4f(u, v[0], v[1], v[2], v[3]);
					}
				case MAT:
					switch(param.size) {
						case 2: gl.uniformMatrix2fv(u, param.transpose, (param.value));
						case 3: gl.uniformMatrix3fv(u, param.transpose, (param.value));
						case 4: gl.uniformMatrix4fv(u, param.transpose, (param.value));
					}
				case SAMPLER:
					if (bd == null ||  @:privateAccess !bd.__isValid) continue;
					gl.activeTexture(gl.TEXTURE0 + renderSession.activeTextures);
					gl.bindTexture(gl.TEXTURE_2D, bd.getTexture(gl));
					uniform1i(u, renderSession.activeTextures);
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
		var location = attributes.get(attribute);
		if (location == null) {
			location = gl.getAttribLocation(program, attribute);
			attributes.set(attribute, location);
		}
		return location;
	}
	
	public function getUniformLocation(uniform:String):GLUniformLocation {
		if (program == null) {
			throw "Shader isn't initialized";
		}
		var location = uniforms.get(uniform);
		if (location == null) {
			location = gl.getUniformLocation(program, uniform);
			uniforms.set(uniform, location);
		}
		return location;
	}
	
	public function enableVertexAttribute(attribute:VertexAttribute, stride:Int, offset:Int) {
		var location = getAttribLocation(attribute.name);
		if (location >= 0) {
			gl.enableVertexAttribArray(location);
			gl.vertexAttribPointer(location, attribute.components, attribute.type, attribute.normalized, stride, offset * 4);
		}
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

		if (va == currentVertexArray) return;
		
 		var offset = 0;
		var stride = va.stride;
		
		if (currentVertexArray != null && va.attributes == currentVertexArray.attributes) {
			for (attribute in va.attributes) {
				if (attribute.enabled) {
					var location = getAttribLocation(attribute.name);
					if (location >= 0) {
						gl.vertexAttribPointer(location, attribute.components, attribute.type, attribute.normalized, stride, offset * 4);
					}
					offset += attribute.elements;
				}
			}
 		} else {
			for (attribute in va.attributes) {
				if (attribute.enabled) {
					enableVertexAttribute(attribute, stride, offset);
					offset += attribute.elements;
				} else {
					disableVertexAttribute(attribute, true);
				}
			}
		} 

		currentVertexArray = va;
	}
	
	public function unbindVertexArray(va:VertexArray) {
		for (attribute in va.attributes) {
			disableVertexAttribute(attribute, false);
		}
		currentVertexArray = null;
	}
	
	
	public static function compileProgram(gl:GLRenderContext, vertexSrc:String, fragmentSrc:String):GLProgram {
		
		var cache = ShaderManager.compiledShadersCache;
		var key = Md5.encode(vertexSrc + fragmentSrc);
		
		if (cache.exists(key)) {
			
			return cache.get(key);
			
		}
		
		var vertexShader = Shader.compileShader(gl, vertexSrc, gl.VERTEX_SHADER);
		var fragmentShader = Shader.compileShader(gl, fragmentSrc, gl.FRAGMENT_SHADER);
		var program = gl.createProgram();
		
		if (vertexShader != null && fragmentShader != null) {
			gl.attachShader(program, vertexShader);
			gl.attachShader(program, fragmentShader);
			gl.bindAttribLocation(program, 0, Attrib.Position);
			gl.bindAttribLocation(program, 1, Attrib.TexCoord);
			gl.bindAttribLocation(program, 2, Attrib.Color);
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
	
	static function compileShader(gl:GLRenderContext, shaderSrc:String, type:Int):GLShader {
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
	
	public function uniform1i (uniform:GLUniformLocation, i:Int):Void {
		
		if (uniform == null) return;

		var cached = uniform1iCache.get (uniform);
		
		if (cached == i) {
			
			return;
			
		} 
		
		gl.uniform1i (uniform, i);
		
		uniform1iCache.set (uniform, i);

	}
	
	public function uniform2f (uniform:GLUniformLocation, x:Float, y:Float):Void {

		if (uniform == null) return;

		var cached = uniform2fCache.get (uniform);

		if (cached == null) {

			cached = new Vector2 ();
			uniform2fCache.set (uniform, cached);

		} else if (cached.x == x && cached.y == y) {

			return;

		}

		gl.uniform2f (uniform, x, y);

		cached.x = x;
		cached.y = y;

	}

	public function uniform4f (uniform:GLUniformLocation, x:Float, y:Float, z:Float, w:Float):Void {
		
		if (uniform == null) return;

		var cached = uniform4fCache.get (uniform);
		
		if (cached == null) {
			
			cached = new Vector4 ();
			uniform4fCache.set (uniform, cached);
			
		} else if (cached.x == x && cached.y == y && cached.z == z && cached.w == w) {
			
			return;
			
		}

		
		gl.uniform4f (uniform, x, y, z, w);
		
		cached.x = x;
		cached.y = y;
		cached.z = z;
		cached.w = w;
		
	}
	
	public function uniformMatrix3fv (uniform:GLUniformLocation, transpose:Bool, matrix:Matrix):Void {
		
		if (uniform == null) return;
		
		var cached = uniformMatrix3fCache.get (uniform);
		
		if (cached == null) {
			
			cached = new Matrix ();
			uniformMatrix3fCache.set (uniform, cached);
			
		} else if (matrix.equals (cached)) {
			
			return;
			
		}
		
		gl.uniformMatrix3fv (uniform, transpose, @:privateAccess matrix.toArray (true));
		
		cached.copyFrom (matrix);
		
	}
	
	public static function resetCache() {
		
		currentVertexArray = null;
		
	}

}
