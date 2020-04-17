package openfl.display;

#if (!openfl_doc_gen || openfl_html5)
#if openfl_html5
import js.html.Element;
#end

class DOMElement extends #if flash Sprite #else DisplayObject #end
{
	@:noCompletion private var __active:Bool;
	@SuppressWarnings("checkstyle:Dynamic") @:noCompletion private var __element:#if openfl_html5 Element #else Dynamic #end;

	@SuppressWarnings("checkstyle:Dynamic")
	public function new(element:#if openfl_html5 Element #else Dynamic #end)
	{
		super();

		__element = element;

		#if !flash
		__type = DOM_ELEMENT;
		#end
	}
}
#end
