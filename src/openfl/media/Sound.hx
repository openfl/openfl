package openfl.media;

#if !flash
import haxe.Int64;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.IOErrorEvent;
import openfl.net.URLRequest;
import openfl.utils.ByteArray;
import openfl.utils.Future;
#if lime
import openfl.utils._internal.UInt8Array;
import lime.media.AudioBuffer;
import lime.media.AudioSource;
#end

/**
	The Sound class lets you work with sound in an application. The Sound class
	lets you create a Sound object, load and play an external MP3 file into
	that object, close the sound stream, and access data about the sound, such
	as information about the number of bytes in the stream and ID3 metadata.
	More detailed control of the sound is performed through the sound source
	 -  the SoundChannel or Microphone object for the sound  -  and through the
	properties in the SoundTransform class that control the output of the sound
	to the computer's speakers.

	In Flash Player 10 and later and AIR 1.5 and later, you can also use
	this class to work with sound that is generated dynamically. In this case,
	the Sound object uses the function you assign to a `sampleData`
	event handler to poll for sound data. The sound is played as it is
	retrieved from a ByteArray object that you populate with sound data. You
	can use `Sound.extract()` to extract sound data from a Sound
	object, after which you can manipulate it before writing it back to the
	stream for playback.

	To control sounds that are embedded in a SWF file, use the properties in
	the SoundMixer class.

	**Note**: The ActionScript 3.0 Sound API differs from ActionScript
	2.0. In ActionScript 3.0, you cannot take sound objects and arrange them in
	a hierarchy to control their properties.

	When you use this class, consider the following security model:


	* Loading and playing a sound is not allowed if the calling file is in
	a network sandbox and the sound file to be loaded is local.
	* By default, loading and playing a sound is not allowed if the calling
	file is local and tries to load and play a remote sound. A user must grant
	explicit permission to allow this type of access.
	* Certain operations dealing with sound are restricted. The data in a
	loaded sound cannot be accessed by a file in a different domain unless you
	implement a cross-domain policy file. Sound-related APIs that fall under
	this restriction are `Sound.id3`,
	`SoundMixer.computeSpectrum()`,
	`SoundMixer.bufferTime`, and the `SoundTransform`
	class.


	However, in Adobe AIR, content in the `application` security
	sandbox(content installed with the AIR application) are not restricted by
	these security limitations.

	For more information related to security, see the Flash Player Developer
	Center Topic: [Security](http://www.adobe.com/go/devnet_security_en).

	@event complete   Dispatched when data has loaded successfully.
	@event id3        Dispatched by a Sound object when ID3 data is available
					  for an MP3 sound.
	@event ioError    Dispatched when an input/output error occurs that causes
					  a load operation to fail.
	@event open       Dispatched when a load operation starts.
	@event progress   Dispatched when data is received as a load operation
					  progresses.
	@event sampleData Dispatched when the runtime requests new audio data.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(lime.media.AudioBuffer)
@:access(lime.utils.AssetLibrary)
@:access(openfl.media.SoundMixer)
@:access(openfl.media.SoundChannel.new)
@:autoBuild(openfl.utils._internal.AssetsMacro.embedSound())
class Sound extends EventDispatcher
{
	/**
		Returns the currently available number of bytes in this sound object. This
		property is usually useful only for externally loaded files.
	**/
	public var bytesLoaded(default, null):Int;

	/**
		Returns the total number of bytes in this sound object.
	**/
	public var bytesTotal(default, null):Int;

	/**
		Provides access to the metadata that is part of an MP3 file.
		MP3 sound files can contain ID3 tags, which provide metadata about the
		file. If an MP3 sound that you load using the `Sound.load()` method
		contains ID3 tags, you can query these properties. Only ID3 tags that
		use the UTF-8 character set are supported.

		Flash Player 9 and later and AIR support ID3 2.0 tags, specifically
		2.3 and 2.4. The following tables list the standard ID3 2.0 tags and
		the type of content the tags represent. The `Sound.id3` property
		provides access to these tags through the format `my_sound.id3.COMM`,
		`my_sound.id3.TIME`, and so on. The first table describes tags that
		can be accessed either through the ID3 2.0 property name or the
		ActionScript property name. The second table describes ID3 tags that
		are supported but do not have predefined properties in ActionScript.

		| ID3 2.0 tag | Corresponding Sound class property |
		| --- | --- |
		| COMM | Sound.id3.comment |
		| TALB | Sound.id3.album |
		| TCON | Sound.id3.genre |
		| TIT2 | Sound.id3.songName |
		| TPE1 | Sound.id3.artist |
		| TRCK | Sound.id3.track |
		| TYER | Sound.id3.year |

		The following table describes ID3 tags that are supported but do not
		have predefined properties in the Sound class. You access them by
		calling `mySound.id3.TFLT`, `mySound.id3.TIME`, and so on. **NOTE:**
		None of these tags are supported in Flash Lite 4.

		| Property | Description |
		| --- | --- |
		| TFLT | File type |
		| TIME | Time |
		| TIT1 | Content group description |
		| TIT2 | Title/song name/content description |
		| TIT3 | Subtitle/description refinement |
		| TKEY | Initial key |
		| TLAN | Languages |
		| TLEN | Length |
		| TMED | Media type |
		| TOAL | Original album/movie/show title |
		| TOFN | Original filename |
		| TOLY | Original lyricists/text writers |
		| TOPE | Original artists/performers |
		| TORY | Original release year |
		| TOWN | File owner/licensee |
		| TPE1 | Lead performers/soloists |
		| TPE2 | Band/orchestra/accompaniment |
		| TPE3 | Conductor/performer refinement |
		| TPE4 | Interpreted, remixed, or otherwise modified by |
		| TPOS | Part of a set |
		| TPUB | Publisher |
		| TRCK | Track number/position in set |
		| TRDA | Recording dates |
		| TRSN | Internet radio station name |
		| TRSO | Internet radio station owner |
		| TSIZ | Size |
		| TSRC | ISRC (international standard recording code) |
		| TSSE | Software/hardware and settings used for encoding |
		| TYER | Year |
		| WXXX | URL link frame |

		When using this property, consider the Flash Player security model:

		* The `id3` property of a Sound object is always permitted for SWF
		files that are in the same security sandbox as the sound file. For
		files in other sandboxes, there are security checks.
		* When you load the sound, using the `load()` method of the Sound
		class, you can specify a `context` parameter, which is a
		SoundLoaderContext object. If you set the `checkPolicyFile` property
		of the SoundLoaderContext object to `true`, Flash Player checks for a
		URL policy file on the server from which the sound is loaded. If a
		policy file exists and permits access from the domain of the loading
		SWF file, then the file is allowed to access the `id3` property of the
		Sound object; otherwise it is not.

		However, in Adobe AIR, content in the `application` security sandbox
		(content installed with the AIR application) are not restricted by
		these security limitations.

		For more information related to security, see the Flash Player
		Developer Center Topic: <a
		href="http://www.adobe.com/go/devnet_security_en"
		scope="external">Security</a>.
	**/
	public var id3(get, never):ID3Info;

	/**
		Returns the buffering state of external MP3 files. If the value is
		`true`, any playback is currently suspended while the object
		waits for more data.
	**/
	public var isBuffering(default, null):Bool;

	// @:noCompletion @:dox(hide) @:require(flash10_1) public var isURLInaccessible (default, null):Bool;

	/**
		The length of the current sound in milliseconds.
	**/
	public var length(get, never):Float;

	/**
		The URL from which this sound was loaded. This property is applicable only
		to Sound objects that were loaded using the `Sound.load()`
		method. For Sound objects that are associated with a sound asset from a
		SWF file's library, the value of the `url` property is
		`null`.

		When you first call `Sound.load()`, the `url`
		property initially has a value of `null`, because the final URL
		is not yet known. The `url` property will have a non-null value
		as soon as an `open` event is dispatched from the Sound
		object.

		The `url` property contains the final, absolute URL from
		which a sound was loaded. The value of `url` is usually the
		same as the value passed to the `stream` parameter of
		`Sound.load()`. However, if you passed a relative URL to
		`Sound.load()` the value of the `url` property
		represents the absolute URL. Additionally, if the original URL request is
		redirected by an HTTP server, the value of the `url` property
		reflects the final URL from which the sound file was actually downloaded.
		This reporting of an absolute, final URL is equivalent to the behavior of
		`LoaderInfo.url`.

		In some cases, the value of the `url` property is truncated;
		see the `isURLInaccessible` property for details.
	**/
	public var url(default, null):String;

	#if lime
	@:noCompletion private var __buffer:AudioBuffer;
	#end

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperties(Sound.prototype, {
			"id3": {get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_id3 (); }")},
			"length": {get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_length (); }")},
		});
	}
	#end

	/**
		Creates a new Sound object. If you pass a valid URLRequest object to the
		Sound constructor, the constructor automatically calls the
		`load()` function for the Sound object. If you do not pass a
		valid URLRequest object to the Sound constructor, you must call the
		`load()` function for the Sound object yourself, or the stream
		will not load.

		Once `load()` is called on a Sound object, you can't later
		load a different sound file into that Sound object. To load a different
		sound file, create a new Sound object.
		In Flash Player 10 and later and AIR 1.5 and later, instead of using
		`load()`, you can use the `sampleData` event handler
		to load sound dynamically into the Sound object.

		@param stream  The URL that points to an external MP3 file.
		@param context An optional SoundLoader context object, which can define
					   the buffer time(the minimum number of milliseconds of MP3
					   data to hold in the Sound object's buffer) and can specify
					   whether the application should check for a cross-domain
					   policy file prior to loading the sound.
	**/
	public function new(stream:URLRequest = null, context:SoundLoaderContext = null)
	{
		super(this);

		bytesLoaded = 0;
		bytesTotal = 0;
		isBuffering = false;
		url = null;

		if (stream != null)
		{
			load(stream, context);
		}
	}

	/**
		Closes the stream, causing any download of data to cease. No data may
		be read from the stream after the `close()` method is called.

		@throws IOError The stream could not be closed, or the stream was not
						open.
	**/
	public function close():Void
	{
		#if lime
		if (__buffer != null)
		{
			__buffer.dispose();
			__buffer = null;
		}
		#end
	}

	#if false
	/**
		Extracts raw sound data from a Sound object.
		This method is designed to be used when you are working with
		dynamically generated audio, using a function you assign to the
		`sampleData` event for a different Sound object. That is, you can use
		this method to extract sound data from a Sound object. Then you can
		write the data to the byte array that another Sound object is using to
		stream dynamic audio.

		The audio data is placed in the target byte array starting from the
		current position of the byte array. The audio data is always exposed
		as 44100 Hz Stereo. The sample type is a 32-bit floating-point value,
		which can be converted to a Number using `ByteArray.readFloat()`.

		@param target A ByteArray object in which the extracted sound samples
					  are placed.
		@param length The number of sound samples to extract. A sample
					  contains both the left and right channels נthat is,
					  two 32-bit floating-point values.
		@return The number of samples written to the ByteArray specified in
				the `target` parameter.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10) public function extract (target:ByteArray, length:Float, startPosition:Float = -1):Float;
	#end

	#if lime
	/**
		Creates a new Sound from an AudioBuffer immediately.

		@param	buffer	An AudioBuffer instance
		@returns	A new Sound
	**/
	public static function fromAudioBuffer(buffer:AudioBuffer):Sound
	{
		var sound = new Sound();
		sound.__buffer = buffer;
		return sound;
	}
	#end

	/**
		Creates a new Sound from a file path synchronously. This means that the
		Sound will be returned immediately (if supported).

		HTML5 and Flash do not support creating Sound synchronously, so these targets
		always return `null`.

		In order to load files from a remote web address, use the `loadFromFile` method,
		which supports asynchronous loading.

		@param	path	A local file path containing a sound
		@returns	A new Sound if successful, or `null` if unsuccessful
	**/
	public static function fromFile(path:String):Sound
	{
		#if lime
		return fromAudioBuffer(AudioBuffer.fromFile(path));
		#else
		return null;
		#end
	}

	/**
		Initiates loading of an external MP3 file from the specified URL. If you
		provide a valid URLRequest object to the Sound constructor, the
		constructor calls `Sound.load()` for you. You only need to call
		`Sound.load()` yourself if you don't pass a valid URLRequest
		object to the Sound constructor or you pass a `null` value.

		Once `load()` is called on a Sound object, you can't later
		load a different sound file into that Sound object. To load a different
		sound file, create a new Sound object.

		When using this method, consider the following security model:

		* Calling `Sound.load()` is not allowed if the calling file
		is in the local-with-file-system sandbox and the sound is in a network
		sandbox.
		* Access from the local-trusted or local-with-networking sandbox
		requires permission from a website through a URL policy file.
		* You cannot connect to commonly reserved ports. For a complete list
		of blocked ports, see "Restricting Networking APIs" in the _ActionScript
		3.0 Developer's Guide_.
		* You can prevent a SWF file from using this method by setting the
		`allowNetworking` parameter of the `object` and
		`embed` tags in the HTML page that contains the SWF
		content.

		 In Flash Player 10 and later, if you use a multipart Content-Type(for
		example "multipart/form-data") that contains an upload(indicated by a
		"filename" parameter in a "content-disposition" header within the POST
		body), the POST operation is subject to the security rules applied to
		uploads:

		* The POST operation must be performed in response to a user-initiated
		action, such as a mouse click or key press.
		* If the POST operation is cross-domain(the POST target is not on the
		same server as the SWF file that is sending the POST request), the target
		server must provide a URL policy file that permits cross-domain
		access.


		Also, for any multipart Content-Type, the syntax must be valid
		(according to the RFC2046 standards). If the syntax appears to be invalid,
		the POST operation is subject to the security rules applied to
		uploads.

		In Adobe AIR, content in the `application` security sandbox
		(content installed with the AIR application) are not restricted by these
		security limitations.

		For more information related to security, see the Flash Player
		Developer Center Topic: [Security](http://www.adobe.com/go/devnet_security_en).

		@param stream  A URL that points to an external MP3 file.
		@param context An optional SoundLoader context object, which can define
					   the buffer time(the minimum number of milliseconds of MP3
					   data to hold in the Sound object's buffer) and can specify
					   whether the application should check for a cross-domain
					   policy file prior to loading the sound.
		@throws IOError       A network error caused the load to fail.
		@throws IOError       The `digest` property of the
							  `stream` object is not `null`.
							  You should only set the `digest` property
							  of a URLRequest object when calling the
							  `URLLoader.load()` method when loading a
							  SWZ file(an Adobe platform component).
		@throws SecurityError Local untrusted files may not communicate with the
							  Internet. You can work around this by reclassifying
							  this file as local-with-networking or trusted.
		@throws SecurityError You cannot connect to commonly reserved ports. For a
							  complete list of blocked ports, see "Restricting
							  Networking APIs" in the _ActionScript 3.0
							  Developer's Guide_.
	**/
	public function load(stream:URLRequest, context:SoundLoaderContext = null):Void
	{
		url = stream.url;

		#if lime
		#if (js && html5)
		var defaultLibrary = lime.utils.Assets.getLibrary("default"); // TODO: Improve this

		if (defaultLibrary != null && defaultLibrary.cachedAudioBuffers.exists(url))
		{
			AudioBuffer_onURLLoad(defaultLibrary.cachedAudioBuffers.get(url));
		}
		else
		{
			AudioBuffer.loadFromFile(url).onComplete(AudioBuffer_onURLLoad).onError(function(_)
			{
				AudioBuffer_onURLLoad(null);
			});
		}
		#else
		AudioBuffer.loadFromFile(url).onComplete(AudioBuffer_onURLLoad).onError(function(_)
		{
			AudioBuffer_onURLLoad(null);
		});
		#end
		#end
	}

	/**
		Load MP3 sound data from a ByteArray object into a Sound object. The data will be read from the current
		ByteArray position and will leave the ByteArray position at the end of the specified bytes length once
		finished. If the MP3 sound data contains ID3 data ID3 events will be dispatched during this function call.
		This function will throw an exception if the ByteArray object does not contain enough data.

		@param	bytes
		@param	bytesLength
	**/
	public function loadCompressedDataFromByteArray(bytes:ByteArray, bytesLength:Int):Void
	{
		if (bytes == null || bytesLength <= 0)
		{
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
			return;
		}

		if (bytes.position > 0 || bytes.length > bytesLength)
		{
			var copy = new ByteArray(bytesLength);
			copy.writeBytes(bytes, bytes.position, bytesLength);
			bytes = copy;
		}

		#if lime
		__buffer = AudioBuffer.fromBytes(bytes);

		if (__buffer == null)
		{
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		}
		else
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		#else
		dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		#end
	}

	/**
		Creates a new Sound from a file path or web address asynchronously. The file
		load will occur in the background.

		Progress, completion and error callbacks will be dispatched in the current
		thread using callbacks attached to a returned Future object.

		@param	path	A local file path or web address containing a sound
		@returns	A Future Sound
	**/
	public static function loadFromFile(path:String):Future<Sound>
	{
		#if lime
		return AudioBuffer.loadFromFile(path).then(function(audioBuffer)
		{
			return Future.withValue(fromAudioBuffer(audioBuffer));
		});
		#else
		return cast Future.withError("Cannot load audio file");
		#end
	}

	/**
		Creates a new Sound from a set of file paths or web addresses asynchronously.
		The audio backend will choose the first compatible file format, and will load the file
		it selects in the background.

		Progress, completion and error callbacks will be dispatched in the current
		thread using callbacks attached to a returned Future object.

		@param	paths	A set of local file paths or web addresses containing sound
		@returns	A Future Sound
	**/
	public static function loadFromFiles(paths:Array<String>):Future<Sound>
	{
		#if lime
		return AudioBuffer.loadFromFiles(paths).then(function(audioBuffer)
		{
			return Future.withValue(fromAudioBuffer(audioBuffer));
		});
		#else
		return cast Future.withError("Cannot load audio files");
		#end
	}

	/**
		Load PCM 32-bit floating point sound data from a ByteArray object into a Sound object. The data will be read
		from the current ByteArray position and will leave the ByteArray position at the end of the specified sample
		length multiplied by either 1 channel or 2 channels if the stereo flag is set once finished.

		Starting with Flash Player 11.8, the amount of audio data that can be passed to this function is limited. For
		SWF versions >= 21, this function throws an exception if the amount of audio data passed into this function is
		more than 1800 seconds. That is, samples / sampleRate should be less than or equal to 1800. For swf versions <
		21, the runtime fails silently if the amount of audio data passed in is more than 12000 seconds. This is
		provided only for backward compatibility.

		This function throws an exception if the ByteArray object does not contain enough data.

		@param	bytes
		@param	samples
		@param	format
		@param	stereo
		@param	sampleRate
	**/
	public function loadPCMFromByteArray(bytes:ByteArray, samples:Int, format:String = "float", stereo:Bool = true, sampleRate:Float = 44100):Void
	{
		if (bytes == null)
		{
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
			return;
		}

		var bitsPerSample = (format == "float" ? 32 : 16); // "short"
		var channels = (stereo ? 2 : 1);
		var bytesLength = Std.int(samples * channels * (bitsPerSample / 8));

		if (bytes.position > 0 || bytes.length > bytesLength)
		{
			var copy = new ByteArray(bytesLength);
			copy.writeBytes(bytes, bytes.position, bytesLength);
			bytes = copy;
		}

		#if lime
		var audioBuffer = new AudioBuffer();
		audioBuffer.bitsPerSample = bitsPerSample;
		audioBuffer.channels = channels;
		audioBuffer.data = new UInt8Array(bytes);
		audioBuffer.sampleRate = Std.int(sampleRate);

		__buffer = audioBuffer;

		dispatchEvent(new Event(Event.COMPLETE));
		#else
		dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		#end
	}

	/**
		Generates a new SoundChannel object to play back the sound. This method
		returns a SoundChannel object, which you access to stop the sound and to
		monitor volume.(To control the volume, panning, and balance, access the
		SoundTransform object assigned to the sound channel.)

		@param startTime    The initial position in milliseconds at which playback
							should start.
		@param loops        Defines the number of times a sound loops back to the
							`startTime` value before the sound channel
							stops playback.
		@param sndTransform The initial SoundTransform object assigned to the
							sound channel.
		@return A SoundChannel object, which you use to control the sound. This
				method returns `null` if you have no sound card or if
				you run out of available sound channels. The maximum number of
				sound channels available at once is 32.
	**/
	public function play(startTime:Float = 0.0, loops:Int = 0, sndTransform:SoundTransform = null):SoundChannel
	{
		#if lime
		if (__buffer == null || SoundMixer.__soundChannels.length >= SoundMixer.MAX_ACTIVE_CHANNELS)
		{
			return null;
		}

		if (sndTransform == null)
		{
			sndTransform = new SoundTransform();
		}
		else
		{
			sndTransform = sndTransform.clone();
		}

		var pan = SoundMixer.__soundTransform.pan + sndTransform.pan;

		if (pan > 1) pan = 1;
		if (pan < -1) pan = -1;

		var volume = SoundMixer.__soundTransform.volume * sndTransform.volume;

		var source = new AudioSource(__buffer);
		source.offset = Std.int(startTime);
		if (loops > 1) source.loops = loops - 1;

		source.gain = volume;

		var position = source.position;
		position.x = pan;
		position.z = -1 * Math.sqrt(1 - Math.pow(pan, 2));
		source.position = position;

		return new SoundChannel(source, sndTransform);
		#else
		return null;
		#end
	}

	// Get & Set Methods
	@:noCompletion private function get_id3():ID3Info
	{
		return new ID3Info();
	}

	@:noCompletion private function get_length():Int
	{
		#if lime
		if (__buffer != null)
		{
			#if (js && html5 && howlerjs)
			return Std.int(__buffer.src.duration() * 1000);
			#else
			if (__buffer.data != null)
			{
				var samples = (__buffer.data.length * 8) / (__buffer.channels * __buffer.bitsPerSample);
				return Std.int(samples / __buffer.sampleRate * 1000);
			}
			else if (__buffer.__srcVorbisFile != null)
			{
				var samples = Int64.toInt(__buffer.__srcVorbisFile.pcmTotal());
				return Std.int(samples / __buffer.sampleRate * 1000);
			}
			else
			{
				return 0;
			}
			#end
		}
		#end

		return 0;
	}

	// Event Handlers
	#if lime
	@:noCompletion private function AudioBuffer_onURLLoad(buffer:AudioBuffer):Void
	{
		if (buffer == null)
		{
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		}
		else
		{
			__buffer = buffer;
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
	#end
}
#else
typedef Sound = flash.media.Sound;
#end
