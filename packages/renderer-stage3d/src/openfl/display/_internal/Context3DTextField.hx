package openfl.display._internal;

import openfl.display._internal.CairoTextField;
import openfl.display._internal.CanvasTextField;
import openfl.display.OpenGLRenderer;
import openfl.text.TextField;

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
		#if (js && html5)
		CanvasTextField.render(textField, cast renderer.__softwareRenderer, textField.__worldTransform);
		#elseif lime_cairo
		CairoTextField.render(textField, cast renderer.__softwareRenderer, textField.__worldTransform);
		#end
		textField.__graphics.__hardwareDirty = false;
	}

	public static function renderMask(textField:TextField, renderer:OpenGLRenderer):Void
	{
		#if (js && html5)
		CanvasTextField.render(textField, cast renderer.__softwareRenderer, textField.__worldTransform);
		#elseif lime_cairo
		CairoTextField.render(textField, cast renderer.__softwareRenderer, textField.__worldTransform);
		#end
		textField.__graphics.__hardwareDirty = false;
	}
}
