package openfl.media;

#if !flash
/**
	The SoundTransform class contains properties for volume and panning.

	@see [Controlling sound volume and panning](https://books.openfl.org/openfl-developers-guide/working-with-sound/controlling-sound-volume-and-panning.html)
	@see `openfl.media.Sound`
	@see `openfl.media.SoundChannel.soundTransform`
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class SoundTransform
{
	/**
		A value, from 0 (none) to 1 (all), specifying how much of the left input
		is played in the left speaker.
	**/
	public var leftToLeft:Float;

	/**
		A value, from 0 (none) to 1 (all), specifying how much of the left input
		is played in the right speaker.
	**/
	public var leftToRight:Float;

	/**
		The left-to-right panning of the sound, ranging from -1 (full pan left)
		to 1 (full pan right). A value of 0 represents no panning (balanced
		center between right and left).

		The following example sets the pan to 0.5 (half pan right) when
		starting to play a Sound.

		```haxe
		var transform = new SoundTransform(1.0, 0.5);
		var soundChannel = sound.play(0, 0, transform);
		```

		The following example sets the pan to -1 (full pan left) for a
		SoundChannel that is currently playing.

		```haxe
		var transform = soundChannel.soundTransform;
		transform.pan = -1.0;
		soundChannel.soundTransform = transform;
		```

		@see [Controlling sound volume and panning](https://books.openfl.org/openfl-developers-guide/working-with-sound/controlling-sound-volume-and-panning.html)
	**/
	public var pan:Float;

	/**
		A value, from 0 (none) to 1 (all), specifying how much of the right
		input is played in the left speaker.
	**/
	public var rightToLeft:Float;

	/**
		A value, from 0 (none) to 1 (all), specifying how much of the right
		input is played in the right speaker.
	**/
	public var rightToRight:Float;

	/**
		The volume, ranging from 0 (silent) to 1 (full volume).

		The following example sets the volume to 0.5 (half volume) when
		starting to play a Sound.

		```haxe
		var transform = new SoundTransform(0.5);
		var soundChannel = sound.play(0, 0, transform);
		```

		The following example sets the volume to 0.0 (silent) for a
		SoundChannel that is currently playing.

		```haxe
		var transform = soundChannel.soundTransform;
		transform.volume = 0.0;
		soundChannel.soundTransform = transform;
		```

		@see [Controlling sound volume and panning](https://books.openfl.org/openfl-developers-guide/working-with-sound/controlling-sound-volume-and-panning.html)
	**/
	public var volume:Float;

	/**
		Creates a SoundTransform object.

		@param vol     The volume, ranging from 0 (silent) to 1 (full volume).
		@param panning The left-to-right panning of the sound, ranging from -1
					   (full pan left) to 1 (full pan right). A value of 0
					   represents no panning (center).
	**/
	public function new(vol:Float = 1, panning:Float = 0)
	{
		volume = vol;
		pan = panning;
		leftToLeft = 0;
		leftToRight = 0;
		rightToLeft = 0;
		rightToRight = 0;
	}

	@SuppressWarnings("checkstyle:FieldDocComment")
	@:noCompletion @:dox(hide) public function clone():SoundTransform
	{
		return new SoundTransform(volume, pan);
	}
}
#else
typedef SoundTransform = flash.media.SoundTransform;
#end
