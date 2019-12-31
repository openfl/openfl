package openfl.display;

#if !flash
import openfl._internal.backend.html5.Element;
#if (!lime && openfl_html5)
import openfl._internal.backend.lime_standalone.DOMRenderContext;
#else
import openfl._internal.backend.lime.DOMRenderContext;
#end

/**
	**BETA**

	The DOMRenderer API exposes support for HTML5 DOM render instructions within the
	`RenderEvent.RENDER_DOM` event
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:Dynamic")
class DOMRenderer extends DisplayObjectRenderer
{
	/**
		The current HTML5 DOM element
	**/
	public var element:#if (lime || openfl_html5) DOMRenderContext #else Dynamic #end;

	/**
		The active pixel ratio used during rendering
	**/
	public var pixelRatio(default, null):Float = 1;

	@:noCompletion private function new(element:#if (lime || openfl_html5) DOMRenderContext #else Dynamic #end)
	{
		super();

		this.element = element;
	}

	/**
		Applies CSS styles to the specified DOM element, using a DisplayObject as the
		virtual parent. This helps set the z-order, position and other components for
		the DOM object
	**/
	public function applyStyle(parent:DisplayObject, childElement:#if (openfl_html5 && !display) Element #else Dynamic #end):Void {}

	/**
		Removes previously set CSS styles from a DOM element, used when the element
		should no longer be a part of the display hierarchy
	**/
	public function clearStyle(childElement:#if (openfl_html5 && !display) Element #else Dynamic #end):Void {}

	private function __clearBitmap(bitmap:Bitmap):Void {}
}
#else
typedef DOMRenderer = Dynamic;
#end
