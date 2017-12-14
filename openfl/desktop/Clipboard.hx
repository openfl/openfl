package openfl.desktop;


import lime.system.Clipboard in LimeClipboard;
import openfl.utils.Object;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class Clipboard {
	
	
	public static var generalClipboard (get, never):Clipboard;
	
	private static var __generalClipboard:Clipboard;
	
	public var formats (get, never):Array<ClipboardFormats>;
	
	private var __htmlText:String;
	private var __richText:String;
	private var __systemClipboard:Bool;
	private var __text:String;
	
	
	#if openfljs
	private static function __init__ () {
		
		untyped global.Object.defineProperty (Clipboard, "generalClipboard", { get: function () { return Clipboard.get_generalClipboard (); } });
		untyped global.Object.defineProperty (Clipboard.prototype, "formats", { get: untyped __js__ ("function () { return this.get_formats (); }") });
		
	}
	#end
	
	
	private function new () {
		
		
		
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
	
	
	public function setDataHandler (format:ClipboardFormats, handler:Void->Dynamic, serializable:Bool = true):Bool {
		
		openfl._internal.Lib.notImplemented ();
		return false;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_formats ():Array<ClipboardFormats> {
		
		var formats = [ ClipboardFormats.TEXT_FORMAT ];
		if (hasFormat (HTML_FORMAT)) formats.push (HTML_FORMAT);
		if (hasFormat (RICH_TEXT_FORMAT)) formats.push (RICH_TEXT_FORMAT);
		if (hasFormat (TEXT_FORMAT)) formats.push (TEXT_FORMAT);
		return formats;
		
	}
	
	
	private static function get_generalClipboard ():Clipboard {
		
		if (__generalClipboard == null) {
			
			__generalClipboard = new Clipboard ();
			__generalClipboard.__systemClipboard = true;
			
		}
		
		return __generalClipboard;
		
	}
	
	
}