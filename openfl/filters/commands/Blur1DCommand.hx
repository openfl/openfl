package openfl.filters.commands;

import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.display.Shader;
import lime.utils.Float32Array;

import openfl._internal.renderer.RenderSession;

class Blur1DCommand {

	public static inline var MAXIMUM_FETCH_COUNT:Int = 64;
	private static var __shader = new BlurShader ();

	public static function apply (renderSession:RenderSession, target:BitmapData, source:BitmapData, blur:Float, quality:Int, horizontal:Bool, strength:Float, offset:Point) {
		// :TODO: reduce the number of tex fetches using texture HW filtering

		var perPassFetchCount:Int = Math.ceil (blur);
		var perPassPadding:Float = (perPassFetchCount - 1) / 2;

		inline function getPassSampleCount (passIndex:Int):Int return perPassFetchCount + passIndex * (perPassFetchCount - 1);

		inline function computeWeightTable():Float32Array {

			var sampleCount = getPassSampleCount (0);
			var weightTable = new Float32Array (sampleCount);
			var uniformDistribution = 1.0 / perPassFetchCount;

			for (i in 0...perPassFetchCount) {

				weightTable[i] = uniformDistribution * strength;

			}

			for (passIndex in 1...quality) {

				var previousWeightTable = weightTable;
				var previousWeightCount = weightTable.length;

				sampleCount = getPassSampleCount (passIndex);
				weightTable = new Float32Array(sampleCount);

				var offset:Int = Std.int (2 * perPassPadding);

				for (i in 0...sampleCount) {

					weightTable[i] = 0.0;

					for (j in 0...perPassFetchCount) {

						var sampleIndex = i - offset + j;

						if (sampleIndex >= 0 && sampleIndex < previousWeightCount) {

							weightTable[i] += uniformDistribution * previousWeightTable[sampleIndex];

						}

					}

				}

			}

			return weightTable;

		}

		var weightTable:Float32Array;
		weightTable = computeWeightTable();

		var totalFetchCount = weightTable.length;
		if (totalFetchCount > MAXIMUM_FETCH_COUNT) {

			var trimCount = totalFetchCount - MAXIMUM_FETCH_COUNT;
			var halfTrimCount = (trimCount + 1) >> 1;

			weightTable = weightTable.subarray (halfTrimCount, totalFetchCount - halfTrimCount);
			var sum = 0.0;
			for(i in 0...weightTable.length) {
				sum += weightTable[i];
			}
			for(i in 0...weightTable.length) {
				weightTable[i] /= sum;
			}
			totalFetchCount = weightTable.length;

		}

		var pass_width:Float, pass_height:Float;

		if (horizontal) {

			pass_width = blur * quality - 1;
			pass_height = 0;

		} else {

			pass_width = 0;
			pass_height = blur * quality - 1;

		}

		__shader.uFetchCount = totalFetchCount;

		if (totalFetchCount > 1) {

			__shader.uTexCoordDelta[0] =  pass_width / ( totalFetchCount - 1);
			__shader.uTexCoordDelta[1] =  pass_height / ( totalFetchCount - 1);

		} else {

			__shader.uTexCoordDelta[0] = 0;
			__shader.uTexCoordDelta[1] = 0;

		}

		__shader.uTexCoordOffset[0] = 0.5 * pass_width + offset.x;
		__shader.uTexCoordOffset[1] = 0.5 * pass_height + offset.y;

		CommandHelper.apply (renderSession, target, source, __shader, source == target, function (renderSession:RenderSession) { preDrawCallback(renderSession, weightTable); } );

	}

	private static function preDrawCallback (renderSession:RenderSession, weightTable:Float32Array) {

		renderSession.gl.uniform1fv (@:privateAccess __shader.__shader.getUniformLocation('uWeightTable'), weightTable);

	}
}

private class BlurShader extends Shader {

	public function new()
	{
		super();
		
		CommandHelper.addShader( this );
	}

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
		'uniform float uFetchCount;',
		'uniform float uWeightTable[${Blur1DCommand.MAXIMUM_FETCH_COUNT}];',

		'void main(void)',
		'{',
			'vec2 texcoord_delta = uTexCoordDelta / ${Shader.uTextureSize};', // :TODO: move to VS
			'int fetch_count = int(uFetchCount);',
			'vec4 result = vec4(0.0);',
			'for(int i = 0; i < ${Blur1DCommand.MAXIMUM_FETCH_COUNT}; ++i){',
			'    if (i >= fetch_count) break;',
			'    result += texture2D(${Shader.uSampler}, ${Shader.vTexCoord} + texcoord_delta * float(i)) * uWeightTable[i];',
			'}',

		'	gl_FragColor = clamp(result, 0.0, 1.0);',
		'}',
	];

}
