package openfl.utils._internal;

import haxe.PosInfos;
import openfl.utils._internal.Log;
#if !openfl_unit_testing
import openfl.display.Application;
import openfl.display.MovieClip;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
class Lib
{
	public static var application:#if !openfl_unit_testing Application #else Dynamic #end;
	public static var current:#if !openfl_unit_testing MovieClip #else Dynamic #end#if flash = flash.Lib.current #end;
	@:noCompletion private static var __sentWarnings:Map<String, Bool> = new Map();

	@SuppressWarnings("checkstyle:NullableParameter")
	public static function notImplemented(?posInfo:PosInfos):Void
	{
		var api = posInfo.className + "." + posInfo.methodName;

		if (!__sentWarnings.exists(api))
		{
			__sentWarnings.set(api, true);

			Log.warn(posInfo.methodName + " is not implemented", posInfo);
		}
	}
}
