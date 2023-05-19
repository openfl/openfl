package openfl.desktop;

#if (haxe4 && sys && !flash)
import haxe.Json;
import haxe.Serializer;
import haxe.io.Bytes;
import haxe.io.Eof;
import haxe.io.Output;
import openfl.errors.Error;
import openfl.errors.IOError;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.IEventDispatcher;
import openfl.events.IOErrorEvent;
import openfl.events.NativeProcessExitEvent;
import openfl.events.ProgressEvent;
import openfl.net.ObjectEncoding;
import openfl.utils.ByteArray;
import openfl.utils.Endian;
import openfl.utils.IDataInput;
import openfl.utils.IDataOutput;
import sys.io.Process;
import sys.thread.Mutex;
import sys.thread.Thread;
#if format
import format.amf.Reader as AMFReader;
import format.amf.Tools as AMFTools;
import format.amf.Writer as AMFWriter;
import format.amf3.Reader as AMF3Reader;
import format.amf3.Tools as AMF3Tools;
import format.amf3.Writer as AMF3Writer;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
#end

/**
	The NativeProcess class provides command line integration and general
	launching capabilities. The NativeProcess class lets an AIR application
	execute native processes on the host operating system. The AIR applcation
	can monitor the standard input (stdin) and standard output (stdout) stream
	of the process as well as the process's standard error (stderr) stream.

	The NativeProcess class and its capabilities are only available to Haxe
	"sys" targets and AIR applications installed with a native installer
	(extended desktop profile applications). When debugging an AIR application,
	you can pass the `-profile extendedDesktop` argument to ADL to enable the
	NativeProcess functionality. At runtime, you can check the
	`NativeProcess.isSupported` property to to determine whether native process
	communication is supported.
**/
@:access(openfl.utils.ByteArrayData)
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class NativeProcess extends EventDispatcher
{
	/**
		ndicates if running native processes is supported in the current
		profile. This property returns `true` only when running on Haxe "sys"
		targets or the Adobe AIR extendedDesktop profile. In addition,
		`NativeProcess.isSupported` is always `false` for applications installed
		as an `.air` file. You must package an AIR application using the ADT
		`-target native` flag in order to use the NativeProcess class in AIR.
	**/
	public static var isSupported(default, never):Bool = true;

	/**
		Constructs an uninitialized NativeProcess object. Call the `start()`
		method to start the process.
	**/
	public function new()
	{
		super();
		__standardInput = new OutboundPipe();
		__standardOutput = new InboundPipe();
		__standardError = new InboundPipe();
	}

	@:noCompletion private var __process:Process;
	@:noCompletion private var __processKilled:Bool;

	/**
		Indicates if this native process is currently running. The process is
		running if you have called the `start()` method and the NativeProcess
		object has not yet dispatched an `exit` event. A NativeProcess instance
		corresponds to a single process on the underlying operating system. This
		property remains `true` as long as the underlying operating system
		process is executing (while the native process is starting and until the
		process returns an exit code to the operating system.)
	**/
	public var running(get, never):Bool;

	@:noCompletion private function get_running():Bool
	{
		return __process != null;
	}

	@:noCompletion private var __standardError:InboundPipe;

	/**
		Provides access to the standard error output from this native process.
		As data becomes available on this pipe, the NativeProcess object
		dispatches a ProgressEvent object. If you attempt to read data from this
		stream when no data is available, the NativeProcess object throw an
		EOFError exception.

		The type is IDataInput because data is input from the perspective of the
		current process, even though it is an output stream of the child
		process.
	**/
	public var standardError(get, never):IDataInput;

	@:noCompletion private function get_standardError():IDataInput
	{
		return __standardError;
	}

	@:noCompletion private var __standardOutput:InboundPipe;

	/**
		Provides access to the standard error output from this native process.
		As data becomes available on this pipe, the NativeProcess object
		dispatches a ProgressEvent object. If you attempt to read data from this
		stream when no data is available, the NativeProcess object throw an
		EOFError exception.

		The type is IDataInput because data is input from the perspective of the
		current process, even though it is an output stream of the child
		process.
	**/
	public var standardOutput(get, never):IDataInput;

	@:noCompletion private function get_standardOutput():IDataInput
	{
		return __standardOutput;
	}

	@:noCompletion private var __standardInput:OutboundPipe;

	/**
		Provides access to the standard input of this native process. Use this
		pipe to send data to this process. Each time data is written to the
		input property that data is written to the native process's input pipe
		as soon as possible.

		The type is IDataOutput because data is output from the perspective of
		the current process, even though it is an input stream of the child
		process.
	**/
	public var standardInput(get, never):IDataOutput;

	@:noCompletion private function get_standardInput():IDataOutput
	{
		return __standardInput;
	}

	/**
		Closes the input stream on this process. Some command line applications
		wait until the input stream is closed to start some operations. Once the
		stream is closed it cannot be re-opened until the process exits and is
		started again.
	**/
	public function closeInput():Void
	{
		if (__process == null || __processKilled)
		{
			// no error or anything. simply return.
			return;
		}
		__process.stdin.close();
	}

	/**
		Attempts to exit the native process.
	**/
	public function exit(force:Bool = false):Void
	{
		if (__process == null || __processKilled)
		{
			// no error or anything. simply return.
			return;
		}
		__processKilled = true;
		__process.kill();
	}

	/**
		Starts the native process identified by the start up info specified.
		Once the process starts, all of the input and output streams will be
		opened. This method returns immediately after the request to start the
		specified process has been made to the operating system. The
		NativeProcess object throws an `IllegalOperationError` exception if the
		process is currently running. The process is running if the `running`
		property of the NativeProcess object returns `true`. If the operating
		system is unable to start the process, an `Error` is thrown.

		A NativeProcess instance corresponds to a single process on the
		underlying operating system. If you want to execute more than one
		instance of the same operating system process concurrently, you can
		create one NativeProcess instance per child process.

		You can call this method whenever the running property of the
		NativeProcess object returns `false`. This means that the NativeProcess
		object can be reused. In other words you can construct a NativeProcess
		instance, call the `start()` method, wait for the `exit` event, and then
		call the `start()` method again. You may use a different
		NativeProcessStartupInfo object as the `info` parameter value in the
		subsequent call to the `start()` method.

		The NativeProcess class and its capabilities are only available to Haxe
		"sys" targets and AIR applications installed with a native installer.
		When debugging AIR, you can pass the `-profile extendedDesktop` argument
		to ADL to enable the NativeProcess functionality. Check the
		`NativeProcess.isSupported` property to to determine whether native
		process communication is supported.

		**Important security considerations:**

		The native process API can run any executable on the user's system. Take
		extreme care when constructing and executing commands. If any part of a
		command to be executed originates from an external source, carefully
		validate that the command is safe to execute. Likewise, your OpenFL
		application should validate data passed to a running process.

		However, validating input can be difficult. To avoid such difficulties,
		it is best to write a native application (such as an EXE file on
		Windows) that has specific APIs. These APIs should process only those
		commands specifically required by the OpenFL application. For example,
		the native application may accept only a limited set of instructions via
		the standard input stream.

		AIR on Windows does not allow you to run .bat files directly. Windows
		.bat files are executed by the command interpreter application
		(cmd.exe). When you invoke a .bat file, this command application can
		interpret arguments passed to the command as additional applications to
		launch. A malicious injection of extra characters in the argument string
		could cause cmd.exe to execute a harmful or insecure application. For
		example, without proper data validation, your AIR application may call
		`myBat.bat myArguments c:/evil.exe`. The command application would
		launch the evil.exe application in addition to running your batch file.

		If you call the `start()` method with a .bat file, the NativeProcess
		object throws an exception. The message property of the Error object
		contains the string "Error #3219: The NativeProcess could not be
		started."
	**/
	public function start(info:NativeProcessStartupInfo):Void
	{
		var cmd = info.executable.nativePath;
		var args:Array<String> = [];
		var vectorArgs = info.arguments;
		if (vectorArgs != null)
		{
			for (i in 0...vectorArgs.length)
			{
				args.push(vectorArgs[i]);
			}
		}
		var cwdToRestore:String = null;
		var workingDirectory = info.workingDirectory;
		if (workingDirectory != null)
		{
			cwdToRestore = Sys.getCwd();
			Sys.setCwd(info.workingDirectory.nativePath);
		}
		__processKilled = false;
		__process = new Process(cmd, args, false);
		var standardOutputMutex = new Mutex();
		__standardOutput.mutex = standardOutputMutex;
		__standardOutput.input = new ByteArray();
		var standardErrorMutex = new Mutex();
		__standardError.mutex = standardErrorMutex;
		__standardError.input = new ByteArray();
		__standardInput.output = __process.stdin;
		if (cwdToRestore != null)
		{
			Sys.setCwd(cwdToRestore);
		}

		var pendingStdoutBytes:Int = 0;
		var pendingStderrBytes:Int = 0;
		var pendingStdoutIOError:IOError = null;
		var pendingStderrIOError:IOError = null;
		var pendingExitCode:Null<Float> = null;
		var pendingExitCodeMutex = new Mutex();
		function onEnterFrame(event:Event):Void
		{
			standardOutputMutex.acquire();
			if (pendingStdoutBytes > 0)
			{
				dispatchEvent(new ProgressEvent(ProgressEvent.STANDARD_OUTPUT_DATA, false, false, pendingStdoutBytes));
				pendingStdoutBytes = 0;
			}
			standardOutputMutex.release();

			standardErrorMutex.acquire();
			if (pendingStderrBytes > 0)
			{
				dispatchEvent(new ProgressEvent(ProgressEvent.STANDARD_ERROR_DATA, false, false, pendingStderrBytes));
				pendingStderrBytes = 0;
			}
			standardErrorMutex.release();

			standardOutputMutex.acquire();
			if (pendingStdoutIOError != null)
			{
				var ioError = pendingStdoutIOError;
				pendingStdoutIOError = null;
				dispatchEvent(new IOErrorEvent(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, false, false, ioError.message, ioError.errorID));
			}
			standardOutputMutex.release();

			standardErrorMutex.acquire();
			if (pendingStderrIOError != null)
			{
				var ioError = pendingStderrIOError;
				pendingStderrIOError = null;
				dispatchEvent(new IOErrorEvent(IOErrorEvent.STANDARD_ERROR_IO_ERROR, false, false, ioError.message, ioError.errorID));
			}
			standardErrorMutex.release();

			pendingExitCodeMutex.acquire();
			if (pendingExitCode != null)
			{
				cast(event.currentTarget, IEventDispatcher).removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				dispatchEvent(new NativeProcessExitEvent(NativeProcessExitEvent.EXIT, false, false, pendingExitCode));
			}
			pendingExitCodeMutex.release();
		}
		Lib.current.addEventListener(Event.ENTER_FRAME, onEnterFrame);

		function stdoutProgress(bytes:Bytes, length:Int):Void
		{
			standardOutputMutex.acquire();
			var newStandardOutput = new ByteArray();
			newStandardOutput.writeBytes(__standardOutput.input, __standardOutput.input.position);
			newStandardOutput.writeBytes(bytes, 0, length);
			newStandardOutput.position = 0;
			__standardOutput.input = newStandardOutput;
			pendingStdoutBytes += length;
			standardOutputMutex.release();
		}

		function stderrProgress(bytes:Bytes, length:Int):Void
		{
			standardErrorMutex.acquire();
			var newStandardError = new ByteArray();
			newStandardError.writeBytes(__standardError.input, __standardError.input.position);
			newStandardError.writeBytes(bytes, 0, length);
			newStandardError.position = 0;
			__standardError.input = newStandardError;
			pendingStderrBytes += length;
			standardErrorMutex.release();
		}

		var stdoutDone = false;
		var stderrDone = false;
		function createStderrThread():Void
		{
			Thread.create(function():Void
			{
				while (true)
				{
					if (__processKilled)
					{
						break;
					}
					try
					{
						var bytes = Bytes.alloc(32768);
						var length = __process.stderr.readBytes(bytes, 0, bytes.length);
						stderrProgress(bytes, length);
					}
					catch (e:Eof)
					{
						// this is normal when the process exits
						break;
					}
					catch (e:Dynamic)
					{
						standardErrorMutex.acquire();
						pendingStderrIOError = new IOError(Std.string(e));
						standardErrorMutex.release();
						break;
					}
					Sys.sleep(1);
				}
				standardErrorMutex.acquire();
				stderrDone = true;
				standardErrorMutex.release();
			});
		}
		function createStdoutThread():Void
		{
			Thread.create(function():Void
			{
				while (true)
				{
					if (__processKilled)
					{
						break;
					}
					try
					{
						var bytes = Bytes.alloc(32768);
						var length = __process.stdout.readBytes(bytes, 0, bytes.length);
						stdoutProgress(bytes, length);
					}
					catch (e:Eof)
					{
						// this is normal when the process exits
						break;
					}
					catch (e:Dynamic)
					{
						standardOutputMutex.acquire();
						pendingStdoutIOError = new IOError(Std.string(e));
						standardOutputMutex.release();
						break;
					}
					Sys.sleep(1);
				}
				standardOutputMutex.acquire();
				stdoutDone = true;
				standardOutputMutex.release();
				#if hl
				createStderrThread();
				#end
			});
		}
		function createExitThread():Void
		{
			Thread.create(function():Void
			{
				var done = false;
				while (!done)
				{
					Sys.sleep(1);
					standardOutputMutex.acquire();
					standardErrorMutex.acquire();
					done = stdoutDone && stderrDone;
					standardErrorMutex.release();
					standardOutputMutex.release();
				}
				var result = Math.NaN;
				try
				{
					result = __process.exitCode(true);
				}
				catch (e:Dynamic)
				{
					// may throw "process killed by signal 9"
				}
				__process.close();

				standardOutputMutex.acquire();
				__standardOutput.input = null;
				standardOutputMutex.release();

				standardErrorMutex.acquire();
				__standardError.input = null;
				standardErrorMutex.release();

				__standardInput.output = null;
				__process = null;

				pendingExitCodeMutex.acquire();
				pendingExitCode = result;
				pendingExitCodeMutex.release();
			});
		}
		createStdoutThread();
		#if !hl
		// for some reason, reading both stdout and stderr on HashLink causes
		// a freeze. as a workaround, we'll wait until stdout throws EOF before
		// we try to read stderr.
		createStderrThread();
		#end
		createExitThread();
	}
}

