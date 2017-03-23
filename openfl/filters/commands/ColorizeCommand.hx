package openfl.filters.commands;

import openfl.display.BitmapData;
import openfl.display.Shader;
import lime.utils.Float32Array;

import openfl._internal.renderer.RenderSession;

class ColorizeCommand {

	private static var __shader = new ColorizeShader ();

	public static function apply (renderSession:RenderSession, target:BitmapData, source:BitmapData, color:Int, alpha:Float) {

		__shader.uColor[0] = ((color >> 16) & 0xFF) / 255;
		__shader.uColor[1] = ((color >> 8) & 0xFF) / 255;
		__shader.uColor[2] = (color & 0xFF) / 255;
		__shader.uColor[3] = alpha;

		CommandHelper.apply (renderSession, target, source, __shader, source == target);

	}

}

private class ColorizeShader extends Shader {

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
		'uniform vec4 uColor;',

		'void main(void)',
		'{',
			'float a = texture2D(${Shader.uSampler}, ${Shader.vTexCoord}).a;',
			'a = clamp(a * uColor.a, 0.0, 1.0);',

			'gl_FragColor = vec4(uColor.rgb * a, a);',
		'}',
	];

}
