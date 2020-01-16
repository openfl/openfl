package openfl.net;

#if (display || !flash)
import openfl.events.EventDispatcher;

#if !openfl_global
@:jsRequire("openfl/net/FileReferenceList", "default")
#end
extern class FileReferenceList extends EventDispatcher
{
	/**
	 * An array of FileReference objects.
	 */
	public var fileList(default, null):Array<FileReference>;

	public function new();
	public function browse(typeFilter:Array<FileFilter> = null):Bool;
}
#else
typedef FileReferenceList = flash.net.FileReferenceList;
#end
