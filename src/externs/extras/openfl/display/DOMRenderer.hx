package openfl.display;


import lime.graphics.DOMRenderContext;
//import js.html.Element;


extern class DOMRenderer extends DisplayObjectRenderer {
	
	
	public var element:DOMRenderContext;
	public var pixelRatio (default, null):Float;
	
	public function applyStyle (parent:DisplayObject, childElement:Dynamic /*Element*/):Void;
	public function clearStyle (childElement:Dynamic /*Element*/):Void;
	
	
}