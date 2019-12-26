package openfl._internal.backend.lime_standalone; #if openfl_html5

import haxe.io.Bytes;
import js.html.Audio;
import openfl._internal.utils.Log;
import openfl.utils.Future;
import openfl.utils.Promise;

class AudioBuffer
{
	public var bitsPerSample:Int;
	public var channels:Int;
	public var sampleRate:Int;
	public var src(get, set):Dynamic;

	@:noCompletion private var __srcAudio:Audio;
	@:noCompletion private var __srcCustom:Dynamic;
	@:noCompletion private var __srcHowl:Howl;

	public function new() {}

	public function dispose():Void
	{
		__srcHowl.unload();
	}

	public static function fromBase64(base64String:String):AudioBuffer
	{
		if (base64String == null) return null;

		// if base64String doesn't contain codec data, add it.
		if (base64String.indexOf(",") == -1)
		{
			base64String = "data:" + __getCodec(Base64.decode(base64String)) + ";base64," + base64String;
		}

		var audioBuffer = new AudioBuffer();
		audioBuffer.src = new Howl({src: [base64String], html5: true, preload: false});
		return audioBuffer;
	}

	public static function fromBytes(bytes:Bytes):AudioBuffer
	{
		if (bytes == null) return null;

		var audioBuffer = new AudioBuffer();
		audioBuffer.src = new Howl({src: ["data:" + __getCodec(bytes) + ";base64," + Base64.encode(bytes)], html5: true, preload: false});

		return audioBuffer;
	}

	public static function fromFile(path:String):AudioBuffer
	{
		if (path == null) return null;

		var audioBuffer = new AudioBuffer();

		#if force_html5_audio
		audioBuffer.__srcHowl = new Howl({src: [path], html5: true, preload: false});
		#else
		audioBuffer.__srcHowl = new Howl({src: [path], preload: false});
		#end

		return audioBuffer;
	}

	public static function fromFiles(paths:Array<String>):AudioBuffer
	{
		var audioBuffer = new AudioBuffer();

		#if force_html5_audio
		audioBuffer.__srcHowl = new Howl({src: paths, html5: true, preload: false});
		#else
		audioBuffer.__srcHowl = new Howl({src: paths, preload: false});
		#end

		return audioBuffer;
	}

	public static function loadFromFile(path:String):Future<AudioBuffer>
	{
		var promise = new Promise<AudioBuffer>();

		var audioBuffer = AudioBuffer.fromFile(path);

		if (audioBuffer != null)
		{
			audioBuffer.__srcHowl.on("load", function()
			{
				promise.complete(audioBuffer);
			});

			audioBuffer.__srcHowl.on("loaderror", function(id, msg)
			{
				promise.error(msg);
			});

			audioBuffer.__srcHowl.load();
		}
		else
		{
			promise.error(null);
		}

		return promise.future;
	}

	public static function loadFromFiles(paths:Array<String>):Future<AudioBuffer>
	{
		var promise = new Promise<AudioBuffer>();

		var audioBuffer = AudioBuffer.fromFiles(paths);

		if (audioBuffer != null)
		{
			audioBuffer.__srcHowl.on("load", function()
			{
				promise.complete(audioBuffer);
			});

			audioBuffer.__srcHowl.on("loaderror", function()
			{
				promise.error(null);
			});

			audioBuffer.__srcHowl.load();
		}
		else
		{
			promise.error(null);
		}

		return promise.future;
	}

	private static function __getCodec(bytes:Bytes):String
	{
		var signature = bytes.getString(0, 4);

		switch (signature)
		{
			case "OggS":
				return "audio/ogg";
			case "fLaC":
				return "audio/flac";
			case "RIFF" if (bytes.getString(8, 4) == "WAVE"):
				return "audio/wav";
			default:
				switch ([bytes.get(0), bytes.get(1), bytes.get(2)])
				{
					case [73, 68, 51] | [255, 251, _] | [255, 250, _] | [255, 243, _]: return "audio/mp3";
					default:
				}
		}

		Log.error("Unsupported sound format");
		return null;
	}

	// Get & Set Methods
	@:noCompletion private function get_src():Dynamic
	{
		return __srcHowl;
	}

	@:noCompletion private function set_src(value:Dynamic):Dynamic
	{
		return __srcHowl = value;
	}
}
#end
