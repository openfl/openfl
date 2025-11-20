package openfl.net._internal;

import cpp.Pointer;
import haxe.io.Bytes;
import haxe.io.BytesData;
import openfl.net._internal.win.HANDLE;
import cpp.RawPointer;
import cpp.UInt8;

@:include('./NativeLocalConnection.cpp')
extern class NativeLocalConnection
{
	@:native('native_createInboundPipe') private static function __createInboundPipe(name:String):HANDLE;
	@:native('native_accept') private static function __accept(pipe:HANDLE):Bool;
	@:native('native_isOpen') private static function __isOpen(pipe:HANDLE):Bool;
	@:native('native_getBytesAvailable') private static function __getBytesAvailable(pipe:HANDLE):Int;
	@:native('native_read') private static function __read(pipe:HANDLE, buffer:Pointer<UInt8>, size:Int):Int;
	@:native('native_write') private static function __write(pipe:HANDLE, data:Pointer<UInt8>, size:Int):Bool;
	@:native('native_connect') private static function __connect(name:String):HANDLE;
	@:native('native_close') private static function __close(pipe:HANDLE):Void;
}
