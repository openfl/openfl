import openfl.geom.Utils3D;

class Utils3DTest
{
	public static function __init__()
	{
		Mocha.describe("Utils3D", function()
		{
			Mocha.it("projectVector", function()
			{
				// TODO: Confirm functionality

				var exists = Utils3D.projectVector;

				Assert.notEqual(exists, null);
			});

			Mocha.it("projectVectors", function()
			{
				// TODO: Confirm functionality

				var exists = Utils3D.projectVectors;

				Assert.notEqual(exists, null);
			});
		});
	}
}
