package openfl.net;

#if (!flash && sys)

#if !openfljs
/**
	The IPVersion class defines constants representing the different families of
	IP addresses.
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract IPVersion(Null<Int>)

{
	/**
		An Internet Protocol version 4 (IPv4) address.

		IPv4 addresses are expressed in Haxe as a string in dot-decimal
		notation, such as: `"192.0.2.0"`.
	**/
	public var IPV4 = 0;

	/**
		IPv6 addresses are expressed in Haxe as a string in hexadecimal-colon
		notation and enclosed in brackets, such as:
		`"[2001:db8:ccc3:ffff:0:444d:555e:666f]"`.
	**/
	public var IPV6 = 1;

	@:from private static function fromString(value:String):IPVersion
	{
		return switch (value)
		{
			case "IPv4": IPV4;
			case "IPv6": IPV6;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : IPVersion)
		{
			case IPVersion.IPV4: "IPv4";
			case IPVersion.IPV6: "IPv6";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract IPVersion(String) from String to String

{
	public var IPV4 = "IPv4";
	public var IPV6 = "IPv6";
}
#end
#else
#if air
typedef IPVersion = flash.net.IPVersion;
#end
#end
