package format.swf.data.consts;

class SoundCompression
{
	public static inline var UNCOMPRESSED_NATIVE_ENDIAN:Int = 0;
	public static inline var ADPCM:Int = 1;
	public static inline var MP3:Int = 2;
	public static inline var UNCOMPRESSED_LITTLE_ENDIAN:Int = 3;
	public static inline var NELLYMOSER_16_KHZ:Int = 4;
	public static inline var NELLYMOSER_8_KHZ:Int = 5;
	public static inline var NELLYMOSER:Int = 6;
	public static inline var SPEEX:Int = 11;
	
	public static function toString(soundCompression:Int):String {
		switch(soundCompression) {
			case UNCOMPRESSED_NATIVE_ENDIAN: return "Uncompressed Native Endian";
			case ADPCM: return "ADPCM";
			case MP3: return "MP3";
			case UNCOMPRESSED_LITTLE_ENDIAN: return "Uncompressed Little Endian";
			case NELLYMOSER_16_KHZ: return "Nellymoser 16kHz";
			case NELLYMOSER_8_KHZ: return "Nellymoser 8kHz";
			case NELLYMOSER: return "Nellymoser";
			case SPEEX: return "Speex";
			default: return "unknown";
		}
	}
}