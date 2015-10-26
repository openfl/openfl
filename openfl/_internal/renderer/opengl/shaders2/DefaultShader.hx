package openfl._internal.renderer.opengl.shaders2;

import lime.graphics.GLRenderContext;


class DefaultShader extends Shader {
	
	public static var VERTEX_SRC(default, null) = [
			'attribute vec2 ${Attrib.Position};',
			'attribute vec2 ${Attrib.TexCoord};',
			'attribute vec4 ${Attrib.Color};',
			
			'uniform mat3 ${Uniform.ProjectionMatrix};',
			'uniform bool ${Uniform.UseColorTransform};',
			
			'varying vec2 ${Varying.TexCoord};',
			'varying vec4 ${Varying.Color};',
			
			'void main(void) {',
			'   gl_Position = vec4((${Uniform.ProjectionMatrix} * vec3(${Attrib.Position}, 1.0)).xy, 0.0, 1.0);',
			'   ${Varying.TexCoord} = ${Attrib.TexCoord};',
			'   if(${Uniform.UseColorTransform})',
			'   	${Varying.Color} = ${Attrib.Color};',
			'   else',
			#if (js && html5)
			'   	${Varying.Color} = vec4(${Attrib.Color}.rgb * ${Attrib.Color}.a, ${Attrib.Color}.a);',
			#else
			'   	${Varying.Color} = vec4(${Attrib.Color}.bgr * ${Attrib.Color}.a, ${Attrib.Color}.a);',
			#end
			'}'
		];

	public function new(gl:GLRenderContext) {
		super(gl);
		
		vertexSrc = VERTEX_SRC;
		
		fragmentSrc = [
			'#ifdef GL_ES',
			'precision lowp float;',
			'#endif',
			
			'uniform sampler2D ${Uniform.Sampler};',
			'uniform vec4 ${Uniform.ColorMultiplier};',
			'uniform vec4 ${Uniform.ColorOffset};',
			'uniform bool ${Uniform.UseColorTransform};',
			
			'varying vec2 ${Varying.TexCoord};',
			'varying vec4 ${Varying.Color};',
			
			'vec4 colorTransform(const vec4 color, const vec4 tint, const vec4 multiplier, const vec4 offset) {',
			'	if(!${Uniform.UseColorTransform}) {',
			'		return color * tint;',
			'	}',
			
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
			'   vec4 tc = texture2D(${Uniform.Sampler}, ${Varying.TexCoord});',
			'   gl_FragColor = colorTransform(tc, ${Varying.Color}, ${Uniform.ColorMultiplier}, ${Uniform.ColorOffset});',
			'}'
		
		];
		
		init();
		
	}
	
	override private function init(force:Bool = false) {
		super.init(force);

		getAttribLocation(Attrib.Position);
		getAttribLocation(Attrib.TexCoord);
		getAttribLocation(Attrib.Color);
		getUniformLocation(Uniform.ProjectionMatrix);
		getUniformLocation(Uniform.Sampler);
		getUniformLocation(Uniform.ColorMultiplier);
		getUniformLocation(Uniform.ColorOffset);
		getUniformLocation(Uniform.UseColorTransform);
	}
	
}

// TODO Find a way to apply these default attributes and uniforms to other shaders
@:enum abstract Attrib(String) from String to String {
	var Position = "openfl_aPosition";
	var TexCoord = "openfl_aTexCoord0";
	var Color = "openfl_aColor";
}

@:enum abstract Uniform(String) from String to String {
	var Sampler = "openfl_uSampler0";
	var ProjectionMatrix = "openfl_uProjectionMatrix";
	var Color = "openfl_uColor";
	var Alpha = "openfl_uAlpha";
	var ColorMultiplier = "openfl_uColorMultiplier";
	var ColorOffset = "openfl_uColorOffset";
	var UseColorTransform = "openfl_uUseColorTransform";
}

@:enum abstract Varying(String) from String to String {
	var TexCoord = "openfl_vTexCoord";
	var Color = "openfl_vColor";
}

typedef DefAttrib = Attrib;
typedef DefUniform = Uniform;
typedef DefVarying = Varying;
