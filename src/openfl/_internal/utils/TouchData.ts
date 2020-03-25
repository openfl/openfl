namespace openfl._internal.utils;

import openfl.display.DisplayObject;
import openfl.display.InteractiveObject;

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
class TouchData
{
	public static __pool: ObjectPool<TouchData> = new ObjectPool<TouchData>(function () return new TouchData(), (data) data.reset());

	public rollOutStack: Array<DisplayObject>;
	public touchDownTarget: InteractiveObject;
	public touchOverTarget: InteractiveObject;

public new ()
{
	rollOutStack = [];
}

public reset(): void
	{
		touchDownTarget = null;
		touchOverTarget = null;

		rollOutStack.splice(0, rollOutStack.length);
	}
}
