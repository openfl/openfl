package openfl._internal.backend.html5;

#if openfl_html5
import haxe.io.Path;
import haxe.Timer;
import js.html.FileReader;
import js.html.InputElement;
import js.Browser;
import openfl._internal.backend.lime_standalone.FileDialog;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.net.FileFilter;
import openfl.net.FileReference;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.utils.ByteArray;

class HTML5FileReferenceBackend
{
	private var data:ByteArray;
	private var inputControl:InputElement;
	private var parent:FileReference;
	private var path:String;
	private var urlLoader:URLLoader;

	public function new(parent:FileReference)
	{
		this.parent = parent;

		inputControl = cast Browser.document.createElement("input");
		inputControl.setAttribute("type", "file");
		inputControl.onclick = function(e)
		{
			e.cancelBubble = true;
			e.stopPropagation();
		}
	}

	public function browse(typeFilter:Array<FileFilter> = null):Bool
	{
		data = null;
		path = null;

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
			modificationDate = Date.fromTime(file.lastModified);
			creationDate = modificationDate;
			size = file.size;
			type = "." + Path.extension(file.name);
			name = Path.withoutDirectory(file.name);
			path = file.name;
			dispatchEvent(new Event(Event.SELECT));
		}
		inputControl.click();
		return true;
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
		data = null;
		path = null;

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
		var file = inputControl.files[0];
		var reader = new FileReader();
		reader.onload = function(evt)
		{
			data = ByteArray.fromArrayBuffer(cast evt.target.result);
			openFileDialog_onComplete();
		}
		reader.readAsArrayBuffer(file);
	}

	public function save(data:Dynamic, defaultFileName:String = null):Void
	{
		data = null;
		path = null;

		if (data == null) return;

		if (Std.is(data, ByteArrayData))
		{
			thisdata = data;
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
	}

	// Event Handlers
	private function openFileDialog_onComplete():Void
	{
		parent.dispatchEvent(new Event(Event.COMPLETE));
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
		parent.dispatchEvent(new Event(Event.SELECT));
	}

	private function urlLoader_onComplete(event:Event):Void
	{
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
