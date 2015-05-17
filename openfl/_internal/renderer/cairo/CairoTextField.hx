package openfl._internal.renderer.cairo;

import openfl._internal.renderer.cairo.CairoGraphics;
import openfl._internal.renderer.cairo.CairoTextRenderer;
import openfl._internal.renderer.opengl.utils.GraphicsRenderer;
import openfl._internal.renderer.RenderSession;
import openfl.display.Graphics;
import openfl.text.TextField;

@:access(openfl.text.TextField)


class CairoTextField {
	
	
	public static function render (textField:TextField, renderSession:RenderSession) {
		
		if (!textField.__renderable || textField.__worldAlpha <= 0) return;

		CairoTextRenderer.render (textField);
		CairoShape.render (textField, renderSession);
	}
}