private class InboundPipe implements IDataInput
{
	public function new() {}

	public var mutex:Mutex;

	public var input:ByteArray;

	public var bytesAvailable(get, never):Int;

	private function get_bytesAvailable():Int
	{
		if (input == null)
		{
			throw new Error("Cannot perform operation on a NativeProcess that is not running.", 3212);
		}
		mutex.acquire();
		var result = input.bytesAvailable;
		mutex.release();
		return result;
	}

	public var endian(get, set):Endian;

	private function get_endian():Endian
	{
		if (input == null)
		{
			throw new Error("Cannot perform operation on a NativeProcess that is not running.", 3212);
		}
		mutex.acquire();
		var result = input.endian;
		mutex.release();
		return result;
	}

	private function set_endian(value:Endian):Endian
	{
		if (input == null)
		{
			throw new Error("Cannot perform operation on a NativeProcess that is not running.", 3212);
		}
		mutex.acquire();
		input.endian = value;
		mutex.release();
		return value;
	}

	public var objectEncoding:ObjectEncoding;

	public function readBoolean():Bool
	{
		if (input == null)
		{
			throw new Error("Cannot perform operation on a NativeProcess that is not running.", 3212);
		}
		mutex.acquire();
		var result = input.readBoolean();
		mutex.release();
		return result;
	}

