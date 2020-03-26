namespace openfl._internal.backend.lime;

#if lime
import lime.system.System;
import openfl.net.URLRequest;
#if openfl_html5
import js.Browser;
#end

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
class LimeLibBackend
{
	public static getTimer(): number
	{
		return System.getTimer();
	}

	public static navigateToURL(request: URLRequest, window: string = null): void
	{
		var uri = request.url;

		if (Type.typeof(request.data) == Type.ValueType.TObject)
		{
			var query = "";
			var fields = Reflect.fields(request.data);

			for (field in fields)
			{
				if (query.length > 0) query += "&";
				query += StringTools.urlEncode(field) + "=" + StringTools.urlEncode(String(Reflect.field(request.data, field)));
			}

			if (uri.indexOf("?") > -1)
			{
				uri += "&" + query;
			}
			else
			{
				uri += "?" + query;
			}
		}

		System.openURL(uri, window);
	}

	public static preventDefaultTouchMove(): void
	{
		#if openfl_html5
		Browser.document.addEventListener("touchmove", function (evt: js.html.Event): void
		{
			evt.preventDefault();
		}, false);
		#end
	}
}
#end
