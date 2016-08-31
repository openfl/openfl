package openfl.filters.commands;

import openfl.display.BitmapData;
import openfl.display.Shader;

import openfl._internal.renderer.RenderSession;

class ColorLookupCommand {

	private static var __shader = new ColorLookupShader ();

	public static function apply (renderSession:RenderSession, target:BitmapData, source:BitmapData, colorLookup:BitmapData) {

		__shader.uColorLookupSampler = colorLookup;

		CommandHelper.apply (renderSession, target, source, __shader, source == target);
		
	}

}

private class ColorLookupShader extends Shader {

	@fragment var fragment = [
		'uniform sampler2D uColorLookupSampler;',

		'void main(void)',
		'{',
			'float a = texture2D(${Shader.uSampler}, ${Shader.vTexCoord}).a;',
			'gl_FragColor = texture2D(uColorLookupSampler, vec2(a, 0.5));',
		'}',
	];

	public function new () {

		super ();

	}

}