	public function readFloat():Float
	{
		if (input == null)
		{
			throw new Error("Cannot perform operation on a NativeProcess that is not running.", 3212);
		}
		mutex.acquire();
		var result = input.readFloat();
		mutex.release();
		return result;
	}

	public function readDouble():Float
	{
		if (input == null)
		{
			throw new Error("Cannot perform operation on a NativeProcess that is not running.", 3212);
		}
		mutex.acquire();
		var result = input.readDouble();
		mutex.release();
		return result;
	}

	public function readByte():Int
	{
		if (input == null)
		{
			throw new Error("Cannot perform operation on a NativeProcess that is not running.", 3212);
		}
		mutex.acquire();
		var result = input.readByte();
		mutex.release();
		return result;
	}

	public function readUnsignedByte():UInt
	{
		if (input == null)
		{
			throw new Error("Cannot perform operation on a NativeProcess that is not running.", 3212);
		}
		mutex.acquire();
		var result = input.readUnsignedByte();
		mutex.release();
		return result;
	}

	public function readShort():Int
	{
		if (input == null)
		{
			throw new Error("Cannot perform operation on a NativeProcess that is not running.", 3212);
		}
		mutex.acquire();
		var result = input.readShort();
		mutex.release();
		return result;
	}

	public function readUnsignedShort():UInt
	{
		if (input == null)
		{
			throw new Error("Cannot perform operation on a NativeProcess that is not running.", 3212);
		}
		mutex.acquire();
		var result = input.readUnsignedShort();
		mutex.release();
		return result;
	}

