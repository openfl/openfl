package flash.desktop; #if (!display && flash)


import openfl.utils.Object;

@:require(flash10)


extern class Clipboard {
	
	
	public static var generalClipboard (default, null):Clipboard;
	
	public var formats (default, null):Array<ClipboardFormats>;
	
	public function clear ():Void;
	public function clearData (format:ClipboardFormats):Void;
	public function getData (format:ClipboardFormats, transferMode:ClipboardTransferMode = null):Object;
	public function hasFormat (format:ClipboardFormats):Bool;
	public function setData (format:ClipboardFormats, data:Object, serializable:Bool = true):Bool;
	public function setDataHandler (format:ClipboardFormats, handler:Dynamic, serializable:Bool = true):Bool;
	
	
}


#else
typedef Clipboard = openfl.desktop.Clipboard;
#end