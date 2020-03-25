namespace openfl._internal.backend.html5;

#if openfl_html5
import js.Browser;
import openfl._internal.backend.lime_standalone.System;
import openfl.net.URLRequest;

class HTML5LibBackend
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
				query += StringTools.urlEncode(field) + "=" + StringTools.urlEncode(Std.string(Reflect.field(request.data, field)));
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
		Browser.document.addEventListener("touchmove", function (evt: js.html.Event): void
		{
			evt.preventDefault();
		}, false);
	}
}
#end