	public function readInt():Int
	{
		if (input == null)
		{
			throw new Error("Cannot perform operation on a NativeProcess that is not running.", 3212);
		}
		mutex.acquire();
		var result = input.readInt();
		mutex.release();
		return result;
	}

	public function readUnsignedInt():UInt
	{
		if (input == null)
		{
			throw new Error("Cannot perform operation on a NativeProcess that is not running.", 3212);
		}
		mutex.acquire();
		var result = input.readUnsignedInt();
		mutex.release();
		return result;
	}

	public function readBytes(bytes:ByteArray, offset:Int = 0, length:Int = 0):Void
	{
		if (input == null)
		{
			throw new Error("Cannot perform operation on a NativeProcess that is not running.", 3212);
		}
		mutex.acquire();
		input.readBytes(bytes, offset, length);
		mutex.release();
	}

	public function readUTF():String
	{
		if (input == null)
		{
			throw new Error("Cannot perform operation on a NativeProcess that is not running.", 3212);
		}
		mutex.acquire();
		var result = input.readUTF();
		mutex.release();
		return result;
	}

	public function readUTFBytes(length:Int):String
	{
		if (input == null)
		{
			throw new Error("Cannot perform operation on a NativeProcess that is not running.", 3212);
		}
		mutex.acquire();
		var result = input.readUTFBytes(length);
		mutex.release();
		return result;
	}

