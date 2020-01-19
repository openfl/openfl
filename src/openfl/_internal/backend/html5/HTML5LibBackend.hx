package openfl._internal.backend.html5;

#if openfl_html5
import js.Browser;
import openfl._internal.backend.lime_standalone.System;
import openfl.net.URLRequest;

class HTML5LibBackend
{
	public static function getTimer():Int
	{
		return System.getTimer();
	}

	public static function navigateToURL(request:URLRequest, window:String = null):Void
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

	public static function preventDefaultTouchMove():Void
	{
		Browser.document.addEventListener("touchmove", function(evt:js.html.Event):Void
		{
			evt.preventDefault();
		}, false);
	}
}
#end
