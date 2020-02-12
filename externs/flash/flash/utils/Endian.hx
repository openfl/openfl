package flash.utils;

#if flash
import lime.system.Endian in LimeEndian;

@:enum abstract Endian(String) from String to String
{
	public var BIG_ENDIAN = "bigEndian";
	public var LITTLE_ENDIAN = "littleEndian";

	@:from private static function fromLimeEndian(value:LimeEndian):Endian
	{
		return switch (value)
		{
			case LimeEndian.BIG_ENDIAN: BIG_ENDIAN;
			case LimeEndian.LITTLE_ENDIAN: LITTLE_ENDIAN;
			default: null;
		}
	}

	@:to private function toLimeEndian():LimeEndian
	{
		return switch (this)
		{
			case Endian.BIG_ENDIAN: LimeEndian.BIG_ENDIAN;
			case Endian.LITTLE_ENDIAN: LimeEndian.LITTLE_ENDIAN;
			default: null;
		}
	}
}
#else
typedef Endian = openfl.utils.Endian;
#end
