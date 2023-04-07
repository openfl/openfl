package flash.net;

#if flash
import openfl.events.EventDispatcher;
import openfl.utils.ByteArray;

extern class FileReference extends EventDispatcher
{
	#if (haxe_ver < 4.3)
	public var creationDate(default, never):Date;
	public var creator(default, never):String;
	@:require(flash10) public var data(default, never):ByteArray;
	public var modificationDate(default, never):Date;
	public var name(default, never):String;
	public var size(default, never):Int;
	public var type(default, never):String;
	#if air
	public static var permissionStatus(default, never):String;
	public var extension(default, never):String;
	#end
	#else
	@:flash.property var creationDate(get, never):Date;
	@:flash.property var creator(get, never):String;
	@:flash.property @:require(flash10) var data(get, never):ByteArray;
	@:flash.property var modificationDate(get, never):Date;
	@:flash.property var name(get, never):String;
	@:flash.property var size(get, never):Float;
	@:flash.property var type(get, never):String;
	#if air
	@:flash.property public static var permissionStatus(get, never):String;
	@:flash.property public var extension(get, never):String;
	#end
	#end
	public function new();
	public function browse(typeFilter:Array<FileFilter> = null):Bool;
	public function cancel():Void;
	public function download(request:URLRequest, defaultFileName:String = null):Void;
	@:require(flash10) public function load():Void;
	@:require(flash10) public function save(data:Dynamic, defaultFileName:String = null):Void;
	public function upload(request:URLRequest, uploadDataFieldName:String = "Filedata", testUpload:Bool = false):Void;
	#if air
	public function requestPermission():Void;
	public function uploadUnencoded(request:URLRequest):Void;
	#end

	#if (haxe_ver >= 4.3)
	private function get_creationDate():Date;
	private function get_creator():String;
	private function get_data():ByteArray;
	private function get_modificationDate():Date;
	private function get_name():String;
	private function get_size():Float;
	private function get_type():String;
	#if air
	private static function get_permissionStatus():String;
	private function get_extension():String;
	#end
	#end
}
#else
typedef FileReference = openfl.net.FileReference;
#end
