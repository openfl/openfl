package;

import openfl.geom.Orientation3D;
import utest.Assert;
import utest.Test;

class Orientation3DTest extends Test
{
	public function test_test()
	{
		switch (Orientation3D.AXIS_ANGLE)
		{
			case Orientation3D.AXIS_ANGLE, Orientation3D.EULER_ANGLES, Orientation3D.QUATERNION:
				Assert.isTrue(true);
		}
	}
}
