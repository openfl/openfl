package flash.net;

#if flash
import openfl.events.EventDispatcher;
import openfl.utils.Object;

extern class SharedObject extends EventDispatcher
{
	#if (haxe_ver < 4.3)
	public static var defaultObjectEncoding:ObjectEncoding;
	@:require(flash11_7) public static var preventBackup:Bool;
	public var client:Dynamic;
	public var data(default, never):Dynamic;
	public var fps(never, default):Float;
	public var objectEncoding:ObjectEncoding;
	public var size(default, never):UInt;
	#else
	@:flash.property static var defaultObjectEncoding(get, set):ObjectEncoding;
	@:flash.property @:require(flash11_7) static var preventBackup(get, set):Bool;
	@:flash.property var client(get, set):Dynamic;
	@:flash.property var data(get, never):Dynamic;
	@:flash.property var fps(never, set):Float;
	@:flash.property var objectEncoding(get, set):ObjectEncoding;
	@:flash.property var size(get, never):UInt;
	#end

	private function new();
	public function clear():Void;
	public function close():Void;
	public function connect(myConnection:NetConnection, params:String = null):Void;
	public static function deleteAll(url:String):Int;
	public function flush(minDiskSpace:Int = 0):SharedObjectFlushStatus;
	public static function getDiskUsage(url:String):Int;
	public static function getLocal(name:String, localPath:String = null, secure:Bool = false):SharedObject;
	public static function getRemote(name:String, remotePath:String = null, persistence:Dynamic = false, secure:Bool = false):SharedObject;
	public function send(arguments:Array<Dynamic>):Void;
	public function setDirty(propertyName:String):Void;
	public function setProperty(propertyName:String, value:Object = null):Void;

	#if (haxe_ver >= 4.3)
	private static function get_defaultObjectEncoding():ObjectEncoding;
	private static function get_preventBackup():Bool;
	private function get_client():Dynamic;
	private function get_data():Dynamic;
	private function get_objectEncoding():ObjectEncoding;
	private function get_size():UInt;
	private function set_client(value:Dynamic):Dynamic;
	private function set_fps(value:Float):Float;
	private function set_objectEncoding(value:ObjectEncoding):ObjectEncoding;
	private static function set_defaultObjectEncoding(value:ObjectEncoding):ObjectEncoding;
	private static function set_preventBackup(value:Bool):Bool;
	#end
}
#else
typedef SharedObject = openfl.net.SharedObject;
#end
