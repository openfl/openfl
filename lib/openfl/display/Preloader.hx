package openfl.display;

// import lime.app.Preloader in LimePreloader;
import openfl.display.Sprite;

@:jsRequire("openfl/display/Preloader", "default")
extern class Preloader /*extends LimePreloader*/
{
	public function new(display:Sprite = null);
}

@:dox(hide) extern class DefaultPreloader extends Sprite
{
	public function new():Void;
	public function getBackgroundColor():Int;
	public function getHeight():Float;
	public function getWidth():Float;
	public function onInit():Void;
	public function onLoaded():Void;
	public function onUpdate(bytesLoaded:Int, bytesTotal:Int):Void;
}
