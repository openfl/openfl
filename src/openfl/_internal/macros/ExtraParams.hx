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

			if (Context.defined("js") && !Context.defined("nodejs") && !Context.defined("lime"))
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

		/**
			Add hidden ApplicationMain type
			for better code completion when
			'update' has not been called
		**/

		try
		{
			Context.getModule("ApplicationMain");
		}
		catch (e:Dynamic)
		{
			var pos = Context.currentPos();
			Context.defineModule("ApplicationMain", [
				{
					fields: [
						{
							access: [APublic, AStatic],
							kind: FFun(
								{
									args: [],
									expr: macro {},
									ret: null
								}),
							meta: [
								{name: ":noCompletion", pos: pos},
								{name: ":dox", params: [macro hide], pos: pos}
							],
							name: "main",
							pos: pos
						}
					],
					kind: TDClass(null, [], false),
					name: "ApplicationMain",
					pack: [],
					pos: pos
				}
			]);
		}
	}

	public static function includeExterns():Void
	{
		var childPath = Context.resolvePath("openfl/_internal/symbols");

		var parts = StringTools.replace(childPath, "\\", "/").split("/");
		parts.pop(); // _internal
		parts.pop(); // openfl
		parts.pop(); // src
		parts.pop(); // root

		var externsPath = parts.join("/") + "/externs";

		Compiler.addClassPath(externsPath + "/flash");
	}
}
#end
