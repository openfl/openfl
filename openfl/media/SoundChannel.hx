package openfl.media; #if (!openfl_legacy || disable_legacy_audio)


import lime.audio.AudioSource;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.media.Sound;


@:final @:keep class SoundChannel extends EventDispatcher {


	public var leftPeak (default, null):Float;
	public var position (get, set):Float;
	public var rightPeak (default, null):Float;
	public var soundTransform (get, set):SoundTransform;

	private var __isValid:Bool;
	private var __source:AudioSource;

	#if html5
	private var __soundInstance:SoundJSInstance;
	#end

	private static var pool : ObjectPool<SoundChannel> = new ObjectPool<SoundChannel>(function() { return new SoundChannel();});


	private function new (#if !html5 source:AudioSource #else soundInstance:SoundJSInstance #end = null):Void {

		super (this);

		leftPeak = 1;
		rightPeak = 1;

	}

	public static function __create(#if !html5 source:AudioSource #else soundInstance:SoundJSInstance #end) {
		var channel = pool.get();
		#if !html5

			if (source != null) {

				channel.__source = source;
				channel.__source.onComplete.add (channel.source_onComplete);
				channel.__isValid = true;

				channel.__source.play ();

			}

		#else

			if (soundInstance != null) {

				channel.__soundInstance = soundInstance;
				channel.__soundInstance.addEventListener ("complete", channel.source_onComplete);
				channel.__isValid = true;

			}

		#end

		return channel;
	}


	public function stop ():Void {

		if (!__isValid) return;

		#if !html5
		__source.stop ();
		__dispose ();
		#else
		__soundInstance.stop ();
		#end

	}


	private function __dispose ():Void {

		if (!__isValid) return;

		#if !html5
		__source.dispose ();
		#else
		__soundInstance.stop ();
		__soundInstance = null;
		#end

		pool.put(this);

		__isValid = false;

	}




	// Get & Set Methods




	private function get_position ():Float {

		if (!__isValid) return 0;

		#if !html5
		return (__source.currentTime + __source.offset) / 1000;
		#else
		return __soundInstance.getPosition ();
		#end

	}


	private function set_position (value:Float):Float {

		if (!__isValid) return 0;

		#if !html5
		__source.currentTime = Std.int (value * 1000) - __source.offset;
		return value;
		#else
		__soundInstance.setPosition (Std.int (value));
		return __soundInstance.getPosition ();
		#end

	}


	private function get_soundTransform ():SoundTransform {

		if (!__isValid) return new SoundTransform ();

		// TODO: pan

		#if !html5
		return new SoundTransform (__source.gain, 0);
		#else
		return new SoundTransform (__soundInstance.getVolume (), __soundInstance.getPan ());
		#end

	}


	private function set_soundTransform (value:SoundTransform):SoundTransform {

		if (!__isValid) return value;

		#if !html5
		__source.gain = value.volume;

		// TODO: pan

		return value;
		#else
		__soundInstance.setVolume (value.volume);
		__soundInstance.setPan (value.pan);

		return value;
		#end

	}




	// Event Handlers




	#if html5
	private function soundInstance_onComplete (_):Void {

		dispatchEvent (Event.__create (Event.SOUND_COMPLETE));

	}
	#end


	private function source_onComplete ():Void {

		__dispose ();
		dispatchEvent (Event.__create (Event.SOUND_COMPLETE));

	}


}


#else
typedef SoundChannel = openfl._legacy.media.SoundChannel;
#end
