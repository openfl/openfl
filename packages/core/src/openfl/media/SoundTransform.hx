package openfl.media;

#if !flash
/**
	The SoundTransform class contains properties for volume and panning.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class SoundTransform
{
	/**
		A value, from 0(none) to 1(all), specifying how much of the left input
		is played in the left speaker.
	**/
	public var leftToLeft:Float;

	/**
		A value, from 0(none) to 1(all), specifying how much of the left input
		is played in the right speaker.
	**/
	public var leftToRight:Float;

	/**
		The left-to-right panning of the sound, ranging from -1(full pan left) to
		1(full pan right). A value of 0 represents no panning(balanced center
		between right and left).
	**/
	public var pan:Float;

	/**
		A value, from 0(none) to 1(all), specifying how much of the right input
		is played in the left speaker.
	**/
	public var rightToLeft:Float;

	/**
		A value, from 0(none) to 1(all), specifying how much of the right input
		is played in the right speaker.
	**/
	public var rightToRight:Float;

	/**
		The volume, ranging from 0(silent) to 1(full volume).
	**/
	public var volume:Float;

	/**
		Creates a SoundTransform object.

		@param vol     The volume, ranging from 0(silent) to 1(full volume).
		@param panning The left-to-right panning of the sound, ranging from -1
					  (full pan left) to 1(full pan right). A value of 0
					   represents no panning(center).
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
