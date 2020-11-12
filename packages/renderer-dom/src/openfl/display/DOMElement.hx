package openfl.display;

#if (!openfl_doc_gen || (js && html5))
#if (js && html5)
import js.html.Element;
#end

class DOMElement extends #if flash Sprite #else DisplayObject #end
{
	@:noCompletion private var __active:Bool;
	@SuppressWarnings("checkstyle:Dynamic") @:noCompletion private var __element:#if (js && html5) Element #else Dynamic #end;

	@SuppressWarnings("checkstyle:Dynamic")
	public function new(element:#if (js && html5) Element #else Dynamic #end)
	{
		super();

		#if !flash
		__drawableType = DOM_ELEMENT;
		#end
		__element = element;
	}
}
#end
