package openfl.net;

#if !flash
import haxe.io.Path;
import openfl.events.Event;
import openfl.events.EventDispatcher;
#if lime
import lime.ui.FileDialog;
#end
#if sys
import sys.FileSystem;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.net.FileReference)
class FileReferenceList extends EventDispatcher
{
	public var fileList(default, null):Array<FileReference>;

	public function new()
	{
		super();
	}

	public function browse(typeFilter:Array<FileFilter> = null):Bool
	{
		#if desktop
		var filter = null;

		if (typeFilter != null)
		{
			var filters = [];

			for (type in typeFilter)
			{
				filters.push(StringTools.replace(StringTools.replace(type.extension, "*.", ""), ";", ","));
			}

			filter = filters.join(";");
		}

		fileList = new Array();

		var fileDialog = new FileDialog();
		fileDialog.onCancel.add(fileDialog_onCancel);
		fileDialog.onSelectMultiple.add(fileDialog_onSelectMultiple);
		fileDialog.browse(OPEN_MULTIPLE, filter);
		return true;
		#end

		return false;
	}

	// Event Handlers
	@:noCompletion private function fileDialog_onCancel():Void
	{
		dispatchEvent(new Event(Event.CANCEL));
	}

	@:noCompletion private function fileDialog_onSelectMultiple(paths:Array<String>):Void
	{
		var fileReference, fileInfo;

		for (path in paths)
		{
			fileReference = new FileReference();

			#if sys
			var fileInfo = FileSystem.stat(path);
			fileReference.creationDate = fileInfo.ctime;
			fileReference.modificationDate = fileInfo.mtime;
			fileReference.size = fileInfo.size;
			fileReference.type = "." + Path.extension(path);
			#end

			fileReference.__path = path;
			fileReference.name = Path.withoutDirectory(path);

			fileList.push(fileReference);
		}

		dispatchEvent(new Event(Event.SELECT));
	}
}
#else
typedef FileReferenceList = flash.net.FileReferenceList;
#end
