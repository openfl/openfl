package openfl._internal.renderer.opengl.shaders2;

import lime.graphics.GLRenderContext;


class DefaultShader extends Shader {

	public function new(gl:GLRenderContext) {
		super(gl);
		
		vertexSrc = [
			'attribute vec2 ${Attrib.Position};',
			'attribute vec2 ${Attrib.TexCoord};',
			'attribute vec4 ${Attrib.Color};',
			
			'uniform mat3 ${Uniform.ProjectionMatrix};',
			
			'varying vec2 vTexCoord;',
			'varying vec4 vColor;',
			
			'void main(void) {',
			'   gl_Position = vec4((${Uniform.ProjectionMatrix} * vec3(${Attrib.Position}, 1.0)).xy, 0.0, 1.0);',
			'   vTexCoord = ${Attrib.TexCoord};',
			'   vColor = ${Attrib.Color};',
			'}'
		];
		
		fragmentSrc = [
			'#ifdef GL_ES',
			'precision lowp float;',
			'#endif',
			
			'uniform sampler2D ${Uniform.Sampler};',
			'uniform vec4 ${Uniform.ColorMultiplier};',
			'uniform vec4 ${Uniform.ColorOffset};',
			
			'varying vec2 vTexCoord;',
			'varying vec4 vColor;',
			
			'vec4 colorTransform(const vec4 color, const vec4 tint, const vec4 multiplier, const vec4 offset) {',
			'	vec4 unmultiply;',
			'	if (color.a == 0.0) {',
			'		unmultiply = vec4(0.0, 0.0, 0.0, 0.0);',
			'	} else {',
			'   	unmultiply = vec4(color.rgb / color.a, color.a);',
			'	}',
			'   vec4 result = unmultiply * tint * multiplier;',
			'   result = result + offset;',
			'   result = clamp(result, 0., 1.);',
			'   result = vec4(result.rgb * result.a, result.a);',
			'   return result;',
			'}',
			
			'void main(void) {',
			'   vec4 tc = texture2D(${Uniform.Sampler}, vTexCoord);',
			'   gl_FragColor = colorTransform(tc, vColor, ${Uniform.ColorMultiplier}, ${Uniform.ColorOffset});',
			'}'
		
		];
		
		init();
		
	}
	
	override private function init() {
		super.init();

		getAttribLocation(Attrib.Position);
		getAttribLocation(Attrib.TexCoord);
		getAttribLocation(Attrib.Color);
		getUniformLocation(Uniform.ProjectionMatrix);
		getUniformLocation(Uniform.Sampler);
		getUniformLocation(Uniform.ColorMultiplier);
		getUniformLocation(Uniform.ColorOffset);
	}
	
}

// TODO Find a way to apply these default attributes and uniforms to other shaders
@:enum private abstract Attrib(String) from String to String {
	var Position = "aPosition";
	var TexCoord = "aTexCoord0";
	var Color = "aColor";
}

@:enum private abstract Uniform(String) from String to String {
	var Sampler = "uSampler0";
	var ProjectionMatrix = "uProjectionMatrix";
	var Color = "uColor";
	var Alpha = "uAlpha";
	var ColorMultiplier = "uColorMultiplier";
	var ColorOffset = "uColorOffset";
}

typedef DefAttrib = Attrib;
typedef DefUniform = Uniform;