package flash.display;

#if flash
import openfl.geom.Rectangle;
import openfl.media.SoundTransform;

extern class Sprite extends DisplayObjectContainer
{
	#if (haxe_ver < 4.3)
	public var buttonMode:Bool;
	public var dropTarget(default, never):DisplayObject;
	public var graphics(default, never):Graphics;
	public var hitArea:Sprite;
	public var soundTransform:SoundTransform;
	public var useHandCursor:Bool;
	#else
	@:flash.property var buttonMode(get, set):Bool;
	@:flash.property var dropTarget(get, never):DisplayObject;
	@:flash.property var graphics(get, never):Graphics;
	@:flash.property var hitArea(get, set):Sprite;
	@:flash.property var soundTransform(get, set):SoundTransform;
	@:flash.property var useHandCursor(get, set):Bool;
	#end

	public function new();
	public function startDrag(lockCenter:Bool = false, bounds:Rectangle = null):Void;
	@:require(flash10_1) public function startTouchDrag(touchPointID:Int, lockCenter:Bool = false, bounds:Rectangle = null):Void;
	public function stopDrag():Void;
	@:require(flash10_1) public function stopTouchDrag(touchPointID:Int):Void;

	#if (haxe_ver >= 4.3)
	private function get_buttonMode():Bool;
	private function get_dropTarget():DisplayObject;
	private function get_graphics():Graphics;
	private function get_hitArea():Sprite;
	private function get_soundTransform():SoundTransform;
	private function get_useHandCursor():Bool;
	private function set_buttonMode(value:Bool):Bool;
	private function set_hitArea(value:Sprite):Sprite;
	private function set_soundTransform(value:SoundTransform):SoundTransform;
	private function set_useHandCursor(value:Bool):Bool;
	#end
}
#else
typedef Sprite = openfl.display.Sprite;
#end
