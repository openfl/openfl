package openfl._internal;

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

			if (Context.defined("lime"))
			{
				var childPath = Context.resolvePath("openfl/external");

				var parts = StringTools.replace(childPath, "\\", "/").split("/");

				if (parts.length > 3)
				{
					parts.pop();
					parts.pop();
					parts.pop();

					var openflPath = parts.join("/");

					var paths = [
						"/packages/application/src", "/packages/assets/src", "/packages/bitmapdata/src", "/packages/displayobject/src",
						"/packages/errors/src", "/packages/eventdispatcher/src", "/packages/externalinterface/src", "/packages/filereference/src",
						"/packages/filters/src", "/packages/geom/src", "/packages/graphics/src", "/packages/input/src", "/packages/loader/src",
						"/packages/movieclip/src", "/packages/printing/src", "/packages/renderer-cairo/src", "/packages/renderer-canvas/src",
						"/packages/renderer-core/src", "/packages/renderer-dom/src", "/packages/renderer-flash/src", "/packages/renderer-stage3d/src",
						"/packages/security/src", "/packages/sensors/src", "/packages/shader/src", "/packages/sharedobject/src", "/packages/socket/src",
						"/packages/sound/src", "/packages/stage/src", "/packages/stage3d/src", "/packages/system/src", "/packages/telemetry/src",
						"/packages/textfield/src", "/packages/tilemap/src", "/packages/urlloader/src", "/packages/urlrequest/src", "/packages/urlstream/src",
						"/packages/utils/src", "/packages/video/src"
					];

					for (path in paths)
					{
						Compiler.addClassPath(openflPath + path);
					}
				}
			}

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
	}

	public static function includeExterns():Void
	{
		var childPath = Context.resolvePath("openfl/external");

		var parts = StringTools.replace(childPath, "\\", "/").split("/");
		parts.pop();
		parts.pop();
		parts.pop();

		var externsPath = parts.join("/") + "/externs";

		Compiler.addClassPath(externsPath + "/flash");
	}
}
#end
