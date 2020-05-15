package openfl.display;

#if (!openfl_doc_gen || openfl_html5)
#if openfl_html5
import js.html.Element;
#end

class DOMElement extends #if flash Sprite #else DisplayObject #end
{
	@SuppressWarnings("checkstyle:Dynamic")
	public function new(element:#if openfl_html5 Element #else Dynamic #end)
	{
		#if !flash
		if (_ == null)
		{
			_ = new _DOMElement(this, element);
		}
		#end

		super();
	}
}
#end
