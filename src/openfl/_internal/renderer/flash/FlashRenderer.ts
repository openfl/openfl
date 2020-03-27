namespace openfl._internal.renderer.flash;

import Event from "../events/Event";
import openfl.utils.Dictionary;
import openfl.Lib;

@SuppressWarnings("checkstyle:FieldDocComment")
class FlashRenderer
{
	private static instances: Dictionary<IDisplayObject, Bool>;

	public static register(renderObject: IDisplayObject): void
	{
		if (instances == null)
		{
			instances = new Dictionary(true);

			Lib.current.stage.addEventListener(Event.ENTER_FRAME, render, false, -2147483648);
		}

		instances[renderObject] = true;
	}

	private static render(_): void
	{
		for (instance in instances)
		{
			if (instance != null)
			{
				instance.__renderFlash();
			}
		}
	}
}

@: allow(openfl._internal.renderer.flash.FlashRenderer)
interface IDisplayObject
{
	private __renderFlash(): void;
}
