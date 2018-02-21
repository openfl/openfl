package openfl.display;


import lime.graphics.GLRenderContext;
import lime.graphics.opengl.GLProgram;
import lime.utils.Float32Array;
import lime.utils.GLUtils;
import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.ShaderInput)
@:access(openfl.display.ShaderParameter)

#if (!display && !macro)
@:autoBuild(openfl._internal.macros.ShaderMacro.build())
@:build(openfl._internal.macros.ShaderMacro.build())
#end


class Shader {
	
	
	public var byteCode (null, default):ByteArray;
	public var data (get, set):ShaderData;
	public var glFragmentSource (get, set):String;
	public var glProgram (default, null):GLProgram;
	public var glVertexSource (get, set):String;
	public var precisionHint:ShaderPrecision;
	
	private var gl:GLRenderContext;
	
	private var __data:ShaderData;
	private var __glFragmentSource:String;
	private var __glSourceDirty:Bool;
	private var __glVertexSource:String;
	private var __isUniform:Map<String, Bool>;
	private var __inputBitmapData:Array<ShaderInput<BitmapData>>;
	private var __numPasses:Int;
	private var __paramBool:Array<ShaderParameter<Bool>>;
	private var __paramFloat:Array<ShaderParameter<Float>>;
	private var __paramInt:Array<ShaderParameter<Int>>;
	private var __uniformMatrix2:Float32Array;
	private var __uniformMatrix3:Float32Array;
	private var __uniformMatrix4:Float32Array;
	
	
	#if openfljs
	private static function __init__ () {
		
		untyped Object.defineProperties (Shader.prototype, {
			"data": { get: untyped __js__ ("function () { return this.get_data (); }"), set: untyped __js__ ("function (v) { return this.set_data (v); }") },
			"glFragmentSource": { get: untyped __js__ ("function () { return this.get_glFragmentSource (); }"), set: untyped __js__ ("function (v) { return this.set_glFragmentSource (v); }") },
			"glVertexSource": { get: untyped __js__ ("function () { return this.get_glVertexSource (); }"), set: untyped __js__ ("function (v) { return this.set_glVertexSource (v); }") },
		});
		
	}
	#end
	
	
	@:glFragmentSource(
		
		#if emscripten
		"varying float vAlpha;
		varying mat4 vColorMultipliers;
		varying vec4 vColorOffsets;
		varying vec2 vTexCoord;
		
		uniform bool uColorTransform;
		uniform sampler2D uImage0;
		
		void main(void) {
			
			vec4 color = texture2D (uImage0, vTexCoord);
			
			if (color.a == 0.0) {
				
				gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);
				
			} else if (uColorTransform) {
				
				color = vec4 (color.rgb / color.a, color.a);
				color = vColorOffsets + (color * vColorMultipliers);
				
				gl_FragColor = vec4 (color.bgr * color.a * vAlpha, color.a * vAlpha);
				
			} else {
				
				gl_FragColor = color.bgra * vAlpha;
				
			}
			
		}"
		#else
		"varying float vAlpha;
		varying vec4 vColorMultipliers0;
		varying vec4 vColorMultipliers1;
		varying vec4 vColorMultipliers2;
		varying vec4 vColorMultipliers3;
		varying vec4 vColorOffsets;
		varying vec2 vTexCoord;
		
		uniform bool uColorTransform;
		uniform sampler2D uImage0;
		
