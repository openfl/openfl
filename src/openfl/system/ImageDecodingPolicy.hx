package openfl.system;

#if (!flash && sys)

#if !openfljs
/**
	The ImageDecodingPolicy class provides values for `imageDecodingPolicy` in
	the LoaderContext class.
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract ImageDecodingPolicy(Null<Int>)

{
	/**
		Specifies that the image being loaded will be decoded when needed and
		that the decoded data may be flushed at will by the system. If flushed,
		it will be re-decoded as needed.
	**/
	public var ON_DEMAND = 0;

	/**
		Specifies that the image being loaded will be decoded on load, prior to
		the `complete` event being sent. The decoded image data is cached, and
		may be flushed at will by the system. If flushed, it will be re-decoded
		as needed.
	**/
	public var ON_LOAD = 1;

	@:from private static function fromString(value:String):ImageDecodingPolicy
	{
		return switch (value)
		{
			case "onDemand": ON_DEMAND;
			case "onLoad": ON_LOAD;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : ImageDecodingPolicy)
		{
			case ImageDecodingPolicy.ON_DEMAND: "onDemand";
			case ImageDecodingPolicy.ON_LOAD: "onLoad";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract ImageDecodingPolicy(String) from String to String

{
	public var ON_DEMAND = "onDemand";
	public var ON_LOAD = "onLoad";
}
#end
#else
#if air
typedef ImageDecodingPolicy = flash.system.ImageDecodingPolicy;
#end
#end
