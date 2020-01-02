package openfl._internal.backend.lime;

#if lime
import haxe.io.Path;
import lime.ui.FileDialog;
import openfl.events.Event;
import openfl.net.FileFilter;
import openfl.net.FileReference;
import openfl.net.FileReferenceList;
#if sys
import sys.FileSystem;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.net.FileReference)
@:access(openfl.net.FileReferenceList)
class LimeFileReferenceListBackend
{
	private var parent:FileReferenceList;

	public function new(parent:FileReferenceList)
	{
		this.parent = parent;
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

		parent.fileList = new Array();

		var fileDialog = new FileDialog();
		fileDialog.onCancel.add(fileDialog_onCancel);
		fileDialog.onSelectMultiple.add(fileDialog_onSelectMultiple);
		fileDialog.browse(OPEN_MULTIPLE, filter);
		return true;
		#end

		return false;
	}

	// Event Handlers
	private function fileDialog_onCancel():Void
	{
		parent.dispatchEvent(new Event(Event.CANCEL));
	}

	private function fileDialog_onSelectMultiple(paths:Array<String>):Void
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

			@:privateAccess fileReference.__backend.path = path;
			fileReference.name = Path.withoutDirectory(path);

			parent.fileList.push(fileReference);
		}

		parent.dispatchEvent(new Event(Event.SELECT));
	}
}
#end
