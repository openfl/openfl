package openfl.display; #if (!flash && !openfl_legacy)


import lime.graphics.GLRenderContext;
import openfl._internal.renderer.opengl.shaders2.Shader in InternalShader;
import openfl.geom.Matrix;
import openfl.gl.GL;

using StringTools;

class Shader {

	static var uniformRegex = ~/^\s*uniform\s+(sampler(?:2D|Cube)|[bi]?vec[234]|float|int|bool|mat[234])\s+(\w+)\s*(?:\[(\d+)\])?\s*;.*$/gmi;
	
	/**
	 * The object's texture.
	 */
	static public var uSampler = DefaultUniform.Sampler;
	/**
	 * The colorMultiplier values from the transfrom.colorTransform of the object.
	 */
	static public var uColorMultiplier = DefaultUniform.ColorMultiplier;
	/**
	 * The colorOffset values from the transfrom.colorTransform of the object.
	 */
	static public var uColorOffset = DefaultUniform.ColorOffset;
	/**
	 * The texture coordinate.
	 */
	static public var vTexCoord = DefaultVarying.TexCoord;
	/**
	 * The tint and alpha values.
	 */
	static public var vColor = DefaultVarying.Color;
	
	static var header = [
		'uniform sampler2D ${Shader.uSampler};',
		'uniform vec4 ${Shader.uColorMultiplier};',
		'uniform vec4 ${Shader.uColorOffset};',
		'varying vec2 ${Shader.vTexCoord};',
		'varying vec4 ${Shader.vColor};',
		
		'vec4 colorTransform(const vec4 color, const vec4 tint, const vec4 multiplier, const vec4 offset) {',
		'   vec4 unmultiply = vec4(color.rgb / color.a, color.a);',
		'   vec4 result = unmultiply * tint * multiplier;',
		'   result = result + offset;',
		'   result = clamp(result, 0., 1.);',
		'   result = vec4(result.rgb * result.a, result.a);',
		'   return result;',
		'}',
	];
	
	/**
	 * The shader precision. It can be HIGH, MEDIUM or LOW. Defaults to MEDIUM
	 */
	public var precision:GLShaderPrecision = MEDIUM;
	/**
	 * The code of the shader. It can be changed at any time.
	 */
	public var fragmentCode(default, set):String;
	/**
	 * A map of <String, GLShaderParameter>
	 */
	public var data(default, null):GLShaderData;
	/**
	 * Overrides the default repetition applied to the object's texture.
	 * By default: NONE
	 */
	public var repeatX:RepeatMode = NONE;
	/**
	 * Overrides the default repetition applied to the object's texture.
	 * By default: NONE
	 */
	public var repeatY:RepeatMode = NONE;
	/**
	 * Overrides the default smooth applied to the object's texture.
	 * By default: not overriden
	 */
	public var smooth:Null<Bool>;
	
	private var __dirty:Bool = true;
	private var __fragmentCode:String;
	private var __shader:InternalShader;
	
	public function new(fragmentCode:String, ?precision:GLShaderPrecision = MEDIUM) {
		this.precision = precision;
		data = new Map();
		this.fragmentCode = fragmentCode;
	}
	
	private function __init(gl:GLRenderContext) {
		var dirty = __dirty;
		if (dirty) {
			if (__shader != null) {
				__shader.destroy();
			}
			__shader = new InternalShader(gl);
			__shader.vertexSrc = openfl._internal.renderer.opengl.shaders2.DefaultShader.VERTEX_SRC;
			__shader.fragmentString = __fragmentCode;
			__dirty = false;
		}
		
		__shader.init(dirty);
	}
	
	private function __buildFragmentCode(code:String) {
		var output = [];
		
		output.push('#ifdef GL_ES');
		output.push(switch(precision) {
			case HIGH: 		'precision highp float;';
			case MEDIUM: 	'precision mediump float;';
			case _: 		'precision lowp float;';
		});
		output.push('#endif');
		
		// TODO extensions
		
		output = output.concat(header);
		
		output.push(code);
		
		return output.join("\n");
	}
	
