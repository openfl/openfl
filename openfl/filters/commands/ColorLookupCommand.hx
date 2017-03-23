package openfl.filters.commands;

import openfl.display.BitmapData;
import openfl.display.Shader;
import lime.utils.Float32Array;

import openfl._internal.renderer.RenderSession;

class ColorLookupCommand {

	private static var __shader = new ColorLookupShader ();

	public static function apply (renderSession:RenderSession, target:BitmapData, source:BitmapData, colorLookup:BitmapData) {

		__shader.uColorLookupSampler = colorLookup;

		CommandHelper.apply (renderSession, target, source, __shader, source == target);

	}

}

private class ColorLookupShader extends Shader {

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
		'uniform sampler2D uColorLookupSampler;',

		'void main(void)',
		'{',
			'float a = texture2D(${Shader.uSampler}, ${Shader.vTexCoord}).a;',
			'gl_FragColor = texture2D(uColorLookupSampler, vec2(a, 0.5));',
		'}',
	];

}
