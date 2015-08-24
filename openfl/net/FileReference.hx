package openfl.net; #if !flash #if !openfl_legacy


import haxe.io.Path;
import lime.system.System;
import lime.ui.FileDialog;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.utils.ByteArray;

#if sys
import sys.io.File;
import sys.FileStat;
import sys.FileSystem;
#end


class FileReference extends EventDispatcher {
	
	
	/**
	 * The creation date of the file on the local disk.
	 */
	public var creationDate (default, null):Date;
	
	/**
	 * The Macintosh creator type of the file, which is only used in Mac OS versions prior to Mac OS X.
	 */
	public var creator (default, null):String;
	
	/**
	 * The ByteArray object representing the data from the loaded file after a successful call to the load() method.
	 */
	public var data (default, null):ByteArray;
	
	/**
	 * The date that the file on the local disk was last modified.
	 */
	public var modificationDate (default, null):Date;
	
	/**
	 * The name of the file on the local disk.
	 */
	public var name (default, null):String;
	
	/**
	 * The size of the file on the local disk in bytes.
	 */
	public var size (default, null):Int;
	
	/**
	 * The file type.
	 */
	public var type (default, null):String;
	
	@:noCompletion private var __data:ByteArray;
	@:noCompletion private var __path:String;
	@:noCompletion private var __urlLoader:URLLoader;
	
	
	public function new () {
		
		super ();
		
	}
	
	
	public function browse (typeFilter:Array<FileFilter> = null):Bool {
		
		__data = null;
		__path = null;
		
		#if desktop
		
		var filter = null;
		
		if (typeFilter != null) {
			
			var filters = [];
			
			for (type in typeFilter) {
				
				filters.push (StringTools.replace (StringTools.replace (type.extension, "*.", ""), ";", ","));
				
			}
			
			filter = filters.join (";");
			
		}
		
		var openFileDialog = new FileDialog ();
		openFileDialog.onCancel.add (openFileDialog_onCancel);
		openFileDialog.onSelect.add (openFileDialog_onSelect);
		openFileDialog.browse (OPEN, filter);
		return true;
		
		#end
		
		return false;
		
	}
	
	
	public function cancel ():Void {
		
		if (__urlLoader != null) {
			
			__urlLoader.close ();
			
		}
		
	}
	
	
	public function download (request:URLRequest, defaultFileName:String = null):Void {
		
		__data = null;
		__path = null;
		
		__urlLoader = new URLLoader ();
		__urlLoader.addEventListener (Event.COMPLETE, urlLoader_onComplete);
		__urlLoader.addEventListener (IOErrorEvent.IO_ERROR, urlLoader_onIOError);
		__urlLoader.addEventListener (ProgressEvent.PROGRESS, urlLoader_onProgress);
		__urlLoader.load (request);
		
		var saveFileDialog = new FileDialog ();
		saveFileDialog.onCancel.add (saveFileDialog_onCancel);
		saveFileDialog.onSelect.add (saveFileDialog_onSelect);
		saveFileDialog.browse (SAVE, defaultFileName != null ? Path.extension (defaultFileName) : null);
		
	}
	
	
	public function load ():Void {
		
		#if sys
		
		if (__path != null) {
			
			data = ByteArray.readFile (__path);
			
		}
		
		#end
		
	}
	
	
	public function save (data:Dynamic, defaultFileName:String = null):Void {
		
		__data = null;
		__path = null;
		
		if (data == null) return;
		
		#if desktop
		
		if (Std.is (data, ByteArray)) {
			
			__data = data;
			
		} else {
			
			__data = new ByteArray ();
			__data.writeUTFBytes (Std.string (data));
			
		}
		
		var saveFileDialog = new FileDialog ();
		saveFileDialog.onCancel.add (saveFileDialog_onCancel);
		saveFileDialog.onSelect.add (saveFileDialog_onSelect);
		saveFileDialog.browse (SAVE, defaultFileName != null ? Path.extension (defaultFileName) : null);
		
		#end
		
	}
	
	
	public function upload (request:URLRequest, uploadDataFieldName:String = "Filedata", testUpload:Bool = false):Void {
		
		openfl.Lib.notImplemented ("FileReference.upload");
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	@:noCompletion private function openFileDialog_onCancel ():Void {
		
		dispatchEvent (new Event (Event.CANCEL));
		
	}
	
	
	@:noCompletion private function openFileDialog_onSelect (path:String):Void {
		
		#if sys
		var fileInfo = FileSystem.stat (path);
		creationDate = fileInfo.ctime;
		modificationDate = fileInfo.mtime;
		size = fileInfo.size;
		type = "." + Path.extension (path);
		#end
		
		name = Path.withoutDirectory (path);
		__path = path;
		
		dispatchEvent (new Event (Event.SELECT));
		
	}
	
	
	@:noCompletion private function saveFileDialog_onCancel ():Void {
		
		dispatchEvent (new Event (Event.CANCEL));
		
	}
	
	
	@:noCompletion private function saveFileDialog_onSelect (path:String):Void {
		
		#if desktop
		
		name = Path.withoutDirectory (path);
		
		if (__data != null) {
			
			File.saveBytes (path, __data);
			
			__data = null;
			__path = null;
			
		} else {
			
			__path = path;
			
		}
		
		#end
		
		dispatchEvent (new Event (Event.SELECT));
		
	}
	
	
	@:noCompletion private function urlLoader_onComplete (event:Event):Void {
		
		#if desktop
		
		if (Std.is (__urlLoader.data, ByteArray)) {
			
			__data = __urlLoader.data;
			
		} else {
			
			__data = new ByteArray ();
			__data.writeUTFBytes (Std.string (__urlLoader.data));
			
		}
		
		if (__path != null) {
			
			File.saveBytes (__path, __data);
			
			__path = null;
			__data = null;
			
		}
		
		#end
		
		dispatchEvent (event);
		
	}
	
	
	@:noCompletion private function urlLoader_onIOError (event:IOErrorEvent):Void {
		
		dispatchEvent (event);
		
	}
	
	
	@:noCompletion private function urlLoader_onProgress (event:ProgressEvent):Void {
		
		dispatchEvent (event);
		
	}
	
	
}


#else
#end
#else
typedef FileReference = flash.net.FileReference;
#end