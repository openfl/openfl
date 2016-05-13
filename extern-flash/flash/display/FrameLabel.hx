package flash.display; #if (!display && flash)


import openfl.events.EventDispatcher;


@:final extern class FrameLabel extends EventDispatcher {
	
	
	public var frame (default, null):Int;
	public var name (default, null):String;
	
	
	public function new (name:String, frame:Int):Void;
	
	
}


#else
typedef FrameLabel = openfl.display.FrameLabel;
#end