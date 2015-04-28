package openfl._internal.renderer.opengl.shaders2;

import lime.graphics.GLRenderContext;
import openfl._internal.renderer.opengl.shaders2.DefaultShader.DefAttrib;
import openfl._internal.renderer.opengl.shaders2.DefaultShader.DefUniform;

class FillShader extends Shader {

	public function new(gl:GLRenderContext) {
		super(gl);
		
		vertexSrc = [
			'attribute vec2 ${Attrib.Position};',
			'uniform mat3 ${Uniform.TranslationMatrix};',
			'uniform mat3 ${Uniform.ProjectionMatrix};',
			
			'uniform vec4 ${Uniform.Color};',
			'uniform float ${Uniform.Alpha};',
			'uniform vec4 ${Uniform.ColorMultiplier};',
			'uniform vec4 ${Uniform.ColorOffset};',
			
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
			'   vColor = colorTransform(${Uniform.Color}, ${Uniform.Alpha}, ${Uniform.ColorMultiplier}, ${Uniform.ColorOffset});',
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
		
		init ();
	}
	
	override function init() {
		super.init();
		
		getAttribLocation(Attrib.Position);
		getUniformLocation(Uniform.TranslationMatrix);
		getUniformLocation(Uniform.ProjectionMatrix);
		getUniformLocation(Uniform.Color);
		getUniformLocation(Uniform.ColorMultiplier);
		getUniformLocation(Uniform.ColorOffset);
	}
	
}

@:enum private abstract Attrib(String) from String to String {
	var Position = DefAttrib.Position;
}

@:enum private abstract Uniform(String) from String to String {
	var TranslationMatrix = "uTranslationMatrix";
	var ProjectionMatrix = DefUniform.ProjectionMatrix;
	var Color = DefUniform.Color;
	var Alpha = DefUniform.Alpha;
	var ColorMultiplier = DefUniform.ColorMultiplier;
	var ColorOffset = DefUniform.ColorOffset;
}

typedef FillAttrib = Attrib;
typedef FillUniform = Uniform;