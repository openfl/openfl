package openfl.filters.commands;

import openfl.display.BitmapData;
import openfl.display.Shader;
import lime.utils.Float32Array;

import openfl._internal.renderer.RenderSession;

class ColorTransformCommand {

	private static var __shader = new ColorTransformShader ();

	public static function apply (renderSession:RenderSession, target:BitmapData, source:BitmapData, multipliers:Float32Array, offsets:Float32Array) {

		__shader.uMultipliers = multipliers;
		__shader.uOffsets = offsets;
		CommandHelper.apply (renderSession, target, source, __shader, source == target);

	}

}

private class ColorTransformShader extends Shader {

	@vertex var vertex = [
		'uniform vec2 openfl_uScaleVector;',

		'void main(void)',
		'{',
			'${Shader.vTexCoord} = openfl_uScaleVector * ${Shader.aTexCoord};',
			'gl_Position = vec4(${Shader.aPosition} * 2.0 - 1.0, 0.0, 1.0);',
		'}',
	];

	@fragment var fragment = [
		'uniform mat4 uMultipliers;',
		'uniform vec4 uOffsets;',
		'void main(void) {',
		'	vec4 color = texture2D(${Shader.uSampler}, ${Shader.vTexCoord});',
		'	color = vec4(color.rgb / (color.a + 0.000001), color.a);',
		'	color = uOffsets + color * uMultipliers;',
		'	color = vec4(color.rgb * color.a, color.a);',
		'	gl_FragColor = color;',
		'}',
	];


	public function new () {

		super ();

	}

}
