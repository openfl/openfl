package;

import openfl.display3D.Context3DProfile;
import utest.Assert;
import utest.Test;

class Context3DProfileTest extends Test
{
	public function test_test()
	{
		switch (Context3DProfile.BASELINE)
		{
			case Context3DProfile.BASELINE, Context3DProfile.BASELINE_CONSTRAINED, Context3DProfile.BASELINE_EXTENDED, Context3DProfile.STANDARD,
				Context3DProfile.STANDARD_CONSTRAINED, Context3DProfile.STANDARD_EXTENDED #if air, Context3DProfile.ENHANCED #end:
				Assert.isTrue(true);
		}
	}
}
