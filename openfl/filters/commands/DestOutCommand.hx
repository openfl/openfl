package openfl.filters.commands;

import openfl.display.BitmapData;
import openfl.display.Shader;

import openfl._internal.renderer.RenderSession;

class DestOutCommand {

	private static var __shader = new DestOutShader ();

	public static function apply (renderSession:RenderSession, target:BitmapData, highlightSource:BitmapData, shadowSource:BitmapData) {

		__shader.uShadowSourceSampler = shadowSource;

		CommandHelper.apply (renderSession, target, highlightSource, __shader, highlightSource == target || shadowSource == target);

	}

}

private class DestOutShader extends Shader {

	@fragment var fragment = [
		'uniform sampler2D uShadowSourceSampler;',
		'uniform float outer;',

		'void main(void)',
		'{',
			'float highlight = texture2D(${Shader.uSampler}, ${Shader.vTexCoord}).a;',
			'float shadow = texture2D(uShadowSourceSampler, ${Shader.vTexCoord}).a;',
			'float high = clamp(highlight - shadow, 0., 1.);',
			'float low = clamp(shadow - highlight, 0., 1.);',
			'gl_FragColor = vec4(0.5 * ( 1. + high - low ));',
		'}',
	];

	public function new () {

		super ();

	}

}
