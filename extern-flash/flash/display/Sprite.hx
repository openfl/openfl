package flash.display; #if (!display && flash)


import openfl.geom.Rectangle;
import openfl.media.SoundTransform;


extern class Sprite extends DisplayObjectContainer {
	
	
	public var buttonMode:Bool;
	
	#if flash
	@:noCompletion @:dox(hide) public var dropTarget (default, null):DisplayObject;
	#end
	
	public var graphics (default, null):Graphics;
	public var hitArea:Sprite;
	
	#if flash
	@:noCompletion @:dox(hide) public var soundTransform:SoundTransform;
	#end
	
	public var useHandCursor:Bool;
	
	public function new ();
	public function startDrag (lockCenter:Bool = false, bounds:Rectangle = null):Void;
	
	#if flash
	@:noCompletion @:dox(hide) public function startTouchDrag (touchPointID:Int, lockCenter:Bool = false, bounds:Rectangle = null):Void;
	#end
	
	public function stopDrag ():Void;
	
	#if flash
	@:noCompletion @:dox(hide) public function stopTouchDrag (touchPointID:Int):Void;
	#end
	
	
}


#else
typedef Sprite = openfl.display.Sprite;
#end