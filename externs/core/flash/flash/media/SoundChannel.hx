package flash.media; #if (!display && flash)


import openfl.events.EventDispatcher;


@:final extern class SoundChannel extends EventDispatcher {
	
	
	public var leftPeak (default, null):Float;
	public var position (default, null):Float;
	public var rightPeak (default, null):Float;
	public var soundTransform:SoundTransform;
	
	#if flash
	public function new ();
	#end
	
	public function stop ():Void;
	
	
}


#else
typedef SoundChannel = openfl.media.SoundChannel;
#end