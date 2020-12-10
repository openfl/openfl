import openfl.display.JointStyle;

class JointStyleTest
{
	public static function __init__()
	{
		Mocha.describe("JointStyle", function()
		{
			Mocha.it("test", function()
			{
				switch (JointStyle.ROUND)
				{
					case JointStyle.BEVEL, JointStyle.MITER, JointStyle.ROUND:
				}
			});
		});
	}
}
