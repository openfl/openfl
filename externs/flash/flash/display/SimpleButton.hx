package flash.display;

#if flash
import openfl.media.SoundTransform;

extern class SimpleButton extends InteractiveObject
{
	@:noCompletion public static var __constructor:SimpleButton->Void;
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

@:noCompletion class SimpleButton2 extends SimpleButton
{
	public function new()
	{
		super();

		if (SimpleButton.__constructor != null)
		{
			var method = SimpleButton.__constructor;
			SimpleButton.__constructor = null;

			method(this);
		}
	}
}
#else
typedef SimpleButton = openfl.display.SimpleButton;
#end
