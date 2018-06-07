package openfl._internal.renderer.opengl;


import openfl.display.OpenGLRenderer;
import openfl.geom.Matrix;
import openfl.text.TextField;

#if (js && html5)
import openfl._internal.renderer.canvas.CanvasTextField;
#else
import openfl._internal.renderer.cairo.CairoTextField;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class GLTextField {
	
	
	public static function render (textField:TextField, renderer:OpenGLRenderer, transform:Matrix):Void {
		
		#if (js && html5)
		CanvasTextField.render (textField, cast renderer.__softwareRenderer, transform);
		#elseif lime_cairo
		CairoTextField.render (textField, cast renderer.__softwareRenderer, transform);
		#end
		
	}
	
	
}