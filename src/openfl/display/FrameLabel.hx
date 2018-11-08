package openfl.display; #if !flash


import openfl.events.EventDispatcher;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


@:final class FrameLabel extends EventDispatcher {
	
	
	public var frame (get, never):Int;
	public var name (get, never):String;
	
	@:noCompletion private var __frame:Int;
	@:noCompletion private var __name:String;
	
	
	#if openfljs
	@:noCompletion private static function __init__ () {
		
		untyped Object.defineProperty (FrameLabel.prototype, "frame", { get: untyped __js__ ("function () { return this.get_frame (); }") });
		untyped Object.defineProperty (FrameLabel.prototype, "name", { get: untyped __js__ ("function () { return this.get_name (); }") });
		
	}
	#end
	
	
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
typedef FrameLabel = flash.display.FrameLabel;
#end