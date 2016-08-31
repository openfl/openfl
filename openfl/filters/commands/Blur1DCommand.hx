package openfl.filters.commands;

import openfl.display.BitmapData;
import openfl.display.Shader;

import openfl._internal.renderer.RenderSession;

@:access(openfl.display.BitmapData)

class Blur1DCommand {

	public static inline var MAXIMUM_FETCH_COUNT = 20;
	private static var __blurShader = new BlurShader ();

	public static function apply (renderSession:RenderSession, target:BitmapData, source:BitmapData, blur:Float, horizontal:Bool, strength:Float, distance:Float, angle:Float) {
		// :TODO: reduce the number of tex fetches using texture HW filtering

		var fetch_count = Math.min(Math.ceil(blur), MAXIMUM_FETCH_COUNT);
		var pass_width = horizontal ? blur - 1 : 0;
		var pass_height = horizontal ? 0 : blur - 1;
		__blurShader.uFetchCountInverseFetchCount[0] = fetch_count;
		__blurShader.uFetchCountInverseFetchCount[1] = 1.0 / fetch_count;
		__blurShader.uTexCoordDelta[0] = fetch_count > 1 ? pass_width / (fetch_count - 1) : 0;
		__blurShader.uTexCoordDelta[1] = fetch_count > 1 ? pass_height / (fetch_count - 1) : 0;
		__blurShader.uTexCoordOffset[0] = 0.5 * pass_width + distance * Math.cos (angle * Math.PI / 180);
		__blurShader.uTexCoordOffset[1] = 0.5 * pass_height + distance * Math.sin (angle * Math.PI / 180);
		__blurShader.uStrength = strength;

		var same = source == target;

		if (target.__usingPingPongTexture) {
			target.__pingPongTexture.swap();
		}

		if (same) {
			source.__pingPongTexture.useOldTexture = true;
		}

		var source_shader = source.__shader;
		source.__shader = __blurShader;
		target.__drawGL(renderSession, source, source.rect, true, false, true);
		source.__shader = source_shader;

		if (same) {
			source.__pingPongTexture.useOldTexture = false;
		}
	}

}

private class BlurShader extends Shader {

	@vertex var vertex = [
		'uniform vec2 uTexCoordOffset;',

		'void main(void)',
		'{',
			'vec2 texcoord_offset = uTexCoordOffset / ${Shader.uTextureSize};',
			'${Shader.vTexCoord} = ${Shader.aTexCoord} - texcoord_offset;',
			'${Shader.vColor} = ${Shader.aColor};',
			'gl_Position = vec4((${Shader.uProjectionMatrix} * vec3(${Shader.aPosition}, 1.0)).xy, 0.0, 1.0);',
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
