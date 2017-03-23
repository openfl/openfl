package openfl.filters.commands;

import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.display.Shader;
import lime.utils.Float32Array;

import openfl._internal.renderer.RenderSession;

class OffsetCommand {

	private static var __shader = new OffsetShader ();

	public static function apply (renderSession:RenderSession, target:BitmapData, source:BitmapData, strength:Float, offset:Point) {

		__shader.uTexCoordOffset[0] = offset.x;
		__shader.uTexCoordOffset[1] = offset.y;
		__shader.uStrength = strength;

		CommandHelper.apply (renderSession, target, source, __shader, source == target);

	}

}

private class OffsetShader extends Shader {

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
	'uniform float uStrength;',

	'void main(void)',
	'{',
		'vec4 result = texture2D(${Shader.uSampler}, ${Shader.vTexCoord});',

		'gl_FragColor = clamp(result * uStrength, 0.0, 1.0);',
	'}',
	];

}
