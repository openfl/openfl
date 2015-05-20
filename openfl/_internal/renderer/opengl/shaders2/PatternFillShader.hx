package openfl._internal.renderer.opengl.shaders2;

import lime.graphics.GLRenderContext;
import openfl._internal.renderer.opengl.shaders2.DefaultShader.DefAttrib;
import openfl._internal.renderer.opengl.shaders2.DefaultShader.DefUniform;

class PatternFillShader extends Shader {

	public function new(gl:GLRenderContext) {
		super(gl);
		
		vertexSrc = [
			'attribute vec2 ${Attrib.Position};',
			'uniform mat3 ${Uniform.TranslationMatrix};',
			'uniform mat3 ${Uniform.ProjectionMatrix};',
			'uniform mat3 ${Uniform.PatternMatrix};',
			
			'varying vec2 vPosition;',
			
			'void main(void) {',
			'   gl_Position = vec4((${Uniform.ProjectionMatrix} * ${Uniform.TranslationMatrix} * vec3(${Attrib.Position}, 1.0)).xy, 0.0, 1.0);',
			'   vPosition = (${Uniform.PatternMatrix} * vec3(${Attrib.Position}, 1)).xy;',
			'}'

		];
		
		fragmentSrc = [
			'#ifdef GL_ES',
			'precision lowp float;',
			'#endif',
			
			'uniform float ${Uniform.Alpha};',
			'uniform vec2 ${Uniform.PatternTL};',
			'uniform vec2 ${Uniform.PatternBR};',
			'uniform sampler2D ${Uniform.Sampler};',
			
			'uniform vec4 ${Uniform.ColorMultiplier};',
			'uniform vec4 ${Uniform.ColorOffset};',
			
			'varying vec2 vPosition;',
			
			'vec4 colorTransform(const vec4 color, const float alpha, const vec4 multiplier, const vec4 offset) {',
			'   vec4 unmultiply = vec4(color.rgb / color.a, color.a);',
			'   vec4 result = unmultiply * multiplier;',
			'   result.a *= alpha;',
			'   result = result + offset;',
			'   result = clamp(result, 0., 1.);',
			'   result = vec4(result.rgb * result.a, result.a);',
			'   return result;',
			'}',	
			
			'void main(void) {',
			'   vec2 pos = mix(${Uniform.PatternTL}, ${Uniform.PatternBR}, vPosition);',
			'   vec4 tcol = texture2D(${Uniform.Sampler}, pos);',
			'   gl_FragColor = colorTransform(tcol, ${Uniform.Alpha}, ${Uniform.ColorMultiplier}, ${Uniform.ColorOffset});',
			'}'
		];
		
		init();
	}
	
	override function init() 
	{
		super.init();
		
		getAttribLocation(Attrib.Position);
		
		getUniformLocation(Uniform.TranslationMatrix);
		getUniformLocation(Uniform.PatternMatrix);
		getUniformLocation(Uniform.ProjectionMatrix);
		getUniformLocation(Uniform.Sampler);
		getUniformLocation(Uniform.PatternTL);
		getUniformLocation(Uniform.PatternBR);
		getUniformLocation(Uniform.Alpha);
		getUniformLocation(Uniform.ColorMultiplier);
		getUniformLocation(Uniform.ColorOffset);
	}
	
}

@:enum private abstract Attrib(String) to String from String {
	var Position = DefAttrib.Position;
}

@:enum private abstract Uniform(String) from String to String {
	var TranslationMatrix = "uTranslationMatrix";
	var PatternMatrix = "uPatternMatrix";
	var PatternTL = "uPatternTL";
	var PatternBR = "uPatternBR";
	var Sampler = DefUniform.Sampler;
	var ProjectionMatrix = DefUniform.ProjectionMatrix;
	var Color = DefUniform.Color;
	var Alpha = DefUniform.Alpha;
	var ColorMultiplier = DefUniform.ColorMultiplier;
	var ColorOffset = DefUniform.ColorOffset;
	
}

typedef PatternFillAttrib = Attrib;
typedef PatternFillUniform = Uniform;