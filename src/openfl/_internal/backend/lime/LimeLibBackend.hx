package openfl._internal.backend.lime;

#if lime
import lime.system.System;
import openfl.net.URLRequest;
#if openfl_html5
import js.Browser;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class LimeLibBackend
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
		#if openfl_html5
		Browser.document.addEventListener("touchmove", function(evt:js.html.Event):Void
		{
			evt.preventDefault();
		}, false);
		#end
	}
}
#end
