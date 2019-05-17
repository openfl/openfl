package openfl.media;

#if !flash
/**
	The SoundMixer class contains static properties and methods for global
	sound control in the application. The SoundMixer class controls embedded
	and streaming sounds in the application. it does not control dynamically
	created sounds (that is, sounds generated in response to a Sound object
	dispatching a `sampleData` event).
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.media.SoundChannel)
@:final class SoundMixer
{
	@:noCompletion private static inline var MAX_ACTIVE_CHANNELS:Int = 32;

	/**
		The number of seconds to preload an embedded streaming sound into a
		buffer before it starts to stream. The data in a loaded sound,
		including its buffer time, cannot be accessed by a SWF file that is in
		a different domain unless you implement a cross-domain policy file.
		For more information about security and sound, see the Sound class
		description. The data in a loaded sound, including its buffer time,
		cannot be accessed by code in a file that is in a different domain
		unless you implement a cross-domain policy file. However, in the
		application sandbox in an AIR application, code can access data in
		sound files from any source. For more information about security and
		sound, see the Sound class description.
		The `SoundMixer.bufferTime` property only affects the buffer time for
		embedded streaming sounds in a SWF and is independent of dynamically
		created Sound objects (that is, Sound objects created in
		ActionScript). The value of `SoundMixer.bufferTime` cannot override or
		set the default of the buffer time specified in the SoundLoaderContext
		object that is passed to the `Sound.load()` method.
	**/
	public static var bufferTime:Int;

	/**
		The SoundTransform object that controls global sound properties. A
		SoundTransform object includes properties for setting volume, panning,
		left speaker assignment, and right speaker assignment. The
		SoundTransform object used in this property provides final sound
		settings that are applied to all sounds after any individual sound
		settings are applied.
	**/
	public static var soundTransform(get, set):SoundTransform;

	@:noCompletion private static var __soundChannels:Array<SoundChannel> = new Array();
	@:noCompletion private static var __soundTransform:SoundTransform = #if (mute || mute_sound) new SoundTransform(0) #else new SoundTransform() #end;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperty(SoundMixer, "soundTransform", {
			get: function()
			{
				return SoundMixer.get_soundTransform();
			},
			set: function(value)
			{
				return SoundMixer.set_soundTransform(value);
			}
		});
	}
	#end

	/**
		Determines whether any sounds are not accessible due to security
		restrictions. For example, a sound loaded from a domain other than
		that of the content calling this method is not accessible if the
		server for the sound has no URL policy file that grants access to the
		domain of that domain. The sound can still be loaded and played, but
		low-level operations, such as getting ID3 metadata for the sound,
		cannot be performed on inaccessible sounds.
		For AIR application content in the application security sandbox,
		calling this method always returns `false`. All sounds, including
		those loaded from other domains, are accessible to content in the
		application security sandbox.

		@return The string representation of the boolean.
	**/
	public static function areSoundsInaccessible():Bool
	{
		return false;
	}

	#if false
	/**
		Takes a snapshot of the current sound wave and places it into the
		specified ByteArray object. The values are formatted as normalized
		floating-point values, in the range -1.0 to 1.0. The ByteArray object
		passed to the `outputArray` parameter is overwritten with the new
		values. The size of the ByteArray object created is fixed to 512
		floating-point values, where the first 256 values represent the left
		channel, and the second 256 values represent the right channel.
		**Note:** This method is subject to local file security restrictions
		and restrictions on cross-domain loading. If you are working with
		local files or sounds loaded from a server in a different domain than
		the calling content, you might need to address sandbox restrictions
		through a cross-domain policy file. For more information, see the
		Sound class description. In addition, this method cannot be used to
		extract data from RTMP streams, even when it is called by content that
		reside in the same domain as the RTMP server.

		This method is supported over RTMP in Flash Player 9.0.115.0 and later
		and in Adobe AIR. You can control access to streams on Flash Media
		Server in a server-side script. For more information, see the
		`Client.audioSampleAccess` and `Client.videoSampleAccess` properties
		in <a href="http://www.adobe.com/go/documentation" scope="external">_
		Server-Side ActionScript Language Reference for Adobe Flash Media
		Server_</a>.

		@param outputArray   A ByteArray object that holds the values
							 associated with the sound. If any sounds are not
							 available due to security restrictions
							 (`areSoundsInaccessible == true`), the
							 `outputArray` object is left unchanged. If all
							 sounds are stopped, the `outputArray` object is
							 filled with zeros.
		@param FFTMode       A Boolean value indicating whether a Fourier
							 transformation is performed on the sound data
							 first. Setting this parameter to `true` causes
							 the method to return a frequency spectrum instead
							 of the raw sound wave. In the frequency spectrum,
							 low frequencies are represented on the left and
							 high frequencies are on the right.
		@param stretchFactor The resolution of the sound samples. If you set
							 the `stretchFactor` value to 0, data is sampled
							 at 44.1 KHz; with a value of 1, data is sampled
							 at 22.05 KHz; with a value of 2, data is sampled
							 11.025 KHz; and so on.
	**/
	// @:noCompletion @:dox(hide) public static function computeSpectrum (outputArray:ByteArray, FFTMode:Bool = false, stretchFactor:Int = 0):Void;
	#end

	/**
		Stops all sounds currently playing.
		>In Flash Professional, this method does not stop the playhead. Sounds
		set to stream will resume playing as the playhead moves over the
		frames in which they are located.

		When using this property, consider the following security model:

		*  By default, calling the `SoundMixer.stopAll()` method stops only
		sounds in the same security sandbox as the object that is calling the
		method. Any sounds whose playback was not started from the same
		sandbox as the calling object are not stopped.
		* When you load the sound, using the `load()` method of the Sound
		class, you can specify a `context` parameter, which is a
		SoundLoaderContext object. If you set the `checkPolicyFile` property
		of the SoundLoaderContext object to `true`, Flash Player or Adobe AIR
		checks for a cross-domain policy file on the server from which the
		sound is loaded. If the server has a cross-domain policy file, and the
		file permits the domain of the calling content, then the file can stop
		the loaded sound by using the `SoundMixer.stopAll()` method; otherwise
		it cannot.

		However, in Adobe AIR, content in the `application` security sandbox
		(content installed with the AIR application) are not restricted by
		these security limitations.

		For more information related to security, see the Flash Player
		Developer Center Topic: <a
		href="http://www.adobe.com/go/devnet_security_en"
		scope="external">Security</a>.

	**/
	public static function stopAll():Void
	{
		for (channel in __soundChannels)
		{
			channel.stop();
		}
	}

	@:noCompletion private static function __registerSoundChannel(soundChannel:SoundChannel):Void
	{
		__soundChannels.push(soundChannel);
	}

	@:noCompletion private static function __unregisterSoundChannel(soundChannel:SoundChannel):Void
	{
		__soundChannels.remove(soundChannel);
	}

	// Get & Set Methods
	@:noCompletion private static function get_soundTransform():SoundTransform
	{
		return __soundTransform;
	}

	@:noCompletion private static function set_soundTransform(value:SoundTransform):SoundTransform
	{
		__soundTransform = value.clone();

		for (channel in __soundChannels)
		{
			channel.__updateTransform();
		}

		return value;
	}
}
#else
typedef SoundMixer = flash.media.SoundMixer;
#end
