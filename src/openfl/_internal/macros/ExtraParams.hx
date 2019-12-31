package openfl._internal.macros;

#if macro
import haxe.macro.Compiler;
import haxe.macro.Context;

@SuppressWarnings("checkstyle:FieldDocComment")
class ExtraParams
{
	public static function include():Void
	{
		if (!Context.defined("tools"))
		{
			if (!Context.defined("flash"))
			{
				Compiler.allowPackage("flash");
				Compiler.define("swf-version", "22.0");
			}
			else
			{
				var childPath = Context.resolvePath("openfl/_internal/macros");

				var parts = StringTools.replace(childPath, "\\", "/").split("/");
				parts.pop(); // _internal
				parts.pop(); // openfl
				parts.pop(); // src
				parts.pop(); // root

				var externsPath = parts.join("/") + "/externs";

				Compiler.addClassPath(externsPath + "/flash");
			}

			#if debug
			if (!Context.defined("openfl-enable-handle-error"))
			{
				Compiler.define("openfl-disable-handle-error");
			}
			#end

			if (Context.defined("js") && (Context.defined("commonjs") || Context.defined("openfljs")))
			{
				var childPath = Context.resolvePath("openfl/external");

				var parts = StringTools.replace(childPath, "\\", "/").split("/");

				if (parts.length > 3)
				{
					parts.pop();
					parts.pop();
					parts.pop();

					var openflPath = parts.join("/");

					Compiler.addClassPath(openflPath + "/lib");
				}
			}
		}

		if (Context.defined("lime"))
		{
			if (Context.defined("lime_cairo")) Compiler.define("openfl-cairo");
			if (Context.defined("lime_harfbuzz")) Compiler.define("openfl-harfbuzz");
			if (Context.defined("lime_opengl") || Context.defined("lime_opengles") || Context.defined("lime_webgl"))
			{
				Compiler.define("openfl-gl");
			}
		}

		if (Context.defined("js") && !Context.defined("nodejs"))
		{
			if (!Context.defined("lime"))
			{
				Compiler.define("howlerjs");
			}
			Compiler.define("openfl-html5");
			Compiler.define("html5");
			Compiler.define("openfl-gl");
		}
	}
}
#end
