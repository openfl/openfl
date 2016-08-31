package openfl.filters.commands;

import openfl.display.BitmapData;
import openfl.display.Shader;

import openfl._internal.renderer.RenderSession;

@:access(openfl.display.BitmapData)

class CommandHelper {

	public static function apply (renderSession:RenderSession, target:BitmapData, source:BitmapData, shader:Shader, drawSelf:Bool) {

		if (target.__usingPingPongTexture) {
			target.__pingPongTexture.swap();
		}

		if (drawSelf) {
			target.__pingPongTexture.useOldTexture = true;
		}

		var source_shader = source.__shader;
		source.__shader = shader;
		target.__drawGL(renderSession, source, source.rect, true, false, true);
		source.__shader = source_shader;

		if (drawSelf) {
			target.__pingPongTexture.useOldTexture = false;
		}
	}
}
