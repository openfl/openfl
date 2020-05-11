package openfl.net;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:forward
abstract _URLVariables(Dynamic) from Dynamic to Dynamic
{
	public function new(source:String = null)
	{
		this = {};

		if (source != null)
		{
			decode(source);
		}
	}

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

	public function toString():String
	{
		var result = new Array<String>();
		var fields = Reflect.fields(this);

		for (f in fields)
		{
			var value:Dynamic = Reflect.field(this, f);
			if (f.indexOf("[]") > -1 && Std.is(value, Array))
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
