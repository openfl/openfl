package openfl.media; #if (display || !flash)


import openfl.display.DisplayObject;
import openfl.net.NetStream;


extern class Video extends DisplayObject {
	
	
	public var deblocking:Int;
	public var smoothing:Bool;
	public var videoHeight (get, never):Int;
	public var videoWidth (get, never):Int;
	
	
	public function new (width:Int = 320, height:Int = 240):Void;
	
	#if flash
	@:noCompletion @:dox(hide) public function attachCamera (camera:flash.media.Camera):Void;
	#end
	
	public function attachNetStream (netStream:NetStream) : Void;
	public function clear ():Void;
	
	
}


#else
typedef Video = flash.media.Video;
#end