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

		__element = element;
	}

	#if !flash
	@:noCompletion private override function __renderDOM(renderer:DOMRenderer):Void
	{
		#if (js && html5)
		if (stage != null && __worldVisible && __renderable)
		{
			if (!__active)
			{
				renderer.__initializeElement(this, __element);
				__active = true;
			}

			renderer.__updateClip(this);
			renderer.__applyStyle(this, true, true, true);
		}
		else
		{
			if (__active)
			{
				renderer.element.removeChild(__element);
				__active = false;
			}
		}

		super.__renderDOM(renderer);
		#end
	}
	#end
}
#end
