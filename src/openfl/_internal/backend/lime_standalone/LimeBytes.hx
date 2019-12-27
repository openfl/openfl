package openfl._internal.backend.lime_standalone;

#if openfl_html5
import haxe.io.Bytes as HaxeBytes;
import haxe.io.BytesData;
import openfl.utils.CompressionAlgorithm;
import openfl.utils.Future;

@:access(haxe.io.Bytes)
@:forward()
abstract LimeBytes(HaxeBytes) from HaxeBytes to HaxeBytes
{
	public function new(length:Int, bytesData:BytesData)
	{
		this = new HaxeBytes(bytesData);
	}

	public static function alloc(length:Int):LimeBytes
	{
		return HaxeBytes.alloc(length);
	}

	public function compress(algorithm:CompressionAlgorithm):LimeBytes
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

	public function decompress(algorithm:CompressionAlgorithm):LimeBytes
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

	public static function fromBytes(bytes:haxe.io.Bytes):LimeBytes
	{
		if (bytes == null) return null;

		return new LimeBytes(bytes.length, bytes.getData());
	}

	public static function fromFile(path:String):LimeBytes
	{
		return null;
	}

	public static function loadFromBytes(bytes:haxe.io.Bytes):Future<LimeBytes>
	{
		return Future.withValue(fromBytes(bytes));
	}

	public static function loadFromFile(path:String):Future<LimeBytes>
	{
		var request = new HTTPRequest<LimeBytes>();
		return request.load(path);
	}

	public static function ofData(b:BytesData):LimeBytes
	{
		var bytes = HaxeBytes.ofData(b);
		return new LimeBytes(bytes.length, bytes.getData());
	}

	public static function ofString(s:String):LimeBytes
	{
		var bytes = HaxeBytes.ofString(s);
		return new LimeBytes(bytes.length, bytes.getData());
	}
}
#end
