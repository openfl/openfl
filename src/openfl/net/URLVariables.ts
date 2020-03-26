/**
	The URLVariables class allows you to transfer variables between an
	application and a server. Use URLVariables objects with methods of the
	URLLoader class, with the `data` property of the URLRequest
	class, and with openfl.net namespace functions.
**/
export default class URLVariables extends Object implements AllowProperties
{
	/**
		Creates a new URLVariables object. You pass URLVariables objects to the
		`data` property of URLRequest objects.

		If you call the URLVariables constructor with a string, the
		`decode()` method is automatically called to convert the string
		to properties of the URLVariables object.

		@param source A URL-encoded string containing name/value pairs.
	**/
	public constructor(source: string = null)
	{
		super();

		if (source != null)
		{
			this.decode(source);
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
	public decode(source: string): void
	{
		var fields = Object.getOwnPropertyNames(this);

		for (let f of fields)
		{
			delete this[f];
		}

		var fields = source.split(";").join("&").split("&");

		for (let f of fields)
		{
			var eq = f.indexOf("=");

			if (eq > 0)
			{
				this[decodeURIComponent(f.substr(0, eq))] = decodeURIComponent(f.substr(eq + 1));
			}
			else if (eq != 0)
			{
				this[decodeURIComponent(f)] = "";
			}
		}
	}

	/**
		Returns a string containing all enumerable variables, in the MIME content
		encoding _application/x-www-form-urlencoded_.

		@return A URL-encoded string containing name/value pairs.
	**/
	public toString(): string
	{
		var result = new Array<string>();
		var fields = Object.getOwnPropertyNames(this);

		for (let f of fields)
		{
			var value: any = this[f];
			if (f.indexOf("[]") > -1 && value instanceof Array)
			{
				var arrayValue: string = value.map((v: string) => encodeURIComponent(v)).join(`&amp;${f}=`);
				result.push(`${encodeURIComponent(f)}=${arrayValue}`);
			}
			else
			{
				result.push(`${encodeURIComponent(f)}=${encodeURIComponent(value)}`);
			}
		}

		return result.join("&");
	}
}

interface AllowProperties
{
	[key: string]: any
}
