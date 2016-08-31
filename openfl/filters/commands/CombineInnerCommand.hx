package openfl.filters.commands;

import openfl.display.BitmapData;
import openfl.display.Shader;

import openfl._internal.renderer.RenderSession;

@:access(openfl.display.BitmapData)

class CombineInnerCommand {

	private static var __shader = new CombineInnerShader ();

	public static function apply (renderSession:RenderSession, target:BitmapData, source1:BitmapData, source2:BitmapData) {
		__shader.uSource1Sampler = source1;

		var same = source1 == target || source2 == target;

		target.__pingPongTexture.swap();

		if (same) {
		target.__pingPongTexture.useOldTexture = true;
		}

		var source_shader = source2.__shader;
		source2.__shader = __shader;
		target.__drawGL(renderSession, source2, source2.rect, true, false, true);
		source2.__shader = source_shader;

		if (same) {
			target.__pingPongTexture.useOldTexture = false;
		}
	}

}

private class CombineInnerShader extends Shader {

	@vertex var vertex = [
		'void main(void)',
		'{',
			'${Shader.vTexCoord} = ${Shader.aTexCoord};',
			'${Shader.vColor} = ${Shader.aColor};',
			'gl_Position = vec4((${Shader.uProjectionMatrix} * vec3(${Shader.aPosition}, 1.0)).xy, 0.0, 1.0);',
		'}',
	];

	@fragment var fragment = [
		'uniform sampler2D uSource1Sampler;',

		'void main(void)',
		'{',
			'vec4 src2 = texture2D(${Shader.uSampler}, ${Shader.vTexCoord});',
			'vec4 src1 = texture2D(uSource1Sampler, ${Shader.vTexCoord});',
			'gl_FragColor = clamp(src1 * (1.0 - src2.a) + src1.a * src2, 0.0, 1.0);',
		'}',
	];

	public function new () {

		super ();

	}

}
