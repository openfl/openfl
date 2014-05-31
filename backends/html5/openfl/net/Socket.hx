package openfl.net;


import haxe.io.Output;
import haxe.io.BytesBuffer;
import haxe.io.Bytes;
import haxe.io.Input;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import openfl.errors.SecurityError;
import openfl.errors.IOError;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.ProgressEvent;
import openfl.events.IOErrorEvent;
import openfl.utils.IDataInput;
import openfl.utils.ByteArray;
import openfl.utils.Endian;


class Socket extends EventDispatcher /*implements IDataInput implements IDataOutput*/ {
	private var _stamp : Float;
	private var _buf : haxe.io.Bytes;
	private var _socket: Dynamic;
	private var _connected: Bool;
	private var _host: String;
	private var _port: Int;

	private var _inputBuffer : ByteArray;
	private var _input : ByteArray;
	private var _output : ByteArray;

	public var bytesAvailable(get, null) : Int;
	public var bytesPending(get, null) : Int;
	public var timeout : Int;
	public var objectEncoding : Int;
	@:isVar
	public var endian(get, set): String;

	public var connected(get, null): Bool;

	private function get_connected(): Bool {
		return _connected;
	}

	private function get_endian(): String {
		return endian;
	}

	private function set_endian(value: String): String {
		endian = value;
		if( _input != null ) _input.endian = value;
		if( _inputBuffer != null ) _inputBuffer.endian = value;
		if( _output != null ) _output.endian = value;
		return endian;
	}

	private function get_bytesAvailable() : Int {
		return _input.bytesAvailable;
	}
	
	private function get_bytesPending() : Int {
		return _output.length;
	}

	public function new(host:String = null, port:Int = 0) {
		super();
		endian = Endian.BIG_ENDIAN;
		timeout = 20000;
		_buf = haxe.io.Bytes.alloc( 4096 );
		if( port > 0 && port < 65535 )
			connect(host, port);
	}
	
	public function connect( ?host: String = null, ?port: Int = 0) {
		if( _socket != null )
			close();

		if( port < 0 || port > 65535 )
			throw new SecurityError("Invalid socket port number specified.");

		_stamp = haxe.Timer.stamp();
		
		_host = host;
		_port = port;

		_output = new ByteArray();
		_output.endian = endian;
		_input = new ByteArray();
		_input.endian = endian;
		_inputBuffer = new ByteArray();
		_inputBuffer.endian = endian;

		_socket = untyped __js__("new WebSocket(\"ws://\" + host + \":\" + port)");

		_socket.onopen = onOpenHandler;
		_socket.onmessage = onMessageHandler;
		_socket.onclose = onCloseHandler;
		_socket.onerror = onErrorHandler;
		_socket.binaryType = "arraybuffer";

		flash.Lib.current.addEventListener( Event.ENTER_FRAME, onFrame );
	}

	private function onOpenHandler (_):Void {
		_connected = true;
		dispatchEvent (new Event (Event.CONNECT));
	}

	private function onMessageHandler (msg:Dynamic):Void {
		var newData = ByteArray.__ofBuffer(msg.data);
		newData.readBytes(_inputBuffer, _inputBuffer.length);
	}
	

	private function onCloseHandler (_):Void {
		
		dispatchEvent (new Event (Event.CLOSE));
		
	}

	private function onErrorHandler (_):Void {
		
		dispatchEvent (new Event (IOErrorEvent.IO_ERROR));
		
	}

	private function onFrame( _ ){
		if (_inputBuffer.bytesAvailable > 0)
		{
			var newInput = new ByteArray();
			var newDataLength = _inputBuffer.bytesAvailable;
			_input.readBytes(newInput, 0, _input.bytesAvailable);
			_inputBuffer.position = 0;
			_inputBuffer.readBytes(newInput, newInput.position, _inputBuffer.length);
			newInput.position = 0;
			_input = newInput;
			_inputBuffer.clear();
			dispatchEvent( new ProgressEvent(ProgressEvent.SOCKET_DATA, false, false, newDataLength, 0) );
		}
		
		if( _socket != null )
			flush();
	}

	private function cleanSocket(){
		try {
			_socket.close();
		}catch( e : Dynamic ){
		}
		_socket = null;
		flash.Lib.current.removeEventListener( Event.ENTER_FRAME, onFrame );
	}

	public function close(): Void {
		if( _socket!=null ){
			cleanSocket();
		}else{
			throw new IOError("Operation attempted on invalid socket.");
		}
	}
	
	// **** READ ****

