import openfl.utils.Endian;

class EndianTest
{
	public static function __init__()
	{
		Mocha.describe("Endian", function()
		{
			Mocha.it("test", function()
			{
				switch (Endian.BIG_ENDIAN)
				{
					case Endian.BIG_ENDIAN, Endian.LITTLE_ENDIAN:
				}
			});
		});
	}
}
