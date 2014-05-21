package openfl.media;


import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.media.Sound;


class SoundChannel extends EventDispatcher {
	
	
	public var leftPeak (default, null):Float;
	public var position (get, set):Float;
	public var rightPeak (default, null):Float;
	public var soundTransform (get, set):SoundTransform;
	
	private var __soundInstance:SoundJSInstance;
	
	
	private function new (soundInstance:SoundJSInstance):Void {
		
		super (this);
		
		__soundInstance = soundInstance;
		__soundInstance.addEventListener ("complete", soundInstance_onComplete);
		
	}
	
	
	public function stop ():Void {
		
		__soundInstance.stop ();
		
	}
	
	
	private function __dispose ():Void {
		
		__soundInstance.stop ();
		__soundInstance = null;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_position ():Float {
		
		return __soundInstance.getPosition ();
		
	}
	
	
	private function set_position (value:Float):Float {
		
		__soundInstance.setPosition (Std.int (value));
		return __soundInstance.getPosition ();
		
	}
	
	
	private function get_soundTransform ():SoundTransform {
		
		return new SoundTransform (__soundInstance.getVolume (), __soundInstance.getPan ());
		
	}
	
	
	private function set_soundTransform (value:SoundTransform):SoundTransform {
		
		__soundInstance.setVolume (value.volume);
		__soundInstance.setPan (value.pan);
		
		return value;
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function soundInstance_onComplete (_):Void {
		
		dispatchEvent (new Event (Event.SOUND_COMPLETE));
		
	}
	
	
}