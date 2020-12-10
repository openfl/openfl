import openfl.text.AntiAliasType;

class AntiAliasTypeTest
{
	public static function __init__()
	{
		Mocha.describe("AntiAliasType", function()
		{
			Mocha.it("test", function()
			{
				switch (AntiAliasType.ADVANCED)
				{
					case AntiAliasType.ADVANCED, AntiAliasType.NORMAL:
				}
			});
		});
	}
}
