package openfl.media; #if (display || !flash)


import openfl.display.DisplayObject;
import openfl.net.NetStream;


extern class Video extends DisplayObject {
	
	
	public var deblocking:Int;
	public var smoothing:Bool;
	
	#if flash
	@:noCompletion @:dox(hide) public var videoHeight (default, null):Int;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public var videoWidth (default, null):Int;
	#end
	
	
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