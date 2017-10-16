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
	private var sound:Sound;

	private static var pool : ObjectPool<SoundChannel> = new ObjectPool<SoundChannel>(function() { return new SoundChannel();});


	private function new ():Void {

		super (this);

		leftPeak = 1;
		rightPeak = 1;

	}

	public static function __create(source:Sound) {
		var channel = pool.get();

		if (source != null) {

			channel.sound = source;
			#if !html5
			@:privateAccess channel.sound.__sound.onComplete.add (channel.soundInstance_onComplete);
			channel.sound.__sound.play ();
			#else
			@:privateAccess channel.sound.__sound.on("stop",channel.soundInstance_onComplete, channel.sound.__soundId);
			#end
			channel.__isValid = true;

		}

		return channel;
	}


	public function stop ():Void {

		if (!__isValid) return;

		#if !html5
		sound.stop ();
		__dispose ();
		#else
		sound.stop ();
		#end

	}


	private function __dispose ():Void {

		if (!__isValid) return;

		sound.dispose();
		pool.put(this);

		__isValid = false;

	}




	// Get & Set Methods




	private function get_position ():Float {

		if (!__isValid) return 0;

		#if !html5
		return (sound.__sound.currentTime + sound.__sound.offset) / 1000;
		#else
		return sound.__sound.seek();
		#end

	}


	private function set_position (value:Float):Float {

		if (!__isValid) return 0;

		#if !html5
		sound.__sound.currentTime = Std.int (value * 1000) - sound.__sound.offset;
		return value;
		#else
		sound.__sound.seek(Std.int (value));
		return sound.__sound.seek();
		#end

	}


	private function get_soundTransform ():SoundTransform {

		if (!__isValid) return new SoundTransform ();

		// TODO: pan

		#if !html5
		return new SoundTransform (sound.__sound.gain, 0);
		#else
		return new SoundTransform (@:privateAccess sound.__sound.volume(), 0);
		#end

	}


	private function set_soundTransform (value:SoundTransform):SoundTransform {

		if (!__isValid) return value;

		#if !html5
		sound.__sound.gain = value.volume;

		// TODO: pan

		return value;
		#else
		sound.__sound.volume(value.volume);
		return value;
		#end

	}




	// Event Handlers

	private function soundInstance_onComplete (_):Void {

		__dispose ();
		dispatchEvent (Event.__create (Event.SOUND_COMPLETE));

	}

}


#else
typedef SoundChannel = openfl._legacy.media.SoundChannel;
#end
