package flash.display;

#if flash
import openfl.media.SoundTransform;

extern class SimpleButton extends InteractiveObject
{
	@:noCompletion public static var __constructor:SimpleButton->Void;

	#if (haxe_ver < 4.3)
	public var downState:DisplayObject;
	public var enabled:Bool;
	public var hitTestState:DisplayObject;
	public var overState:DisplayObject;
	public var soundTransform:SoundTransform;
	public var trackAsMenu:Bool;
	public var upState:DisplayObject;
	public var useHandCursor:Bool;
	#else
	@:flash.property var downState(get, set):DisplayObject;
	@:flash.property var enabled(get, set):Bool;
	@:flash.property var hitTestState(get, set):DisplayObject;
	@:flash.property var overState(get, set):DisplayObject;
	@:flash.property var soundTransform(get, set):SoundTransform;
	@:flash.property var trackAsMenu(get, set):Bool;
	@:flash.property var upState(get, set):DisplayObject;
	@:flash.property var useHandCursor(get, set):Bool;
	#end

	public function new(upState:DisplayObject = null, overState:DisplayObject = null, downState:DisplayObject = null, hitTestState:DisplayObject = null);

	#if (haxe_ver >= 4.3)
	private function get_downState():DisplayObject;
	private function get_enabled():Bool;
	private function get_hitTestState():DisplayObject;
	private function get_overState():DisplayObject;
	private function get_soundTransform():SoundTransform;
	private function get_trackAsMenu():Bool;
	private function get_upState():DisplayObject;
	private function get_useHandCursor():Bool;
	private function set_downState(value:DisplayObject):DisplayObject;
	private function set_enabled(value:Bool):Bool;
	private function set_hitTestState(value:DisplayObject):DisplayObject;
	private function set_overState(value:DisplayObject):DisplayObject;
	private function set_soundTransform(value:SoundTransform):SoundTransform;
	private function set_trackAsMenu(value:Bool):Bool;
	private function set_upState(value:DisplayObject):DisplayObject;
	private function set_useHandCursor(value:Bool):Bool;
	#end
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
