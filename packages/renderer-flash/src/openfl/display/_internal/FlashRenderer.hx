package openfl.display._internal;

import openfl.events.Event;
import openfl.utils.Dictionary;
import openfl.Lib;

@SuppressWarnings("checkstyle:FieldDocComment")
class FlashRenderer
{
	public static var instances:Dictionary<IDisplayObject, Bool>;

	public static function register(renderObject:IDisplayObject):Void
	{
		if (instances == null)
		{
			instances = new Dictionary(true);

			Lib.current.stage.addEventListener(Event.ENTER_FRAME, render, false, -2147483648);
		}

		instances[renderObject] = true;
	}

	public static function render(_):Void
	{
		for (instance in instances)
		{
			if (instance != null)
			{
				instance._.__renderFlash();
			}
		}
	}
}

@:allow(openfl.display._internal.FlashRenderer)
interface IDisplayObject
{
	public function __renderFlash():Void;
}
