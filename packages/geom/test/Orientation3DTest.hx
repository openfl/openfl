import openfl.geom.Orientation3D;

class Orientation3DTest
{
	public static function __init__()
	{
		Mocha.describe("Orientation", function()
		{
			Mocha.it("test", function()
			{
				switch (Orientation3D.AXIS_ANGLE)
				{
					case Orientation3D.AXIS_ANGLE, Orientation3D.EULER_ANGLES, Orientation3D.QUATERNION:
				}
			});
		});
	}
}
