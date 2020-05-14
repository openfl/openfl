package openfl.display;

#if !flash
#if lime
import lime.graphics.DOMRenderContext;
#elseif openfl_html5
import openfl._internal.backend.lime_standalone.DOMRenderContext;
#end
#if openfl_html5
import js.html.Element;
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
	public var element(get, set):#if (lime || openfl_html5) DOMRenderContext #else Dynamic #end;

	/**
		The active pixel ratio used during rendering
	**/
	public var pixelRatio(get, never):Float = 1;

	@:noCompletion private function new(element:#if (lime || openfl_html5) DOMRenderContext #else Dynamic #end)
	{
		if (_ == null)
		{
			_ = new _DOMRenderer(this, element);
		}

		super();
	}

	/**
		Applies CSS styles to the specified DOM element, using a DisplayObject as the
		virtual parent. This helps set the z-order, position and other components for
		the DOM object
	**/
	public function applyStyle(parent:DisplayObject, childElement:#if (openfl_html5 && !display) Element #else Dynamic #end):Void
	{
		_.applyStyle(parent, childElement);
	}

	/**
		Removes previously set CSS styles from a DOM element, used when the element
		should no longer be a part of the display hierarchy
	**/
	public function clearStyle(childElement:#if (openfl_html5 && !display) Element #else Dynamic #end):Void
	{
		_.clearStyle(childElement);
	}

	// Get & Set Methods

	@:noCompletion private function get_element():#if (lime || openfl_html5) DOMRenderContext #else Dynamic #end
	{
		return _.element;
	}

	@:noCompletion private function set_element(value:#if (lime || openfl_html5) DOMRenderContext #else Dynamic #end):#if (lime || openfl_html5) DOMRenderContext #else Dynamic #end
	{
		return _.element = value;
	}

	@:noCompletion private function get_pixelRatio():Float
	{
		return _.pixelRatio;
	}
}
#else
typedef DOMRenderer = Dynamic;
#end
