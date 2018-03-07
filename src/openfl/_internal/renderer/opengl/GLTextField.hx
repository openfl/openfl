package openfl._internal.renderer.opengl;


import openfl._internal.renderer.RenderSession;
import openfl.geom.Matrix;
import openfl.text.TextField;

#if (js && html5)
import openfl._internal.renderer.canvas.CanvasTextField;
#else
import openfl._internal.renderer.cairo.CairoTextField;
#end


class GLTextField {
	
	
	public static function render (textField:TextField, renderSession:RenderSession, transform:Matrix):Void {
		
		var renderer:GLRenderer = cast renderSession.renderer;
		
		#if (js && html5)
		CanvasTextField.render (textField, renderer.softwareRenderSession, transform);
		#elseif lime_cairo
		CairoTextField.render (textField, renderer.softwareRenderSession, transform);
		#end
		
	}
	
	
}