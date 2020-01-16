package openfl._internal.backend.lime_standalone; #if openfl_html5

import haxe.io.Bytes;

class Deflate
{
	public static function compress(bytes:Bytes):Bytes
	{
		#if commonjs
		var data = untyped __js__("require (\"pako\").deflateRaw")(bytes.getData());
		#else
		var data = untyped __js__("pako.deflateRaw")(bytes.getData());
		#end
		return Bytes.ofData(data);
	}

	public static function decompress(bytes:Bytes):Bytes
	{
		#if commonjs
		var data = untyped __js__("require (\"pako\").inflateRaw")(bytes.getData());
		#else
		var data = untyped __js__("pako.inflateRaw")(bytes.getData());
		#end
		return Bytes.ofData(data);
	}
}
#end
