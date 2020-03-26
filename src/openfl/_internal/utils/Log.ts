namespace openfl._internal.utils;

#if!lime
import haxe.PosInfos;

#if!lime_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
@SuppressWarnings([
	"checkstyle:FieldDocComment",
	"checkstyle:Dynamic",
	"checkstyle:NullableParameter"
])
class Log
{
	public static level: LogLevel;
	public static throwErrors: boolean = true;

	public static debug(message: Dynamic, ?info: PosInfos): void
	{
		if (level >= LogLevel.DEBUG)
		{
			#if js
			untyped __js__("console").debug("[" + info.className + "] " + message);
			#else
			println("[" + info.className + "] " + String(message));
			#end
		}
	}

	public static error(message: Dynamic, ?info: PosInfos): void
	{
		if (level >= LogLevel.ERROR)
		{
			var message = "[" + info.className + "] ERROR: " + message;

			if (throwErrors)
			{
				throw message;
			}
			else
			{
				#if js
				untyped __js__("console").error(message);
				#else
				println(message);
				#end
			}
		}
	}

	public static info(message: Dynamic, ?info: PosInfos): void
	{
		if (level >= LogLevel.INFO)
		{
			#if js
			untyped __js__("console").info("[" + info.className + "] " + message);
			#else
			println("[" + info.className + "] " + String(message));
			#end
		}
	}

	public static readonly print(message: Dynamic): void
	{
		#if sys
		Sys.print(String(message));
		#elseif flash
		untyped __global__["trace"](String(message));
		#elseif js
		untyped __js__("console").log(message);
		#else
		@SuppressWarnings("checkstyle:Trace") trace(message);
		#end
	}

	public static readonly println(message: Dynamic): void
	{
		#if sys
		Sys.println(String(message));
		#elseif flash
		untyped __global__["trace"](String(message));
		#elseif js
		untyped __js__("console").log(message);
		#else
		@SuppressWarnings("checkstyle:Trace") trace(String(message));
		#end
	}

	public static verbose(message: Dynamic, ?info: PosInfos): void
	{
		if (level >= LogLevel.VERBOSE)
		{
			println("[" + info.className + "] " + message);
		}
	}

	public static warn(message: Dynamic, ?info: PosInfos): void
	{
		if (level >= LogLevel.WARN)
		{
			#if js
			untyped __js__("console").warn("[" + info.className + "] WARNING: " + message);
			#else
			println("[" + info.className + "] WARNING: " + String(message));
			#end
		}
	}

	private static __init__(): void
	{
		#if no_traces
		level = NONE;
		#elseif verbose
		level = VERBOSE;
		#else
		#if sys
		var args = Sys.args();
		if (args.indexOf("-v") > -1 || args.indexOf("-verbose") > -1)
		{
			level = VERBOSE;
		}
		else
		#end
		{
			#if debug
			level = DEBUG;
			#else
			level = INFO;
			#end
		}
		#end

		#if js
		untyped __js__("if (typeof console == undefined) console = {};");
		untyped __js__("if (!console.log) console.log = function() {};");
		#end
	}
}

@: enum abstract LogLevel(Int) from Int to Int from UInt to UInt
{
	public NONE = 0;
	public ERROR = 1;
	public WARN = 2;
	public INFO = 3;
	public DEBUG = 4;
	public VERBOSE = 5;

	@: op(A > B) private static readonly gt(a: LogLevel, b: LogLevel) : boolean
	{
		return (a: number) > (b  : number);
	}

	@: op(A >= B) private static readonly gte(a: LogLevel, b: LogLevel) : boolean
	{
		return (a: number) >= (b  : number);
	}

	@: op(A < B) private static readonly lt(a: LogLevel, b: LogLevel) : boolean
	{
		return (a: number) <(b: number);
	}

	@: op(A <= B) private static readonly lte(a: LogLevel, b: LogLevel) : boolean
	{
		return (a: number) <= (b  : number);
	}
}
#else
typedef Log = lime.utils.Log;
typedef LogLevel = lime.utils.LogLevel;
#end
