package openfl._internal.backend.lime_standalone;

package lime.ui;

import lime.graphics.RenderContextAttributes;

typedef WindowAttributes =
{
	@:optional public var allowHighDPI:Bool;
	@:optional public var alwaysOnTop:Bool;
	@:optional public var borderless:Bool;
	@:optional public var context:RenderContextAttributes;
	// @:optional public var display:Int;
	@:optional public var element:#if (js && html5 && !doc_gen) js.html.Element #else Dynamic #end;
	@:optional public var frameRate:Float;
	@:optional public var fullscreen:Bool;
	@:optional public var height:Int;
	@:optional public var hidden:Bool;
	@:optional public var maximized:Bool;
	@:optional public var minimized:Bool;
	@:optional public var parameters:Dynamic;
	@:optional public var resizable:Bool;
	@:optional public var title:String;
	@:optional public var width:Int;
	@:optional public var x:Int;
	@:optional public var y:Int;
}
