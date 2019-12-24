package openfl._internal.backend.lime_standalone;

package lime.graphics;

#if (!lime_doc_gen || lime_dom)
#if (lime_dom && (lime_doc_gen || !doc_gen))
import js.html.Element;

/**
	The `DOMRenderContext` represents the primary `js.html.Element` instance when DOM
	is the render context type of the `Window`.

	You can convert from `lime.graphics.RenderContext` to `DOMRenderContext` directly
	if desired:

	```haxe
	var dom:DOMRenderContext = window.context;
	```
**/
@:access(lime.graphics.RenderContext)
@:forward
abstract DOMRenderContext(Element) from Element to Element
{
	@:from private static function fromRenderContext(context:RenderContext):DOMRenderContext
	{
		return context.dom;
	}
}
#else
@:forward
abstract DOMRenderContext(Dynamic) from Dynamic to Dynamic
{
	@:from private static function fromRenderContext(context:RenderContext):DOMRenderContext
	{
		return null;
	}
}
#end
#end
