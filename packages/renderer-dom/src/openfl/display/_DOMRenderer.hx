package openfl.display;

#if lime
import lime.graphics.DOMRenderContext;
#elseif openfl_html5
import openfl._internal.backend.lime_standalone.DOMRenderContext;
#end
#if openfl_html5
import js.html.Element;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:Dynamic")
@:noCompletion
class _DOMRenderer extends _DisplayObjectRenderer
{
	public var element:#if (lime || openfl_html5) DOMRenderContext #else Dynamic #end;
	public var pixelRatio(default, null):Float = 1;

	public function new(element:#if (lime || openfl_html5) DOMRenderContext #else Dynamic #end)
	{
		super();

		this.element = element;
	}

	public function applyStyle(parent:DisplayObject, childElement:#if (openfl_html5 && !display) Element #else Dynamic #end):Void {}

	public function clearStyle(childElement:#if (openfl_html5 && !display) Element #else Dynamic #end):Void {}

	private function __clearBitmap(bitmap:Bitmap):Void {}
}
