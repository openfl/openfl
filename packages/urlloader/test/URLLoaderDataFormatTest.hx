import openfl.net.URLLoaderDataFormat;

class URLLoaderDataFormatTest
{
	public static function __init__()
	{
		Mocha.describe("URLLoaderDataFormat", function()
		{
			Mocha.it("test", function()
			{
				switch (URLLoaderDataFormat.BINARY)
				{
					case URLLoaderDataFormat.BINARY, URLLoaderDataFormat.TEXT, URLLoaderDataFormat.VARIABLES:
				}
			});
		});
	}
}
