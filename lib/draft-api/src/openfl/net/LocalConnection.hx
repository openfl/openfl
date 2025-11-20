package openfl.net;

#if !(flash || air)
import haxe.Timer;
import openfl.errors.ArgumentError;
import openfl.events.StatusEvent;
import openfl.utils.Object;
import haxe.Unserializer;
import haxe.Serializer;
import cpp.Pointer;
import haxe.ds.StringMap;
import haxe.io.Bytes;
import haxe.io.BytesData;
import openfl.net._internal.NativeLocalConnection;
import lime.system.BackgroundWorker;
import openfl.net._internal.win.HANDLE;
import sys.thread.Deque;
import openfl.events.EventDispatcher;

/**
 * LocalConnection - Implements IPC using Named Pipes
 */
@:access(haxe.Serializer)
@:access(openfl.net._internal.NativeLocalConnection)
class LocalConnection extends EventDispatcher
{
	public var client:Object;

	public var domain(get, never):String;

	public var isPerUser:Bool;

	private function get_domain():String
	{
		Lib.notImplemented("LocalConnection.domain");
		return "";
	}

	@:noCompletion private var __inboundPipe:HANDLE;
	@:noCompletion private var __outboundPipe:HANDLE;
	@:noCompletion private var __serializer:Serializer;
	@:noCompletion private var __worker:BackgroundWorker;
	@:noCompletion private var __clientPipes:Array<Dynamic>;
	@:noCompletion private var __outboundTimeout:Timer;
	@:noCompletion private var __lastSentTime:Float = 0;
	@:noCompletion private var __connected:Bool = false;

	@:noCompletion private static inline var TIME_OUT:Int = 45000;
	@:noCompletion private static inline var BUFFER_SIZE:Int = 4096;

	public function new()
	{
		super();
		__serializer = new Serializer();
		__serializer.useCache = true;
		__clientPipes = [];
	}

	/** Closes the receiving connection*/
	public function close():Void
	{
		if (__inboundPipe != null)
		{
			__close(__inboundPipe);
			__inboundPipe = null;
		}
		__connected = false;
	}

	/** Starts listening for messages */
	public function connect(connectionName:String):Void
	{
		// trace('Connecting as server: ' + connectionName);
		if (!__setupNamedPipe(connectionName))
		{
			// trace("Error setting up named pipe: " + connectionName);
			throw new ArgumentError("Connection name is already in use or invalid");
		}
		else
		{
			__connected = true;
		}
	}