	private function __parseUniforms(code:String) {
		var src = code.split("\n");
		var us:Array<String>;
		var type:String;
		var name:String;
		var array:Null<Int>;
		var skip = [uSampler, uColorMultiplier, uColorOffset];
		for (s in src) {
			if (uniformRegex.match(s)) {
				name = uniformRegex.matched(2);
				if (skip.indexOf(name) > -1) continue;
				
				type = uniformRegex.matched(1);
				array = Std.parseInt(uniformRegex.matched(3));
				data.set(name, new GLShaderParameter(type, array) );
			}
		}		
	}
	
	private function set_fragmentCode(value:String) {
		var code = __buildFragmentCode(value);
		
		if (code == __fragmentCode) {
			return fragmentCode;
		} else {
			__dirty = true;
			__fragmentCode = code;
			__parseUniforms(code);
			return fragmentCode = value;
		}
	}
	
}

class GLShaderParameter {
	/**
	 * The raw type as expressed in the glsl code
	 * For example: vec4 will be "vec4"
	 */
	public var type(default, null):String;
	/**
	 * The size of the value.
	 * For example: vec4 will be 4
	 */
	public var size(default, null):Int = 0;
	/**
	 * The size of the array.
	 * For example: uniform vec2 uExample[2]; will be 2
	 */
	public var arraySize(default, null):Int = 0;
	/**
	 * The value of the parameter when the type isn't a sampler2D
	 */
	public var value(default, set):Array<Float> = [];
	/**
	 * The BitmapData to be used when the type is a sampler2D
	 */
	public var bitmap(default, set):BitmapData;
	/**
	 * Enables linear smoothing to the BitmapData
	 */
	public var smooth:Bool = false;
	/**
	 * Controls repetition in the x axis for the BitmapData
	 */
	public var repeatX:RepeatMode = NONE;
	/**
	 * Controls repetition in the y axis for the BitmapData
	 */
	public var repeatY:RepeatMode = NONE;
	/**
	 * Enables matrices to be transposed. Only used in mat* types.
	 */
	public var transpose:Bool = false;
	
	private var internalType:GLShaderParameterInternal = NONE;
	
	public function new(type:String, arraySize:Null<Int>) {
		this.type = type;
		this.arraySize = arraySize == null ? 0 : arraySize;
		
		init();
	}
	
	private function init() {
		switch(type) {
			case "bool": 
				internalType = INT;
				size = 1;
			case "int": 
				internalType = INT;
				size = 1;
			case "float":
				internalType = FLOAT;
				size = 1;
			case v if (v.indexOf("vec") > -1):
				if(type.startsWith("b") || type.startsWith("i"))
					internalType = INT;
				else
					internalType = FLOAT;
				
				var s = Std.parseInt(type.charAt(type.length - 1));
				size = s;
			case m if (m.indexOf("mat") > -1):
				internalType = MAT;
				var s = Std.parseInt(type.charAt(type.length - 1));
				size = s;
			case "sampler2D" | "samplerCube":
				internalType = SAMPLER;
				size = 0;
			case _: 
				internalType = NONE;
				trace("Can't initialize value for type " + type);
				
		}
	}
	
	private inline function set_value(v) {
		if (internalType == SAMPLER) throw "This parameter doesn't accept a value, use bitmap instead";
		return value = v;
	}
	private inline function set_bitmap(v) {
		if (internalType != SAMPLER) throw "This parameter doesn't accept a bitmap, use value instead";
		return bitmap = v;
	}
}

@:enum abstract GLShaderPrecision(Int) {
	var LOW 	= 0;
	var MEDIUM 	= 1;
	var HIGH 	= 2;
}


@:enum private abstract GLShaderParameterInternal(Int) {
	var NONE 	= 0;
	var INT 	= 1;
	var FLOAT 	= 2;
	var MAT 	= 3;
	var SAMPLER = 4;
}

@:enum abstract RepeatMode(Int) to Int {
	var NONE 	= GL.CLAMP_TO_EDGE;
	var REPEAT 	= GL.REPEAT;
	var MIRROR 	= GL.MIRRORED_REPEAT;
}

typedef GLShaderData = Map<String, GLShaderParameter>;

private typedef DefaultUniform = openfl._internal.renderer.opengl.shaders2.DefaultShader.Uniform;
private typedef DefaultVarying = openfl._internal.renderer.opengl.shaders2.DefaultShader.Varying;

#else
typedef Shader = flash.display.Shader;
#end