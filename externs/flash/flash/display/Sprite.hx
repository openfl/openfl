package flash.display;

#if flash
import openfl.geom.Rectangle;
import openfl.media.SoundTransform;

extern class Sprite extends DisplayObjectContainer
{
	public var buttonMode:Bool;
	public var dropTarget(default, never):DisplayObject;
	public var graphics(default, never):Graphics;
	public var hitArea:Sprite;
	#if flash
	public var soundTransform:SoundTransform;
	#end
	public var useHandCursor:Bool;
	public function new();
	public function startDrag(lockCenter:Bool = false, bounds:Rectangle = null):Void;
	#if flash
	public function startTouchDrag(touchPointID:Int, lockCenter:Bool = false, bounds:Rectangle = null):Void;
	#end
	public function stopDrag():Void;
	#if flash
	public function stopTouchDrag(touchPointID:Int):Void;
	#end
}
#else
typedef Sprite = openfl.display.Sprite;
#end
