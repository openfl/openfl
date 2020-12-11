package openfl.utils._internal;

#if macro
import haxe.macro.Compiler;
import haxe.macro.Context;

@SuppressWarnings("checkstyle:FieldDocComment")
class ExtraParamsMacro
{
	public static function include():Void
	{
		if (!Context.defined("tools"))
		{
			if (Context.defined("display"))
			{
				includeExterns();
			}

			if (!Context.defined("flash"))
			{
				Compiler.allowPackage("flash");
				Compiler.define("swf-version", "22.0");
			}

			#if debug
			if (!Context.defined("openfl-enable-handle-error"))
			{
				Compiler.define("openfl-disable-handle-error");
			}
			#end
		}
	}

	public static function includeExterns():Void
	{
		var childPath = Context.resolvePath("openfl/external");

		var parts = StringTools.replace(childPath, "\\", "/").split("/");
		parts.pop();
		parts.pop();
		parts.pop();

		var externsPath = parts.join("/") + "/lib/flash-externs/src";

		Compiler.addClassPath(externsPath);
	}
}
#end
