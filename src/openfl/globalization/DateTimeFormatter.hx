package openfl.globalization;

import haxe.EnumTools.EnumValueTools;
import openfl.Vector;
#if html5
import js.lib.intl.DateTimeFormat;
#end

#if !flash
#if !html5
@:final class DateTimeFormatter
{
	private static var WEEKDAY_NAMES_EN = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
	private static var MONTH_NAMES_EN = [
		"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
	];
	private static inline var MERIDIEM_AM = "AM";
	private static inline var MERIDIEM_PM = "PM";
	private static inline var ERA_AD_LONG = "Anno Domini";
	private static inline var ERA_AD_SHORT = "AD";
	private static inline var ERA_AD_NARROW = "A";

	public static function getAvailableLocaleIDNames():Vector<String>
	{
		return new Vector<String>(1, true, ["en-US"]);
	}

	public function new(requestedLocaleIDName:String, dateStyle:DateTimeStyle = LONG, timeStyle:DateTimeStyle = LONG)
	{
		this.requestedLocaleIDName = requestedLocaleIDName;

		this.setDateTimeStyles(dateStyle, timeStyle);
		this.actualLocaleIDName = "en-US";
		this.lastOperationStatus = NO_ERROR;
	}

	private var dateStyle:DateTimeStyle;
	private var timeStyle:DateTimeStyle;
	private var dateTimePattern:String;

	public function getDateStyle():DateTimeStyle
	{
		this.lastOperationStatus = NO_ERROR;
		return this.dateStyle;
	}

	public function getTimeStyle():DateTimeStyle
	{
		this.lastOperationStatus = NO_ERROR;
		return this.timeStyle;
	}

	public function getDateTimePattern():String
	{
		this.lastOperationStatus = NO_ERROR;
		return this.dateTimePattern;
	}

	public function getFirstWeekday():Int
	{
		this.lastOperationStatus = NO_ERROR;
		return 0;
	}

	public var actualLocaleIDName(default, null):String;
	public var requestedLocaleIDName(default, null):String;
	public var lastOperationStatus(default, null):LastOperationStatus;

	public function format(date:Date):String
	{
		if (this.dateStyle == CUSTOM || this.timeStyle == CUSTOM)
		{
			var result = this.formatPattern(date, false);
			this.lastOperationStatus = NO_ERROR;
			return result;
		}
		var result = this.formatStyles(date, false);
		this.lastOperationStatus = NO_ERROR;
		return result;
	}

	public function formatUTC(date:Date):String
	{
		if (this.dateTimePattern != null)
		{
			var result = this.formatPattern(date, true);
			this.lastOperationStatus = NO_ERROR;
			return result;
		}
		var result = this.formatStyles(date, true);
		this.lastOperationStatus = NO_ERROR;
		return result;
	}

	private function formatStyles(date:Date, utc:Bool):String
	{
		var result = "";
		if (this.dateStyle != NONE)
		{
			#if haxe4
			var fullYear = utc ? date.getUTCFullYear() : date.getFullYear();
			var month = utc ? date.getUTCMonth() : date.getMonth();
			var dateOfMonth = utc ? date.getUTCDate() : date.getDate();
			var weekday = utc ? date.getUTCDay() : date.getDay();
			#else
			var fullYear = date.getFullYear();
			var month = date.getMonth();
			var dateOfMonth = date.getDate();
			var weekday = date.getDay();
			#end
			result += switch (this.dateStyle)
			{
				case MEDIUM: '${MONTH_NAMES_EN[month]} ${dateOfMonth}, ${fullYear}';
				case SHORT: '${month + 1}/${dateOfMonth}/${fullYear}';
				default: '${WEEKDAY_NAMES_EN[weekday]}, ${MONTH_NAMES_EN[month]} ${dateOfMonth}, ${fullYear}';
			};
			if (this.timeStyle != NONE)
			{
				result += " ";
			}
		}
		if (this.timeStyle != NONE)
		{
			#if haxe4
			var hours = utc ? date.getUTCHours() : date.getHours();
			var minutes = utc ? date.getUTCMinutes() : date.getMinutes();
			var seconds = utc ? date.getUTCSeconds() : date.getSeconds();
			#else
			var hours = date.getHours();
			var minutes = date.getMinutes();
			var seconds = date.getSeconds();
			#end
			var meridiem = MERIDIEM_AM;
			if (hours > 12)
			{
				hours -= 12;
				meridiem = MERIDIEM_PM;
			}
			result += switch (this.timeStyle)
			{
				case SHORT: '${hours}:${StringTools.lpad(Std.string(minutes), "0", 2)} ${meridiem}';
				default: '${hours}:${StringTools.lpad(Std.string(minutes), "0", 2)}:${StringTools.lpad(Std.string(seconds), "0", 2)} ${meridiem}';
			};
		}
		return result;
	}

	private function formatPattern(date:Date, utc:Bool):String
	{
		var result = "";
		var tokens = DateTimeFormatTokenizer.tokenize(this.dateTimePattern);
		#if haxe4
		var fullYear = utc ? date.getUTCFullYear() : date.getFullYear();
		var month = utc ? date.getUTCMonth() : date.getMonth();
		var dateOfMonth = utc ? date.getUTCDate() : date.getDate();
		var weekday = utc ? date.getUTCDay() : date.getDay();
		var hours = utc ? date.getUTCHours() : date.getHours();
		var minutes = utc ? date.getUTCMinutes() : date.getMinutes();
		var seconds = utc ? date.getUTCSeconds() : date.getSeconds();
		#else
		var fullYear = date.getFullYear();
		var month = date.getMonth();
		var dateOfMonth = date.getDate();
		var weekday = date.getDay();
		var hours = date.getHours();
		var minutes = date.getMinutes();
		var seconds = date.getSeconds();
		#end

		for (token in tokens)
		{
			result += switch (token)
			{
				case Invalid(_): "";
				case Text(text): text;
				case Era(length): // G
					switch (length)
					{
						case 5: ERA_AD_NARROW;
						case 4: ERA_AD_LONG;
						default: ERA_AD_SHORT;
					}
				case Year(length): // y
					switch (length)
					{
						case 1: Std.string(fullYear);
						default:
							var yearString = StringTools.lpad(Std.string(fullYear), "0", length);
							yearString.substr(yearString.length - length, length);
					}
				case Month(length): // M
					switch (length)
					{
						case 1: Std.string(month + 1);
						case 2: StringTools.lpad(Std.string(month + 1), "0", 2);
						case 3: getMonthNames(LONG_ABBREVIATION)[month];
						case 5: getMonthNames(SHORT_ABBREVIATION)[month];
						default: getMonthNames(FULL)[month];
					}
				case Date(length): // d
					switch (length)
					{
						case 1: Std.string(dateOfMonth + 1);
						default: StringTools.lpad(Std.string(dateOfMonth + 1), "0", 2);
					}
				case Weekday(length): // E
					switch (length)
					{
						case 5: getWeekdayNames(SHORT_ABBREVIATION)[weekday];
						case 4: getWeekdayNames(FULL)[weekday];
						default: getWeekdayNames(LONG_ABBREVIATION)[weekday];
					}
				case Quarter(_): // Q
					""; // not supported
				case WeekOfYear(_): // w
					""; // not supported
				case DayOfYear(_): // D
					""; // not supported
				case DayOfWeekOccurence: // F
					""; // not supported
				case WeekOfMonth: // W
					""; // not supported
				case AMPM: // a
					(hours >= 12) ? MERIDIEM_PM : MERIDIEM_AM;
				case Hour11(length): // K
					var hours2 = hours % 12;
					if (hours2 == 0)
					{
						hours2 = 12;
					}
					hours2--;
					switch (length)
					{
						case 1: Std.string(hours2);
						default: StringTools.lpad(Std.string(hours2), "0", 2);
					}
				case Hour12(length): // h
					var hours2 = hours % 12;
					if (hours2 == 0)
					{
						hours2 = 12;
					}
					switch (length)
					{
						case 1: Std.string(hours2);
						default: StringTools.lpad(Std.string(hours2), "0", 2);
					}
				case Hour23(length): // H
					switch (length)
					{
						case 1: Std.string(hours);
						default: StringTools.lpad(Std.string(hours), "0", 2);
					}
				case Hour24(length): // k
					switch (length)
					{
						case 1: Std.string(hours + 1);
						default: StringTools.lpad(Std.string(hours + 1), "0", 2);
					}
				case Minute(length): // m
					switch (length)
					{
						case 1: Std.string(minutes);
						default: StringTools.lpad(Std.string(minutes), "0", 2);
					}
				case Second(length): // s
					switch (length)
					{
						case 1: Std.string(seconds);
						default: StringTools.lpad(Std.string(seconds), "0", 2);
					}
				case Millisecond(length): // S
					""; // not supported
				case TimeZoneDST(length): // z
					""; // not supported
				case TimeZoneOffset(length): // Z
					""; // not supported
				case TimeZone(length): // v
					""; // not supported
			}
		}
		return result;
	}

	public function getMonthNames(nameStyle:DateTimeNameStyle = FULL, context:DateTimeNameContext = STANDALONE):Vector<String>
	{
		if (nameStyle == FULL)
		{
			var result = new Vector(MONTH_NAMES_EN.length, true, MONTH_NAMES_EN);
			this.lastOperationStatus = NO_ERROR;
			return result;
		}
		var result = new Vector(MONTH_NAMES_EN.length, true, MONTH_NAMES_EN.map(function(monthName:String):String
		{
			return monthName.substr(0, 3);
		}));
		this.lastOperationStatus = NO_ERROR;
		return result;
	}

	public function getWeekdayNames(nameStyle:DateTimeNameStyle = FULL, context:DateTimeNameContext = STANDALONE):Vector<String>
	{
		if (nameStyle == FULL)
		{
			var result = new Vector(WEEKDAY_NAMES_EN.length, true, WEEKDAY_NAMES_EN);
			this.lastOperationStatus = NO_ERROR;
			return result;
		}
		var abbrLength = nameStyle == SHORT_ABBREVIATION ? 2 : 3;
		var result = new Vector(WEEKDAY_NAMES_EN.length, true, WEEKDAY_NAMES_EN.map(function(weekdayName:String):String
		{
			return weekdayName.substr(0, abbrLength);
		}));
		this.lastOperationStatus = NO_ERROR;
		return result;
	}

	public function setDateTimeStyles(dateStyle:DateTimeStyle = LONG, timeStyle:DateTimeStyle = LONG):Void
	{
		if (dateStyle == CUSTOM || timeStyle == CUSTOM)
		{
			this.lastOperationStatus = ILLEGAL_ARGUMENT_ERROR;
			return;
		}
		this.dateStyle = dateStyle;
		this.timeStyle = timeStyle;
		this.dateTimePattern = switch (dateStyle)
		{
			case NONE: "";
			case MEDIUM: "MMMM d, yyyy";
			case SHORT: "M/d/yyyy";
			default: "EEEE, MMMM d, yyyy";
		}
		if (dateStyle != NONE && timeStyle != NONE)
		{
			this.dateTimePattern += " ";
		}
		this.dateTimePattern += switch (timeStyle)
		{
			case NONE: "";
			case SHORT: "h:mm a";
			default: "h:mm:ss a";
		}
		this.lastOperationStatus = NO_ERROR;
	}

	public function setDateTimePattern(pattern:String):Void
	{
		if (pattern == null || pattern.length > 255)
		{
			this.lastOperationStatus = PATTERN_SYNTAX_ERROR;
			return;
		}
		this.dateStyle = CUSTOM;
		this.timeStyle = CUSTOM;
		this.dateTimePattern = pattern;
		try
		{
			var tokens = DateTimeFormatTokenizer.tokenize(this.dateTimePattern);
			this.lastOperationStatus = NO_ERROR;
			for (token in tokens)
			{
				switch (token)
				{
					case Invalid(_):
						this.lastOperationStatus = PATTERN_SYNTAX_ERROR;
						return;
					case Quarter(_): // not supported
						this.lastOperationStatus = UNSUPPORTED_ERROR;
						return;
					case WeekOfYear(_): // not supported
						this.lastOperationStatus = UNSUPPORTED_ERROR;
						return;
					case DayOfYear(_): // not supported
						this.lastOperationStatus = UNSUPPORTED_ERROR;
						return;
					case DayOfWeekOccurence: // not supported
						this.lastOperationStatus = UNSUPPORTED_ERROR;
						return;
					case WeekOfMonth: // not supported
						this.lastOperationStatus = UNSUPPORTED_ERROR;
						return;
					case Millisecond(_): // not supported
						this.lastOperationStatus = UNSUPPORTED_ERROR;
					case TimeZoneDST(_): // not supported by Intl.DateTimeFormat
						this.lastOperationStatus = UNSUPPORTED_ERROR;
						return;
					case TimeZoneOffset(_): // not supported by Intl.DateTimeFormat
						this.lastOperationStatus = UNSUPPORTED_ERROR;
						return;
					case TimeZone(_): // not supported by Intl.DateTimeFormat
						this.lastOperationStatus = UNSUPPORTED_ERROR;
						return;
					default: // do nothing
				}
			}
		}
		catch (e:Dynamic)
		{
			// something went terribly wrong!
			trace("Date time tokenization error: " + e);
			this.dateTimePattern = "";
			this.lastOperationStatus = PATTERN_SYNTAX_ERROR;
			return;
		}
	}
}
#else
@:final class DateTimeFormatter
{
	public static function getAvailableLocaleIDNames():Vector<String>
	{
		// there doesn't seem to be a way to get this in JS?
		return new Vector<String>();
	}

	public function new(requestedLocaleIDName:String, dateStyle:DateTimeStyle = LONG, timeStyle:DateTimeStyle = LONG)
	{
		this.requestedLocaleIDName = requestedLocaleIDName;
		this._normalizedRequestedLocaleIDName = @:privateAccess LocaleID.normalizeRequestedLocaleIDName(requestedLocaleIDName);

		this.setDateTimeStyles(dateStyle, timeStyle);
		this.actualLocaleIDName = this.intlDateTimeFormat.resolvedOptions().locale;
		this.lastOperationStatus = NO_ERROR;
	}

	private var intlDateTimeFormat:DateTimeFormat;
	private var intlDateTimeFormatUTC:DateTimeFormat;
	private var dateStyle:DateTimeStyle;
	private var timeStyle:DateTimeStyle;
	private var dateTimePattern:String;

	public function getDateStyle():DateTimeStyle
	{
		this.lastOperationStatus = NO_ERROR;
		return this.dateStyle;
	}

	public function getTimeStyle():DateTimeStyle
	{
		this.lastOperationStatus = NO_ERROR;
		return this.timeStyle;
	}

	public function getDateTimePattern():String
	{
		this.lastOperationStatus = NO_ERROR;
		return this.dateTimePattern;
	}

	public function getFirstWeekday():Int
	{
		// there doesn't seem to be a way to get this in JS?
		this.lastOperationStatus = PLATFORM_API_FAILED;
		return 0;
	}

	public var actualLocaleIDName(default, null):String;
	public var requestedLocaleIDName(default, null):String;

	private var _normalizedRequestedLocaleIDName:String;

	public var lastOperationStatus(default, null):LastOperationStatus;

	public function format(date:Date):String
	{
		var jsDate = js.lib.Date.fromHaxeDate(date);
		if (this.dateStyle == CUSTOM || this.timeStyle == CUSTOM)
		{
			var result = this.formatPatternJS(jsDate, false);
			this.lastOperationStatus = NO_ERROR;
			return result;
		}
		else
		{
			try
			{
				var result = this.intlDateTimeFormat.format(jsDate);
				this.lastOperationStatus = NO_ERROR;
				return result;
			}
			catch (e:Dynamic)
			{
				this.lastOperationStatus = ERROR_CODE_UNKNOWN;
				return null;
			}
		}
	}

	public function formatUTC(date:Date):String
	{
		var jsDate = js.lib.Date.fromHaxeDate(date);
		if (this.dateTimePattern != null)
		{
			var result = this.formatPatternJS(jsDate, true);
			this.lastOperationStatus = NO_ERROR;
			return result;
		}
		else
		{
			try
			{
				var result = this.intlDateTimeFormatUTC.format(jsDate);
				this.lastOperationStatus = NO_ERROR;
				return result;
			}
			catch (e:Dynamic)
			{
				this.lastOperationStatus = ERROR_CODE_UNKNOWN;
				return null;
			}
		}
	}

	private function formatPatternJS(date:js.lib.Date, utc:Bool):String
	{
		var result = "";
		var tokens = DateTimeFormatTokenizer.tokenize(this.dateTimePattern);
		var timeZone = utc ? "UTC" : js.Syntax.code("undefined");
		for (token in tokens)
		{
			result += switch (token)
			{
				case Invalid(_): "";
				case Text(text): text;
				case Era(length): // G
					getDateFormatPart("era", switch (length)
					{
						case 5: (new DateTimeFormat(this._normalizedRequestedLocaleIDName, cast {era: "narrow", timeZone: timeZone})).formatToParts(date);
						case 4: (new DateTimeFormat(this._normalizedRequestedLocaleIDName, cast {era: "long", timeZone: timeZone})).formatToParts(date);
						default: (new DateTimeFormat(this._normalizedRequestedLocaleIDName, cast {era: "short", timeZone: timeZone})).formatToParts(date);
					});
				case Year(length): // y
					switch (length)
					{
						case 1: (new DateTimeFormat(this._normalizedRequestedLocaleIDName,
								cast {year: "numeric", timeZone: timeZone})).formatToParts(date)[0].value;
						case 2: (new DateTimeFormat(this._normalizedRequestedLocaleIDName,
								cast {year: "2-digit", timeZone: timeZone})).formatToParts(date)[0].value;
						default: StringTools.lpad((new DateTimeFormat(this._normalizedRequestedLocaleIDName,
								cast {year: "numeric", timeZone: timeZone})).formatToParts(date)[0].value,
								"0", Std.int(Math.min(4, length)));
					}
				case Month(length): // M
					getDateFormatPart("month", switch (length)
					{
						case 1: (new DateTimeFormat(this._normalizedRequestedLocaleIDName, cast {month: "numeric", timeZone: timeZone})).formatToParts(date);
						case 2: (new DateTimeFormat(this._normalizedRequestedLocaleIDName, cast {month: "2-digit", timeZone: timeZone})).formatToParts(date);
						case 3: (new DateTimeFormat(this._normalizedRequestedLocaleIDName, cast {month: "short", timeZone: timeZone})).formatToParts(date);
						case 4: (new DateTimeFormat(this._normalizedRequestedLocaleIDName, cast {month: "long", timeZone: timeZone})).formatToParts(date);
						default: (new DateTimeFormat(this._normalizedRequestedLocaleIDName, cast {month: "narrow", timeZone: timeZone})).formatToParts(date);
					});
				case Date(length): // d
					getDateFormatPart("day", switch (length)
					{
						case 1: (new DateTimeFormat(this._normalizedRequestedLocaleIDName, cast {day: "numeric", timeZone: timeZone})).formatToParts(date);
						default: (new DateTimeFormat(this._normalizedRequestedLocaleIDName, cast {day: "2-digit", timeZone: timeZone})).formatToParts(date);
					});
				case Weekday(length): // E
					getDateFormatPart("weekday", switch (length)
					{
						case 5: (new DateTimeFormat(this._normalizedRequestedLocaleIDName, cast {weekday: "narrow", timeZone: timeZone})).formatToParts(date);
						case 4: (new DateTimeFormat(this._normalizedRequestedLocaleIDName, cast {weekday: "long", timeZone: timeZone})).formatToParts(date);
						default: (new DateTimeFormat(this._normalizedRequestedLocaleIDName, cast {weekday: "short", timeZone: timeZone})).formatToParts(date);
					});
				case Quarter(_): // Q
					""; // not supported by Intl.DateTimeFormat
				case WeekOfYear(_): // w
					""; // not supported by Intl.DateTimeFormat
				case DayOfYear(_): // D
					""; // not supported by Intl.DateTimeFormat
				case DayOfWeekOccurence: // F
					""; // not supported by Intl.DateTimeFormat
				case WeekOfMonth: // W
					""; // not supported by Intl.DateTimeFormat
				case AMPM: // a
					getDateFormatPart("dayPeriod", (new DateTimeFormat(this._normalizedRequestedLocaleIDName, cast {
						hour: "numeric",
						hour12: true,
						dayPeriod: "short",
						timeZone: timeZone
					})).formatToParts(date));
				case Hour11(length): // K
					getDateFormatPart("hour", switch (length)
					{
						case 1:
							(new DateTimeFormat(this._normalizedRequestedLocaleIDName,
								cast {hour: "numeric", hourCycle: "h11", timeZone: timeZone})).formatToParts(date);
						default:
							(new DateTimeFormat(this._normalizedRequestedLocaleIDName,
								cast {hour: "2-digit", hourCycle: "h11", timeZone: timeZone})).formatToParts(date);
					});
				case Hour12(length): // h
					getDateFormatPart("hour", switch (length)
					{
						case 1:
							(new DateTimeFormat(this._normalizedRequestedLocaleIDName,
								cast {hour: "numeric", hourCycle: "h12", timeZone: timeZone})).formatToParts(date);
						default:
							(new DateTimeFormat(this._normalizedRequestedLocaleIDName,
								cast {hour: "2-digit", hourCycle: "h12", timeZone: timeZone})).formatToParts(date);
					});
				case Hour23(length): // H
					getDateFormatPart("hour", switch (length)
					{
						case 1:
							(new DateTimeFormat(this._normalizedRequestedLocaleIDName,
								cast {hour: "numeric", hourCycle: "h23", timeZone: timeZone})).formatToParts(date);
						default:
							(new DateTimeFormat(this._normalizedRequestedLocaleIDName,
								cast {hour: "2-digit", hourCycle: "h23", timeZone: timeZone})).formatToParts(date);
					});
				case Hour24(length): // k
					getDateFormatPart("hour", switch (length)
					{
						case 1:
							(new DateTimeFormat(this._normalizedRequestedLocaleIDName,
								cast {hour: "numeric", hourCycle: "h24", timeZone: timeZone})).formatToParts(date);
						default:
							(new DateTimeFormat(this._normalizedRequestedLocaleIDName,
								cast {hour: "2-digit", hourCycle: "h24", timeZone: timeZone})).formatToParts(date);
					});
				case Minute(length): // m
					getDateFormatPart("minute", switch (length)
					{
						case 1: (new DateTimeFormat(this._normalizedRequestedLocaleIDName, cast {minute: "numeric", timeZone: timeZone})).formatToParts(date);
						default: (new DateTimeFormat(this._normalizedRequestedLocaleIDName, cast {minute: "2-digit", timeZone: timeZone})).formatToParts(date);
					});
				case Second(length): // s
					getDateFormatPart("second", switch (length)
					{
						case 1: (new DateTimeFormat(this._normalizedRequestedLocaleIDName, cast {second: "numeric", timeZone: timeZone})).formatToParts(date);
						default: (new DateTimeFormat(this._normalizedRequestedLocaleIDName, cast {second: "2-digit", timeZone: timeZone})).formatToParts(date);
					});
				case Millisecond(length): // S
					""; // not supported by Intl.DateTimeFormat
				case TimeZoneDST(length): // z
					getDateFormatPart("timeZoneName", switch (length)
					{
						case 4: (new DateTimeFormat(this._normalizedRequestedLocaleIDName,
								cast {timeZoneName: "long", timeZone: timeZone})).formatToParts(date);
						default: (new DateTimeFormat(this._normalizedRequestedLocaleIDName,
								cast {timeZoneName: "short", timeZone: timeZone})).formatToParts(date);
					});
				case TimeZoneOffset(length): // Z
					""; // not supported by Intl.DateTimeFormat
				case TimeZone(length): // v
					""; // not supported by Intl.DateTimeFormat
			}
		}
		return result;
	}

	private function getDateFormatPart(partName:String, parts:Array<DateTimeFormatPart>):String
	{
		var result = "";
		for (part in parts)
		{
			var typeAsString = Std.string(part.type);
			if (typeAsString != partName)
			{
				continue;
			}
			result = part.value;
		}
		return result;
	}

	public function getMonthNames(nameStyle:DateTimeNameStyle = FULL, context:DateTimeNameContext = STANDALONE):Vector<String>
	{
		try
		{
			var monthStyle = switch (nameStyle)
			{
				case FULL: "long";
				default: "short";
			}
			var intlDateTimeFormat = new DateTimeFormat(this.actualLocaleIDName, cast {month: monthStyle});
			var monthNames:Array<String> = [];
			for (i in 0...12)
			{
				var date = new Date(2000, i, 1, 0, 0, 0);
				monthNames[i] = intlDateTimeFormat.format(js.lib.Date.fromHaxeDate(date));
			}
			this.lastOperationStatus = NO_ERROR;
			return new Vector(monthNames.length, true, monthNames);
		}
		catch (e:Dynamic)
		{
			this.lastOperationStatus = ERROR_CODE_UNKNOWN;
			return null;
		}
	}

	public function getWeekdayNames(nameStyle:DateTimeNameStyle = FULL, context:DateTimeNameContext = STANDALONE):Vector<String>
	{
		try
		{
			var weekdayStyle = switch (nameStyle)
			{
				case FULL: "long";
				case SHORT_ABBREVIATION: "narrow";
				default: "short";
			}
			var intlDateTimeFormat = new DateTimeFormat(this.actualLocaleIDName, cast {weekday: weekdayStyle});
			var weekdayNames:Array<String> = [];
			for (i in 0...7)
			{
				// 2006 started on a sunday
				var date = new Date(2006, 0, i + 1, 0, 0, 0);
				weekdayNames[i] = intlDateTimeFormat.format(js.lib.Date.fromHaxeDate(date));
			}
			this.lastOperationStatus = NO_ERROR;
			return new Vector(weekdayNames.length, true, weekdayNames);
		}
		catch (e:Dynamic)
		{
			this.lastOperationStatus = ERROR_CODE_UNKNOWN;
			return null;
		}
	}

	public function setDateTimeStyles(dateStyle:DateTimeStyle = LONG, timeStyle:DateTimeStyle = LONG):Void
	{
		if (dateStyle == CUSTOM || timeStyle == CUSTOM)
		{
			this.lastOperationStatus = ILLEGAL_ARGUMENT_ERROR;
			return;
		}
		this.dateStyle = dateStyle;
		this.timeStyle = timeStyle;
		this.dateTimePattern = null;
		var options:Dynamic = {};
		if (dateStyle != NONE)
		{
			options.dateStyle = switch (dateStyle)
			{
				case LONG: "full"; // more closely matches swf than "long"
				case MEDIUM: "long"; // more closely matches swf than "medium"
				default: "short";
			};
		}
		if (timeStyle != NONE)
		{
			options.timeStyle = switch (timeStyle)
			{
				case LONG: "medium"; // more closely matches swf than "long"
				case MEDIUM: "medium"; // swf long and medium are the same
				default: "short";
			};
		}
		try
		{
			this.intlDateTimeFormat = new DateTimeFormat(this._normalizedRequestedLocaleIDName, cast options);
			options.timeZone = "UTC";
			this.intlDateTimeFormatUTC = new DateTimeFormat(this._normalizedRequestedLocaleIDName, cast options);
			this.resolveDateTimePattern();
			this.lastOperationStatus = NO_ERROR;
		}
		catch (e:Dynamic)
		{
			this.lastOperationStatus = ERROR_CODE_UNKNOWN;
		}
	}

	public function setDateTimePattern(pattern:String):Void
	{
		if (pattern == null || pattern.length > 255)
		{
			this.lastOperationStatus = PATTERN_SYNTAX_ERROR;
			return;
		}
		this.dateStyle = CUSTOM;
		this.timeStyle = CUSTOM;
		this.dateTimePattern = pattern;
		try
		{
			var tokens = DateTimeFormatTokenizer.tokenize(this.dateTimePattern);
			this.lastOperationStatus = NO_ERROR;
			for (token in tokens)
			{
				switch (token)
				{
					case Invalid(text):
						this.lastOperationStatus = PATTERN_SYNTAX_ERROR;
						return;
					case Quarter(_): // not supported by Intl.DateTimeFormat
						this.lastOperationStatus = UNSUPPORTED_ERROR;
						return;
					case WeekOfYear(_): // not supported by Intl.DateTimeFormat
						this.lastOperationStatus = UNSUPPORTED_ERROR;
						return;
					case DayOfYear(_): // not supported by Intl.DateTimeFormat
						this.lastOperationStatus = UNSUPPORTED_ERROR;
						return;
					case DayOfWeekOccurence: // not supported by Intl.DateTimeFormat
						this.lastOperationStatus = UNSUPPORTED_ERROR;
						return;
					case WeekOfMonth: // not supported by Intl.DateTimeFormat
						this.lastOperationStatus = UNSUPPORTED_ERROR;
						return;
					case Millisecond(_): // not supported by Intl.DateTimeFormat
						this.lastOperationStatus = UNSUPPORTED_ERROR;
					case TimeZoneOffset(_): // not supported by Intl.DateTimeFormat
						this.lastOperationStatus = UNSUPPORTED_ERROR;
						return;
					case TimeZone(_): // not supported by Intl.DateTimeFormat
						this.lastOperationStatus = UNSUPPORTED_ERROR;
						return;
					default: // do nothing
				}
			}
		}
		catch (e:Dynamic)
		{
			// something went terribly wrong!
			trace("Date time tokenization error: " + e);
			this.dateTimePattern = "";
			this.lastOperationStatus = PATTERN_SYNTAX_ERROR;
			return;
		}
	}

	private function resolveDateTimePattern():Void
	{
		var pattern = "";
		var parts = this.intlDateTimeFormat.formatToParts(js.lib.Date.fromHaxeDate(new Date(2021, 9, 12, 0, 0, 0)));
		for (part in parts)
		{
			pattern += switch (part.type)
			{
				case Month: "M";
				case Day: "d";
				case Year: "y";
				case Hour: "h";
				case Minute: "m";
				case Second: "s";
				case DayPeriod: "a";
				case Era: "G";
				case TimeZoneName: "z";
				case Weekday: "E";
				case Literal: part.value;
				default: "";
			}
		}
		this.dateTimePattern = pattern;
	}
}
#end

