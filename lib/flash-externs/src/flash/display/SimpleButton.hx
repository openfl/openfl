package flash.display;

#if flash
import openfl.media.SoundTransform;

extern class SimpleButton extends InteractiveObject
{
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
#else
typedef SimpleButton = openfl.display.SimpleButton;
#end
