package openfl.display;


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
	
	
	
	
	private function get_frame ():Int { return __frame; }
	private function get_name ():String { return __name; }
	
	
}