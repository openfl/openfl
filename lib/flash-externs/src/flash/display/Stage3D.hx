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
	public var context3D(default, never):Context3D;
	public var visible:Bool;
	public var x:Float;
	public var y:Float;
	public function requestContext3D(?context3DRenderMode:Context3DRenderMode, ?profile:Context3DProfile):Void;
	@:require(flash12) public function requestContext3DMatchingProfiles(profiles:Vector<Context3DProfile>):Void;
}
#else
typedef Stage3D = openfl.display.Stage3D;
#end
