package openfl.display;

import openfl.errors.ArgumentError;

class AVM1MovieTest
{
	@Test public function _new()
	{
		Assert.throws(ArgumentError, function()
		{
			// bypass private constructor
			Type.createInstance(AVM1Movie, []);
		});

		#if (!flash && !cpp)
		var object:AVM1Movie = cast
			{
				addCallback: function(name, closure) {},
				call: function(name, ?p1, ?p2, ?p3, ?p4, ?p5) {}
			};

		// Check that the type signature compiles
		object.addCallback("foo", null);
		object.call("foo");
		#end
	}
}
