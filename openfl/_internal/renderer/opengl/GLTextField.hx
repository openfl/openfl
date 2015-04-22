package openfl._internal.renderer.opengl;


import openfl._internal.renderer.opengl.utils.GraphicsRenderer;
import openfl._internal.renderer.RenderSession;
import openfl.text.TextField;

@:access(openfl.text.TextField)


class GLTextField {
	
	
	public static function render (textField:TextField, renderSession:RenderSession) {
		
		if (!textField.__renderable || textField.__worldAlpha <= 0) return;

		TextFieldGraphics.render (textField);
		
		GraphicsRenderer.render (textField, renderSession);
		
	}
	
	
}
