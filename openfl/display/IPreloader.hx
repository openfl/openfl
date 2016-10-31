package openfl.display;


interface IPreloader {
	
	public function onInit ():Void;
	public function onLoaded ():Void;
	public function onUpdate (bytesLoaded:Int, bytesTotal:Int):Void;
	
}