import openfl.display3D.Program3D;
import Stage3DTest;

class Program3DTest
{
	public static function __init__()
	{
		Mocha.describe("Program3D", function()
		{
			Mocha.it("dispose", function()
			{
				// TODO: Confirm functionality

				var context3D = Stage3DTest.__getContext3D();

				if (context3D != null)
				{
					var program = context3D.createProgram();
					var exists = program.dispose;

					Assert.notEqual(exists, null);
				}
			});

			Mocha.it("upload", function()
			{
				// TODO: Confirm functionality

				var context3D = Stage3DTest.__getContext3D();

				if (context3D != null)
				{
					var program = context3D.createProgram();
					var exists = program.upload;

					Assert.notEqual(exists, null);
				}
			});
		});
	}
}
