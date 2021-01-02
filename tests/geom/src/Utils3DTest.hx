package;

import openfl.geom.Utils3D;
import utest.Assert;
import utest.Test;

class Utils3DTest extends Test
{
	public function test_projectVector()
	{
		// TODO: Confirm functionality

		var exists = Utils3D.projectVector;

		Assert.notNull(exists);
	}

	public function test_projectVectors()
	{
		// TODO: Confirm functionality

		var exists = Utils3D.projectVectors;

		Assert.notNull(exists);
	}
}
