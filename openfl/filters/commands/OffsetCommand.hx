package openfl.filters.commands;

import openfl.display.BitmapData;
import openfl.display.Shader;

import openfl._internal.renderer.RenderSession;

class OffsetCommand {

	private static var __shader = new OffsetShader ();

	public static function apply (renderSession:RenderSession, target:BitmapData, source:BitmapData, strength:Float, distance:Float, angle:Float) {

		__shader.uTexCoordOffset[0] = distance * Math.cos (angle * Math.PI / 180);
		__shader.uTexCoordOffset[1] = distance * Math.sin (angle * Math.PI / 180);
		__shader.uStrength = strength;

		CommandHelper.apply (renderSession, target, source, __shader, source == target);

	}

}

private class OffsetShader extends Shader {

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
	'uniform float uStrength;',

	'void main(void)',
	'{',
		'vec4 result = texture2D(${Shader.uSampler}, ${Shader.vTexCoord});',

		'gl_FragColor = clamp(result * uStrength, 0.0, 1.0);',
	'}',
	];

	public function new () {

		super ();

	}

}
