package openfl._internal.renderer.opengl.shaders2;

import lime.graphics.GLRenderContext;
import openfl._internal.renderer.opengl.shaders2.DefaultShader.DefAttrib;
import openfl._internal.renderer.opengl.shaders2.DefaultShader.DefUniform;

class PrimitiveShader extends Shader {

	public function new(gl:GLRenderContext) {
		super(gl);
		
		vertexSrc  = [
			'attribute vec2 ${Attrib.Position};',
			'attribute vec4 ${Attrib.Color};',
			
			'uniform mat3 ${Uniform.TranslationMatrix};',
			'uniform mat3 ${Uniform.ProjectionMatrix};',
			'uniform vec4 ${Uniform.ColorMultiplier};',
			'uniform vec4 ${Uniform.ColorOffset};',
			'uniform float ${Uniform.Alpha};',
			
			'varying vec4 vColor;',
			
			'vec4 colorTransform(const vec4 color, const float alpha, const vec4 multiplier, const vec4 offset) {',
			'   vec4 result = color * multiplier;',
			'   result.a *= alpha;',
			'   result = result + offset;',
			'   result = clamp(result, 0., 1.);',
			'   result = vec4(result.rgb * result.a, result.a);',
			'   return result;',
			'}',	
			
			'void main(void) {',
			'   gl_Position = vec4((${Uniform.ProjectionMatrix} * ${Uniform.TranslationMatrix} * vec3(${Attrib.Position}, 1.0)).xy, 0.0, 1.0);',
			'   vColor = colorTransform(${Attrib.Color}, ${Uniform.Alpha}, ${Uniform.ColorMultiplier}, ${Uniform.ColorOffset});',
			'}'
		];
		
		fragmentSrc = [
			'#ifdef GL_ES',
			'precision lowp float;',
			'#endif',
			
			'varying vec4 vColor;',
			
			'void main(void) {',
			'   gl_FragColor = vColor;',
			'}'
		];
		
		init();
	}
	
	override function init() 
	{
		super.init();
		
		getAttribLocation(Attrib.Position);
		getAttribLocation(Attrib.Color);
		getUniformLocation(Uniform.TranslationMatrix);
		getUniformLocation(Uniform.ProjectionMatrix);
		getUniformLocation(Uniform.Alpha);
		getUniformLocation(Uniform.ColorMultiplier);
		getUniformLocation(Uniform.ColorOffset);
	}
	
}

@:enum private abstract Attrib(String) to String from String {
	var Position = DefAttrib.Position;
	var Color = DefAttrib.Color;
}

@:enum private abstract Uniform(String) from String to String {
	var TranslationMatrix = "uTranslationMatrix";
	var ProjectionMatrix = DefUniform.ProjectionMatrix;
	var Alpha = DefUniform.Alpha;
	var ColorMultiplier = DefUniform.ColorMultiplier;
	var ColorOffset = DefUniform.ColorOffset;
}

typedef PrimitiveAttrib =  Attrib;
typedef PrimitiveUniform =  Uniform;