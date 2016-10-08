package openfl.display; #if !macro


import lime.graphics.GLRenderContext;
import lime.graphics.opengl.GLProgram;
import lime.utils.Float32Array;
import lime.utils.GLUtils;
import openfl.utils.ByteArray;

@:access(openfl.display.ShaderInput)
@:access(openfl.display.ShaderParameter)

#if !display
@:autoBuild(openfl.display.Shader.build())
@:build(openfl.display.Shader.build())
#end


class Shader {
	
	
	public var byteCode (null, default):ByteArray;
	public var data:ShaderData;
	public var glFragmentSource:String;
	public var glProgram:GLProgram;
	public var glVertexSource:String;
	public var precisionHint:ShaderPrecision;
	
	private var gl:GLRenderContext;
	
	private var __isUniform:Map<String, Bool>;
	private var __inputBitmapData:Array<ShaderInput<BitmapData>>;
	private var __paramBool:Array<ShaderParameter<Bool>>;
	private var __paramFloat:Array<ShaderParameter<Float>>;
	private var __paramInt:Array<ShaderParameter<Int>>;
	private var __uniformMatrix2:Float32Array;
	private var __uniformMatrix3:Float32Array;
	private var __uniformMatrix4:Float32Array;
	
	
	@:glFragmentSource(
		
		"varying float vAlpha;
		varying vec2 vTexCoord;
		uniform sampler2D uImage0;
		
		void main(void) {
			
			vec4 color = texture2D (uImage0, vTexCoord);
			
			if (color.a == 0.0) {
				
				gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);
				
			} else {
				
				gl_FragColor = vec4 (color.rgb / color.a, color.a * vAlpha);
				
			}
			
		}"
		
	)
	
	
	@:glVertexSource(
		
		"attribute float aAlpha;
		attribute vec4 aPosition;
		attribute vec2 aTexCoord;
		varying float vAlpha;
		varying vec2 vTexCoord;
		
		uniform mat4 uMatrix;
		
		void main(void) {
			
			vAlpha = aAlpha;
			vTexCoord = aTexCoord;
			gl_Position = uMatrix * aPosition;
			
		}"
		
	)
	
	
	public function new (code:ByteArray = null) {
		
		byteCode = code;
		precisionHint = FULL;
		
		__init ();
		
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
		
		#if desktop
		gl.disable (gl.TEXTURE_2D);
		#end
		
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
		
		#if desktop
		if (textureCount > 0) {
			
			gl.enable (gl.TEXTURE_2D);
			
		}
		#end
		
	}
	
	
	private function __init ():Void {
		
		if (data == null) {
			
			data = cast new ShaderData (null);
			
		}
		
		if (glFragmentSource != null && glVertexSource != null) {
			
			__initGL ();
			
		}
		
	}
	
	
	private function __initGL ():Void {
		
		if (__inputBitmapData == null) {
			
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
		
		if (gl != null && glProgram == null && glFragmentSource != null && glVertexSource != null) {
			
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
		
		var index:Dynamic = 0;
		
		for (parameter in __paramBool) {
			
			var value = parameter.value;
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
		
		for (parameter in __paramFloat) {
			
			var value = parameter.value;
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
						
						gl.uniformMatrix2fv (index, false, __uniformMatrix2);
					
					//case MATRIX2X3:
					//case MATRIX2X4:
					//case MATRIX3X2:
					
					case MATRIX3X3:
						
						for (i in 0...9) {
							
							__uniformMatrix3[i] = value[i];
							
						}
						
						gl.uniformMatrix3fv (index, false, __uniformMatrix3);
					
					//case MATRIX3X4:
					//case MATRIX4X2:
					//case MATRIX4X3:
					
					case MATRIX4X4:
						
						for (i in 0...16) {
							
							__uniformMatrix4[i] = value[i];
							
						}
						
						gl.uniformMatrix4fv (index, false, __uniformMatrix4);
					
					default:
					
				}
				
			} else if (!__isUniform.get (parameter.name)) {
				
				gl.enableVertexAttribArray (parameter.index);
				
			}
			
		}
		
		for (parameter in __paramInt) {
			
			var value = parameter.value;
			
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
	
	
}


#else


import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
using haxe.macro.ExprTools;
using haxe.macro.Tools;


class Shader {
	
	
	private static var defaultFields = new Map<String, Bool> ();
	
	
	public static function build ():Array<Field> {
		
		var fields = Context.getBuildFields ();
		
		var glFragmentSource = null;
		var glVertexSource = null;
		
		for (field in fields) {
			
			for (meta in field.meta) {
				
				switch (meta.name) {
					
					case "glFragmentSource", ":glFragmentSource":
						
						glFragmentSource = meta.params[0].getValue ();
					
					case "glVertexSource", ":glVertexSource":
						
						glVertexSource = meta.params[0].getValue ();
					
					default:
					
				}
				
			}
			
		}
		
		if (glVertexSource != null || glFragmentSource != null) {
			
			var pos = Context.currentPos ();
			var localClass = Context.getLocalClass ().get ();
			
			var isBaseClass = (localClass.name == "Shader" && localClass.pack.length == 2 && localClass.pack[0] == "openfl" && localClass.pack[1] == "display");
			
			var shaderDataFields = new Array<Field> ();
			var dataClassName;
			
			processFields (glVertexSource, "attribute", shaderDataFields, isBaseClass, pos);
			processFields (glVertexSource, "uniform", shaderDataFields, isBaseClass, pos);
			processFields (glFragmentSource, "uniform", shaderDataFields, isBaseClass, pos);
			
			if (shaderDataFields.length > 0) {
				
				dataClassName = "_" + localClass.name + "_ShaderData";
				
				Context.defineType ({
					
					pos: pos,
					pack: localClass.pack,
					name: dataClassName,
					kind: TDClass ({ pack: [ "openfl", "display" ], name: isBaseClass ? "ShaderData" : "_Shader_ShaderData", params: [] }, null, false),
					fields: shaderDataFields,
					params: [],
					meta: [ { name: ":dox", params: [ macro hide ], pos: pos }, { name: ":noCompletion", pos: pos }, { name: ":hack", pos: pos } ]
					
				});
				
			} else {
				
				dataClassName = "_Shader_ShaderData";
				
			}
			
			for (field in fields) {
				
				switch (field.name) {
					
					case "new":
						
						var block = switch (field.kind) {
							
							case FFun (f):
								
								if (f.expr == null) null;
								
								switch (f.expr.expr) {
									
									case EBlock (e): e;
									default: null;
									
								}
							
							default: null;
							
						}
						
						if (glVertexSource != null) block.unshift (macro if (glVertexSource == null) glVertexSource = $v{glVertexSource});
						if (glFragmentSource != null) block.unshift (macro if (glFragmentSource == null) glFragmentSource = $v{glFragmentSource});
					
					case "data":
						
						field.kind = FVar (TPath ({ name: dataClassName, pack: localClass.pack, params: [] }), Context.parse ("new " + dataClassName + " (null)", pos));
					
					default:
					
				}
				
			}
			
		}
		
		return fields;
		
	}
	
	
	private static function processFields (source:String, storageType:String, fields:Array<Field>, isBaseClass:Bool, pos:Position):Void {
		
		if (source == null) return;
		
		var lastMatch = 0, position, regex, name, type;
		
		if (storageType == "uniform") {
			
			regex = ~/uniform ([A-Za-z0-9]+) ([A-Za-z0-9]+)/;
			
		} else {
			
			regex = ~/attribute ([A-Za-z0-9]+) ([A-Za-z0-9]+)/;
			
		}
		
		while (regex.matchSub (source, lastMatch)) {
			
			type = regex.matched (1);
			name = regex.matched (2);
			
			if (isBaseClass) {
				
				defaultFields.set (name, true);
				
			} else if (defaultFields.exists (name)) {
				
				position = regex.matchedPos ();
				lastMatch = position.pos + position.len;
				continue;
				
			}
			
			if (StringTools.startsWith (type, "sampler")) {
				
				fields.push ( { name: name, access: [ APublic ], kind: FVar (macro :openfl.display.ShaderInput<openfl.display.BitmapData>), pos: pos } );
				
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
						
						fields.push ( { name: name, access: [ APublic ], kind: FVar (macro :openfl.display.ShaderParameter<Bool>), pos: pos } );
					
					case INT, INT2, INT3, INT4:
						
						fields.push ( { name: name, access: [ APublic ], kind: FVar (macro :openfl.display.ShaderParameter<Int>), pos: pos } );
					
					default:
						
						fields.push ( { name: name, access: [ APublic ], kind: FVar (macro :openfl.display.ShaderParameter<Float>), pos: pos } );
					
				}
				
			}
			
			position = regex.matchedPos ();
			lastMatch = position.pos + position.len;
			
		}
		
	}
	
	
}


#end