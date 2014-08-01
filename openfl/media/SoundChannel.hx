package openfl.media; #if !flash


import lime.media.AudioSource;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.media.Sound;


class SoundChannel extends EventDispatcher {
	
	
	public var leftPeak (default, null):Float;
	public var position (get, set):Float;
	public var rightPeak (default, null):Float;
	public var soundTransform (get, set):SoundTransform;
	
	private var __source:AudioSource;
	
	
	private function new (source:AudioSource):Void {
		
		super (this);
		
		__source = source;
		__source.onComplete.add (source_onComplete);
		__source.play ();
		
	}
	
	
	public function stop ():Void {
		
		__source.stop ();
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_position ():Float {
		
		return __source.timeOffset / 1000;
		
	}
	
	
	private function set_position (value:Float):Float {
		
		__source.timeOffset = Std.int (value * 1000);
		return value;
		
	}
	
	
	private function get_soundTransform ():SoundTransform {
		
		// TODO: pan
		
		return new SoundTransform (__source.gain, 0);
		
	}
	
	
	private function set_soundTransform (value:SoundTransform):SoundTransform {
		
		__source.gain = value.volume;
		
		// TODO: pan
		
		return value;
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function source_onComplete ():Void {
		
		dispatchEvent (new Event (Event.SOUND_COMPLETE));
		
	}
	
	
}


#else
typedef SoundChannel = flash.media.SoundChannel;
#end