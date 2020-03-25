namespace openfl._internal.backend.html5;

#if openfl_html5
import haxe.io.Path;
import haxe.Timer;
import js.html.FileReader;
import js.html.InputElement;
import js.Browser;
import openfl._internal.backend.lime_standalone.FileDialog;
import Event from "openfl/events/Event";
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.net.FileFilter;
import openfl.net.FileReference;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import ByteArray from "openfl/utils/ByteArray";

class HTML5FileReferenceBackend
{
	private data: ByteArray;
	private inputControl: InputElement;
	private parent: FileReference;
	private path: string;
	private urlLoader: URLLoader;

	public new(parent: FileReference)
	{
		this.parent = parent;

		inputControl = cast Browser.document.createElement("input");
		inputControl.setAttribute("type", "file");
		inputControl.onclick = (e)
		{
			e.cancelBubble = true;
			e.stopPropagation();
		}
	}

	public browse(typeFilter: Array<FileFilter> = null): boolean
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
		inputControl.onchange = ()
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

	public cancel(): void
	{
		if (urlLoader != null)
		{
			urlLoader.close();
			urlLoader = null;
		}
	}

	public download(request: URLRequest, defaultFileName: string = null): void
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

	public load(): void
	{
		var file = inputControl.files[0];
		var reader = new FileReader();
		reader.onload = (evt)
		{
			data = ByteArray.fromArrayBuffer(cast evt.target.result);
			openFileDialog_onComplete();
		}
		reader.readAsArrayBuffer(file);
	}

	public save(data: Dynamic, defaultFileName: string = null): void
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
	private openFileDialog_onComplete(): void
	{
		parent.dispatchEvent(new Event(Event.COMPLETE));
	}

	private saveFileDialog_onCancel(): void
	{
		parent.dispatchEvent(new Event(Event.CANCEL));
	}

	private saveFileDialog_onSave(path: string): void
	{
		Timer.delay(function ()
		{
			parent.dispatchEvent(new Event(Event.COMPLETE));
		}, 1);
	}

	private saveFileDialog_onSelect(path: string): void
	{
		parent.dispatchEvent(new Event(Event.SELECT));
	}

	private urlLoader_onComplete(event: Event): void
	{
		parent.dispatchEvent(event);
	}

	private urlLoader_onIOError(event: IOErrorEvent): void
	{
		parent.dispatchEvent(event);
	}

	private urlLoader_onProgress(event: ProgressEvent): void
	{
		parent.dispatchEvent(event);
	}
}
#end
