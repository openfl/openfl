package openfl._internal.backend.lime_standalone;

import haxe.crypto.Base64 as HaxeBase64;
import haxe.io.Bytes;

class Base64
{
	private static var DICTIONARY:Array<String> = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/".split("");
	private static var EXTENDED_DICTIONARY:Array<String> =
		{
			var result = new Array<String>();
			for (a in DICTIONARY)
			{
				for (b in DICTIONARY)
				{
					result.push(a + b);
				}
			}
			result;
		};

	public static function decode(source:String):Bytes
	{
		return HaxeBase64.decode(source);
	}

	public static function encode(source:Bytes):String
	{
		var result = new Array<String>();

		var dictionary = DICTIONARY;
		var extendedDictionary = EXTENDED_DICTIONARY;

		var numBytes = source.length;
		var numInputTriplets = Math.floor(numBytes / 3);
		var numChunksToWrite = numInputTriplets * 2;

		#if cpp
		cpp.NativeArray.setSize(result, Math.ceil(numBytes / 3) * 2);
		#elseif js
		untyped (result).length = Math.ceil(numBytes / 3) * 2;
		#end

		var numBytesRead = 0;
		var numChunksWritten = 0;
		var inputTriplet;

		while (numChunksWritten < numChunksToWrite)
		{
			inputTriplet = (source.get(numBytesRead) << 16) | (source.get(numBytesRead + 1) << 8) | source.get(numBytesRead + 2);
			result[numChunksWritten] = extendedDictionary[(inputTriplet >> 12) & 0xfff];
			result[numChunksWritten + 1] = extendedDictionary[(inputTriplet) & 0xfff];

			numBytesRead += 3;
			numChunksWritten += 2;
		}

		switch (numBytes - numInputTriplets * 3)
		{
			case 1:
				inputTriplet = (source.get(numBytesRead) << 16);
				result[numChunksWritten] = extendedDictionary[(inputTriplet >> 12) & 0xfff];
				result[numChunksWritten + 1] = "==";
			case 2:
				inputTriplet = (source.get(numBytesRead) << 16) | (source.get(numBytesRead + 1) << 8);
				result[numChunksWritten] = extendedDictionary[(inputTriplet >> 12) & 0xfff];
				result[numChunksWritten + 1] = dictionary[(inputTriplet >> 6) & 0x3f] + "=";
			case _:
		}

		return result.join("");
	}
}
