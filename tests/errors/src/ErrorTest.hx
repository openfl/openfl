package;

import openfl.errors.Error;
import utest.Assert;
import utest.Test;

class ErrorTest extends Test
{
	public function test_errorID()
	{
		// TODO: Confirm functionality

		var error = new Error();
		var exists = error.errorID;

		Assert.notNull(exists);
	}

	public function test_message()
	{
		// TODO: Confirm functionality

		var error = new Error();
		var exists = error.message;

		Assert.notNull(exists);
	}

	public function test_name()
	{
		// TODO: Confirm functionality

		var error = new Error();
		var exists = error.name;

		Assert.notNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var error = new Error();

		Assert.notNull(error);
	}

	public function test_getStackTrace()
	{
		// TODO: Confirm functionality

		var error = new Error();
		var exists = error.getStackTrace;

		Assert.notNull(exists);
	}

	public function test_toString()
	{
		// as in Flash: the name, then the message if there is one (Std.string calls toString)
		Assert.equals("Error: boom", Std.string(new Error("boom")));
		Assert.equals("Error: boom", Std.string(new Error("boom", 42)));
		Assert.equals("Error", Std.string(new Error()));

		var named = new Error("Required HUD bake failed");
		named.name = "HudFatalError";
		Assert.equals("HudFatalError: Required HUD bake failed", Std.string(named));
	}

	public function test_getStackTraceStartsWithError()
	{
		// as in Flash's debugger, the first line is the error itself: a build without a stack still tells what it was
		var error = new Error("boom");
		Assert.equals("Error: boom", error.getStackTrace().split("\n")[0]);
	}
}
