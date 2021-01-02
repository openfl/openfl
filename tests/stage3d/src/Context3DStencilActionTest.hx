package;

import openfl.display3D.Context3DStencilAction;
import utest.Assert;
import utest.Test;

class Context3DStencilActionTest extends Test
{
	public function test_test()
	{
		switch (Context3DStencilAction.DECREMENT_SATURATE)
		{
			case Context3DStencilAction.DECREMENT_SATURATE, Context3DStencilAction.DECREMENT_WRAP, Context3DStencilAction.INCREMENT_SATURATE,
				Context3DStencilAction.INCREMENT_WRAP, Context3DStencilAction.INVERT, Context3DStencilAction.KEEP, Context3DStencilAction.SET,
				Context3DStencilAction.ZERO:
				Assert.isTrue(true);
		}
	}
}
