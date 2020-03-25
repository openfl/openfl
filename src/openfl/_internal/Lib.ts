namespace openfl._internal;

import haxe.PosInfos;
import openfl._internal.utils.Log;
#if!openfl_unit_testing
import openfl.display.Application;
import openfl.display.MovieClip;
#end

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
class Lib
{
	public static current: #if !openfl_unit_testing MovieClip #else Dynamic #end#if flash = flash.Lib.current #end;
	#if lime
	public static limeApplication: #if !openfl_unit_testing Application #else Dynamic #end;
	#end
	protected static __sentWarnings: Map<string, Bool> = new Map();

	@SuppressWarnings("checkstyle:NullableParameter")
	public static notImplemented(?posInfo: PosInfos): void
	{
		var api = posInfo.className + "." + posInfo.methodName;

		if (!__sentWarnings.exists(api))
		{
			__sentWarnings.set(api, true);

			Log.warn(posInfo.methodName + " is not implemented", posInfo);
		}
	}
}