	/** Sends a message to another connection */
	public function send(connectionName:String, methodName:String, ...arguments):Void
	{
		__resetSeralizer();
		var status:Bool = false;

		__serializer.serialize(arguments);
		var methodBytes:Bytes = Bytes.ofString(methodName);
		var serializationBytes:Bytes = Bytes.ofString(__serializer.toString());

		var messageBuffer:BytesBuffer = new BytesBuffer();
		messageBuffer.addInt32(methodBytes.length);
		messageBuffer.addBytes(methodBytes, 0, methodBytes.length);
		messageBuffer.addInt32(serializationBytes.length);
		messageBuffer.addBytes(serializationBytes, 0, serializationBytes.length);

		var messageBytes:Bytes = messageBuffer.getBytes();
		// trace("Attempt to send: " + message);

		// Connects to the outbound pipe

		if (__outboundPipe == null || !__isOpen(__outboundPipe))
		{
			__outboundPipe = __connect(connectionName);
		}

		// Send the message
		if (__outboundPipe != null)
		{
			status = __write(__outboundPipe, messageBytes.getData(), messageBytes.length);
		}

		// trace("Send message status is: " + (status ? "Success" : "Failure"));
		var level:String = status ? "status" : "error";

		dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, "0", level));
		// __close(pipe);

		// Update last sent time
		__lastSentTime = Sys.time();

		// Ensure timeout checking is running
		if (__outboundTimeout == null)
		{
			__startTimeoutCheck();
		}
	}

	public function allowDomain(?domains:Array<String>):Void
	{
		Lib.notImplemented("LocalConnection.allowDomain");
	}

	public function allowInsecureDomain(?domains:Array<String>):Void
	{
		Lib.notImplemented("LocalConnection.allowInsecureDomain");
	}

	public static function get_isSupported():Bool
	{
		#if (cpp && windows)
		return true;
		#else
		return false;
		#end
	}

	/** Resets our serializer internally */
	@:noCompeltion private inline function __resetSeralizer():Void
	{
		__serializer.buf = new StringBuf();
		__serializer.shash.clear();
		__serializer.cache = [];
		__serializer.scount = 0;
	}

	/** Starts the timeout check (but does not hold a strong reference) */
	@:noCompletion private function __startTimeoutCheck():Void
	{
		if (__outboundTimeout != null) return; // Prevent multiple timers

		__outboundTimeout = Timer.delay(() -> __checkTimeout(), 5000);
	}

	/** Checks if the pipe should be closed due to timeout */
	@:noCompletion private function __checkTimeout():Void
	{
		if (__outboundPipe != null)
		{
			var elapsed:Float = Sys.time() - __lastSentTime;
			if (elapsed >= TIME_OUT / 1000)
			{
				// trace("Timeout expired. Closing outbound pipe.");
				__close(__outboundPipe);
				__outboundPipe = null;
			}
		}

		// Stop the timer if there’s no active pipe
		if (__outboundPipe == null && __outboundTimeout != null)
		{
			// trace("No active pipe, stopping timeout checks.");
			__outboundTimeout.stop();
			__outboundTimeout = null; // Allow garbage collection
			return;
		}

		// Continue checking if still active
		__outboundTimeout = Timer.delay(() -> __checkTimeout(), 5000);
	}

	/** Writes data to a named pipe */
	@:noCompletion private static function __write(pipe:HANDLE, data:BytesData, size:Int):Bool
	{
		return NativeLocalConnection.__write(pipe, Pointer.ofArray(data), size);
	}

	/** Connects to an outbound pipe */
	@:noCompletion private static function __connect(name:String):HANDLE
	{
		return NativeLocalConnection.__connect(name);
	}

	/** Creates an inbound pipe (server) */
	@:noCompletion private static function __createInboundPipe(name:String):HANDLE
	{
		return NativeLocalConnection.__createInboundPipe(name);
	}

	/** Accepts a new client connection */
	@:noCompletion private static function __accept(pipe:HANDLE):Bool
	{
		return NativeLocalConnection.__accept(pipe);
	}

	@:noCompletion private static function __isOpen(pipe:HANDLE):Bool
	{
		return NativeLocalConnection.__isOpen(pipe);
	}

	/** Reads from the named pipe */
	@:noCompletion private static function __read(pipe:HANDLE, buffer:BytesData, size:Int):Int
	{
		return NativeLocalConnection.__read(pipe, Pointer.ofArray(buffer), size);
	}

	/** Gets available bytes in the pipe */
	@:noCompletion private static function __getBytesAvailable(pipe:HANDLE):Int
	{
		return NativeLocalConnection.__getBytesAvailable(pipe);
	}

	/** Closes a named pipe */
	@:noCompletion private static function __close(pipe:HANDLE):Void
	{
		NativeLocalConnection.__close(pipe);
	}

	/** Initializes the Named Pipe Server */
	@:noCompletion private function __setupNamedPipe(connectionName:String):Bool
	{
		__worker = new BackgroundWorker();
		var handleQueue:Deque<HANDLE> = new Deque();

		__worker.doWork.add((name:String) ->
		{
			var handle:HANDLE = null;
			try
			{
				handle = __createInboundPipe(name);
				handleQueue.add(handle);
			}
			catch (e:Dynamic)
			{
				handleQueue.add(null);
			}
			if (handle != null)
			{
				__runLocalConnection(name);
			}
		});

		__worker.run(connectionName);

		var handle:HANDLE = handleQueue.pop(true);
		if (handle != null)
		{
			__inboundPipe = handle;
			return true;
		}

		return false;
	}

	@:noCompletion private #if !debug inline #end function __onData(received:Bytes):Void
	{
		if (client == null)
		{
			return;
		}

		var offset:Int = 0;
		try
		{
			var methodLength:Int = received.getInt32(0);
			// trace(methodLength);
			offset += 4;

			var method:String = received.getString(offset, methodLength);
			offset += methodLength;
			// trace(method);

			var serializationLength:Int = received.getInt32(offset);
			offset += 4;
			// trace(serializationLength);

			var serialization:String = received.getString(offset, serializationLength);
			// trace(serialization);

			var args:Array<Dynamic> = Unserializer.run(serialization);

			Reflect.callMethod(client, client[method], args);
		}
		catch (e:Dynamic)
		{
			throw "error parsing LocalConnection message";
		}

		/*try{
				Reflect.callMethod(client, client[method], args);
			}
			catch (e:Dynamic)
			{
				// De nada
		}*/
	}

	/** Listens for incoming messages in a background thread */
	@:noCompletion private function __runLocalConnection(connectionName:String):Void
	{
		var buffer:Bytes = Bytes.alloc(BUFFER_SIZE);

		while (true)
		{
			// Accepts new clients
			if (__accept(__inboundPipe))
			{
				// trace("New client connected!");

				// we store new client pipe
				__clientPipes.push(__inboundPipe);
				// Creates a new pipe for next client
				__inboundPipe = __createInboundPipe(connectionName);
			}

			// we can iterate in reverse to safely remove elements
			var i = __clientPipes.length - 1;
			while (i >= 0)
			{
				var pipe = __clientPipes[i];

				// Checks if the client disconnected
				var available:Int = __getBytesAvailable(pipe);
				if (available == 0)
				{
					// Check if the pipe is still valid?
					if (!__isOpen(pipe))
					{
						// trace("Client disconnected. Removing handle.");
						__clientPipes.splice(i, 1); // Remove client from the list
					}
				}
				else if (available > 0)
				{
					if (available > BUFFER_SIZE)
					{
						var largeMessageBuffer:BytesBuffer = new BytesBuffer();
						var bytesRemaining:Int = available;
						while (bytesRemaining > 0)
						{
							if (__read(pipe, buffer.getData(), BUFFER_SIZE) == 0)
							{
								var length:Int = bytesRemaining > BUFFER_SIZE ? BUFFER_SIZE : bytesRemaining;
								bytesRemaining -= length;
								largeMessageBuffer.addBytes(buffer, 0, length);
							}
						}
						__onData(largeMessageBuffer.getBytes());
					}
					else
					{
						// Read theavailable data
						if (__read(pipe, buffer.getData(), BUFFER_SIZE) == 0)
						{
							var received:Bytes = buffer;
							// trace("Received: " + received);
							__onData(received);
						}
					}
				}

				i--; // Moves to the previous index
			}

			// Application seems to lock up without sleep
			Sys.sleep(0);
		}
	}
}
#else
typedef LocalConnection = flash.net.LocalConnection;
#end
