package;

import openfl.display.DOMElement;
import utest.Assert;
import utest.Test;

class DOMElementTest extends Test
{
	public function test_new_()
	{
		// TODO: Confirm functionality

		var domElement = new DOMElement(null);
		var exists = domElement;

		Assert.notNull(exists);
	}
}
