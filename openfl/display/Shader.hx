package openfl.display; #if !flash #if !openfl_legacy

import lime.graphics.GLRenderContext;
import openfl._internal.renderer.opengl.shaders2.DefaultShader;
import openfl._internal.renderer.opengl.shaders2.Shader as GLShader;

@:access(openfl._internal.renderer.opengl.shaders2.Shader)
class Shader {

	public var fragmentCode(default, set):String;
	public var data:ShaderData;
	public var precisionHint:String;
	
	static public var uSampler = DefaultUniform.Sampler;
	static public var uColorMultiplier = DefaultUniform.ColorMultiplier;
	static public var uColorOffset = DefaultUniform.ColorOffset;
	static public var vTexCoord = DefaultVarying.TexCoord;
	static public var vColor = DefaultVarying.Color;
	
	static public var HEADER:String = [
			'#ifdef GL_ES',
			'precision lowp float;',
			'#endif',
			
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
	].join("\n");
	
	private var __shader:GLShader;
	private var __dirty:Bool = true;
	
	public function new(?fragmentCode:String) {
		
		this.fragmentCode = fragmentCode;
		data = new ShaderData();
		
	}
	
	private function __init(gl:GLRenderContext) {
		var dirty = __dirty;
		if (dirty) {
			if (__shader != null) {
				__shader.destroy();
			}
			__shader = new GLShader(gl);
			__shader.vertexSrc = openfl._internal.renderer.opengl.shaders2.DefaultShader.VERTEX_SRC;
			__shader.fragmentString = fragmentCode;
			__dirty = false;
		}
		
		__shader.init(dirty);
	}
	
	private function set_fragmentCode(value:String) {
		if(fragmentCode != value) {
			__dirty = true;
		}
		return fragmentCode = value;
	}
	
}

private typedef DefaultUniform = openfl._internal.renderer.opengl.shaders2.DefaultShader.Uniform;
private typedef DefaultVarying = openfl._internal.renderer.opengl.shaders2.DefaultShader.Varying;

#else
typedef Shader = openfl._legacy.display.Shader;
#end
#else
typedef Shader = flash.display.Shader;
#end