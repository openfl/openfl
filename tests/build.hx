import hxp.*;
import sys.FileSystem;

class Build extends Script
{
	public function new()
	{
		super();

		var tests = [];
		var cwd = Sys.getCwd();

		for (file in FileSystem.readDirectory(cwd))
		{
			var path = Path.combine(cwd, file);
			if (FileSystem.isDirectory(path) && FileSystem.exists(Path.combine(path, "build.hx")))
			{
				tests.push(file);
			}
		}

		if (StringTools.startsWith(command, "test-"))
		{
			var testName = command.substr("test-".length).toLowerCase();
			var index = tests.indexOf(testName);
			if (index > -1)
			{
				System.runCommand(tests[index], "hxp", getArgs());
			}
			else
			{
				Log.error("Cannot find test group \"" + testName + "\"");
			}
		}
		else
		{
			var i = 0;
			for (test in tests)
			{
				Log.println('\nRUNNING TEST GROUP: $test (${++i}/${tests.length})\n');
				System.runCommand(test, "hxp", getArgs());
			}
		}
	}

	private function getArgs():Array<String>
	{
		var args = Log.verbose ? ["-verbose"] : [];
		if (defines.exists("target"))
		{
			args.push('-Dtarget=${defines.get("target")}');
		}
		return args;
	}
}
