package openfl.display;

// import lime.graphics.DOMRenderContext;
import js.html.Element;

typedef DOMRenderContext = js.html.Element;

@:jsRequire("openfl/display/DOMRenderer", "default")
extern class DOMRenderer extends DisplayObjectRenderer
{
	public var element:DOMRenderContext;
	public var pixelRatio(default, null):Float;
	public function applyStyle(parent:DisplayObject, childElement:Element):Void;
	public function clearStyle(childElement:Element):Void;
}
