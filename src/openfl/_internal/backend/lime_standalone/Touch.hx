package openfl._internal.backend.lime_standalone;

package lime.ui;

import lime.app.Event;

#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Touch
{
	public static var onCancel = new Event<Touch->Void>();
	public static var onEnd = new Event<Touch->Void>();
	public static var onMove = new Event<Touch->Void>();
	public static var onStart = new Event<Touch->Void>();

	public var device:Int;
	public var dx:Float;
	public var dy:Float;
	public var id:Int;
	public var pressure:Float;
	public var x:Float;
	public var y:Float;

	public function new(x:Float, y:Float, id:Int, dx:Float, dy:Float, pressure:Float, device:Int)
	{
		this.x = x;
		this.y = y;
		this.id = id;
		this.dx = dx;
		this.dy = dy;
		this.pressure = pressure;
		this.device = device;
	}
}
