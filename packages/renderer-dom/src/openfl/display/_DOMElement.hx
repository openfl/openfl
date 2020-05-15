package openfl.display;

#if openfl_html5
import js.html.Element;
#end

@:noCompletion
class _DOMElement extends _DisplayObject
{
	public var __active:Bool;
	public var __element:#if openfl_html5 Element #else Dynamic #end;

	private var domElement:DOMElement;

	public function new(domElement:DOMElement, element:#if openfl_html5 Element #else Dynamic #end)
	{
		this.domElement = domElement;

		super(domElement);

		__element = element;
		__type = DOM_ELEMENT;
	}
}
