package openfl.filters.commands;

import openfl.display.BitmapData;
import openfl.display.Shader;

import openfl._internal.renderer.RenderSession;

class CombineInnerCommand {

	private static var __shader = new CombineInnerShader ();

	public static function apply (renderSession:RenderSession, target:BitmapData, source1:BitmapData, source2:BitmapData) {

		__shader.uSource1Sampler = source1;

		CommandHelper.apply (renderSession, target, source2, __shader, source1 == target || source2 == target);

	}

}

private class CombineInnerShader extends Shader {

	@fragment var fragment = [
		'uniform sampler2D uSource1Sampler;',

		'void main(void)',
		'{',
			'vec4 src2 = texture2D(${Shader.uSampler}, ${Shader.vTexCoord});',
			'vec4 src1 = texture2D(uSource1Sampler, ${Shader.vTexCoord});',
			'gl_FragColor = clamp(src1 * (1.0 - src2.a) + src1.a * src2, 0.0, 1.0);',
		'}',
	];

	public function new () {

		super ();

	}

}