private class DateTimeFormatTokenizer
{
	public static function tokenize(format:String):Array<DateTimeFormatToken>
	{
		var tokens:Array<DateTimeFormatToken> = [];
		var unquotedText = "";
		var currentToken:DateTimeFormatToken = null;
		var i = 0;
		while (i < format.length)
		{
			var char = format.charAt(i);
			i++;
			if (currentToken != null)
			{
				switch (currentToken)
				{
					case Text(text):
						switch (char)
						{
							case "'":
								var nextChar = (i < format.length) ? format.charAt(i) : null;
								if (nextChar == "'")
								{
									currentToken = Text(text + char);
									i++;
								}
								else
								{
									tokens.push(currentToken);
									currentToken = null;
								}
							default:
								currentToken = Text(text + char);
						}
						continue;
					default: // do nothing
				}
			}
			var newToken = switch (char)
			{
				case "G": Era(1);
				case "y": Year(1);
				case "M": Month(1);
				case "d": Date(1);
				case "E": Weekday(1);
				case "Q": Quarter(1);
				case "w": WeekOfYear(1);
				case "D": DayOfYear(1);
				case "F": DayOfWeekOccurence;
				case "W": WeekOfMonth;
				case "a": AMPM;
				case "K": Hour11(1);
				case "h": Hour12(1);
				case "H": Hour23(1);
				case "k": Hour24(1);
				case "m": Minute(1);
				case "s": Second(1);
				case "S": Millisecond(1);
				case "v": TimeZone(1);
				case "z": TimeZoneDST(1);
				case "Z": TimeZoneOffset(1);
				case "'": Text("");
				default:
					if (~/^[A-Za-z]$/.match(char))
					{
						Invalid(char);
					}
					else
					{
						unquotedText += char;
						null;
					}
			}
			if (newToken != null && unquotedText.length > 0)
			{
				tokens.push(Text(unquotedText));
				unquotedText = "";
			}
			if (currentToken != null && newToken != null && EnumValueTools.getName(newToken) == EnumValueTools.getName(currentToken))
			{
				currentToken = switch (currentToken)
				{
					case Era(length): Era(Std.int(Math.min(5, length + 1)));
					case Year(length): Year(Std.int(Math.min(5, length + 1)));
					case Month(length): Month(Std.int(Math.min(5, length + 1)));
					case Date(length): Date(Std.int(Math.min(2, length + 1)));
					case Weekday(length): Weekday(Std.int(Math.min(5, length + 1)));
					case Quarter(length): Quarter(Std.int(Math.min(4, length + 1)));
					case WeekOfYear(length): WeekOfYear(Std.int(Math.min(2, length + 1)));
					case WeekOfMonth: WeekOfMonth;
					case DayOfYear(length): DayOfYear(Std.int(Math.min(3, length + 1)));
					case DayOfWeekOccurence: DayOfWeekOccurence;
					case AMPM: AMPM;
					case Hour11(length): Hour11(Std.int(Math.min(2, length + 1)));
					case Hour12(length): Hour12(Std.int(Math.min(2, length + 1)));
					case Hour23(length): Hour23(Std.int(Math.min(2, length + 1)));
					case Hour24(length): Hour24(Std.int(Math.min(2, length + 1)));
					case Minute(length): Minute(Std.int(Math.min(2, length + 1)));
					case Second(length): Second(Std.int(Math.min(2, length + 1)));
					case Millisecond(length): Millisecond(Std.int(Math.min(5, length + 1)));
					case TimeZone(length): TimeZone(Std.int(Math.min(4, length + 1)));
					case TimeZoneDST(length): TimeZoneDST(Std.int(Math.min(4, length + 1)));
					case TimeZoneOffset(length): TimeZoneOffset(Std.int(Math.min(4, length + 1)));
					case Text(text): Invalid(text);
					case Invalid(text): Invalid(text);
				}
			}
			else
			{
				if (currentToken != null)
				{
					tokens.push(currentToken);
				}
				currentToken = newToken;
			}
		}
		if (currentToken != null)
		{
			tokens.push(currentToken);
			currentToken = null;
		}
		if (unquotedText.length > 0)
		{
			tokens.push(Text(unquotedText));
			unquotedText = "";
		}
		return tokens;
	}
}

private enum DateTimeFormatToken
{
	Text(text:String);
	Invalid(text:String);
	Weekday(length:Int);
	Era(length:Int);
	Year(length:Int);
	Month(length:Int);
	Date(length:Int);
	Quarter(length:Int);
	WeekOfYear(length:Int);
	WeekOfMonth;
	DayOfYear(length:Int);
	DayOfWeekOccurence;
	AMPM;
	Hour11(length:Int);
	Hour12(length:Int);
	Hour23(length:Int);
	Hour24(length:Int);
	Minute(length:Int);
	Second(length:Int);
	Millisecond(length:Int);
	TimeZone(length:Int);
	TimeZoneDST(length:Int);
	TimeZoneOffset(length:Int);
}
#else
typedef DateTimeFormatter = flash.globalization.DateTimeFormatter;
#end
