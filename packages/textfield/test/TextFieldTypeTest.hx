import openfl.text.TextFieldType;

class TextFieldTypeTest
{
	public static function __init__()
	{
		Mocha.describe("TextFieldType", function()
		{
			Mocha.it("test", function()
			{
				switch (TextFieldType.DYNAMIC)
				{
					case TextFieldType.DYNAMIC, TextFieldType.INPUT:
				}
			});
		});
	}
}
