package openfl._internal.renderer.opengl.shaders2;

import lime.graphics.GLRenderContext;
import openfl._internal.renderer.opengl.shaders2.DefaultShader.DefAttrib;
import openfl._internal.renderer.opengl.shaders2.DefaultShader.DefUniform;


class DrawTrianglesShader extends Shader {

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
			// the passed color is ARGB format
			'   vColor = ${Attrib.Color}.bgra;',
			'}',

		];
		
		fragmentSrc = [
			'#ifdef GL_ES',
			'precision lowp float;',
			'#endif',
			
			'uniform sampler2D ${Uniform.Sampler};',
			'uniform vec3 ${Uniform.Color};',
			'uniform bool ${Uniform.UseTexture};',
			'uniform float ${Uniform.Alpha};',
			'uniform vec4 ${Uniform.ColorMultiplier};',
			'uniform vec4 ${Uniform.ColorOffset};',
			
			'varying vec2 vTexCoord;',
			'varying vec4 vColor;',
			
			'vec4 tmp;',
			
			'vec4 colorTransform(const vec4 color, const vec4 tint, const vec4 multiplier, const vec4 offset) {',
			'   vec4 unmultiply = vec4(color.rgb / color.a, color.a);',
			'   vec4 result = unmultiply * tint * multiplier;',
			'   result = result + offset;',
			'   result = clamp(result, 0., 1.);',
			'   result = vec4(result.rgb * result.a, result.a);',
			'   return result;',
			'}',
			
			'void main(void) {',
			'   if(${Uniform.UseTexture}) {',
			'       tmp = texture2D(${Uniform.Sampler}, vTexCoord);',
			'   } else {',
			'       tmp = vec4(${Uniform.Color}, 1.);',
			'   }',
			'   gl_FragColor = colorTransform(tmp, vColor, ${Uniform.ColorMultiplier}, ${Uniform.ColorOffset});',
			'}'
		];
		
		init ();
	}
	
	override function init() {
		super.init();
		
		getAttribLocation(Attrib.Position);
		getAttribLocation(Attrib.TexCoord);
		getAttribLocation(Attrib.Color);
		
		getUniformLocation(Uniform.Sampler);
		getUniformLocation(Uniform.ProjectionMatrix);
		getUniformLocation(Uniform.Color);
		getUniformLocation(Uniform.Alpha);
		getUniformLocation(Uniform.UseTexture);
		getUniformLocation(Uniform.ColorMultiplier);
		getUniformLocation(Uniform.ColorOffset);
		
	}
	
}

@:enum private abstract Attrib(String) from String to String {
	var Position = DefAttrib.Position;
	var TexCoord = DefAttrib.TexCoord;
	var Color = DefAttrib.Color;
}

@:enum private abstract Uniform(String) from String to String {
	var UseTexture = "uUseTexture";
	var Sampler = DefUniform.Sampler;
	var ProjectionMatrix = DefUniform.ProjectionMatrix;
	var Color = DefUniform.Color;
	var Alpha = DefUniform.Alpha;
	var ColorMultiplier = DefUniform.ColorMultiplier;
	var ColorOffset = DefUniform.ColorOffset;	
}

typedef DrawTrianglesAttrib = Attrib;
typedef DrawTrianglesUniform = Uniform;