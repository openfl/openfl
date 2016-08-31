package openfl.filters.commands;

import openfl.display.BitmapData;
import openfl.display.Shader;

import openfl._internal.renderer.RenderSession;

@:access(openfl.display.BitmapData)

class ColorLookupCommand {

	private static var __shader = new ColorLookupShader ();

	public static function apply (renderSession:RenderSession, target:BitmapData, source:BitmapData, colorLookup:BitmapData) {

		__shader.uColorLookupSampler = colorLookup;

		var same = source == target;
		
		target.__pingPongTexture.swap();

		if (same) {
			source.__pingPongTexture.useOldTexture = true;
		}

		var source_shader = source.__shader;
		source.__shader = __shader;
		target.__drawGL(renderSession, source, source.rect, true, false, true);
		source.__shader = source_shader;

		if (same) {
			source.__pingPongTexture.useOldTexture = false;
		}
	}

}

private class ColorLookupShader extends Shader {

	@vertex var vertex = [
		'void main(void)',
		'{',
			'${Shader.vTexCoord} = ${Shader.aTexCoord};',
			'${Shader.vColor} = ${Shader.aColor};',
			'gl_Position = vec4((${Shader.uProjectionMatrix} * vec3(${Shader.aPosition}, 1.0)).xy, 0.0, 1.0);',
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

	public function new () {

		super ();

	}

}
