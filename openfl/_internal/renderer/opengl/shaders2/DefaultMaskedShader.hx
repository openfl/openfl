package openfl._internal.renderer.opengl.shaders2;

import lime.graphics.GLRenderContext;


class DefaultMaskedShader extends Shader {

	public static var VERTEX_SRC(default, null) = [
			'attribute vec2 ${MaskedAttrib.Position};',
			'attribute vec2 ${MaskedAttrib.TexCoord};',
			'attribute vec4 ${MaskedAttrib.Color};',

			'uniform mat3 ${MaskedUniform.ProjectionMatrix};',
			'uniform mat3 ${MaskedUniform.MaskMatrix};',
			'uniform bool ${MaskedUniform.UseColorTransform};',

			'varying vec2 ${MaskedVarying.TexCoord};',
			'varying vec2 ${MaskedVarying.MaskTexCoord};',
			'varying vec4 ${MaskedVarying.Color};',

			'void main(void) {',
			'   gl_Position = vec4((${MaskedUniform.ProjectionMatrix} * vec3(${MaskedAttrib.Position}, 1.0)).xy, 0.0, 1.0);',
			'   ${MaskedVarying.TexCoord} = ${MaskedAttrib.TexCoord};',
			'   ${MaskedVarying.MaskTexCoord} = (${MaskedUniform.MaskMatrix} * vec3(${MaskedAttrib.Position}, 1.0)).xy;',
			'   if(${MaskedUniform.UseColorTransform})',
			'   	${MaskedVarying.Color} = ${MaskedAttrib.Color};',
			'   else',
			#if (js && html5)
			'   	${MaskedVarying.Color} = vec4(${MaskedAttrib.Color}.rgb * ${MaskedAttrib.Color}.a, ${MaskedAttrib.Color}.a);',
			#else
			'   	${MaskedVarying.Color} = vec4(${MaskedAttrib.Color}.bgr * ${MaskedAttrib.Color}.a, ${MaskedAttrib.Color}.a);',
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

			'uniform sampler2D ${MaskedUniform.Sampler};',
			'uniform sampler2D ${MaskedUniform.MaskSampler};',
			'uniform vec4 ${MaskedUniform.ColorMultiplier};',
			'uniform vec4 ${MaskedUniform.ColorOffset};',
			'uniform bool ${MaskedUniform.UseColorTransform};',
			'uniform vec2 ${MaskedUniform.MaskUVScale};',

			'varying vec2 ${MaskedVarying.TexCoord};',
			'varying vec2 ${MaskedVarying.MaskTexCoord};',
			'varying vec4 ${MaskedVarying.Color};',

			'vec4 colorTransform(const vec4 color, const vec4 tint, const vec4 multiplier, const vec4 offset) {',
			'	if(!${MaskedUniform.UseColorTransform}) {',
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
			'   vec4 tc = texture2D(${MaskedUniform.Sampler}, ${MaskedVarying.TexCoord});',
			'   vec4 mask = texture2D(${MaskedUniform.MaskSampler}, ${MaskedVarying.MaskTexCoord} * ${MaskedUniform.MaskUVScale});',
			'   float inside = step( 0.0, ${MaskedVarying.MaskTexCoord}.x ) * step( -1.0, -${MaskedVarying.MaskTexCoord}.x );',
			'   inside *= step( 0.0, ${MaskedVarying.MaskTexCoord}.y ) * step( -1.0, -${MaskedVarying.MaskTexCoord}.y );',
			'	float maskAlpha = inside * step( 0.9, mask.a);',
			//'   gl_FragColor = vec4(maskAlpha, maskAlpha, maskAlpha, 1.0 );',
			'   gl_FragColor = colorTransform(tc, ${MaskedVarying.Color}, ${MaskedUniform.ColorMultiplier}, ${MaskedUniform.ColorOffset})* maskAlpha;',
			'}'

		];

		init();

	}

	override private function init(force:Bool = false) {
		super.init(force);

		getAttribLocation(MaskedAttrib.Position);
		getAttribLocation(MaskedAttrib.TexCoord);
		getAttribLocation(MaskedAttrib.Color);
		getUniformLocation(MaskedUniform.ProjectionMatrix);
		getUniformLocation(MaskedUniform.MaskMatrix);
		getUniformLocation(MaskedUniform.MaskUVScale);
		getUniformLocation(MaskedUniform.Sampler);
		getUniformLocation(MaskedUniform.MaskSampler);
		getUniformLocation(MaskedUniform.ColorMultiplier);
		getUniformLocation(MaskedUniform.ColorOffset);
		getUniformLocation(MaskedUniform.UseColorTransform);
	}

}

// TODO Find a way to apply these default attributes and uniforms to other shaders

@:enum abstract MaskedAttrib(String) from String to String {
	var Position = "openfl_aPosition";
	var TexCoord = "openfl_aTexCoord0";
	var Color = "openfl_aColor";
}

@:enum abstract MaskedUniform(String) from String to String {
	var Sampler = "openfl_uSampler0";
	var MaskSampler = "openfl_uSampler1";
	var MaskUVScale = 'openfl_uUVScale';
	var ProjectionMatrix = "openfl_uProjectionMatrix";
	var MaskMatrix = "openfl_uMaskMatrix";
	var Color = "openfl_uColor";
	var Alpha = "openfl_uAlpha";
	var ColorMultiplier = "openfl_uColorMultiplier";
	var ColorOffset = "openfl_uColorOffset";
	var UseColorTransform = "openfl_uUseColorTransform";
}

@:enum abstract MaskedVarying(String) from String to String {
	var TexCoord = "openfl_vTexCoord";
	var MaskTexCoord = "openfl_vMaskTexCoord";
	var Color = "openfl_vColor";
}
