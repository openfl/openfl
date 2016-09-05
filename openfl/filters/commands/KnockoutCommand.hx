package openfl.filters.commands;

import openfl.display.BitmapData;
import openfl.display.Shader;

import openfl._internal.renderer.RenderSession;

class KnockoutCommand {

	private static var __shader = new KnockoutShader ();

	public static function apply (renderSession:RenderSession, target:BitmapData, source1:BitmapData, source2:BitmapData, inner:Bool) {

		__shader.uSource1Sampler = source1;
		__shader.inner = inner ? 1 : 0;

		CommandHelper.apply (renderSession, target, source2, __shader, source1 == target || source2 == target);

	}

}

private class KnockoutShader extends Shader {

	@fragment var fragment = [
		'uniform sampler2D uSource1Sampler;',
		'uniform int inner;',

		'void main(void)',
		'{',
			'vec4 src1 = texture2D(uSource1Sampler, ${Shader.vTexCoord});',
			'if (inner == 0) {',
				'src1 *= src2.a;',
			'} else {',
				'src1 *= ( 1 - src2.a );',
			'}',
			'gl_FragColor = src1;',
		'}',
	];

	public function new () {

		super ();

	}

}
