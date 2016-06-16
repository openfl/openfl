package flash.net; #if (!display && flash)


import openfl.events.EventDispatcher;
import openfl.utils.Object;


extern class SharedObject extends EventDispatcher {
	
	
	public static var defaultObjectEncoding:Int;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_7) public static var preventBackup:Bool;
	#end
	
	public var client:Dynamic;
	public var data (default, null):Dynamic;
	public var fps (null, default):Float;
	public var objectEncoding:UInt;
	public var size (default, null):UInt;
	
	private function new ();
	public function clear ():Void;
	public function close ():Void;
	public function connect (myConnection:NetConnection, params:String = null):Void;
	
	#if flash
	@:noCompletion @:dox(hide) public static function deleteAll (url:String):Int;
	#end
	
	public function flush (minDiskSpace:Int = 0):SharedObjectFlushStatus;
	
	#if flash
	@:noCompletion @:dox(hide) public static function getDiskUsage (url:String):Int;
	#end
	
	public static function getLocal (name:String, localPath:String = null, secure:Bool = false):SharedObject;
	public static function getRemote (name:String, remotePath:String = null, persistence:Dynamic = false, secure:Bool = false):SharedObject;
	public function send (arguments:Array<Dynamic>):Void;
	public function setDirty (propertyName:String):Void;
	public function setProperty (propertyName:String, value:Object = null):Void;
	
	
}


#else
typedef SharedObject = openfl.net.SharedObject;
#end