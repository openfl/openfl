package openfl._internal.backend.lime;

#if lime
import haxe.io.Path;
import haxe.Timer;
import lime.ui.FileDialog;
import lime.utils.Bytes;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.net.FileFilter;
import openfl.net.FileReference;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.utils.ByteArray;
#if openfl_html5
import js.html.FileReader;
import js.html.InputElement;
import js.Browser;
#end
#if sys
import sys.io.File;
import sys.FileSystem;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.net.FileReference)
class LimeFileReferenceBackend
{
	private var data:ByteArray;
	private var parent:FileReference;
	private var path:String;
	private var urlLoader:URLLoader;
	#if openfl_html5
	private var inputControl:InputElement;
	#end

	public function new(parent:FileReference)
	{
		this.parent = parent;

		#if openfl_html5
		inputControl = cast Browser.document.createElement("input");
		inputControl.setAttribute("type", "file");
		inputControl.onclick = function(e)
		{
			e.cancelBubble = true;
			e.stopPropagation();
		}
		#end
	}

	public function browse(typeFilter:Array<FileFilter> = null):Bool
	{
		data = null;
		path = null;

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

		var openFileDialog = new FileDialog();
		openFileDialog.onCancel.add(openFileDialog_onCancel);
		openFileDialog.onSelect.add(openFileDialog_onSelect);
		openFileDialog.browse(OPEN, filter);
		return true;
		#elseif openfl_html5
		var filter = null;
		if (typeFilter != null)
		{
			var filters = [];
			for (type in typeFilter)
			{
				filters.push(StringTools.replace(StringTools.replace(type.extension, "*.", "."), ";", ","));
			}
			filter = filters.join(",");
		}
		if (filter != null)
		{
			inputControl.setAttribute("accept", filter);
		}
		inputControl.onchange = function()
		{
			var file = inputControl.files[0];
			parent.modificationDate = Date.fromTime(file.lastModified);
			parent.creationDate = parent.modificationDate;
			parent.size = file.size;
			parent.type = "." + Path.extension(file.name);
			parent.name = Path.withoutDirectory(file.name);
			path = file.name;
			parent.dispatchEvent(new Event(Event.SELECT));
		}
		inputControl.click();
		return true;
		#end

		return false;
	}

	public function cancel():Void
	{
		if (urlLoader != null)
		{
			urlLoader.close();
			urlLoader = null;
		}
	}

	public function download(request:URLRequest, defaultFileName:String = null):Void
	{
		this.data = null;
		this.path = null;

		urlLoader = new URLLoader();
		urlLoader.addEventListener(Event.COMPLETE, urlLoader_onComplete);
		urlLoader.addEventListener(IOErrorEvent.IO_ERROR, urlLoader_onIOError);
		urlLoader.addEventListener(ProgressEvent.PROGRESS, urlLoader_onProgress);
		urlLoader.load(request);

		var saveFileDialog = new FileDialog();
		saveFileDialog.onCancel.add(saveFileDialog_onCancel);
		saveFileDialog.onSelect.add(saveFileDialog_onSelect);
		saveFileDialog.browse(SAVE, defaultFileName != null ? Path.extension(defaultFileName) : null, defaultFileName);
	}

	public function load():Void
	{
		#if sys
		if (path != null)
		{
			data = Bytes.fromFile(path);
			openFileDialog_onComplete();
		}
		#elseif openfl_html5
		var file = inputControl.files[0];
		var reader = new FileReader();
		reader.onload = function(evt)
		{
			data = ByteArray.fromArrayBuffer(cast evt.target.result);
			openFileDialog_onComplete();
		}
		reader.readAsArrayBuffer(file);
		#end
	}

	public function save(data:Dynamic, defaultFileName:String = null):Void
	{
		this.data = null;
		this.path = null;

		if (data == null) return;

		#if desktop
		if (Std.is(data, ByteArrayData))
		{
			this.data = data;
		}
		else
		{
			var _data = new ByteArray();
			_data.writeUTFBytes(Std.string(data));
			this.data = _data;
		}

		var saveFileDialog = new FileDialog();
		saveFileDialog.onCancel.add(saveFileDialog_onCancel);
		saveFileDialog.onSelect.add(saveFileDialog_onSelect);
		saveFileDialog.browse(SAVE, defaultFileName != null ? Path.extension(defaultFileName) : null, defaultFileName);
		#elseif openfl_html5
		if (Std.is(data, ByteArrayData))
		{
			this.data = data;
		}
		else
		{
			var _data = new ByteArray();
			_data.writeUTFBytes(Std.string(data));
			this.data = _data;
		}

		var saveFileDialog = new FileDialog();
		saveFileDialog.onCancel.add(saveFileDialog_onCancel);
		saveFileDialog.onSave.add(saveFileDialog_onSave);
		saveFileDialog.save(data, defaultFileName != null ? Path.extension(defaultFileName) : null, defaultFileName);
		#end
	}

	// Event Handlers
	private function openFileDialog_onCancel():Void
	{
		parent.dispatchEvent(new Event(Event.CANCEL));
	}

	private function openFileDialog_onComplete():Void
	{
		parent.dispatchEvent(new Event(Event.COMPLETE));
	}

	private function openFileDialog_onSelect(path:String):Void
	{
		#if sys
		var fileInfo = FileSystem.stat(path);
		parent.creationDate = fileInfo.ctime;
		parent.modificationDate = fileInfo.mtime;
		parent.size = fileInfo.size;
		parent.type = "." + Path.extension(path);
		#end

		parent.name = Path.withoutDirectory(path);
		this.path = path;

		parent.dispatchEvent(new Event(Event.SELECT));
	}

	private function saveFileDialog_onCancel():Void
	{
		parent.dispatchEvent(new Event(Event.CANCEL));
	}

	private function saveFileDialog_onSave(path:String):Void
	{
		Timer.delay(function()
		{
			parent.dispatchEvent(new Event(Event.COMPLETE));
		}, 1);
	}

	private function saveFileDialog_onSelect(path:String):Void
	{
		#if desktop
		parent.name = Path.withoutDirectory(path);

		if (this.data != null)
		{
			File.saveBytes(path, data);

			this.data = null;
			this.path = null;
		}
		else
		{
			this.path = path;
		}
		#end

		parent.dispatchEvent(new Event(Event.SELECT));
	}

	private function urlLoader_onComplete(event:Event):Void
	{
		#if desktop
		if (Std.is(urlLoader.data, ByteArrayData))
		{
			data = urlLoader.data;
		}
		else
		{
			data = new ByteArray();
			data.writeUTFBytes(Std.string(urlLoader.data));
		}

		if (path != null)
		{
			File.saveBytes(path, data);

			path = null;
			data = null;
		}
		#end

		parent.dispatchEvent(event);
	}

	private function urlLoader_onIOError(event:IOErrorEvent):Void
	{
		parent.dispatchEvent(event);
	}

	private function urlLoader_onProgress(event:ProgressEvent):Void
	{
		parent.dispatchEvent(event);
	}
}
#end
