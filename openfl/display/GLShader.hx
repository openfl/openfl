package openfl.display;


import lime.graphics.GLRenderContext;
import openfl._internal.renderer.opengl.shaders2.Shader in InternalShader;
import openfl.geom.Matrix;

using StringTools;

@:access(openfl._internal.renderer.opengl.shaders2.Shader)
class GLShader {

	static var uniformRegex = ~/^\s*uniform\s+(sampler(?:2D|Cube)|[bi]?vec[234]|float|int|bool|mat[234])\s+(\w+)\s*(?:\[(\d+)\])?\s*;.*$/gmi;
	
	static public var uSampler = DefaultUniform.Sampler;
	static public var uColorMultiplier = DefaultUniform.ColorMultiplier;
	static public var uColorOffset = DefaultUniform.ColorOffset;
	static public var vTexCoord = DefaultVarying.TexCoord;
	static public var vColor = DefaultVarying.Color;
	
	static var header = [
		'uniform sampler2D ${GLShader.uSampler};',
		'uniform vec4 ${GLShader.uColorMultiplier};',
		'uniform vec4 ${GLShader.uColorOffset};',
		'varying vec2 ${GLShader.vTexCoord};',
		'varying vec4 ${GLShader.vColor};',
		
		'vec4 colorTransform(const vec4 color, const vec4 tint, const vec4 multiplier, const vec4 offset) {',
		'   vec4 unmultiply = vec4(color.rgb / color.a, color.a);',
		'   vec4 result = unmultiply * tint * multiplier;',
		'   result = result + offset;',
		'   result = clamp(result, 0., 1.);',
		'   result = vec4(result.rgb * result.a, result.a);',
		'   return result;',
		'}',
	];
	
	public var precision:GLShaderPrecision = LOW;
	public var fragmentCode(default, set):String;
	public var data(default, null):GLShaderData;
	
	private var __dirty:Bool = true;
	private var __shader:InternalShader;
	private var __fragmentCode:String;
	
	public function new(fragmentCode:String, ?precision:GLShaderPrecision) {
		this.precision = precision == null ? LOW : precision;
		data = new Map();
		this.fragmentCode = fragmentCode;
		
		trace(__fragmentCode);
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
	public var type(default, null):String;
	public var size(default, null):Int = 0;
	public var arraySize(default, null):Int = 0;
	public var value:Array<Float> = [];
	public var bitmap:BitmapData;
	public var transpose:Bool = false;
	
	private var internalType:GLShaderParameterInternal;
	
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
				trace("sampler");
				internalType = SAMPLER;
				size = 0;
			case _: 
				internalType = NONE;
				trace("Can't initialize value for type " + type);
				
		}
	}
}

@:enum abstract GLShaderPrecision(Int) {
	var LOW = 0;
	var MEDIUM = 1;
	var HIGH = 2;
}

@:enum private abstract GLShaderParameterInternal(Int) {
	var NONE = 0;
	var INT = 1;
	var FLOAT = 2;
	var MAT = 3;
	var SAMPLER = 4;
}

typedef GLShaderData = Map<String, GLShaderParameter>;

private typedef DefaultUniform = openfl._internal.renderer.opengl.shaders2.DefaultShader.Uniform;
private typedef DefaultVarying = openfl._internal.renderer.opengl.shaders2.DefaultShader.Varying;