	public function readMultiByte(length:Int, charSet:String):String
	{
		if (input == null)
		{
			throw new Error("Cannot perform operation on a NativeProcess that is not running.", 3212);
		}
		mutex.acquire();
		var result = input.readMultiByte(length, charSet);
		mutex.release();
		return result;
	}

	public function readObject():Dynamic
	{
		if (input == null)
		{
			throw new Error("Cannot perform operation on a NativeProcess that is not running.", 3212);
		}
		mutex.acquire();
		var result = input.readObject();
		mutex.release();
		return result;
	}
}

private class OutboundPipe implements IDataOutput
{
	public function new() {}

	public var output:Output;

	public var endian(get, set):Endian;

	private function get_endian():Endian
	{
		if (output == null)
		{
			throw new Error("Cannot perform operation on a NativeProcess that is not running.", 3212);
		}
		return output.bigEndian ? BIG_ENDIAN : LITTLE_ENDIAN;
	}

	private function set_endian(value:Endian):Endian
	{
		if (output == null)
		{
			throw new Error("Cannot perform operation on a NativeProcess that is not running.", 3212);
		}
		output.bigEndian = value == BIG_ENDIAN;
		return value;
	}

	public var objectEncoding:ObjectEncoding;

	public function writeBoolean(value:Bool):Void
	{
		if (output == null)
		{
			throw new Error("Cannot perform operation on a NativeProcess that is not running.", 3212);
		}
		output.writeByte(1);
	}

