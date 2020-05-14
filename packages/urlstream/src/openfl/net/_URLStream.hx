package openfl.net;

import openfl.events.EventDispatcher;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.SecurityErrorEvent;
import openfl.events.ProgressEvent;
import openfl.utils.IDataInput;
import openfl.utils.ByteArray;
import openfl.utils.Endian;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _URLStream extends _EventDispatcher
{
	public var bytesAvailable(get, never):UInt;
	public var connected(get, never):Bool;
	public var endian(get, set):Endian;
	public var objectEncoding:ObjectEncoding;

	public var __data:ByteArray;
	public var __loader:URLLoader;

	private var urlStream:URLStream;

	public function new(urlStream:URLStream)
	{
		this.urlStream = urlStream;

		super();

		// TODO: Operate more like socket?
		// Stay connected then allow closing before downloading all data?

		__loader = new URLLoader();
		__loader.dataFormat = URLLoaderDataFormat.BINARY;
	}

	public function close():Void
	{
		__removeEventListeners();
		__data = null;
	}

	public function load(request:URLRequest):Void
	{
		__removeEventListeners();
		__addEventListeners();

		__loader.load(request);
	}

	public function readBoolean():Bool
	{
		return __data.readBoolean();
	}

	public function readByte():Int
	{
		return __data.readByte();
	}

	public function readBytes(bytes:ByteArray, offset:UInt = 0, length:Int = 0):Void
	{
		__data.readBytes(bytes, offset, length);
	}

	public function readDouble():Float
	{
		return __data.readDouble();
	}

	public function readFloat():Float
	{
		return __data.readFloat();
	}

	public function readInt():Int
	{
		return __data.readInt();
	}

	public function readMultiByte(length:UInt, charSet:String):String
	{
		return __data.readMultiByte(length, charSet);
	}

	public function readObject():Dynamic
	{
		return null;
	}

	public function readShort():Int
	{
		return __data.readShort();
	}

	public function readUnsignedByte():UInt
	{
		return __data.readUnsignedByte();
	}

	public function readUnsignedInt():UInt
	{
		return __data.readUnsignedInt();
	}

	public function readUnsignedShort():UInt
	{
		return __data.readUnsignedShort();
	}

	public function readUTF():String
	{
		return __data.readUTF();
	}

	public function readUTFBytes(length:UInt):String
	{
		return __data.readUTFBytes(length);
	}

	public function __addEventListeners():Void
	{
		__loader.addEventListener(Event.COMPLETE, loader_onComplete);
		__loader.addEventListener(IOErrorEvent.IO_ERROR, loader_onIOError);
		__loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_onSecurityError);
		__loader.addEventListener(ProgressEvent.PROGRESS, loader_onProgressEvent);
	}

	public function __removeEventListeners():Void
	{
		__loader.removeEventListener(Event.COMPLETE, loader_onComplete);
		__loader.removeEventListener(IOErrorEvent.IO_ERROR, loader_onIOError);
		__loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_onSecurityError);
		__loader.removeEventListener(ProgressEvent.PROGRESS, loader_onProgressEvent);
	}

	// Event Handlers

	public function loader_onComplete(event:Event):Void
	{
		__removeEventListeners();
		__data = __loader.data;

		dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, __loader.bytesLoaded, __loader.bytesTotal));
		dispatchEvent(new Event(Event.COMPLETE));
	}

	public function loader_onIOError(event:IOErrorEvent):Void
	{
		__removeEventListeners();

		dispatchEvent(event);
	}

	public function loader_onSecurityError(event:SecurityErrorEvent):Void
	{
		__removeEventListeners();

		dispatchEvent(event);
	}

	public function loader_onProgressEvent(event:ProgressEvent):Void
	{
		__data = __loader.data;
		dispatchEvent(event);
	}

	// Get & Set Methods

	private function get_bytesAvailable():UInt
	{
		if (__data != null)
		{
			return __data.length - __data.position;
		}

		return 0;
	}

	private function get_connected():Bool
	{
		return false;
	}

	private function get_endian():Endian
	{
		return __data.endian;
	}

	private function set_endian(value:Endian):Endian
	{
		return __data.endian = value;
	}
}
