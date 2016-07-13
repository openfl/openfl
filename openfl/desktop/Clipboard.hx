package openfl.desktop;


import lime.system.Clipboard in LimeClipboard;
import openfl.utils.Object;


class Clipboard {
	
	
	public static var generalClipboard (get, null):Clipboard;
	
	private static var __generalClipboard:Clipboard;
	
	public var formats:Array<ClipboardFormats>;
	
	private var __htmlText:String;
	private var __richText:String;
	private var __systemClipboard:Bool;
	private var __text:String;
	
	
	public function new () {
		
		
		
	}
	
	
	public function clear ():Void {
		
		if (!__systemClipboard) {
			
			__htmlText = null;
			__richText = null;
			__text = null;
			
		} else {
			
			LimeClipboard.text = null;
			
		}
		
	}
	
	
	public function clearData (format:ClipboardFormats):Void {
		
		if (!__systemClipboard) {
			
			switch (format) {
				
				case HTML_FORMAT:
					
					__htmlText = null;
				
				case RICH_TEXT_FORMAT:
					
					__richText = null;
				
				case TEXT_FORMAT:
					
					__text = null;
				
				default:
				
			}
			
		} else {
			
			switch (format) {
				
				case HTML_FORMAT, RICH_TEXT_FORMAT, TEXT_FORMAT:
					
					LimeClipboard.text = null;
				
				default:
				
			}
			
		}
		
	}
	
	
	public function getData (format:ClipboardFormats, transferMode:ClipboardTransferMode = null):Object {
		
		if (transferMode == null) {
			
			transferMode = ORIGINAL_PREFERRED;
			
		}
		
		if (!__systemClipboard) {
			
			return switch (format) {
				
				case HTML_FORMAT: __htmlText;
				case RICH_TEXT_FORMAT: __richText;
				case TEXT_FORMAT: __text;
				default: null;
				
			}
			
		} else {
			
			return switch (format) {
				
				case HTML_FORMAT, RICH_TEXT_FORMAT, TEXT_FORMAT: LimeClipboard.text;
				default: null;
				
			}
			
		}
		
	}
	
	
	public function hasFormat (format:ClipboardFormats):Bool {
		
		if (!__systemClipboard) {
			
			return switch (format) {
				
				case HTML_FORMAT: __htmlText != null;
				case RICH_TEXT_FORMAT: __richText != null;
				case TEXT_FORMAT: __text != null;
				default: false;
				
			}
			
		} else {
			
			return switch (format) {
				
				case HTML_FORMAT, RICH_TEXT_FORMAT, TEXT_FORMAT: LimeClipboard.text != null;
				default: false;
				
			}
			
		}
		
	}
	
	
	public function setData (format:ClipboardFormats, data:Object, serializable:Bool = true):Bool {
		
		if (!__systemClipboard) {
			
			switch (format) {
				
				case HTML_FORMAT:
					
					__htmlText = data;
					return true;
				
				case RICH_TEXT_FORMAT:
					
					__richText = data;
					return true;
				
				case TEXT_FORMAT:
					
					__text = data;
					return true;
				
				default:
					
					return false;
				
			}
			
		} else {
			
			switch (format) {
				
				case HTML_FORMAT, RICH_TEXT_FORMAT, TEXT_FORMAT:
					
					LimeClipboard.text = data;
					return true;
				
				default:
					
					return false;
				
			}
			
		}
		
	}
	
	
	public function setDataHandler (format:ClipboardFormats, handler:Dynamic, serializable:Bool = true):Bool {
		
		openfl.Lib.notImplemented ("Clipboard.setDataHandler");
		return false;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private static function get_generalClipboard ():Clipboard {
		
		if (__generalClipboard == null) {
			
			__generalClipboard = new Clipboard ();
			__generalClipboard.__systemClipboard = true;
			
		}
		
		return __generalClipboard;
		
	}
	
	
}