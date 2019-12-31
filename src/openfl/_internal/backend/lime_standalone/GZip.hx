package openfl._internal.backend.lime_standalone; #if openfl_html5

import haxe.io.Bytes;

class GZip
{
	public static function compress(bytes:Bytes):Bytes
	{
		#if commonjs
		var data = untyped __js__("require (\"pako\").gzip")(bytes.getData());
		#else
		var data = untyped __js__("pako.gzip")(bytes.getData());
		#end
		return Bytes.ofData(data);
	}

	public static function decompress(bytes:Bytes):Bytes
	{
		#if commonjs
		var data = untyped __js__("require (\"pako\").ungzip")(bytes.getData());
		#else
		var data = untyped __js__("pako.ungzip")(bytes.getData());
		#end
		return Bytes.ofData(data);
	}
}
#end
