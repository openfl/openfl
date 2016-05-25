package openfl.net; #if (display || !flash)


import openfl.events.EventDispatcher;
import openfl.utils.ByteArray;


extern class FileReference extends EventDispatcher {
	
	
	/**
	 * The creation date of the file on the local disk.
	 */
	public var creationDate (default, null):Date;
	
	/**
	 * The Macintosh creator type of the file, which is only used in Mac OS versions prior to Mac OS X.
	 */
	public var creator (default, null):String;
	
	/**
	 * The ByteArray object representing the data from the loaded file after a successful call to the load() method.
	 */
	public var data (default, null):ByteArray;
	
	/**
	 * The date that the file on the local disk was last modified.
	 */
	public var modificationDate (default, null):Date;
	
	/**
	 * The name of the file on the local disk.
	 */
	public var name (default, null):String;
	
	/**
	 * The size of the file on the local disk in bytes.
	 */
	public var size (default, null):Int;
	
	/**
	 * The file type.
	 */
	public var type (default, null):String;
	
	
	public function new ();
	
	
	public function browse (typeFilter:Array<FileFilter> = null):Bool;
	
	
	public function cancel ():Void;
	
	
	public function download (request:URLRequest, defaultFileName:String = null):Void;
	
	
	public function load ():Void;
	
	
	public function save (data:Dynamic, defaultFileName:String = null):Void;
	
	
	public function upload (request:URLRequest, uploadDataFieldName:String = "Filedata", testUpload:Bool = false):Void;
	
	
}


#else
typedef FileReference = flash.net.FileReference;
#end