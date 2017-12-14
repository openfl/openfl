package openfl.net;


import openfl.events.EventDispatcher;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.SecurityErrorEvent;
import openfl.events.ProgressEvent;
import openfl.utils.IDataInput;
import openfl.utils.ByteArray;
import openfl.utils.Endian;


class URLStream extends EventDispatcher implements IDataInput {
	
	
	public var bytesAvailable (get, never):UInt;
	public var connected (get, never):Bool;
	public var endian (get, set):Endian;
	public var objectEncoding:UInt;
	
	private var __data:ByteArray;
	private var __loader:URLLoader;
	
	
	#if openfljs
	private static function __init__ () {
		
		untyped Object.defineProperties (URLStream.prototype, {
			"bytesAvailable": { get: untyped __js__ ("function () { return this.get_bytesAvailable (); }") },
			"connected": { get: untyped __js__ ("function () { return this.get_connected (); }") },
			"endian": { get: untyped __js__ ("function () { return this.get_endian (); }"), set: untyped __js__ ("function (v) { return this.set_endian (v); }") },
		});
		
	}
	#end
	
	
	public function new () {
		
		super ();
		
		__loader = new URLLoader ();
		__loader.dataFormat = URLLoaderDataFormat.BINARY;
		
	}
	
	
	public function close ():Void {
		
		__removeEventListeners ();
		__data = null;
		
	}
	
	
	public function load (request:URLRequest):Void {
		
		__removeEventListeners ();
		__addEventListeners ();
		
		__loader.load (request);
		
	}
	
	
	public function readBoolean ():Bool {
		
		return __data.readBoolean ();
		
	}
	
	
	public function readByte ():Int {
		
		return __data.readByte ();
		
	}
	
	
	public function readBytes (bytes:ByteArray, offset:UInt = 0, length:Int = 0):Void {
		
		__data.readBytes (bytes, offset, length);
		
	}
	
	
	public function readDouble ():Float {
		
		return __data.readDouble ();
		
	}
	
	
	public function readFloat ():Float {
		
		return __data.readFloat ();
		
	}
	
	
	public function readInt ():Int {
		
		return __data.readInt ();
		
	}
	
	
	public function readMultiByte (length:UInt, charSet:String):String {
		
		return __data.readMultiByte (length, charSet);
		
	}
	
	
	public function readObject ():Dynamic {
		
		return null;
		
	}
	
	
	public function readShort ():Int {
		
		return __data.readShort ();
		
	}
	
	
	public function readUnsignedByte ():UInt {
		
		return __data.readUnsignedByte ();
		
	}
	
	
	public function readUnsignedInt ():UInt {
		
		return __data.readUnsignedInt ();
		
	}
	
	
	public function readUnsignedShort ():UInt {
		
		return __data.readUnsignedShort ();
		
	}
	
	
	public function readUTF ():String {
		
		return __data.readUTF ();
		
	}
	
	
	public function readUTFBytes (length:UInt):String {
		
		return __data.readUTFBytes (length);
		
	}
	
	
	private function __addEventListeners ():Void {
		
		__loader.addEventListener (Event.COMPLETE, loader_onComplete);
		__loader.addEventListener (IOErrorEvent.IO_ERROR, loader_onIOError);
		__loader.addEventListener (SecurityErrorEvent.SECURITY_ERROR, loader_onSecurityError);
		__loader.addEventListener (ProgressEvent.PROGRESS, loader_onProgressEvent);
		
	}
	
	
	private function __removeEventListeners ():Void {
		
		__loader.removeEventListener (Event.COMPLETE, loader_onComplete);
		__loader.removeEventListener (IOErrorEvent.IO_ERROR, loader_onIOError);
		__loader.removeEventListener (SecurityErrorEvent.SECURITY_ERROR, loader_onSecurityError);
		__loader.removeEventListener (ProgressEvent.PROGRESS, loader_onProgressEvent);
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function loader_onComplete (event:Event):Void {
		
		__removeEventListeners ();
		__data = __loader.data;
		
		dispatchEvent (new ProgressEvent (ProgressEvent.PROGRESS, false, false, __loader.bytesLoaded, __loader.bytesTotal));
		dispatchEvent (new Event (Event.COMPLETE));
		
	}
	
	
	private function loader_onIOError (event:IOErrorEvent):Void {
		
		__removeEventListeners ();
		
		dispatchEvent (event);
		
	}
	
	
	private function loader_onSecurityError (event:SecurityErrorEvent):Void {
		
		__removeEventListeners ();
		
		dispatchEvent (event);
		
	}
	
	
	private function loader_onProgressEvent (event:ProgressEvent):Void {
		
		__data = __loader.data;
		dispatchEvent (event);
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	public function get_bytesAvailable ():UInt {
		
		if (__data != null) {
			
			return __data.length - __data.position;
			
		}
		
		return 0;
		
	}
	
	
	public function get_connected ():Bool {
		
		return false;
		
	}
	
	
	public function get_endian ():Endian {
		
		return __data.endian;
		
	}
	
	
	public function set_endian (value:Endian):Endian {
		
		return __data.endian = value;
		
	}
	
	
}