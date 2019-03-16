package flash.net;

#if flash
import openfl.events.EventDispatcher;
import openfl.utils.ByteArray;

extern class FileReference extends EventDispatcher
{
	public var creationDate(default, never):Date;
	public var creator(default, never):String;
	@:require(flash10) public var data(default, never):ByteArray;
	#if air
	public var extension(default, never):String;
	#end
	public var modificationDate(default, never):Date;
	public var name(default, never):String;
	public var size(default, never):Int;
	public var type(default, never):String;
	public function new();
	public function browse(typeFilter:Array<FileFilter> = null):Bool;
	public function cancel():Void;
	public function download(request:URLRequest, defaultFileName:String = null):Void;
	@:require(flash10) public function load():Void;
	@:require(flash10) public function save(data:Dynamic, defaultFileName:String = null):Void;
	public function upload(request:URLRequest, uploadDataFieldName:String = "Filedata", testUpload:Bool = false):Void;
	#if air
	public function uploadUnencoded(request:URLRequest):Void;
	#end
}
#else
typedef FileReference = openfl.net.FileReference;
#end
