package openfl.display; #if (!display && !flash)


import openfl.events.EventDispatcher;


@:final class FrameLabel extends EventDispatcher {
	
	
	public var frame (get, null):Int;
	public var name (get, null):String;
	
	private var __frame:Int;
	private var __name:String;
	
	
	public function new (name:String, frame:Int) {
		
		super ();
		
		__name = name;
		__frame = frame;
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	@:noCompletion private function get_frame ():Int { return __frame; }
	@:noCompletion private function get_name ():String { return __name; }
	
	
}


#else


import openfl.events.EventDispatcher;


#if flash
@:native("flash.display.FrameLabel")
#end

@:final extern class FrameLabel extends EventDispatcher {
	
	
	public var frame (default, null):Int;
	public var name (default, null):String;
	
	
	public function new (name:String, frame:Int):Void;
	
	
}


#end