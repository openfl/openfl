package flash.net;

#if flash
import openfl.events.EventDispatcher;

extern class FileReferenceList extends EventDispatcher
{
	public var fileList(default, never):Array<FileReference>;
	public function new();
	public function browse(typeFilter:Array<FileFilter> = null):Bool;
}
#else
typedef FileReferenceList = openfl.net.FileReferenceList;
#end