	public function writeByte(value:Int):Void
	{
		if (output == null)
		{
			throw new Error("Cannot perform operation on a NativeProcess that is not running.", 3212);
		}
		output.writeByte(value);
	}

	public function writeDouble(value:Float):Void
	{
		if (output == null)
		{
			throw new Error("Cannot perform operation on a NativeProcess that is not running.", 3212);
		}
		output.writeDouble(value);
	}

	public function writeFloat(value:Float):Void
	{
		if (output == null)
		{
			throw new Error("Cannot perform operation on a NativeProcess that is not running.", 3212);
		}
		output.writeFloat(value);
	}

	public function writeInt(value:Int):Void
	{
		if (output == null)
		{
			throw new Error("Cannot perform operation on a NativeProcess that is not running.", 3212);
		}
		output.writeInt32(value);
	}

	public function writeShort(value:Int):Void
	{
		if (output == null)
		{
			throw new Error("Cannot perform operation on a NativeProcess that is not running.", 3212);
		}
		output.writeInt16(value);
	}

	public function writeUnsignedInt(value:UInt):Void
	{
		if (output == null)
		{
			throw new Error("Cannot perform operation on a NativeProcess that is not running.", 3212);
		}
		output.writeInt32(value);
	}

	public function writeBytes(bytes:ByteArray, offset:Int = 0, length:Int = 0):Void
	{
		if (output == null)
		{
			throw new Error("Cannot perform operation on a NativeProcess that is not running.", 3212);
		}
		output.writeBytes(bytes, offset, length);
	}

	public function writeUTF(value:String):Void
	{
		if (output == null)
		{
			throw new Error("Cannot perform operation on a NativeProcess that is not running.", 3212);
		}
		output.writeInt16(value.length);
		output.writeString(value);
	}

	public function writeUTFBytes(value:String):Void
	{
		if (output == null)
		{
			throw new Error("Cannot perform operation on a NativeProcess that is not running.", 3212);
		}
		output.writeString(value);
	}

	public function writeMultiByte(value:String, charSet:String):Void
	{
		writeUTFBytes(value);
	}

	public function writeObject(object:Dynamic):Void
	{
		if (output == null)
		{
			throw new Error("Cannot perform operation on a NativeProcess that is not running.", 3212);
		}
		switch (objectEncoding)
		{
			#if format
			case AMF0:
				var value = AMFTools.encode(object);
				var output:BytesOutput = new BytesOutput();
				var writer = new AMFWriter(output);
				writer.write(value);
				var bytes:Bytes = output.getBytes();
				output.writeBytes(bytes, 0, bytes.length);

			case AMF3:
				var value = AMF3Tools.encode(object);
				var output = new BytesOutput();
				var writer = new AMF3Writer(output);
				writer.write(value);
				var bytes:Bytes = output.getBytes();
				output.writeBytes(bytes, 0, bytes.length);
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
}
#elseif flash
#if air
typedef NativeProcess = flash.desktop.NativeProcess;
#end
#end
