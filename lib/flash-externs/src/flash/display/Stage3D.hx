package flash.display;

#if flash
import openfl.display3D.Context3D;
import openfl.display3D.Context3DProfile;
import openfl.display3D.Context3DRenderMode;
import openfl.events.EventDispatcher;
import openfl.Vector;

@:require(flash11)
extern class Stage3D extends EventDispatcher
{
	#if (haxe_ver < 4.3)
	public var context3D(default, never):Context3D;
	public var visible:Bool;
	public var x:Float;
	public var y:Float;
	#else
	@:flash.property var context3D(get, never):Context3D;
	@:flash.property var visible(get, set):Bool;
	@:flash.property var x(get, set):Float;
	@:flash.property var y(get, set):Float;
	#end

	public function requestContext3D(?context3DRenderMode:Context3DRenderMode, ?profile:Context3DProfile):Void;
	@:require(flash12) public function requestContext3DMatchingProfiles(profiles:Vector<Context3DProfile>):Void;

	#if (haxe_ver >= 4.3)
	private function get_context3D():Context3D;
	private function get_visible():Bool;
	private function get_x():Float;
	private function get_y():Float;
	private function set_visible(value:Bool):Bool;
	private function set_x(value:Float):Float;
	private function set_y(value:Float):Float;
	#end
}
#else
typedef Stage3D = openfl.display.Stage3D;
#end
