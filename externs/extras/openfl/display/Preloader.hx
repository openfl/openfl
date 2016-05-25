package openfl.display;


import lime.app.Preloader in LimePreloader;
import openfl.display.Sprite;


extern class Preloader extends LimePreloader {
	
	
	public function new (display:Sprite = null);
	
	
}


#if tools
typedef OpenFLPreloader = NMEPreloader
#else
private extern class OpenFLPreloader extends Sprite {
	
	public function new () { super (); }
	public function onInit ():Void {};
	public function onUpdate (loaded:Int, total:Int):Void {};
	public function onLoaded ():Void {};
	
}
#end