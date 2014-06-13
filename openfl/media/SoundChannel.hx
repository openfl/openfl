package openfl.media;


import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.media.Sound;


class SoundChannel extends EventDispatcher {
	
	
	public var leftPeak (default, null):Float;
	public var position (get, set):Float;
	public var rightPeak (default, null):Float;
	public var soundTransform (get, set):SoundTransform;
	
	#if js
	private var __soundInstance:SoundJSInstance;
	#end
	
	
	private function new (#if js soundInstance:SoundJSInstance #end):Void {
		
		super (this);
		
		#if js
		__soundInstance = soundInstance;
		__soundInstance.addEventListener ("complete", soundInstance_onComplete);
		#end
		
	}
	
	
	public function stop ():Void {
		
		#if js
		__soundInstance.stop ();
		#end
		
	}
	
	
	private function __dispose ():Void {
		
		#if js
		__soundInstance.stop ();
		__soundInstance = null;
		#end
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_position ():Float {
		
		#if js
		return __soundInstance.getPosition ();
		#else
		return 0;
		#end
		
	}
	
	
	private function set_position (value:Float):Float {
		
		#if js
		__soundInstance.setPosition (Std.int (value));
		return __soundInstance.getPosition ();
		#else
		return 0;
		#end
		
	}
	
	
	private function get_soundTransform ():SoundTransform {
		
		#if js
		return new SoundTransform (__soundInstance.getVolume (), __soundInstance.getPan ());
		#else
		return null;
		#end
		
	}
	
	
	private function set_soundTransform (value:SoundTransform):SoundTransform {
		
		#if js
		__soundInstance.setVolume (value.volume);
		__soundInstance.setPan (value.pan);
		#end
		
		return value;
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function soundInstance_onComplete (_):Void {
		
		dispatchEvent (new Event (Event.SOUND_COMPLETE));
		
	}
	
	
}