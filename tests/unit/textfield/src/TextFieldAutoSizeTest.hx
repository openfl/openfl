import openfl.text.TextFieldAutoSize;

class TextFieldAutoSizeTest
{
	public static function __init__()
	{
		Mocha.describe("TextFieldAutoSize", function()
		{
			Mocha.it("test", function()
			{
				switch (TextFieldAutoSize.CENTER)
				{
					case TextFieldAutoSize.CENTER, TextFieldAutoSize.LEFT, TextFieldAutoSize.NONE, TextFieldAutoSize.RIGHT:
				}
			});
		});
	}
}
