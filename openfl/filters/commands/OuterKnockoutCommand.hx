package openfl.filters.commands;

import openfl.display.BitmapData;
import openfl.display.Shader;
import lime.utils.Float32Array;

import openfl._internal.renderer.RenderSession;

class OuterKnockoutCommand {

	private static var __shader = new OuterKnockoutShader ();

	public static function apply (renderSession:RenderSession, target:BitmapData, source1:BitmapData, source2:BitmapData, allowTransparency:Bool = true) {

		__shader.uSource1Sampler = source1;
		__shader.allow_transparency = allowTransparency ? 1.0 : 0.0;

		CommandHelper.apply (renderSession, target, source2, __shader, source1 == target || source2 == target);

	}

}

private class OuterKnockoutShader extends Shader {

	public function new()
	{
		super();

		CommandHelper.addShader( this );
	}

	@vertex var vertex = [
		'uniform vec2 openfl_uScaleVector;',

		'void main(void)',
		'{',
			'${Shader.vTexCoord} = openfl_uScaleVector * ${Shader.aTexCoord};',
			'gl_Position = vec4(${Shader.aPosition} * 2.0 - 1.0, 0.0, 1.0);',
		'}',
	];

	@fragment var fragment = [
		'uniform sampler2D uSource1Sampler;',
		'uniform float allow_transparency;',

		'void main(void)',
		'{',
			'vec4 src2 = texture2D(${Shader.uSampler}, ${Shader.vTexCoord});',
			'vec4 src1 = texture2D(uSource1Sampler, ${Shader.vTexCoord});', // target image
			'src2 *=  1. - ( allow_transparency * src1.a + ( 1. - allow_transparency ) * step(0.0001, src1.a) );',
			'gl_FragColor = src2;',
		'}',
	];

}
