package openfl.net;

#if !flash
import haxe.io.Path;
import haxe.Timer;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.utils.ByteArray;
#if lime
import lime.ui.FileDialog;
import lime.utils.Bytes;
#end
#if sys
import sys.io.File;
import sys.FileSystem;
#end
#if (js && html5)
import js.html.FileReader;
import js.html.InputElement;
import js.Browser;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class FileReference extends EventDispatcher
{
	public var creationDate(default, null):Date;
	public var creator(default, null):String;
	public var data(default, null):ByteArray;
	public var modificationDate(default, null):Date;
	public var name(default, null):String;
	public var size(default, null):Int;
	public var type(default, null):String;

	@:noCompletion private var __data:ByteArray;
	@:noCompletion private var __path:String;
	@:noCompletion private var __urlLoader:URLLoader;
	#if (js && html5)
	@:noCompletion private var __inputControl:InputElement;
	#end

	public function new()
	{
		super();
		#if (js && html5)
		__inputControl = cast Browser.document.createElement("input");
		__inputControl.setAttribute("type", "file");
		__inputControl.onclick = function(e)
		{
			e.cancelBubble = true;
			e.stopPropagation();
		}
		#end
	}

	public function browse(typeFilter:Array<FileFilter> = null):Bool
	{
		__data = null;
		__path = null;

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
		#elseif (js && html5)
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
			__inputControl.setAttribute("accept", filter);
		}
		__inputControl.onchange = function()
		{
			var file = __inputControl.files[0];
			modificationDate = Date.fromTime(file.lastModified);
			creationDate = modificationDate;
			size = file.size;
			type = "." + Path.extension(file.name);
			name = Path.withoutDirectory(file.name);
			__path = file.name;
			dispatchEvent(new Event(Event.SELECT));
		}
		__inputControl.click();
		return true;
		#end

		return false;
	}

	public function cancel():Void
	{
		if (__urlLoader != null)
		{
			__urlLoader.close();
		}
	}

	public function download(request:URLRequest, defaultFileName:String = null):Void
	{
		__data = null;
		__path = null;

		__urlLoader = new URLLoader();
		__urlLoader.addEventListener(Event.COMPLETE, urlLoader_onComplete);
		__urlLoader.addEventListener(IOErrorEvent.IO_ERROR, urlLoader_onIOError);
		__urlLoader.addEventListener(ProgressEvent.PROGRESS, urlLoader_onProgress);
		__urlLoader.load(request);

		var saveFileDialog = new FileDialog();
		saveFileDialog.onCancel.add(saveFileDialog_onCancel);
		saveFileDialog.onSelect.add(saveFileDialog_onSelect);
		saveFileDialog.browse(SAVE, defaultFileName != null ? Path.extension(defaultFileName) : null, defaultFileName);
	}

	public function load():Void
	{
		#if sys
		if (__path != null)
		{
			data = Bytes.fromFile(__path);
			openFileDialog_onComplete();
		}
		#elseif (js && html5)
		var file = __inputControl.files[0];
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
		__data = null;
		__path = null;

		if (data == null) return;

		#if desktop
		if ((data is ByteArrayData))
		{
			__data = data;
		}
		else
		{
			__data = new ByteArray();
			__data.writeUTFBytes(Std.string(data));
		}

		var saveFileDialog = new FileDialog();
		saveFileDialog.onCancel.add(saveFileDialog_onCancel);
		saveFileDialog.onSelect.add(saveFileDialog_onSelect);
		saveFileDialog.browse(SAVE, defaultFileName != null ? Path.extension(defaultFileName) : null, defaultFileName);
		#elseif (js && html5)
		if ((data is ByteArrayData))
		{
			__data = data;
		}
		else
		{
			__data = new ByteArray();
			__data.writeUTFBytes(Std.string(data));
		}

		var saveFileDialog = new FileDialog();
		saveFileDialog.onCancel.add(saveFileDialog_onCancel);
		saveFileDialog.onSave.add(saveFileDialog_onSave);
		saveFileDialog.save(__data, defaultFileName != null ? Path.extension(defaultFileName) : null, defaultFileName);
		#end
	}

	#if !openfl_strict
	public function upload(request:URLRequest, uploadDataFieldName:String = "Filedata", testUpload:Bool = false):Void
	{
		openfl._internal.Lib.notImplemented();
	}
	#end

	// Event Handlers
	@:noCompletion private function openFileDialog_onCancel():Void
	{
		dispatchEvent(new Event(Event.CANCEL));
	}

	@:noCompletion private function openFileDialog_onComplete():Void
	{
		dispatchEvent(new Event(Event.COMPLETE));
	}

	@:noCompletion private function openFileDialog_onSelect(path:String):Void
	{
		#if sys
		var fileInfo = FileSystem.stat(path);
		creationDate = fileInfo.ctime;
		modificationDate = fileInfo.mtime;
		size = fileInfo.size;
		type = "." + Path.extension(path);
		#end

		name = Path.withoutDirectory(path);
		__path = path;

		dispatchEvent(new Event(Event.SELECT));
	}

	@:noCompletion private function saveFileDialog_onCancel():Void
	{
		dispatchEvent(new Event(Event.CANCEL));
	}

	@:noCompletion private function saveFileDialog_onSave(path:String):Void
	{
		Timer.delay(function()
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}, 1);
	}

	@:noCompletion private function saveFileDialog_onSelect(path:String):Void
	{
		#if desktop
		name = Path.withoutDirectory(path);

		if (__data != null)
		{
			File.saveBytes(path, __data);

			__data = null;
			__path = null;
		}
		else
		{
			__path = path;
		}
		#end

		dispatchEvent(new Event(Event.SELECT));
	}

	@:noCompletion private function urlLoader_onComplete(event:Event):Void
	{
		#if desktop
		if ((__urlLoader.data is ByteArrayData))
		{
			__data = __urlLoader.data;
		}
		else
		{
			__data = new ByteArray();
			__data.writeUTFBytes(Std.string(__urlLoader.data));
		}

		if (__path != null)
		{
			File.saveBytes(__path, __data);

			__path = null;
			__data = null;
		}
		#end

		dispatchEvent(event);
	}

	@:noCompletion private function urlLoader_onIOError(event:IOErrorEvent):Void
	{
		dispatchEvent(event);
	}

	@:noCompletion private function urlLoader_onProgress(event:ProgressEvent):Void
	{
		dispatchEvent(event);
	}
}
#else
typedef FileReference = flash.net.FileReference;
#end