		void main(void) {
			
			vec4 color = texture2D (uImage0, vTexCoord);
			
			if (color.a == 0.0) {
				
				gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);
				
			} else if (uColorTransform) {
				
				color = vec4 (color.rgb / color.a, color.a);
				
				mat4 colorMultiplier;
				colorMultiplier[0] = vColorMultipliers0;
				colorMultiplier[1] = vColorMultipliers1;
				colorMultiplier[2] = vColorMultipliers2;
				colorMultiplier[3] = vColorMultipliers3;
				
				color = vColorOffsets + (color * colorMultiplier);
				
				if (color.a > 0.0) {
					
					gl_FragColor = vec4 (color.rgb * color.a * vAlpha, color.a * vAlpha);
					
				} else {
					
					gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);
					
				}
				
			} else {
				
				gl_FragColor = color * vAlpha;
				
			}
			
		}"
		#end
		
	)
	
	
	@:glVertexSource(
		
		"attribute float aAlpha;
		attribute vec4 aColorMultipliers0;
		attribute vec4 aColorMultipliers1;
		attribute vec4 aColorMultipliers2;
		attribute vec4 aColorMultipliers3;
		attribute vec4 aColorOffsets;
		attribute vec4 aPosition;
		attribute vec2 aTexCoord;
		varying float vAlpha;
		varying vec4 vColorMultipliers0;
		varying vec4 vColorMultipliers1;
		varying vec4 vColorMultipliers2;
		varying vec4 vColorMultipliers3;
		varying vec4 vColorOffsets;
		varying vec2 vTexCoord;
		
		uniform mat4 uMatrix;
		uniform bool uColorTransform;
		
		void main(void) {
			
			vAlpha = aAlpha;
			vTexCoord = aTexCoord;
			
			if (uColorTransform) {
				
				vColorMultipliers0 = aColorMultipliers0;
				vColorMultipliers1 = aColorMultipliers1;
				vColorMultipliers2 = aColorMultipliers2;
				vColorMultipliers3 = aColorMultipliers3;
				vColorOffsets = aColorOffsets;
				
			}
			
			gl_Position = uMatrix * aPosition;
			
		}"
		
	)
	
	
	public function new (code:ByteArray = null) {
		
		byteCode = code;
		precisionHint = FULL;
		
		__glSourceDirty = true;
		__numPasses = 1;
		
	}
	
	
	private function __disable ():Void {
		
		if (glProgram != null) {
			
			__disableGL ();
			
		}
		
	}
	
	
	private function __disableGL ():Void {
		
		if (data.uImage0 != null) {
			
			data.uImage0.input = null;
			
		}
		
		for (parameter in __paramBool) {
			
			gl.disableVertexAttribArray (parameter.index);
			
		}
		
		for (parameter in __paramFloat) {
			
			gl.disableVertexAttribArray (parameter.index);
			
		}
		
		for (parameter in __paramInt) {
			
			gl.disableVertexAttribArray (parameter.index);
			
		}
		
		gl.bindBuffer (gl.ARRAY_BUFFER, null);
		gl.bindTexture (gl.TEXTURE_2D, null);
		
		if (gl.type == OPENGL) {
			
			gl.disable (gl.TEXTURE_2D);
			
		}
		
	}
	
	
	private function __enable ():Void {
		
		__init ();
		
		if (glProgram != null) {
			
			__enableGL ();
			
		}
		
	}
	
	
	private function __enableGL ():Void {
		
		var textureCount = 0;
		
		for (input in __inputBitmapData) {
			
			gl.uniform1i (input.index, textureCount);
			textureCount++;
			
		}
		
		if (gl.type == OPENGL && textureCount > 0) {
			
			gl.enable (gl.TEXTURE_2D);
			
		}
		
	}
	
	
	private function __init ():Void {
		
		if (__data == null) {
			
			__data = cast new ShaderData (null);
			
		}
		
		if (__glFragmentSource != null && __glVertexSource != null && (glProgram == null || __glSourceDirty)) {
			
			__initGL ();
			
		}
		
	}
	
	
	private function __initGL ():Void {
		
		if (__glSourceDirty || __isUniform == null) {
			
			__glSourceDirty = false;
			glProgram = null;
			
			__isUniform = new Map ();
			
			__inputBitmapData = new Array ();
			__paramBool = new Array ();
			__paramFloat = new Array ();
			__paramInt = new Array ();
			
			__uniformMatrix2 = new Float32Array (4);
			__uniformMatrix3 = new Float32Array (9);
			__uniformMatrix4 = new Float32Array (16);
			
			__processGLData (glVertexSource, "attribute");
			__processGLData (glVertexSource, "uniform");
			__processGLData (glFragmentSource, "uniform");
			
		}
		
		if (gl != null && glProgram == null) {
			
			var fragment = 
				
				"#ifdef GL_ES
				precision " + (precisionHint == FULL ? "mediump" : "lowp") + " float;
				#endif
				" + glFragmentSource;
			
			glProgram = GLUtils.createProgram (glVertexSource, fragment);
			
			if (glProgram != null) {
				
				for (input in __inputBitmapData) {
					
					if (__isUniform.get (input.name)) {
						
						input.index = gl.getUniformLocation (glProgram, input.name);
						
					} else {
						
						input.index = gl.getAttribLocation (glProgram, input.name);
						
					}
					
				}
				
				for (parameter in __paramBool) {
					
					if (__isUniform.get (parameter.name)) {
						
						parameter.index = gl.getUniformLocation (glProgram, parameter.name);
						
					} else {
						
						parameter.index = gl.getAttribLocation (glProgram, parameter.name);
						
					}
					
				}
				
				for (parameter in __paramFloat) {
					
					if (__isUniform.get (parameter.name)) {
						
						parameter.index = gl.getUniformLocation (glProgram, parameter.name);
						
					} else {
						
						parameter.index = gl.getAttribLocation (glProgram, parameter.name);
						
					}
					
				}
				
				for (parameter in __paramInt) {
					
					if (__isUniform.get (parameter.name)) {
						
						parameter.index = gl.getUniformLocation (glProgram, parameter.name);
						
					} else {
						
						parameter.index = gl.getAttribLocation (glProgram, parameter.name);
						
					}
					
				}
				
			}
			
		}
		
	}
	
	
	private function __processGLData (source:String, storageType:String):Void {
		
		var lastMatch = 0, position, regex, name, type;
		
		if (storageType == "uniform") {
			
			regex = ~/uniform ([A-Za-z0-9]+) ([A-Za-z0-9]+)/;
			
		} else {
			
			regex = ~/attribute ([A-Za-z0-9]+) ([A-Za-z0-9]+)/;
			
		}
		
		while (regex.matchSub (source, lastMatch)) {
			
			type = regex.matched (1);
			name = regex.matched (2);
			
			if (StringTools.startsWith (type, "sampler")) {
				
				var input = new ShaderInput<BitmapData> ();
				input.name = name;
				__inputBitmapData.push (input);
				Reflect.setField (data, name, input);
				
			} else {
				
				var parameterType:ShaderParameterType = switch (type) {
					
					case "bool": BOOL;
					case "double", "float": FLOAT;
					case "int", "uint": INT;
					case "bvec2": BOOL2;
					case "bvec3": BOOL3;
					case "bvec4": BOOL4;
					case "ivec2", "uvec2": INT2;
					case "ivec3", "uvec3": INT3;
					case "ivec4", "uvec4": INT4;
					case "vec2", "dvec2": FLOAT2;
					case "vec3", "dvec3": FLOAT3;
					case "vec4", "dvec4": FLOAT4;
					case "mat2", "mat2x2": MATRIX2X2;
					case "mat2x3": MATRIX2X3;
					case "mat2x4": MATRIX2X4;
					case "mat3x2": MATRIX3X2;
					case "mat3", "mat3x3": MATRIX3X3;
					case "mat3x4": MATRIX3X4;
					case "mat4x2": MATRIX4X2;
					case "mat4x3": MATRIX4X3;
					case "mat4", "mat4x4": MATRIX4X4;
					default: null;
					
				}
				
				switch (parameterType) {
					
					case BOOL, BOOL2, BOOL3, BOOL4:
						
						var parameter = new ShaderParameter<Bool> ();
						parameter.name = name;
						parameter.type = parameterType;
						__paramBool.push (parameter);
						Reflect.setField (data, name, parameter);
					
					case INT, INT2, INT3, INT4:
						
						var parameter = new ShaderParameter<Int> ();
						parameter.name = name;
						parameter.type = parameterType;
						__paramInt.push (parameter);
						Reflect.setField (data, name, parameter);
					
					default:
						
						var parameter = new ShaderParameter<Float> ();
						parameter.name = name;
						parameter.type = parameterType;
						__paramFloat.push (parameter);
						Reflect.setField (data, name, parameter);
					
				}
				
			}
			
			__isUniform.set (name, storageType == "uniform");
			
			position = regex.matchedPos ();
			lastMatch = position.pos + position.len;
			
		}
		
	}
	
	
	private function __update ():Void {
		
		if (glProgram != null) {
			
			__updateGL ();
			
		}
		
	}
	
	
	private function __updateGL ():Void {
		
		var textureCount = 0;
		
		for (input in __inputBitmapData) {
			
			if (input.input != null) {
				
				gl.activeTexture (gl.TEXTURE0 + textureCount);
				gl.bindTexture (gl.TEXTURE_2D, input.input.getTexture (gl));
				
				if (input.smoothing) {
					
					gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
					gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
					
				} else {
					
					gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
					gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
					
				}
				
			}
			
			textureCount++;
			
		}
		
		var value, index;
		
		for (parameter in __paramBool) {
			
			value = parameter.value;
			index = parameter.index;
			
			if (value != null) {
				
				switch (parameter.type) {
					
					case BOOL:
						
						gl.uniform1i (index, value[0] ? 1 : 0);
					
					case BOOL2:
						
						gl.uniform2i (index, value[0] ? 1 : 0, value[1] ? 1 : 0);
					
					case BOOL3:
						
						gl.uniform3i (index, value[0] ? 1 : 0, value[1] ? 1 : 0, value[2] ? 1 : 0);
					
					case BOOL4:
						
						gl.uniform4i (index, value[0] ? 1 : 0, value[1] ? 1 : 0, value[2] ? 1 : 0, value[3] ? 1 : 0);
					
					default:
					
				}
				
			} else if (!__isUniform.get (parameter.name)) {
				
				gl.enableVertexAttribArray (parameter.index);
				
			}
			
		}
		
		var value, index;
		
		for (parameter in __paramFloat) {
			
			value = parameter.value;
			index = parameter.index;
			
			if (value != null) {
				
				switch (parameter.type) {
					
					case FLOAT:
						
						gl.uniform1f (index, value[0]);
					
					case FLOAT2:
						
						gl.uniform2f (index, value[0], value[1]);
					
					case FLOAT3:
						
						gl.uniform3f (index, value[0], value[1], value[2]);
					
					case FLOAT4:
						
						gl.uniform4f (index, value[0], value[1], value[2], value[3]);
					
					case MATRIX2X2:
						
						for (i in 0...4) {
							
							__uniformMatrix2[i] = value[i];
							
						}
						
						gl.uniformMatrix2fv (index, 1, false, __uniformMatrix2);
					
					//case MATRIX2X3:
					//case MATRIX2X4:
					//case MATRIX3X2:
					
					case MATRIX3X3:
						
						for (i in 0...9) {
							
							__uniformMatrix3[i] = value[i];
							
						}
						
						gl.uniformMatrix3fv (index, 1, false, __uniformMatrix3);
					
					//case MATRIX3X4:
					//case MATRIX4X2:
					//case MATRIX4X3:
					
					case MATRIX4X4:
						
						for (i in 0...16) {
							
							__uniformMatrix4[i] = value[i];
							
						}
						
						gl.uniformMatrix4fv (index, 1, false, __uniformMatrix4);
					
					default:
					
				}
				
			} else if (!__isUniform.get (parameter.name)) {
				
				gl.enableVertexAttribArray (parameter.index);
				
				switch (parameter.type) {
					
					case MATRIX2X2:
						
						gl.enableVertexAttribArray (parameter.index + 1);
					
					case MATRIX3X3:
						
						gl.enableVertexAttribArray (parameter.index + 1);
						gl.enableVertexAttribArray (parameter.index + 2);
					
					case MATRIX4X4:
						
						gl.enableVertexAttribArray (parameter.index + 1);
						gl.enableVertexAttribArray (parameter.index + 2);
						gl.enableVertexAttribArray (parameter.index + 3);
					
					default:
					
				}
				
			}
			
		}
		
		var value, index;
		
		for (parameter in __paramInt) {
			
			value = parameter.value;
			index = parameter.index;
			
			if (value != null) {
				
				switch (parameter.type) {
					
					case INT:
						
						gl.uniform1i (index, value[0]);
					
					case INT2:
						
						gl.uniform2i (index, value[0], value[1]);
					
					case INT3:
						
						gl.uniform3i (index, value[0], value[1], value[2]);
					
					case INT4:
						
						gl.uniform4i (index, value[0], value[1], value[2], value[3]);
					
					default:
					
				}
				
			} else if (!__isUniform.get (parameter.name)) {
				
				gl.enableVertexAttribArray (parameter.index);
				
			}
			
		}
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_data ():ShaderData {
		
		if (__glSourceDirty || __data == null) {
			
			__init ();
			
		}
		
		return __data;
		
	}
	
	
	private function set_data (value:ShaderData):ShaderData {
		
		return __data = cast value;
		
	}
	
	
	private function get_glFragmentSource ():String {
		
		return __glFragmentSource;
		
	}
	
	
	private function set_glFragmentSource (value:String):String {
		
		if (value != __glFragmentSource) {
			
			__glSourceDirty = true;
			
		}
		
		return __glFragmentSource = value;
		
	}
	
	
	private function get_glVertexSource ():String {
		
		return __glVertexSource;
		
	}
	
	
	private function set_glVertexSource (value:String):String {
		
		if (value != __glVertexSource) {
			
			__glSourceDirty = true;
			
		}
		
		return __glVertexSource = value;
		
	}
	
	
}