	public function readBoolean():Bool {
		if ( _socket == null ) 
			throw new IOError("Operation attempted on invalid socket.");
		return _input.readBoolean();
	}
	public function readByte():Int {
		if ( _socket == null ) 
			throw new IOError("Operation attempted on invalid socket.");
		return _input.readByte(); 
	}
	public function readBytes(bytes: flash.utils.ByteArray, offset: Int = 0, length: Int = 0): Void {
		if ( _socket == null ) 
			throw new IOError("Operation attempted on invalid socket.");
		_input.readBytes(bytes,offset,length);
	}
	public function readDouble():Float { 
		if ( _socket == null ) 
			throw new IOError("Operation attempted on invalid socket.");
		return _input.readDouble(); 
	}
	public function readFloat():Float { 
		if ( _socket == null ) 
			throw new IOError("Operation attempted on invalid socket.");
		return _input.readFloat(); 
	}	
	public function readInt():Int { 
		if ( _socket == null ) 
			throw new IOError("Operation attempted on invalid socket.");
		return _input.readInt();
	}
	public function readMultiByte(length:Int, charSet:String):String { 
		if ( _socket == null ) 
			throw new IOError("Operation attempted on invalid socket.");
		return _input.readMultiByte(length, charSet);
	}
	//public function readObject():Dynamic { return _input.readObject(); }
	public function readShort():Int { 
		if ( _socket == null ) 
			throw new IOError("Operation attempted on invalid socket.");
		return _input.readShort(); 
	}
	public function readUnsignedByte():Int { 
		if ( _socket == null ) 
			throw new IOError("Operation attempted on invalid socket.");
		return _input.readUnsignedByte();
	}
	public function readUnsignedInt():Int { 
		if ( _socket == null ) 
			throw new IOError("Operation attempted on invalid socket.");
		return _input.readUnsignedInt();
	}
	public function readUnsignedShort():Int { 
		if ( _socket == null ) 
			throw new IOError("Operation attempted on invalid socket.");
		return _input.readUnsignedShort(); 
	}
	public function readUTF():String { 
		if ( _socket == null ) 
			throw new IOError("Operation attempted on invalid socket.");
		return _input.readUTF();
	}
	public function readUTFBytes(length:Int):String { 
		if ( _socket == null ) 
			throw new IOError("Operation attempted on invalid socket.");
		return _input.readUTFBytes(length); 
	}

	// **** WRITE ****

	public function writeBoolean( value:Bool ):Void { 
		if ( _socket == null ) 
			throw new IOError("Operation attempted on invalid socket.");
		_output.writeBoolean(value);
	}
	public function writeByte( value:Int ):Void { 
		if ( _socket == null ) 
			throw new IOError("Operation attempted on invalid socket.");
		_output.writeByte(value);
	}
	public function writeBytes( bytes:ByteArray, offset : Int = 0, length : Int = 0 ):Void { 
		if ( _socket == null ) 
			throw new IOError("Operation attempted on invalid socket.");
		_output.writeBytes(bytes, offset, length);
	}
	public function writeDouble( value:Float ):Void { 
		if ( _socket == null ) 
			throw new IOError("Operation attempted on invalid socket.");
		_output.writeDouble(value); 
	}
	public function writeFloat( value:Float ):Void { 
		if ( _socket == null ) 
			throw new IOError("Operation attempted on invalid socket.");
		_output.writeFloat(value);
	}
	public function writeInt( value:Int ):Void { 
		if ( _socket == null ) 
			throw new IOError("Operation attempted on invalid socket.");
		_output.writeInt(value);
	}
	public function writeMultiByte( value:String, charSet:String ):Void { 
		if ( _socket == null ) 
			throw new IOError("Operation attempted on invalid socket.");
		_output.writeUTFBytes(value);
	}
	public function writeShort( value:Int ):Void { 
		if ( _socket == null ) 
			throw new IOError("Operation attempted on invalid socket.");
		_output.writeShort(value);
	}
	public function writeUTF( value:String ):Void { 
		if ( _socket == null ) 
			throw new IOError("Operation attempted on invalid socket.");
		_output.writeUTF(value); 
	}
	public function writeUTFBytes( value:String ):Void { 
		if ( _socket == null ) 
			throw new IOError("Operation attempted on invalid socket.");
		_output.writeUTFBytes(value);
	}
	public function writeUnsignedInt( value:Int ):Void { 
		if ( _socket == null ) 
			throw new IOError("Operation attempted on invalid socket.");
		_output.writeUnsignedInt(value); 
	}
	//public function writeObject( object:Dynamic ):Void {  _output.writeObject(object); }

	public function flush() {
		if( _socket == null )
			throw new IOError("Operation attempted on invalid socket.");
		if( _output.length > 0 ){
			_socket.send( _output.__getBuffer() );
			_output = new ByteArray();
			_output.endian = endian;
		}
	}
}
