package openfl.filters.commands;

import openfl.display.BitmapData;
import openfl.display.Shader;

import openfl._internal.renderer.RenderSession;

class ColorTransformCommand {

	private static var __shader = new ColorTransformShader ();

	public static function apply (renderSession:RenderSession, target:BitmapData, source:BitmapData, colorMatrix:Array<Float>) {

		__shader.uMultipliers = [ colorMatrix[0], colorMatrix[1], colorMatrix[2], colorMatrix[3], colorMatrix[5], colorMatrix[6], colorMatrix[7], colorMatrix[8], colorMatrix[10], colorMatrix[11], colorMatrix[12], colorMatrix[13], colorMatrix[15], colorMatrix[16], colorMatrix[17], colorMatrix[18] ];
		__shader.uOffsets = [ colorMatrix[4] / 255., colorMatrix[9] / 255., colorMatrix[14] / 255., colorMatrix[19] / 255. ];

		CommandHelper.apply (renderSession, target, source, __shader, source == target);

	}

}

private class ColorTransformShader extends Shader {

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
