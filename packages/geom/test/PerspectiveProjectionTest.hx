import openfl.display.Stage;
import openfl.geom.PerspectiveProjection;

class PerspectiveProjectionTest
{
	public static function __init__()
	{
		Mocha.before(function()
		{
			var stage = new Stage(550, 400);
		});

		Mocha.describe("Haxe | PerspectiveProjection", function()
		{
			Mocha.it("fieldOfView", function()
			{
				// TODO: Confirm functionality

				var perspectiveProjection = new PerspectiveProjection();
				var exists = perspectiveProjection.fieldOfView;

				Assert.notEqual(exists, null);
			});

			Mocha.it("focalLength", function()
			{
				// TODO: Confirm functionality

				var perspectiveProjection = new PerspectiveProjection();
				var exists = perspectiveProjection.focalLength;

				Assert.notEqual(exists, null);
			});

			Mocha.it("projectionCenter", function()
			{
				// TODO: Confirm functionality

				var perspectiveProjection = new PerspectiveProjection();
				var exists = perspectiveProjection.projectionCenter;

				Assert.notEqual(exists, null);
			});

			Mocha.it("new", function()
			{
				// TODO: Confirm functionality

				var perspectiveProjection = new PerspectiveProjection();
				var exists = perspectiveProjection;

				Assert.notEqual(exists, null);
			});

			Mocha.it("toMatrix3D", function()
			{
				// TODO: Confirm functionality

				var perspectiveProjection = new PerspectiveProjection();
				var exists = perspectiveProjection.toMatrix3D;

				Assert.notEqual(exists, null);
			});
		});
	}
}
