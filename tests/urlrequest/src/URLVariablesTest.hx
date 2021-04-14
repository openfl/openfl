package;

import openfl.net.URLVariables;
import utest.Assert;
import utest.Test;

class URLVariablesTest extends Test
{
	public function test_new_()
	{
		// TODO: Confirm functionality

		var urlVariables = new URLVariables();
		Assert.notNull(urlVariables);
	}

	public function test_decode()
	{
		// TODO: Confirm functionality

		var urlVariables = new URLVariables();
		var exists = urlVariables.decode;

		Assert.notNull(exists);
	}
	/*public function toString () {



	}*/
}
