package openfl.display;


import openfl.display.Sprite;

#if (lime >= "7.0.0")
import lime.utils.Preloader in LimePreloader;
#else
import lime.app.Preloader in LimePreloader;
#end


extern class Preloader extends LimePreloader {
	
	
	public function new (display:Sprite = null);
	
	
}


@:dox(hide) extern class DefaultPreloader extends Sprite {
	
	public function new ():Void;
	public function getBackgroundColor ():Int;
	public function getHeight ():Float;
	public function getWidth ():Float;
	public function onInit ():Void;
	public function onLoaded ():Void;
	public function onUpdate (bytesLoaded:Int, bytesTotal:Int):Void;
	
}