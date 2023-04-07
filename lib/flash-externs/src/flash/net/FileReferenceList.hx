package flash.net;

#if flash
import openfl.events.EventDispatcher;

extern class FileReferenceList extends EventDispatcher
{
	#if (haxe_ver < 4.3)
	public var fileList(default, never):Array<FileReference>;
	#else
	@:flash.property var fileList(get, never):Array<FileReference>;
	#end

	public function new();
	public function browse(typeFilter:Array<FileFilter> = null):Bool;

	#if (haxe_ver >= 4.3)
	private function get_fileList():Array<FileReference>;
	#end
}
#else
typedef FileReferenceList = openfl.net.FileReferenceList;
#end
