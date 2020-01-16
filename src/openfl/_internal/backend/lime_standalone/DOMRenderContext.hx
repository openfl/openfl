package openfl._internal.backend.lime_standalone;

#if openfl_html5
import js.html.Element;

@:access(lime.graphics.RenderContext)
@:forward
abstract DOMRenderContext(Element) from Element to Element
{
	@:from private static function fromRenderContext(context:RenderContext):DOMRenderContext
	{
		return context.dom;
	}
}
#end
