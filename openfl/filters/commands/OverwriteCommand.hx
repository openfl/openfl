package openfl.filters.commands;

import openfl.display.BitmapData;
import openfl.display.Shader;

import openfl._internal.renderer.RenderSession;

class OverwriteCommand {

	private static var __shader = new OverwriteShader ();

	public static function apply (renderSession:RenderSession, target:BitmapData, source1:BitmapData) {

		CommandHelper.apply (renderSession, target, source1, __shader, source1 == target);

	}

}

private class OverwriteShader extends Shader {

	@fragment var fragment = [

		'void main(void)',
		'{',
			'vec4 src1 = texture2D(${Shader.uSampler}, ${Shader.vTexCoord});',
			'gl_FragColor = src1;',
		'}',
	];

	public function new () {

		super ();

	}

}
