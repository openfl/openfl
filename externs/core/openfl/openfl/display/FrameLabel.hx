package openfl.display; #if (display || !flash)


import openfl.events.EventDispatcher;


@:final extern class FrameLabel extends EventDispatcher {
	
	
	public var frame (get, never):Int;
	public var name (get, never):String;
	
	
	public function new (name:String, frame:Int):Void;
	
	
}


#else
typedef FrameLabel = flash.display.FrameLabel;
#end