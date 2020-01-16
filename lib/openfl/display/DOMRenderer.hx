package openfl.display;

// import lime.graphics.DOMRenderContext;
import js.html.Element;

typedef DOMRenderContext = js.html.Element;

#if !openfl_global
@:jsRequire("openfl/display/DOMRenderer", "default")
#end
extern class DOMRenderer extends DisplayObjectRenderer
{
	public var element:DOMRenderContext;
	public var pixelRatio(default, null):Float;
	public function applyStyle(parent:DisplayObject, childElement:Element):Void;
	public function clearStyle(childElement:Element):Void;
}
