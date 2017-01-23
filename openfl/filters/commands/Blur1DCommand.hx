package openfl.filters.commands;

import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.display.Shader;
import lime.utils.Float32Array;

import openfl._internal.renderer.RenderSession;

class Blur1DCommand {

	public static inline var MAXIMUM_FETCH_COUNT = 20;
	private static var __shader = new BlurShader ();

	public static function apply (renderSession:RenderSession, target:BitmapData, source:BitmapData, blur:Float, horizontal:Bool, strength:Float, offset:Point) {
		// :TODO: reduce the number of tex fetches using texture HW filtering

		var fetch_count = Math.min(Math.ceil(blur), MAXIMUM_FETCH_COUNT);
		var pass_width = horizontal ? blur - 1 : 0;
		var pass_height = horizontal ? 0 : blur - 1;
		__shader.uFetchCountInverseFetchCount[0] = fetch_count;
		__shader.uFetchCountInverseFetchCount[1] = 1.0 / fetch_count;
		__shader.uTexCoordDelta[0] = fetch_count > 1 ? pass_width / (fetch_count - 1) : 0;
		__shader.uTexCoordDelta[1] = fetch_count > 1 ? pass_height / (fetch_count - 1) : 0;
		__shader.uTexCoordOffset[0] = 0.5 * pass_width + offset.x;
		__shader.uTexCoordOffset[1] = 0.5 * pass_height + offset.y;
		__shader.uStrength = strength;

		CommandHelper.apply (renderSession, target, source, __shader, source == target);

	}

}

private class BlurShader extends Shader {

	@vertex var vertex = [
		'uniform vec2 openfl_uScaleVector;',
		'uniform vec2 uTexCoordOffset;',

		'void main(void)',
		'{',
			'vec2 texcoord_offset = uTexCoordOffset / ${Shader.uTextureSize};',
			'${Shader.vTexCoord} = openfl_uScaleVector * ${Shader.aTexCoord} - texcoord_offset;',
			'${Shader.vColor} = ${Shader.aColor};',
			'gl_Position = vec4(${Shader.aPosition} * 2.0 - 1.0, 0.0, 1.0);',
		'}',
	];

	@fragment var fragment = [
		'uniform vec2 uTexCoordDelta;',
		'uniform vec2 uFetchCountInverseFetchCount;',
		'uniform float uStrength;',

		'void main(void)',
		'{',
			'vec2 texcoord_delta = uTexCoordDelta / ${Shader.uTextureSize};', // :TODO: move to VS
			'int fetch_count = int(uFetchCountInverseFetchCount.x);',
			'vec4 result = vec4(0.0);',
			'for(int i = 0; i < ${Blur1DCommand.MAXIMUM_FETCH_COUNT}; ++i){',
			'    if (i >= fetch_count) break;',
			'    result += texture2D(${Shader.uSampler}, ${Shader.vTexCoord} + texcoord_delta * float(i));',
			'}',

		'	gl_FragColor = clamp(result * uFetchCountInverseFetchCount.y * uStrength, 0.0, 1.0);',
		'}',
	];

	public function new () {

		super ();

	}

}
