import openfl.text.FontStyle;

class FontStyleTest
{
	public static function __init__()
	{
		Mocha.describe("FontStyle", function()
		{
			Mocha.it("test", function()
			{
				switch (FontStyle.BOLD)
				{
					case FontStyle.BOLD, FontStyle.BOLD_ITALIC, FontStyle.ITALIC, FontStyle.REGULAR:
				}
			});
		});
	}
}
