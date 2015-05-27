package openfl.display;


import lime.graphics.GLRenderContext;
import openfl._internal.renderer.opengl.shaders2.DefaultShader in InternalShader;

using StringTools;

class GLShader
{

	public static var UNIFORM_REGEX = ~/^\s*uniform\s+(sampler(?:2D|Cube)|[bi]?vec[234]|float|int|bool|mat[234])\s+(\w+)\s*(.*)$/gmi;
	
	public var precision(default, set):GLShaderPrecision = LOW;
	public var fragmentCode(default, set):String;
	public var uniforms(get, never):Map<String, Dynamic>;
	
	private var __dirty:Bool = true;
	private var __shader:InternalShader;
	private var __fragmentCode:String;
	
	public function new() {
		
	}
	
	private function __init(gl:GLRenderContext) {
		var dirty = __dirty;
		if (dirty) {
			if (__shader != null) {
				__shader.destroy();
			}
			__shader = new InternalShader(gl);
			__shader.vertexSrc = openfl._internal.renderer.opengl.shaders2.DefaultShader.VERTEX_SRC;
			__shader.fragmentString = fragmentCode;
			__dirty = false;
		}
		
		__shader.init(dirty);
	}
	
	private function __buildFragmentCode(code:String) {
		var output = [];
		
		output.push('#ifdef GL_ES');
		output.push(switch(precision) {
			case HIGH: 		'precision highp float;'
			case MEDIUM: 	'precision mediump float;'
			case LOW: 		'precision lowp float;'
		});
		output.push('#endif');
		
		// TODO extensions
		
		output.push(code);
		
		return output.join("\n");
	}
	
	private function __parseUniforms(code:String) {
		var src = code.split("\n");
		var us:Array<String>;
		var type:String;
		var name:String;
		var isArray:Bool;
		for (s in src) {
			if (UNIFORM_REGEX.match(s)) {
				type = UNIFORM_REGEX.matched(1);
				name = UNIFORM_REGEX.matched(2);
				trace(type, name);
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

@:enum abstract GLShaderPrecision(Int) {
	var LOW = 0;
	var MEDIUM = 1;
	var HIGH = 2;
}