package openfl.utils._internal;

import openfl.display.DisplayObject;
import openfl.display.InteractiveObject;
import openfl.display.Sprite;
import openfl.geom.Rectangle;
#if lime
import lime.ui.Touch;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
class TouchData
{
	public static var __pool:ObjectPool<TouchData> = new ObjectPool<TouchData>(function() return new TouchData(), function(data) data.reset());

	public var dragBounds:Rectangle;
	public var dragObject:Sprite;
	public var dragOffsetX:Float;
	public var dragOffsetY:Float;
	public var rollOutStack:Array<DisplayObject>;
	@SuppressWarnings("checkstyle:Dynamic") public var touch:#if lime Touch #else Dynamic #end;
	public var touchDownTarget:InteractiveObject;
	public var touchOverTarget:InteractiveObject;

	public function new()
	{
		rollOutStack = [];
		dragOffsetX = 0;
		dragOffsetY = 0;
	}

	public function reset():Void
	{
		touch = null;
		touchDownTarget = null;
		touchOverTarget = null;
		dragBounds = null;
		dragObject = null;
		dragOffsetX = 0;
		dragOffsetY = 0;

		rollOutStack.splice(0, rollOutStack.length);
	}
}
