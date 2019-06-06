package flash.display;

#if flash
import openfl._internal.formats.swf.SWFLite;
import openfl._internal.symbols.ButtonSymbol;
import openfl.media.SoundTransform;

extern class SimpleButton extends InteractiveObject
{
	@:noCompletion public static var __initSWF:SWFLite;
	@:noCompletion public static var __initSymbol:ButtonSymbol;
	public var downState:DisplayObject;
	public var enabled:Bool;
	public var hitTestState:DisplayObject;
	public var overState:DisplayObject;
	public var soundTransform:SoundTransform;
	public var trackAsMenu:Bool;
	public var upState:DisplayObject;
	public var useHandCursor:Bool;
	public function new(upState:DisplayObject = null, overState:DisplayObject = null, downState:DisplayObject = null, hitTestState:DisplayObject = null);
}

@:access(openfl._internal.symbols.SWFSymbol)
@:noCompletion class SimpleButton2 extends SimpleButton
{
	public function new()
	{
		super();

		if (SimpleButton.__initSymbol != null)
		{
			var swf = SimpleButton.__initSWF;
			var symbol = SimpleButton.__initSymbol;

			SimpleButton.__initSWF = null;
			SimpleButton.__initSymbol = null;

			if (symbol.downState != null)
			{
				downState = symbol.downState.__createObject(swf);
			}

			if (symbol.hitState != null)
			{
				hitTestState = symbol.hitState.__createObject(swf);
			}

			if (symbol.overState != null)
			{
				overState = symbol.overState.__createObject(swf);
			}

			if (symbol.upState != null)
			{
				upState = symbol.upState.__createObject(swf);
			}
		}
	}
}
#else
typedef SimpleButton = openfl.display.SimpleButton;
#end
