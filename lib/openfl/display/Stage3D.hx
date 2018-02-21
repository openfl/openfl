package openfl.display; #if (display || !flash)


import openfl.display3D.Context3D;
import openfl.display3D.Context3DProfile;
import openfl.display3D.Context3DRenderMode;
import openfl.events.EventDispatcher;
import openfl.Vector;

@:jsRequire("openfl/display/Stage3D", "default")


extern class Stage3D extends EventDispatcher {
	
	
	public var context3D (default, null):Context3D;
	public var visible:Bool;
	public var x:Float;
	public var y:Float;
	
	
	public function requestContext3D (?context3DRenderMode:Context3DRenderMode, ?profile:Context3DProfile):Void;
	public function requestContext3DMatchingProfiles (profiles:Vector<String>):Void;
	
	
}



#else
typedef Stage3D = flash.display.Stage3D;
#end