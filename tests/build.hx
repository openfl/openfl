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

		var i = 0;
		for (test in tests)
		{
			Log.println('\nRUNNING TEST GROUP: $test (${++i}/${tests.length})\n');
			System.runCommand(test, "hxp");
		}
	}
}
