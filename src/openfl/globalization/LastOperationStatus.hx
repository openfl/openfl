package openfl.globalization;

#if !flash
#if !openfljs
@:enum abstract LastOperationStatus(Null<Int>)
{
	public var BUFFER_OVERFLOW_ERROR = 0;
	public var ERROR_CODE_UNKNOWN = 1;
	public var ILLEGAL_ARGUMENT_ERROR = 2;
	public var INDEX_OUT_OF_BOUNDS_ERROR = 3;
	public var INVALID_ATTR_VALUE = 4;
	public var INVALID_CHAR_FOUND = 5;
	public var MEMORY_ALLOCATION_ERROR = 6;
	public var NO_ERROR = 7;
	public var NUMBER_OVERFLOW_ERROR = 8;
	public var PARSE_ERROR = 9;
	public var PATTERN_SYNTAX_ERROR = 10;
	public var PLATFORM_API_FAILED = 11;
	public var TRUNCATED_CHAR_FOUND = 12;
	public var UNEXPECTED_TOKEN = 13;
	public var UNSUPPORTED_ERROR = 14;
	public var USING_DEFAULT_WARNING = 15;
	public var USING_FALLBACK_WARNING = 16;

	@:noCompletion private inline static function fromInt(value:Null<Int>):LastOperationStatus
	{
		return cast value;
	}

	@:from private static function fromString(value:String):LastOperationStatus
	{
		return switch (value)
		{
			case "bufferOverflowError": BUFFER_OVERFLOW_ERROR;
			case "errorCodeUnknown": ERROR_CODE_UNKNOWN;
			case "illegalArgumentError": ILLEGAL_ARGUMENT_ERROR;
			case "indexOutOfBoundsError": INDEX_OUT_OF_BOUNDS_ERROR;
			case "invalidAttrValue": INVALID_ATTR_VALUE;
			case "invalidCharFound": INVALID_CHAR_FOUND;
			case "memoryAllocationError": MEMORY_ALLOCATION_ERROR;
			case "noError": NO_ERROR;
			case "numberOverflowError": NUMBER_OVERFLOW_ERROR;
			case "parseError": PARSE_ERROR;
			case "patternSyntaxError": PATTERN_SYNTAX_ERROR;
			case "platformAPIFailed": PLATFORM_API_FAILED;
			case "truncatedCharFound": TRUNCATED_CHAR_FOUND;
			case "unexpectedToken": UNEXPECTED_TOKEN;
			case "unsupportedError": UNSUPPORTED_ERROR;
			case "usingDefaultWarning": USING_DEFAULT_WARNING;
			case "usingFallbackWarning": USING_FALLBACK_WARNING;
			default: null;
		}
	}

	@:noCompletion private inline function toInt():Null<Int>
	{
		return this;
	}

	@:to private function toString():String
	{
		return switch (cast this : LastOperationStatus)
		{
			case LastOperationStatus.BUFFER_OVERFLOW_ERROR: "bufferOverflowError";
			case LastOperationStatus.ERROR_CODE_UNKNOWN: "errorCodeUnknown";
			case LastOperationStatus.ILLEGAL_ARGUMENT_ERROR: "illegalArgumentError";
			case LastOperationStatus.INDEX_OUT_OF_BOUNDS_ERROR: "indexOutOfBoundsError";
			case LastOperationStatus.INVALID_ATTR_VALUE: "invalidAttrValue";
			case LastOperationStatus.INVALID_CHAR_FOUND: "invalidCharFound";
			case LastOperationStatus.MEMORY_ALLOCATION_ERROR: "memoryAllocationError";
			case LastOperationStatus.NO_ERROR: "noError";
			case LastOperationStatus.NUMBER_OVERFLOW_ERROR: "numberOverflowError";
			case LastOperationStatus.PARSE_ERROR: "parseError";
			case LastOperationStatus.PATTERN_SYNTAX_ERROR: "patternSyntaxError";
			case LastOperationStatus.PLATFORM_API_FAILED: "platformAPIFailed";
			case LastOperationStatus.TRUNCATED_CHAR_FOUND: "truncatedCharFound";
			case LastOperationStatus.UNEXPECTED_TOKEN: "unexpectedToken";
			case LastOperationStatus.UNSUPPORTED_ERROR: "unsupportedError";
			case LastOperationStatus.USING_DEFAULT_WARNING: "usingDefaultWarning";
			case LastOperationStatus.USING_FALLBACK_WARNING: "usingFallbackWarning";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract LastOperationStatus(String) from String to String
{
	public var BUFFER_OVERFLOW_ERROR = "bufferOverflowError";
	public var ERROR_CODE_UNKNOWN = "errorCodeUnknown";
	public var ILLEGAL_ARGUMENT_ERROR = "illegalArgumentError";
	public var INDEX_OUT_OF_BOUNDS_ERROR = "indexOutOfBoundsError";
	public var INVALID_ATTR_VALUE = "invalidAttrValue";
	public var INVALID_CHAR_FOUND = "invalidCharFound";
	public var MEMORY_ALLOCATION_ERROR = "memoryAllocationError";
	public var NO_ERROR = "noError";
	public var NUMBER_OVERFLOW_ERROR = "numberOverflowError";
	public var PARSE_ERROR = "parseError";
	public var PATTERN_SYNTAX_ERROR = "patternSyntaxError";
	public var PLATFORM_API_FAILED = "platformAPIFailed";
	public var TRUNCATED_CHAR_FOUND = "truncatedCharFound";
	public var UNEXPECTED_TOKEN = "unexpectedToken";
	public var UNSUPPORTED_ERROR = "unsupportedError";
	public var USING_DEFAULT_WARNING = "usingDefaultWarning";
	public var USING_FALLBACK_WARNING = "usingFallbackWarning";

	@:noCompletion private inline static function fromInt(value:Null<Int>):DateTimeNameContext
	{
		return switch (value)
		{
			case 0: BUFFER_OVERFLOW_ERROR;
			case 1: ERROR_CODE_UNKNOWN;
			case 2: ILLEGAL_ARGUMENT_ERROR;
			case 3: INDEX_OUT_OF_BOUNDS_ERROR;
			case 4: INVALID_ATTR_VALUE;
			case 5: INVALID_CHAR_FOUND;
			case 6: MEMORY_ALLOCATION_ERROR;
			case 7: NO_ERROR;
			case 8: NUMBER_OVERFLOW_ERROR;
			case 9: PARSE_ERROR;
			case 10: PATTERN_SYNTAX_ERROR;
			case 11: PLATFORM_API_FAILED;
			case 12: TRUNCATED_CHAR_FOUND;
			case 13: UNEXPECTED_TOKEN;
			case 14: UNSUPPORTED_ERROR;
			case 15: USING_DEFAULT_WARNING;
			case 16: USING_FALLBACK_WARNING;
			default: null;
		}
	}
}
#end
#else
typedef LastOperationStatus = flash.globalization.LastOperationStatus;
#end
