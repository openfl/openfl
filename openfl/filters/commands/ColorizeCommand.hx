package openfl.filters.commands;

import openfl.display.BitmapData;
import openfl.display.Shader;

import openfl._internal.renderer.RenderSession;

@:access(openfl.display.BitmapData)

class ColorizeCommand {

	private static var __shader = new ColorizeShader ();

	public static function apply (renderSession:RenderSession, target:BitmapData, source:BitmapData, color:Int, alpha:Float) {

		__shader.uColor[0] = ((color >> 16) & 0xFF) / 255;
		__shader.uColor[1] = ((color >> 8) & 0xFF) / 255;
		__shader.uColor[2] = (color & 0xFF) / 255;
		__shader.uColor[3] = alpha;

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

private class ColorizeShader extends Shader {

	@vertex var vertex = [
		'void main(void)',
		'{',
			'${Shader.vTexCoord} = ${Shader.aTexCoord};',
			'${Shader.vColor} = ${Shader.aColor};',
			'gl_Position = vec4((${Shader.uProjectionMatrix} * vec3(${Shader.aPosition}, 1.0)).xy, 0.0, 1.0);',
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

	public function new () {

		super ();

	}

}
