package flash.net; #if (!display && flash)


import openfl.events.EventDispatcher;
import openfl.utils.ByteArray;


extern class FileReference extends EventDispatcher {
	
	
	public var creationDate (default, null):Date;
	public var creator (default, null):String;
	@:require(flash10) public var data (default, null):ByteArray;
	public var modificationDate (default, null):Date;
	public var name (default, null):String;
	public var size (default, null):Int;
	public var type (default, null):String;
	
	
	public function new ();
	public function browse (typeFilter:Array<FileFilter> = null):Bool;
	public function cancel ():Void;
	public function download (request:URLRequest, defaultFileName:String = null):Void;
	@:require(flash10) public function load ():Void;
	@:require(flash10) public function save (data:Dynamic, defaultFileName:String = null):Void;
	public function upload (request:URLRequest, uploadDataFieldName:String = "Filedata", testUpload:Bool = false):Void;
	
	
}


#else
typedef FileReference = openfl.net.FileReference;
#end