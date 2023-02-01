package openfl.filesystem;

#if (!flash && sys)
import haxe.Json;
import haxe.Serializer;
import haxe.Timer;
import haxe.Unserializer;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.io.Encoding;
import haxe.io.Bytes;
import haxe.io.Path;
import lime.system.BackgroundWorker;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.filesystem.FileMode;
import openfl.errors.IOError;
import openfl.events.IOErrorEvent;
import openfl.net.ObjectEncoding;
import openfl.events.OutputProgressEvent;
import openfl.events.ProgressEvent;
import openfl.utils.ByteArray;
import openfl.utils.Endian;
import openfl.utils.IDataInput;
import openfl.utils.IDataOutput;
import openfl.utils.Object;
import sys.FileSystem;
import sys.io.FileInput;
import sys.io.FileOutput;
import sys.io.FileSeek;
import sys.thread.Mutex;
#if format
import format.amf.Reader as AMFReader;
import format.amf.Writer as AMFWriter;
import format.amf.Tools as AMFTools;
import format.amf3.Reader as AMF3Reader;
import format.amf3.Writer as AMF3Writer;
import format.amf3.Tools as AMF3Tools;
#end

@:noCompletion private typedef HaxeFile = sys.io.File;

/**
	A FileStream object is used to read and write files. Files can be opened synchronously
	by calling the open() method or asynchronously by calling the openAsync() method.

	The advantage of opening files asynchronously is that other code can execute while Adobe
	AIR runs read and write processes in the background. When opened asynchronously, progress
	events are dispatched as operations proceed.

	A File object that is opened synchronously behaves much like a ByteArray object; a file
	opened asynchronously behaves much like a Socket or URLStream object. When a File object
	is opened synchronously, the caller pauses while the requested data is read from or written
	to the underlying file. When opened asynchronously, any data written to the stream is
	immediately buffered and later written to the file.

	Whether reading from a file synchronously or asynchronously, the actual read methods are
	synchronous. In both cases they read from data that is currently "available." The difference
	is that when reading synchronously all of the data is available at all times, and when
	reading asynchronously data becomes available gradually as the data streams into a read
	buffer. Either way, the data that can be synchronously read at the current moment is
	represented by the bytesAvailable property.

	An application that is processing asynchronous input typically registers for progress events
	and consumes the data as it becomes available by calling read methods. Alternatively, an
	application can simply wait until all of the data is available by registering for the complete
	event and processing the entire data set when the complete event is dispatched.
**/
@:access(openfl.utils.ByteArray)
@:access(openfl.utils.ByteArrayData)
@:access(openfl.filesystem.File)
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class FileStream extends EventDispatcher implements IDataInput implements IDataOutput
{
	/**
		Returns the number of bytes of data available for reading in the input buffer. User code
		must call bytesAvailable to ensure that sufficient data is available before trying to read
		it with one of the read methods.
	**/
	public var bytesAvailable(get, never):Int;

	/**
		The byte order for the data, either the BIG_ENDIAN or LITTLE_ENDIAN constant from the Endian
		class.
	**/
	public var endian(get, set):Endian;

	/**
		Specifies whether the HXSF, JSON, AMF3 or AMF0 format is used when writing or reading binary
		data by using the readObject() or writeObject() method.

		The value is a constant from the ObjectEncoding class. By default, on non-AIR platforms, the
		HXSF format is used. For AIR the default format is AMF3. If you would like to use AMF and AMF3
		on non-AIR platforms, you must also include the format dependency in your project from haxelib.

	**/
	public var objectEncoding:ObjectEncoding;

	/**
		The current position in the file.

		This value is modified in any of the following ways:

		* When you set the property explicitly
		* When reading from the FileStream object (by using one of the read methods)
		* When writing to the FileStream object

		The position is defined as a Number (instead of uint) in order to support files larger than
		232 bytes in length. The value of this property is always a whole number less than 253. If
		you set this value to a number with a fractional component, the value is rounded down to
		the nearest integer.

		When reading a file asyncronously, if you set the position property, the application begins
		filling the read buffer with the data starting at the specified position, and the bytesAvailable
		property may be set to 0. Wait for a complete event before using a read method to read data;
		or wait for a progress event and check the bytesAvailable property before using a read method.
	**/
	@:isVar public var position(get, set):UInt;

	/**
		The minimum amount of data to read from disk when reading files asynchronously.

		This property specifies how much data an asynchronous stream attempts to read beyond the current
		position. Data is read in blocks based on the file system page size. Thus if you set readAhead to
		9,000 on a computer system with an 8KB (8192 byte) page size, the runtime reads ahead 2 blocks,
		or 16384 bytes at a time. The default value of this property is infinity: by default a file that
		is opened to read asynchronously reads as far as the end of the file.

		Reading data from the read buffer does not change the value of the readAhead property. When you
		read data from the buffer, new data is read in to refill the read buffer.

		The readAhead property has no effect on a file that is opened synchronously.

		As data is read in asynchronously, the FileStream object dispatches progress events. In the event
		handler method for the progress event, check to see that the required number of bytes is available
		(by checking the bytesAvailable property), and then read the data from the read buffer by using a
		read method.
	**/
	public var readAhead:Float = Math.POSITIVE_INFINITY;

	/**
		The isWriting property returns a bool used to identify the write state of asynchronous Update,
		Append, or Write streams. If isWrite is true, data is actively being written from the buffer.
	**/
	public var isWriting(default, null):Bool = false;

	@:noCompletion private var __input:FileInput;
	@:noCompletion private var __output:FileOutput;
	@:noCompletion private var __fileMode:FileMode;
	@:noCompletion private var __file:File;
	@:noCompletion private var __fileStreamWorker:BackgroundWorker;
	@:noCompletion private var __isOpen:Bool;
	@:noCompletion private var __isWrite:Bool;
	@:noCompletion private var __isAsync:Bool;
	@:noCompletion private var __pendingClose:Bool;
	// TODO:
	// Find another way to handle the situation where writeBytes has zero length during WRITE async mode.
	@:noCompletion private var __isZeroLength:Bool = false;
	@:noCompletion private var __positionDirty:Bool = false;
	@:noCompletion private var __buffer:ByteArray;
	@:noCompletion private var __fileStreamMutex:Mutex;
	@:noCompletion private var __pageSize:Int = 4096000;

	/**
		Creates a FileStream object. Use the open() or openAsync() method to open a file.
	**/
	public function new()
	{
		super();
		__isOpen = false;
		isWriting = false;
		__pendingClose = false;

		objectEncoding = HXSF;
		position = 0;
	}

	/**
		 Closes the FileStream object.

		You cannot read or write any data after you call the close() method. If the file was
		opened asynchronously (the FileStream object used the openAsync() method to open the
		file), calling the close() method causes the object to dispatch the close event.

		Closing the application automatically closes all files associated with FileStream
		objects in the application. However, it is best to register for a closed event on
		all FileStream objects opened asynchronously that have pending data to write, before
		closing the application (to ensure that data is written).

		You can reuse the FileStream object by calling the open() or the openAsync() method.
		This closes any file associated with the FileStream object, but the object does not
		dispatch the close event.

		For a FileStream object opened asynchronously (by using the openAsync() method), even
		if you call the close() event for a FileStream object and delete properties and variables
		that reference the object, the FileStream object is not garbage collected as long as
		there are pending operations and event handlers are registered for their completion. In
		particular, an otherwise unreferenced FileStream object persists as long as any of the
		following are still possible:

		For file reading operations, the end of the file has not been reached (and the complete
		event has not been dispatched).
		Output data is still available to written, and output-related events (such as the
		outputProgress event or the ioError event) have registered event listeners.

		@event close    			The file, which was opened asynchronously, is closed.
	**/
	public function close():Void
	{
		if (!__isOpen || __pendingClose)
		{
			return;
		}

		var async = __isAsync;
		if (async)
		{
			__fileStreamMutex.acquire();
			if (__fileStreamWorker != null && !__fileStreamWorker.canceled)
			{
				__pendingClose = true;
				__fileStreamMutex.release();
				return;
			}
		}

		__isOpen = false;
		__isAsync = false;
		__pendingClose = false;
		__buffer = null;

		if (__isWrite)
		{
			__output.close();
			__output = null;
		}
		else
		{
			__input.close();
			__input = null;
		}

		if (async)
		{
			__fileStreamMutex.release();
		}

		position = 0;
		__positionDirty = false;

		if (__fileStreamWorker != null)
		{
			__disposeFileStreamWorker();
			dispatchEvent(new Event(Event.CLOSE));
		}
	}

	/**
		 Opens the FileStream object synchronously, pointing to the file specified by the
		 file parameter.

		If the FileStream object is already open, calling the method closes the file before
		opening and no further events (including close) are delivered for the previously opened
		file.

		On systems that support file locking, a file opened in "write" or "update" mode
		(FileMode.WRITE or FileMode.UPDATE) is not readable until it is closed.

		Once you are done performing operations on the file, call the close() method of the
		FileStream object. Some operating systems limit the number of concurrently open files.
		@param 		file The File object specifying the file to open.
		@param 		 A string from the FileMode class that defines the capabilities of the
		FileStream, such as the ability to read from or write to the file.
		@throws 	IOError The file does not exist; you do not have adequate permissions to
		open the file; you are opening a file for read access, and you do not have read
		permissions; or you are opening a file for write access, and you do not have write
		permissions.
		@throws 	SecurityError The file location is in the application directory, and the
		fileMode parameter is set to "append", "update", or "write" mode.
	 */
	public function open(file:File, fileMode:FileMode):Void
	{
		__file = file;
		__fileMode = fileMode;

		__openFile();
	}

	@:noCompletion private function __disposeFileStreamWorker():Void
	{
		if (__fileStreamWorker == null)
		{
			return;
		}
		__fileStreamWorker.cancel();
		__fileStreamWorker.doWork.cancel();
		__fileStreamWorker.onProgress.cancel();
		__fileStreamWorker.onComplete.cancel();
		__fileStreamWorker = null;
	}

	/**
		Opens the FileStream object asynchronously, pointing to the file specified by the file
		parameter.

		If the FileStream object is already open, calling the method closes the file before opening
		and no further events (including close) are delivered for the previously opened file.

		If the fileMode parameter is set to FileMode.READ or FileMode.UPDATE, AIR reads data into
		the input buffer as soon as the file is opened, and progress and open events are dispatched
		as the data is read to the input buffer.

		On systems that support file locking, a file opened in "write" or "update" mode (FileMode.WRITE
		or FileMode.UPDATE) is not readable until it is closed.

		Once you are done performing operations on the file, call the close() method of the FileStream
		object. Some operating systems limit the number of concurrently open files.

		@param 		file The File object specifying the file to open.
		@param 		 A string from the FileMode class that defines the capabilities of the
		FileStream, such as the ability to read from or write to the file.
		@event 		ioError The file does not exist; you do not have adequate permissions to open the
		file; you are opening a file for read access, and you do not have read permissions; or you are
		opening a file for write access, and you do not have write permissions.
		@event 		progress Dispatched as data is read to the input buffer. (The file must be opened
		with the fileMode parameter set to FileMode.READ or FileMode.UPDATE.)
		@event		complete The file data has been read to the input buffer. (The file must be opened
		with the fileMode parameter set to FileMode.READ or FileMode.UPDATE.)
		@throws 	SecurityError The file location is in the application directory, and the
		fileMode parameter is set to "append", "update", or "write" mode.
	 */
	public function openAsync(file:File, fileMode:FileMode):Void
	{
		__isAsync = true;

		__fileStreamMutex = new Mutex();

		__fileStreamWorker = new BackgroundWorker();

		__fileStreamWorker.onProgress.add(function(e:Event)
		{
			dispatchEvent(e);
		});

		__fileStreamWorker.onComplete.add(function(e:Event)
		{
			// close() checks the canceled property to determine if it should
			// actually close or wait for the worker to finish
			__fileStreamWorker.cancel();
			if (e != null)
			{
				dispatchEvent(e);
			}
			if (__pendingClose)
			{
				__pendingClose = false;
				close();
			}
		});

		open(file, fileMode);

		if (fileMode == READ)
		{
			__buffer = new ByteArray(file.size);
			__fileStreamWorker.doWork.add(function(m:Dynamic)
			{
				var inputBytesAvailable:Int = 0;
				var tempPos:Int = 0;
				var bytesLoaded:Int = 0;

				while ((inputBytesAvailable = __getStreamBytesAvailable()) > 0)
				{
					if (__pendingClose)
					{
						// close() was called
						__fileStreamWorker.sendComplete();
						return;
					}

					var oldBytesLoaded = bytesLoaded;
					__fileStreamMutex.acquire();
					if (__buffer.bytesAvailable < readAhead)
					{
						try
						{
							var maxBytes:Int = Std.int(Math.min(__pageSize, inputBytesAvailable));

							var chunkBytes:Bytes = Bytes.alloc(maxBytes);
							tempPos = __buffer.position;
							__buffer.position = __input.tell();
							__input.readBytes(chunkBytes, 0, maxBytes);
							__buffer.writeBytes(ByteArray.fromBytes(chunkBytes), 0, chunkBytes.length);
							__buffer.position = tempPos;
							bytesLoaded += maxBytes;
						}
						catch (e:Dynamic)
						{
							__fileStreamMutex.release();
							__fileStreamWorker.sendComplete(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, "Index is out of bounds."));
							return;
						}
					}
					__fileStreamMutex.release();

					if (oldBytesLoaded != bytesLoaded)
					{
						__fileStreamWorker.sendProgress(new ProgressEvent(ProgressEvent.PROGRESS, false, false, bytesLoaded, __file.size));
					}
				}

				__fileStreamWorker.sendComplete(new Event(Event.COMPLETE));
			});
		}
		else
		{
			__buffer = new ByteArray();

			__fileStreamWorker.doWork.add(function(m:Dynamic)
			{
				var bytesLoaded:Int = 0;

				while (__fileStreamWorker != null)
				{
					Sys.sleep(.001);

					__fileStreamMutex.acquire();
					while (isWriting)
					{
						while (__buffer.length > bytesLoaded || __isZeroLength)
						{
							try
							{
								var maxBytes:Int = Std.int(Math.min(__pageSize, __buffer.length - bytesLoaded));

								__output.writeBytes(__buffer, bytesLoaded, maxBytes);
								bytesLoaded += maxBytes;

								__file.__fileStatsDirty = true;
								__isZeroLength = false;

								__fileStreamWorker.sendProgress(new OutputProgressEvent(OutputProgressEvent.OUTPUT_PROGRESS, false, false,
									__buffer.length - bytesLoaded, __buffer.length));
							}
							catch (e:Dynamic)
							{
								__fileStreamWorker.sendComplete(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, "Index is out of bounds."));
								break;
							}
						}

						isWriting = false;
					}
					__fileStreamMutex.release();
					if (__pendingClose)
					{
						// close() was called
						__fileStreamWorker.sendComplete();
						return;
					}
				}
			});
		}

		__fileStreamWorker.run();
	}

	/**
	 * Reads a Boolean value from the file stream, byte stream, or byte array. A single byte is read
	 * and true is returned if the byte is nonzero, false otherwise.
	 *
	 * @return 		A Boolean value, true if the byte is nonzero, false otherwise.
	 * @event 		ioError The file cannot be read or the file is not open. This event is dispatched only
	 * for files opened for asynchronous operations (by using the openAsync() method).
	 * @throws 		IOError The file has not been opened; the file has been opened, but it was not opened
	 * with read capabilities; or for a file that has been opened for synchronous operations (by using
	 * the open() method), the file cannot be read (for example, because the file is missing).
	 * @throws 		EOFError The position specfied for reading data exceeds the number of bytes available
	 * (specified by the bytesAvailable property).
	 */
	public function readBoolean():Bool
	{
		__checkIfReadable();
		__positionDirty = true;
		if (__isAsync)
		{
			__fileStreamMutex.acquire();
			var result = __buffer.readBoolean();
			__fileStreamMutex.release();
			return result;
		}
		return __input.readByte() == 1;
	}

	/**
	 * Reads a signed byte from the file stream, byte stream, or byte array.
	 *
	 * @return The returned value is in the range -128 to 127.
	 * @event 		ioError The file cannot be read or the file is not open. This event is dispatched only
	 * for files opened for asynchronous operations (by using the openAsync() method).
	 * @throws 		IOError The file has not been opened; the file has been opened, but it was not opened
	 * with read capabilities; or for a file that has been opened for synchronous operations (by using
	 * the open() method), the file cannot be read (for example, because the file is missing).
	 * @throws 			EOFError The position specfied for reading data exceeds the number of bytes available
	 * (specified by the bytesAvailable property).
	 */
	public function readByte():Int
	{
		__checkIfReadable();
		__positionDirty = true;

		if (__isAsync)
		{
			__fileStreamMutex.acquire();
			var result = __buffer.readByte();
			__fileStreamMutex.release();
			return result;
		}

		return __input.readByte();
	}

	/**
	 * Reads the number of data bytes, specified by the length parameter, from the file stream, byte
	 * stream, or byte array. The bytes are read into the ByteArray objected specified by the bytes
	 * parameter, starting at the position specified by offset.
	 *
	 * @param	bytes
	 * @param	offset
	 * @param	length
	 * @event 		ioError The file cannot be read or the file is not open. This event is dispatched only
	 * for files opened for asynchronous operations (by using the openAsync() method).
	 * @throws 		IOError The file has not been opened; the file has been opened, but it was not opened
	 * with read capabilities; or for a file that has been opened for synchronous operations (by using
	 * the open() method), the file cannot be read (for example, because the file is missing).
	 * @throws 		EOFError The position specfied for reading data exceeds the number of bytes available
	 * (specified by the bytesAvailable property).
	 */
	public function readBytes(bytes:ByteArray, offset:UInt = 0, length:UInt = 0):Void
	{
		__checkIfReadable();

		if (__isAsync)
		{
			__fileStreamMutex.acquire();
			__buffer.readBytes(bytes, offset, length);
			__fileStreamMutex.release();
			__positionDirty = true;
			return;
		}

		if (length == 0)
		{
			__input.seek(0, FileSeek.SeekEnd);
			length = __input.tell();
			__input.seek(position, FileSeek.SeekBegin);
		}

		var hxBytes = Bytes.alloc(length - offset);

		__input.readBytes(hxBytes, offset, length);

		bytes.writeBytes(hxBytes);

		__positionDirty = true;
	}

	/**
	 * Reads an IEEE 754 double-precision floating point number from the file stream, byte stream, or
	 * byte array.
	 *
	 * @return An IEEE 754 double-precision floating point number
	 * @event 		ioError The file cannot be read or the file is not open. This event is dispatched only
	 * for files opened for asynchronous operations (by using the openAsync() method).
	 * @throws 		IOError The file has not been opened; the file has been opened, but it was not opened
	 * with read capabilities; or for a file that has been opened for synchronous operations (by using
	 * the open() method), the file cannot be read (for example, because the file is missing).
	 * @throws 		EOFError The position specfied for reading data exceeds the number of bytes available
	 * (specified by the bytesAvailable property).
	 */
	public function readDouble():Float
	{
		__checkIfReadable();
		__positionDirty = true;

		if (__isAsync)
		{
			__fileStreamMutex.acquire();
			var result = __buffer.readDouble();
			__fileStreamMutex.release();
			return result;
		}

		return __input.readDouble();
	}

	/**
	 * Reads an IEEE 754 single-precision floating point number from the file stream, byte stream, or byte array.
	 *
	 * @return		An IEEE 754 single-precision floating point number.
	 * @event 		ioError The file cannot be read or the file is not open. This event is dispatched only
	 * for files opened for asynchronous operations (by using the openAsync() method).
	 * @throws 		IOError The file has not been opened; the file has been opened, but it was not opened
	 * with read capabilities; or for a file that has been opened for synchronous operations (by using
	 * the open() method), the file cannot be read (for example, because the file is missing).
	 * @throws 		EOFError The position specfied for reading data exceeds the number of bytes available
	 * (specified by the bytesAvailable property).
	 */
	public function readFloat():Float
	{
		__checkIfReadable();
		__positionDirty = true;

		if (__isAsync)
		{
			__fileStreamMutex.acquire();
			var result = __buffer.readFloat();
			__fileStreamMutex.release();
			return result;
		}

		return __input.readFloat();
	}

	/**
	 * Reads a signed 32-bit integer from the file stream, byte stream, or byte array.
	 *
	 * @return The returned value is in the range -2147483648 to 2147483647.
	 * @event 		ioError The file cannot be read or the file is not open. This event is dispatched only
	 * for files opened for asynchronous operations (by using the openAsync() method).
	 * @throws 		IOError The file has not been opened; the file has been opened, but it was not opened
	 * with read capabilities; or for a file that has been opened for synchronous operations (by using
	 * the open() method), the file cannot be read (for example, because the file is missing).
	 * @throws 		EOFError The position specfied for reading data exceeds the number of bytes available
	 * (specified by the bytesAvailable property).
	 */
	public function readInt():Int
	{
		__checkIfReadable();
		__positionDirty = true;

		if (__isAsync)
		{
			__fileStreamMutex.acquire();
			var result = __buffer.readInt();
			__fileStreamMutex.release();
			return result;
		}

		return __input.readInt32();
	}

	/**
	 * Reads a multibyte string of specified length from the file stream, byte stream, or byte array using
	 * the specified character set.
	 *
	 * @param		length The number of bytes from the byte stream to read.
	 * @param		charSet The string denoting the character set to use to interpret the bytes. Possible
	 * character set strings include "shift-jis", "cn-gb", "iso-8859-1", and others.	 *
	 * @return		UTF-8 encoded string.
	 * @event 		ioError The file cannot be read or the file is not open. This event is dispatched only
	 * for files opened for asynchronous operations (by using the openAsync() method).
	 * @throws 		IOError The file has not been opened; the file has been opened, but it was not opened
	 * with read capabilities; or for a file that has been opened for synchronous operations (by using
	 * the open() method), the file cannot be read (for example, because the file is missing).
	 * @throws 		EOFError The position specfied for reading data exceeds the number of bytes available
	 * (specified by the bytesAvailable property).
	 */
	public function readMultiByte(length:Int, charSet:String):String
	{
		__checkIfReadable();
		__positionDirty = true;

		if (__isAsync)
		{
			__fileStreamMutex.acquire();
			var result = __buffer.readMultiByte(length, charSet);
			__fileStreamMutex.release();
			return result;
		}

		return readUTFBytes(length);
	}

	/**
	 * Reads an object from the file stream, byte stream, or byte array, encoded in AMF serialized format.
	 *
	 * @return The deserialized object
	 * @event 		ioError The file cannot be read or the file is not open. This event is dispatched only
	 * for files opened for asynchronous operations (by using the openAsync() method).
	 * @throws 		IOError The file has not been opened; the file has been opened, but it was not opened
	 * with read capabilities; or for a file that has been opened for synchronous operations (by using
	 * the open() method), the file cannot be read (for example, because the file is missing).
	 * @throws 		EOFError The position specfied for reading data exceeds the number of bytes available
	 * (specified by the bytesAvailable property).
	 */
	public function readObject():Dynamic
	{
		__checkIfReadable();

		if (__isAsync)
		{
			__positionDirty = true;
			__fileStreamMutex.acquire();
			var result = __buffer.readObject();
			__fileStreamMutex.release();
			return result;
		}

		switch (objectEncoding)
		{
			#if format
			case AMF0:
				var bytes:Bytes = Bytes.alloc(bytesAvailable);
				__input.readBytes(bytes, 0, bytesAvailable);

				var input = new BytesInput(bytes, 0);
				var reader = new AMFReader(input);
				var data = ByteArrayData.unwrapAMFValue(reader.read());
				__positionDirty = true;
				return data;

			case AMF3:
				var bytes:Bytes = Bytes.alloc(bytesAvailable);
				__input.readBytes(bytes, 0, bytesAvailable);

				var input = new BytesInput(bytes, 0);
				var reader = new AMF3Reader(input);
				var data = ByteArrayData.unwrapAMF3Value(reader.read());
				__positionDirty = true;
				return data;
			#end

			case HXSF:
				var data = readUTF();
				return Unserializer.run(data);

			case JSON:
				var data = readUTF();
				return Json.parse(data);

			default:
				return null;
		}

		__positionDirty = true;
		return {};
	}

	/**
	 * Reads a signed 16-bit integer from the file stream, byte stream, or byte array.
	 *
	 * @return The returned value is in the range -32768 to 32767.
	 * @event 		ioError The file cannot be read or the file is not open. This event is dispatched only
	 * for files opened for asynchronous operations (by using the openAsync() method).
	 * @throws 		IOError The file has not been opened; the file has been opened, but it was not opened
	 * with read capabilities; or for a file that has been opened for synchronous operations (by using
	 * the open() method), the file cannot be read (for example, because the file is missing).
	 * @throws 		EOFError The position specfied for reading data exceeds the number of bytes available
	 * (specified by the bytesAvailable property).
	 */
	public function readShort():Int
	{
		__checkIfReadable();
		__positionDirty = true;

		if (__isAsync)
		{
			__fileStreamMutex.acquire();
			var result = __buffer.readShort();
			__fileStreamMutex.release();
			return result;
		}

		return __input.readInt16();
	}

	/**
	 * Reads an unsigned byte from the file stream, byte stream, or byte array.
	 *
	 * @return The returned value is in the range 0 to 255.
	 * @event 		ioError The file cannot be read or the file is not open. This event is dispatched only
	 * for files opened for asynchronous operations (by using the openAsync() method).
	 * @throws 		IOError The file has not been opened; the file has been opened, but it was not opened
	 * with read capabilities; or for a file that has been opened for synchronous operations (by using
	 * the open() method), the file cannot be read (for example, because the file is missing).
	 * @throws 		EOFError The position specfied for reading data exceeds the number of bytes available
	 * (specified by the bytesAvailable property).
	 */
	public function readUnsignedByte():UInt
	{
		__checkIfReadable();
		__positionDirty = true;

		if (__isAsync)
		{
			__fileStreamMutex.acquire();
			var result = __buffer.readUnsignedByte();
			__fileStreamMutex.release();
			return result;
		}

		return ByteArray.fromBytes(__input.read(1)).readUnsignedByte();
	}

	/**
	 * Reads an unsigned 32-bit integer from the file stream, byte stream, or byte array.
	 *
	 * @return The returned value is in the range 0 to 4294967295.
	 * @event 		ioError The file cannot be read or the file is not open. This event is dispatched only
	 * for files opened for asynchronous operations (by using the openAsync() method).
	 * @throws 		IOError The file has not been opened; the file has been opened, but it was not opened
	 * with read capabilities; or for a file that has been opened for synchronous operations (by using
	 * the open() method), the file cannot be read (for example, because the file is missing).
	 * @throws 		EOFError The position specfied for reading data exceeds the number of bytes available
	 * (specified by the bytesAvailable property).
	 */
	public function readUnsignedInt():UInt
	{
		__checkIfReadable();
		__positionDirty = true;

		if (__isAsync)
		{
			__fileStreamMutex.acquire();
			var result = __buffer.readUnsignedInt();
			__fileStreamMutex.release();
			return result;
		}

		return __input.readInt32();
	}

	/**
	 * Reads an unsigned 16-bit integer from the file stream, byte stream, or byte array.
	 *
	 * @event 		ioError The file cannot be read or the file is not open. This event is dispatched only
	 * for files opened for asynchronous operations (by using the openAsync() method).
	 * @throws 		IOError The file has not been opened; the file has been opened, but it was not opened
	 * with read capabilities; or for a file that has been opened for synchronous operations (by using
	 * the open() method), the file cannot be read (for example, because the file is missing).
	 * @throws 		EOFError The position specfied for reading data exceeds the number of bytes available
	 * (specified by the bytesAvailable property).
	 */
	public function readUnsignedShort():UInt
	{
		__checkIfReadable();
		__positionDirty = true;

		if (__isAsync)
		{
			__fileStreamMutex.acquire();
			var result = __buffer.readUnsignedShort();
			__fileStreamMutex.release();
			return result;
		}

		return __input.readUInt16();
	}

	/**
		*  Reads a UTF-8 string from the file stream, byte stream, or byte array. The string is assumed to be
		* prefixed with an unsigned short indicating the length in bytes.

				This method is similar to the readUTF() method in the Java® IDataInput interface.
		* @return A UTF-8 string produced by the byte representation of characters.
		* @event 		ioError The file cannot be read or the file is not open. This event is dispatched only
		* for files opened for asynchronous operations (by using the openAsync() method).
		* @throws 		IOError The file has not been opened; the file has been opened, but it was not opened
		* with read capabilities; or for a file that has been opened for synchronous operations (by using
		* the open() method), the file cannot be read (for example, because the file is missing).
		* @throws 		EOFError The position specfied for reading data exceeds the number of bytes available
		* (specified by the bytesAvailable property).
	 */
	public function readUTF():String
	{
		__checkIfReadable();
		__positionDirty = true;

		if (__isAsync)
		{
			__fileStreamMutex.acquire();
			var result = __buffer.readUTF();
			__fileStreamMutex.release();
			return result;
		}

		var length:Int = __input.readUInt16();
		return __input.readString(length);
	}

	/**
	 * Reads a sequence of UTF-8 bytes from the byte stream or byte array and returns a string.
	 * @param		length The number of bytes to read.
	 * @return A UTF-8 string produced by the byte representation of characters of the specified length.
	 * @event 		ioError The file cannot be read or the file is not open. This event is dispatched only
	 * for files opened for asynchronous operations (by using the openAsync() method).
	 * @throws 		IOError The file has not been opened; the file has been opened, but it was not opened
	 * with read capabilities; or for a file that has been opened for synchronous operations (by using
	 * the open() method), the file cannot be read (for example, because the file is missing).
	 * @throws 		EOFError The position specfied for reading data exceeds the number of bytes available
	 * (specified by the bytesAvailable property).
	 */
	public function readUTFBytes(length:Int):String
	{
		__checkIfReadable();
		__positionDirty = true;

		if (__isAsync)
		{
			__fileStreamMutex.acquire();
			var result = __buffer.readUTFBytes(length);
			__fileStreamMutex.release();
			return result;
		}

		return __input.readString(length);
	}

	/**
	 * Truncates the file at the position specified by the position property of the FileStream object.
	 *
	 * Bytes from the position specified by the position property to the end of the file are deleted.
	 * The file must be open for writing.
	 * @throws 		IllegalOperationError The file is not open for writing.
	 */
	public function truncate():Void
	{
		__checkIfOpen();

		var fileMode:FileMode = __fileMode;

		var isAsync:Bool = __isAsync;

		var fileBytes:ByteArray = ByteArray.fromBytes(HaxeFile.getBytes(__file.nativePath));

		var truncatedBytes:ByteArray = new ByteArray(position);
		truncatedBytes.writeBytes(fileBytes, 0, truncatedBytes.length);
		close();

		HaxeFile.saveBytes(__file.nativePath, truncatedBytes);
		var pos:Int = truncatedBytes.length;
		fileBytes = null;

		if (isAsync)
		{
			openAsync(__file, fileMode);
		}
		else
		{
			open(__file, fileMode);
		}
		position = pos;

		__file.__fileStatsDirty = true;
	}

	/**
	 * Writes a Boolean value. A single byte is written according to the value parameter, either
	 * 1 if true or 0 if false.
	 *
	 * @param		value  A Boolean value determining which byte is written. If the parameter is
	 * true, 1 is written; if false, 0 is written.
	 * @event 		ioError  You cannot write to the file (for example, because the file is missing).
	 * This event is dispatched only for files that have been opened for asynchronous operations (by
	 * using the openAsync() method).
	 * @throws 		The file has not been opened; the file has been opened, but it was not opened
	 * with write capabilities; or for a file that has been opened for synchronous operations (by
	 * using the open() method), the file cannot be written (for example, because the file is missing).
	 */
	public function writeBoolean(value:Bool):Void
	{
		__checkIfWritable();

		if (__isAsync)
		{
			__fileStreamMutex.acquire();
			__buffer.writeBoolean(value);
			isWriting = true;
			__fileStreamMutex.release();

			return;
		}

		__output.writeByte(value ? 1 : 0);
		__file.__fileStatsDirty = true;
		__positionDirty = true;
	}

	/**
	 * Writes a byte. The low 8 bits of the parameter are used; the high 24 bits are ignored.
	 *
	 * @param	value A byte value as an integer.
	 * @event 		ioError  You cannot write to the file (for example, because the file is missing).
	 * This event is dispatched only for files that have been opened for asynchronous operations (by
	 * using the openAsync() method).
	 * @throws 		The file has not been opened; the file has been opened, but it was not opened
	 * with write capabilities; or for a file that has been opened for synchronous operations (by
	 * using the open() method), the file cannot be written (for example, because the file is missing).
	 */
	public function writeByte(value:Int):Void
	{
		__checkIfWritable();

		if (__isAsync)
		{
			__fileStreamMutex.acquire();
			__buffer.writeByte(value);
			isWriting = true;
			__fileStreamMutex.release();

			return;
		}

		__output.writeByte(value);
		__file.__fileStatsDirty = true;
		__positionDirty = true;
	}

	/**
	 *  Writes a sequence of bytes from the specified byte array, bytes, starting at the byte specified
	 * by offset (using a zero-based index) with a length specified by length, into the file stream,
	 * byte stream, or byte array.
	 *
	 * If the length parameter is omitted, the default length of 0 is used and the entire buffer starting at
	 * offset is written. If the offset parameter is also omitted, the entire buffer is written.
	 *
	 * If the offset or length parameter is out of range, they are clamped to the beginning and end of the bytes array.
	 *
	 * @param		bytes The byte array to write.
	 * @param		offset A zero-based index specifying the position into the array to begin writing.
	 * @param		length An unsigned integer specifying how far into the buffer to write.
	 * @event 		ioError  You cannot write to the file (for example, because the file is missing).
	 * This event is dispatched only for files that have been opened for asynchronous operations (by
	 * using the openAsync() method).
	 * @throws 		The file has not been opened; the file has been opened, but it was not opened
	 * with write capabilities; or for a file that has been opened for synchronous operations (by
	 * using the open() method), the file cannot be written (for example, because the file is missing).
	 */
	public function writeBytes(bytes:ByteArray, offset:Int = 0, length:Int = 0):Void
	{
		__checkIfWritable();

		if (__isAsync)
		{
			__fileStreamMutex.acquire();
			__buffer.writeBytes(bytes, offset, length);

			if (length == 0) __isZeroLength = true;
			isWriting = true;
			__fileStreamMutex.release();

			return;
		}

		if (length == 0)
		{
			length = bytes.length - offset;
		}

		__output.writeBytes(bytes, offset, length);

		__file.__fileStatsDirty = true;
		__positionDirty = true;
	}

	/**
	 * Writes an IEEE 754 double-precision (64-bit) floating point number.
	 *
	 * @param		value A double-precision (64-bit) floating point number.
	 * @event 		ioError  You cannot write to the file (for example, because the file is missing).
	 * This event is dispatched only for files that have been opened for asynchronous operations (by
	 * using the openAsync() method).
	 * @throws 		The file has not been opened; the file has been opened, but it was not opened
	 * with write capabilities; or for a file that has been opened for synchronous operations (by
	 * using the open() method), the file cannot be written (for example, because the file is missing).
	 */
	public function writeDouble(value:Float):Void
	{
		__checkIfWritable();

		if (__isAsync)
		{
			__fileStreamMutex.acquire();
			__buffer.writeDouble(value);
			isWriting = true;
			__fileStreamMutex.release();

			return;
		}

		__output.writeDouble(value);
		__file.__fileStatsDirty = true;
		__positionDirty = true;
	}

	/**
	 * Writes an IEEE 754 single-precision (32-bit) floating point number.
	 *
	 * @param		A single-precision (32-bit) floating point number.
	 * @event 		ioError  You cannot write to the file (for example, because the file is missing).
	 * This event is dispatched only for files that have been opened for asynchronous operations (by
	 * using the openAsync() method).
	 * @throws 		The file has not been opened; the file has been opened, but it was not opened
	 * with write capabilities; or for a file that has been opened for synchronous operations (by
	 * using the open() method), the file cannot be written (for example, because the file is missing).
	 */
	public function writeFloat(value:Float):Void
	{
		__checkIfWritable();

		if (__isAsync)
		{
			__fileStreamMutex.acquire();
			__buffer.writeFloat(value);
			isWriting = true;
			__fileStreamMutex.release();

			return;
		}

		__output.writeFloat(value);
		__file.__fileStatsDirty = true;
		__positionDirty = true;
	}

	/**
	 * Writes a 32-bit signed integer.
	 *
	 * @param		value A byte value as a signed integer
	 * @event 		ioError  You cannot write to the file (for example, because the file is missing).
	 * This event is dispatched only for files that have been opened for asynchronous operations (by
	 * using the openAsync() method).
	 * @throws 		The file has not been opened; the file has been opened, but it was not opened
	 * with write capabilities; or for a file that has been opened for synchronous operations (by
	 * using the open() method), the file cannot be written (for example, because the file is missing).
	 */
	public function writeInt(value:Int):Void
	{
		__checkIfWritable();

		if (__isAsync)
		{
			__fileStreamMutex.acquire();
			__buffer.writeInt(value);
			isWriting = true;
			__fileStreamMutex.release();

			return;
		}

		__output.writeInt32(value);
		__file.__fileStatsDirty = true;
		__positionDirty = true;
	}

	/**
	 * Writes a multibyte string to the file stream, byte stream, or byte array, using the specified
	 * character set.
	 *
	 * @param		value The string value to be written.
	 * @param		charSet The string denoting the character set to use. Possible character set strings
	 * include "shift-jis", "cn-gb", "iso-8859-1", and others
	 * @event 		ioError  You cannot write to the file (for example, because the file is missing).
	 * This event is dispatched only for files that have been opened for asynchronous operations (by
	 * using the openAsync() method).
	 * @throws 		The file has not been opened; the file has been opened, but it was not opened
	 * with write capabilities; or for a file that has been opened for synchronous operations (by
	 * using the open() method), the file cannot be written (for example, because the file is missing).
	 */
	public function writeMultiByte(value:String, charSet:String):Void
	{
		__checkIfWritable();

		if (__isAsync)
		{
			__fileStreamMutex.acquire();
			__buffer.writeMultiByte(value, charSet);
			isWriting = true;
			__fileStreamMutex.release();

			return;
		}

		writeUTFBytes(value);
		__file.__fileStatsDirty = true;
		__positionDirty = true;
	}

	/**
	 * Writes an object to the file stream, byte stream, or byte array, in AMF, HXSF, or JSON serialized
	 * format. The format library from haxelib is required to enable AMF on non-AIR targets.
	 *
	 * @param		object The object to be serialized.
	 * @event 		ioError  You cannot write to the file (for example, because the file is missing).
	 * This event is dispatched only for files that have been opened for asynchronous operations (by
	 * using the openAsync() method).
	 * @throws 		The file has not been opened; the file has been opened, but it was not opened
	 * with write capabilities; or for a file that has been opened for synchronous operations (by
	 * using the open() method), the file cannot be written (for example, because the file is missing).
	 */
	public function writeObject(object:Dynamic):Void
	{
		__checkIfWritable();

		if (__isAsync)
		{
			__fileStreamMutex.acquire();
			__buffer.writeObject(object);
			isWriting = true;
			__fileStreamMutex.release();

			return;
		}

		__writeObject(object);
		__file.__fileStatsDirty = true;
		__positionDirty = true;
	}

	/**
	 * Writes a 16-bit integer. The low 16 bits of the parameter are used; the high 16 bits are ignored.
	 *
	 * @param		value  A byte value as an integer.
	 * @event 		ioError  You cannot write to the file (for example, because the file is missing).
	 * This event is dispatched only for files that have been opened for asynchronous operations (by
	 * using the openAsync() method).
	 * @throws 		The file has not been opened; the file has been opened, but it was not opened
	 * with write capabilities; or for a file that has been opened for synchronous operations (by
	 * using the open() method), the file cannot be written (for example, because the file is missing).
	 */
	public function writeShort(value:Int):Void
	{
		__checkIfWritable();

		if (__isAsync)
		{
			__fileStreamMutex.acquire();
			__buffer.writeShort(value);
			isWriting = true;
			__fileStreamMutex.release();

			return;
		}

		__output.writeInt16(value);
		__file.__fileStatsDirty = true;
		__positionDirty = true;
	}

	/**
	 * Writes a 32-bit unsigned integer.
	 *
	 * @param		value A byte value as an unsigned integer.
	 * @event 		ioError  You cannot write to the file (for example, because the file is missing).
	 * This event is dispatched only for files that have been opened for asynchronous operations (by
	 * using the openAsync() method).
	 * @throws 		The file has not been opened; the file has been opened, but it was not opened
	 * with write capabilities; or for a file that has been opened for synchronous operations (by
	 * using the open() method), the file cannot be written (for example, because the file is missing).
	 */
	public function writeUnsignedInt(value:UInt):Void
	{
		__checkIfWritable();

		if (__isAsync)
		{
			__fileStreamMutex.acquire();
			__buffer.writeUnsignedInt(value);
			isWriting = true;
			__fileStreamMutex.release();

			return;
		}

		__output.writeInt32(value);
		__file.__fileStatsDirty = true;
		__positionDirty = true;
	}

	/**
	 * Writes a UTF-8 string to the file stream, byte stream, or byte array. The length of
	 * the UTF-8 string in bytes is written first, as a 16-bit integer, followed by the bytes
	 * representing the characters of the string.
	 * @param		value The string value to be written.
	 * @event 		ioError  You cannot write to the file (for example, because the file is missing).
	 * This event is dispatched only for files that have been opened for asynchronous operations (by
	 * using the openAsync() method).
	 * @throws 		RangeError — If the length of the string is larger than 65535.
	 * @throws 		The file has not been opened; the file has been opened, but it was not opened
	 * with write capabilities; or for a file that has been opened for synchronous operations (by
	 * using the open() method), the file cannot be written (for example, because the file is missing).
	 */
	public function writeUTF(value:String):Void
	{
		__checkIfWritable();

		if (__isAsync)
		{
			__fileStreamMutex.acquire();
			__buffer.writeUTF(value);
			isWriting = true;
			__fileStreamMutex.release();

			return;
		}

		__output.writeInt16(value.length);
		__output.writeString(value);
		__file.__fileStatsDirty = true;
		__positionDirty = true;
	}

	/**
	 * Writes a UTF-8 string. Similar to writeUTF(), but does not prefix the string with a 16-bit length
	 * integer.
	 *
	 * @param		value The string value to be written.
	 * @event 		ioError  You cannot write to the file (for example, because the file is missing).
	 * This event is dispatched only for files that have been opened for asynchronous operations (by
	 * using the openAsync() method).
	 * @throws 		The file has not been opened; the file has been opened, but it was not opened
	 * with write capabilities; or for a file that has been opened for synchronous operations (by
	 * using the open() method), the file cannot be written (for example, because the file is missing).
	 */
	public function writeUTFBytes(value:String):Void
	{
		__checkIfWritable();

		if (__isAsync)
		{
			__fileStreamMutex.acquire();
			__buffer.writeUTFBytes(value);
			isWriting = true;
			__fileStreamMutex.release();

			return;
		}

		__output.writeString(value);
		__file.__fileStatsDirty = true;
		__positionDirty = true;
	}

	@:noCompletion private function __checkIfOpen():Void
	{
		if (!__isOpen)
		{
			throw new Error("This FileStream object does not have a stream opened.", 2092);
		}
	}

	@:noCompletion private function __checkIfReadable():Void
	{
		__checkIfOpen();

		if (__isWrite)
		{
			throw new Error("This FileStream object does not have a input stream opened.", 2092);
		}
	}

	@:noCompletion private function __checkIfWritable():Void
	{
		__checkIfOpen();

		if (!__isWrite)
		{
			throw new Error("This FileStream object does not have a output stream opened.", 2092);
		}
	}

	@:noCompletion private function __getStreamBytesAvailable():Int
	{
		if (__isWrite)
		{
			var pos:Int = position;

			if (__isAsync)
			{
				__fileStreamMutex.acquire();
				pos = __output.tell();
			}

			__output.seek(0, FileSeek.SeekEnd);
			var length = __output.tell();
			__output.seek(pos, FileSeek.SeekBegin);

			if (__isAsync)
			{
				__fileStreamMutex.release();
			}

			return length - pos;
		}

		var pos:Int = position;

		if (__isAsync)
		{
			__fileStreamMutex.acquire();
			pos = __input.tell();
		}

		__input.seek(0, FileSeek.SeekEnd);
		var length = __input.tell();
		__input.seek(pos, FileSeek.SeekBegin);

		if (__isAsync)
		{
			__fileStreamMutex.release();
		}

		return length - pos;
	}

	@:noCompletion private function __openFile():Void
	{
		if (__isOpen)
		{
			if (__fileStreamWorker != null)
			{
				// when opening a new file, if an existing file is already open,
				// we should not dispatch Event.CLOSE, so dispose the worker
				// right away
				__disposeFileStreamWorker();
			}
			close();
		}

		__isOpen = true;

		switch (__fileMode)
		{
			case READ:
				try
				{
					__input = HaxeFile.read(__file.nativePath, true);
					__input.seek(0, FileSeek.SeekBegin);
					__isWrite = false;
				}
				catch (e:Dynamic)
				{
					throw new IOError("Invalid parameters.");
				}
			case WRITE:
				try
				{
					var dirPath:String = Path.directory(__file.nativePath);
					if (!FileSystem.exists(dirPath)) FileSystem.createDirectory(dirPath);
					__output = HaxeFile.write(__file.nativePath, true);
					__isWrite = true;
				}
				catch (e:Dynamic)
				{
					throw new IOError("Invalid parameters.");
				}
			case APPEND:
				try
				{
					__output = HaxeFile.append(__file.nativePath, true);
					__isWrite = true;
				}
				catch (d:Dynamic)
				{
					throw new openfl.errors.IOError("Invalid parameters.");
				}
			case UPDATE:
				try
				{
					__output = HaxeFile.update(__file.nativePath, true);
					__output.seek(0, sys.io.FileSeek.SeekBegin);
					__isWrite = true;
				}
				catch (d:Dynamic)
				{
					throw new openfl.errors.IOError("Invalid parameters.");
				}
		}

		if (__isWrite)
		{
			__output.bigEndian = true;
		}
		else
		{
			__input.bigEndian = true;
		}
	}

	@:noCompletion private function __writeObject(object:Dynamic):Void
	{
		switch (objectEncoding)
		{
			#if format
			case AMF0:
				var value = AMFTools.encode(object);
				var output:BytesOutput = new BytesOutput();
				var writer = new AMFWriter(output);
				writer.write(value);
				var bytes:Bytes = output.getBytes();
				__output.writeBytes(bytes, 0, bytes.length);

			case AMF3:
				var value = AMF3Tools.encode(object);
				var output = new BytesOutput();
				var writer = new AMF3Writer(output);
				writer.write(value);
				var bytes:Bytes = output.getBytes();
				__output.writeBytes(bytes, 0, bytes.length);
			#end

			case HXSF:
				var value = Serializer.run(object);
				writeUTF(value);

			case JSON:
				var value = Json.stringify(object);
				writeUTF(value);

			default:
				return;
		}
	}

	@:noCompletion private function get_endian():Endian
	{
		if (__isWrite)
		{
			return __output.bigEndian ? BIG_ENDIAN : LITTLE_ENDIAN;
		}

		return __input.bigEndian ? BIG_ENDIAN : LITTLE_ENDIAN;
	}

	@:noCompletion private function set_endian(value:Endian):Endian
	{
		if (__isWrite)
		{
			__output.bigEndian = value == BIG_ENDIAN ? true : false;
			return value;
		}

		__input.bigEndian = value == BIG_ENDIAN ? true : false;
		return value;
	}

	@:noCompletion private function get_bytesAvailable():Int
	{
		if (__isOpen)
		{
			if (!__isAsync)
			{
				return __getStreamBytesAvailable();
			}

			if (__fileMode == READ)
			{
				__fileStreamMutex.acquire();
				var result = 0;
				if (__buffer != null)
				{
					result = __buffer.bytesAvailable;
				}
				__fileStreamMutex.release();
				return result;
			}
		}

		return 0;
	}

	@:noCompletion private function get_position():UInt
	{
		if (__positionDirty)
		{
			if (!__isAsync)
			{
				__positionDirty = false;
				if (__isWrite)
				{
					return position = __output.tell();
				}

				return position = __input.tell();
			}
			if (__fileMode == READ)
			{
				__fileStreamMutex.acquire();
				position = __buffer.position;
				__fileStreamMutex.release();
				return position;
			}
		}
		return position;
	}

	@:noCompletion private function set_position(value:UInt):UInt
	{
		if (__isOpen)
		{
			if (!__isAsync)
			{
				if (__isWrite)
				{
					__output.seek(value, FileSeek.SeekBegin);
				}
				else
				{
					__input.seek(value, FileSeek.SeekBegin);
				}
			}
			else
			{
				__fileStreamMutex.acquire();
				__buffer.position = value;
				__fileStreamMutex.release();
			}
		}

		return position = value;
	}
}
#else
#if air
typedef FileStream = flash.filesystem.FileStream;
#end
#end
