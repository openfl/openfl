package openfl._internal.backend.lime_standalone;

#if openfl_html5
import haxe.Timer;
import js.Browser;

class AudioManager
{
	public static var context:AudioContext;

	public static function init(context:AudioContext = null)
	{
		if (AudioManager.context == null)
		{
			if (context == null)
			{
				// AudioManager.context = new AudioContext();
				// context = AudioManager.context;
			}

			AudioManager.context = context;
		}
	}

	public static function resume():Void {}

	public static function shutdown():Void
	{
		context = null;
	}

	public static function suspend():Void {}
}

typedef AudioContext = Dynamic;
#end
