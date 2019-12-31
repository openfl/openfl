package openfl._internal.backend.lime_standalone; #if openfl_html5

import haxe.io.Bytes;

class Zlib
{
	public static function compress(bytes:Bytes):Bytes
	{
		#if commonjs
		var data = untyped __js__("require (\"pako\").deflate")(bytes.getData());
		#else
		var data = untyped __js__("pako.deflate")(bytes.getData());
		#end
		return Bytes.ofData(data);
	}

	public static function decompress(bytes:Bytes):Bytes
	{
		#if commonjs
		var data = untyped __js__("require (\"pako\").inflate")(bytes.getData());
		#else
		var data = untyped __js__("pako.inflate")(bytes.getData());
		#end
		return Bytes.ofData(data);
	}
}
#end
