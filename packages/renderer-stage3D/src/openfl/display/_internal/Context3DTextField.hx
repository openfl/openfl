package openfl.display._internal;

#if openfl_gl
import openfl.display._internal.CairoTextField;
import openfl.display._internal.CanvasTextField;
import openfl.display._Context3DRenderer;
import openfl.text.TextField;
import openfl.text._TextField;

#if !openfl_debug
@:fileXml(' tags="haxe,release" ')
@:noDebug
#end
@:access(openfl.display.Graphics)
@:access(openfl.text.TextField)
@SuppressWarnings("checkstyle:FieldDocComment")
class Context3DTextField
{
	public static function render(textField:TextField, renderer:OpenGLRenderer):Void
	{
		#if openfl_html5
		CanvasTextField.render(textField, cast(renderer._ : _Context3DRenderer).__softwareRenderer, (textField._ : _TextField).__worldTransform);
		#elseif openfl_cairo
		CairoTextField.render(textField, cast(renderer._ : _Context3DRenderer).__softwareRenderer, (textField._ : _TextField).__worldTransform);
		#end
		((textField._ : _TextField).__graphics._ : _Graphics).__hardwareDirty = false;
	}

	public static function renderMask(textField:TextField, renderer:OpenGLRenderer):Void
	{
		#if openfl_html5
		CanvasTextField.render(textField, cast(renderer._ : _Context3DRenderer).__softwareRenderer, (textField._ : _TextField).__worldTransform);
		#elseif openfl_cairo
		CairoTextField.render(textField, cast(renderer._ : _Context3DRenderer).__softwareRenderer, (textField._ : _TextField).__worldTransform);
		#end
		((textField._ : _TextField).__graphics._ : _Graphics).__hardwareDirty = false;
	}
}
#end
