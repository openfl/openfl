package openfl._internal.backend.lime_standalone;

#if openfl_html5
typedef WindowAttributes =
{
	@:optional public var allowHighDPI:Bool;
	@:optional public var alwaysOnTop:Bool;
	@:optional public var borderless:Bool;
	@:optional public var context:RenderContextAttributes;
	// @:optional public var display:Int;
	@:optional public var element:js.html.Element;
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
#end
