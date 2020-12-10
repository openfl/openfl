package openfl.net;

#if !flash
/**
	The URLVariables class allows you to transfer variables between an
	application and a server. Use URLVariables objects with methods of the
	URLLoader class, with the `data` property of the URLRequest
	class, and with openfl.net package functions.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:forward
abstract URLVariables(Dynamic) from Dynamic to Dynamic
{
	/**
		Creates a new URLVariables object. You pass URLVariables objects to the
		`data` property of URLRequest objects.

		If you call the URLVariables constructor with a string, the
		`decode()` method is automatically called to convert the string
		to properties of the URLVariables object.

		@param source A URL-encoded string containing name/value pairs.
	**/
	public function new(source:String = null)
	{
		this = {};

		if (source != null)
		{
			decode(source);
		}
	}

	/**
		Converts the variable string to properties of the specified URLVariables
		object.

		This method is used internally by the URLVariables events. Most users
		do not need to call this method directly.

		@param source A URL-encoded query string containing name/value pairs.
		@throws Error The source parameter must be a URL-encoded query string
					  containing name/value pairs.
	**/
	public function decode(source:String):Void
	{
		var fields = Reflect.fields(this);

		for (f in fields)
		{
			Reflect.deleteField(this, f);
		}

		var fields = source.split(";").join("&").split("&");

		for (f in fields)
		{
			var eq = f.indexOf("=");

			if (eq > 0)
			{
				Reflect.setField(this, StringTools.urlDecode(f.substr(0, eq)), StringTools.urlDecode(f.substr(eq + 1)));
			}
			else if (eq != 0)
			{
				Reflect.setField(this, StringTools.urlDecode(f), "");
			}
		}
	}

	/**
		Returns a string containing all enumerable variables, in the MIME content
		encoding _application/x-www-form-urlencoded_.

		@return A URL-encoded string containing name/value pairs.
	**/
	public function toString():String
	{
		var result = new Array<String>();
		var fields = Reflect.fields(this);

		for (f in fields)
		{
			var value:Dynamic = Reflect.field(this, f);
			if (f.indexOf("[]") > -1 && (value is Array))
			{
				var arrayValue:String = Lambda.map(value, function(v:String)
				{
					return StringTools.urlEncode(v);
				}).join('&amp;${f}=');
				result.push(StringTools.urlEncode(f) + "=" + arrayValue);
			}
			else
			{
				result.push(StringTools.urlEncode(f) + "=" + StringTools.urlEncode(value));
			}
		}

		return result.join("&");
	}
}
#else
typedef URLVariables = flash.net.URLVariables;
#end
