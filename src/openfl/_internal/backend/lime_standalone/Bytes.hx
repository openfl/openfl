package openfl._internal.backend.lime_standalone; #if openfl_html5

import haxe.io.Bytes as HaxeBytes;
import haxe.io.BytesData;
import openfl.utils.CompressionAlgorithm;
import openfl.utils.Future;

@:access(haxe.io.Bytes)
@:forward()
abstract Bytes(HaxeBytes) from HaxeBytes to HaxeBytes
{
	public function new(length:Int, bytesData:BytesData)
	{
		this = new HaxeBytes(bytesData);
	}

	public static function alloc(length:Int):Bytes
	{
		return HaxeBytes.alloc(length);
	}

	public function compress(algorithm:CompressionAlgorithm):Bytes
	{
		switch (algorithm)
		{
			case DEFLATE:
				return Deflate.compress(this);

			// case GZIP:
			// 	return GZip.compress(this);

			case LZMA:
				return openfl._internal.backend.lime_standalone.LZMA.compress(this);

			case ZLIB:
				return openfl._internal.backend.lime_standalone.Zlib.compress(this);

			default:
				return null;
		}
	}

	public function decompress(algorithm:CompressionAlgorithm):Bytes
	{
		switch (algorithm)
		{
			case DEFLATE:
				return Deflate.decompress(this);

			// case GZIP:
			// 	return GZip.decompress(this);

			case LZMA:
				return openfl._internal.backend.lime_standalone.LZMA.decompress(this);

			case ZLIB:
				return openfl._internal.backend.lime_standalone.Zlib.decompress(this);

			default:
				return null;
		}
	}

	public static inline function fastGet(b:BytesData, pos:Int):Int
	{
		return HaxeBytes.fastGet(b, pos);
	}

	public static function fromBytes(bytes:haxe.io.Bytes):Bytes
	{
		if (bytes == null) return null;

		return new Bytes(bytes.length, bytes.getData());
	}

	public static function fromFile(path:String):Bytes
	{
		return null;
	}

	public static function loadFromBytes(bytes:haxe.io.Bytes):Future<Bytes>
	{
		return Future.withValue(fromBytes(bytes));
	}

	public static function loadFromFile(path:String):Future<Bytes>
	{
		var request = new HTTPRequest<Bytes>();
		return request.load(path);
	}

	public static function ofData(b:BytesData):Bytes
	{
		var bytes = HaxeBytes.ofData(b);
		return new Bytes(bytes.length, bytes.getData());
	}

	public static function ofString(s:String):Bytes
	{
		var bytes = HaxeBytes.ofString(s);
		return new Bytes(bytes.length, bytes.getData());
	}
}
#end
