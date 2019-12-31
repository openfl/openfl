package openfl._internal.utils;

import openfl.display.DisplayObject;
import openfl.display.InteractiveObject;
#if (!lime && openfl_html5)
import openfl._internal.backend.lime_standalone.Touch;
#else
import openfl._internal.backend.lime.Touch;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
class TouchData
{
	public static var __pool:ObjectPool<TouchData> = new ObjectPool<TouchData>(function() return new TouchData(), function(data) data.reset());

	public var rollOutStack:Array<DisplayObject>;
	@SuppressWarnings("checkstyle:Dynamic") public var touch:#if (lime || openfl_html5) Touch #else Dynamic #end;
	public var touchDownTarget:InteractiveObject;
	public var touchOverTarget:InteractiveObject;

	public function new()
	{
		rollOutStack = [];
	}

	public function reset():Void
	{
		touch = null;
		touchDownTarget = null;
		touchOverTarget = null;

		rollOutStack.splice(0, rollOutStack.length);
	}
}
