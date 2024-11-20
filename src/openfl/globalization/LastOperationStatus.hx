package openfl.globalization;

#if !flash
/**
	The LastOperationStatus class enumerates constant values that represent the
	status of the most recent globalization service operation. These values can
	be retrieved through the read-only property `lastOperationStatus` available
	in most globalization classes.
**/
#if !openfljs
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract LastOperationStatus(Null<Int>)

{
	/**
		Indicates that given buffer is not enough to hold the result.
	**/
	public var BUFFER_OVERFLOW_ERROR = 0;

	/**
		Indicates that the return error code is not known. Any non-static method
		or read/write properties can return this error when the operation is not
		successful and the return error code is not known.
	**/
	public var ERROR_CODE_UNKNOWN = 1;

	/**
		Indicates that an argument passed to a method was illegal.
	**/
	public var ILLEGAL_ARGUMENT_ERROR = 2;

	/**
		Indicates that an iterator went out of range or an invalid parameter was specified for month, day, or time.
	**/
	public var INDEX_OUT_OF_BOUNDS_ERROR = 3;

	/**
		Indicates that a given attribute value is out of the expected range.
	**/
	public var INVALID_ATTR_VALUE = 4;

	/**
		Indicates that invalid Unicode value was found.
	**/
	public var INVALID_CHAR_FOUND = 5;

	/**
		Indicates that memory allocation has failed.
	**/
	public var MEMORY_ALLOCATION_ERROR = 6;

	/**
		Indicates that the last operation succeeded without any errors. This
		status can be returned by all constructors, non-static methods, static
		methods and read/write properties.
	**/
	public var NO_ERROR = 7;

	/**
		Indicates that an operation resulted a value that exceeds a specified
		numeric type.
	**/
	public var NUMBER_OVERFLOW_ERROR = 8;

	/**
		Indicates that the parsing of a number failed. This status can be
		returned by parsing methods of the formatter classes, such as
		`CurrencyFormatter.parse()` and `NumberFormatter.parseNumber()`. For
		example, if the value "12abc34" is passed as the parameter to the
		`CurrencyFormatter.parse()` method, the method returns "NaN" and sets
		the `lastOperationStatus` value to `LastOperationStatus.PARSE_ERROR`.
	**/
	public var PARSE_ERROR = 9;

	/**
		Indicates that the pattern for formatting a number, date, or time is
		invalid. This status is set when the user's operating system does not
		support the given pattern.
	**/
	public var PATTERN_SYNTAX_ERROR = 10;

	/**
		Indicates that an underlying platform API failed for an operation.
	**/
	public var PLATFORM_API_FAILED = 11;

	/**
		Indicates that a truncated Unicode character value was found.
	**/
	public var TRUNCATED_CHAR_FOUND = 12;

	/**
		Indicates that an unexpected token was detected in a Locale ID string.
	**/
	public var UNEXPECTED_TOKEN = 13;

	/**
		Indicates that the requested operation or option is not supported. This
		status can be returned by methods like
		`DateTimeFormatter.setDateTimePattern()` and when retrieving properties
		like `Collator.ignoreCase`.
	**/
	public var UNSUPPORTED_ERROR = 14;

	/**
		Indicates that an operating system default value was used during the
		most recent operation. Class constructors can return this status.
	**/
	public var USING_DEFAULT_WARNING = 15;

	/**
		Indicates that a fallback value was set during the most recent
		operation. This status can be returned by constructors and methods like
		`DateTimeFormatter.setDateTimeStyles()`, and when retrieving properties
		like `CurrencyFormatter.groupingPattern`.
	**/
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
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract LastOperationStatus(String) from String to String

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

	@:noCompletion private inline static function fromInt(value:Null<Int>):LastOperationStatus
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
