import hxp.*;
import sys.FileSystem;

class Build extends Script
{
	public function new()
	{
		super();

		if (defines.exists("use-lime-tools"))
		{
			runLimeToolsTests();
		}
		else
		{
			runHxpTests();
		}
	}

	private function runHxpTests():Void
	{
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
				System.runCommand(tests[index], "haxelib", ["run", "hxp"].concat(getHxpArgs()));
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
				System.runCommand(test, "haxelib", ["run", "hxp"].concat(getHxpArgs()));
			}
		}
	}

	private function getHxpArgs():Array<String>
	{
		var args = Log.verbose ? ["-verbose"] : [];
		if (defines.exists("target"))
		{
			args.push('-Dtarget=${defines.get("target")}');
		}
		return args;
	}

	private function runLimeToolsTests():Void
	{
		var tests = [];
		var cwd = Sys.getCwd();

		for (file in FileSystem.readDirectory(cwd))
		{
			var path = Path.combine(cwd, file);
			if (FileSystem.isDirectory(path) && file != "functional" && FileSystem.exists(Path.combine(path, "project.xml")))
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
				System.runCommand(tests[index], "haxelib", ["run", "lime"].concat(getLimeToolsArgs()));
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
				System.runCommand(test, "haxelib", ["run", "lime"].concat(getLimeToolsArgs()));
			}
		}
	}

	private function getLimeToolsArgs():Array<String>
	{
		var args = ["test"];
		if (defines.exists("target"))
		{
			args.push(defines.get("target"));
		}
		else
		{
			args.push("neko");
		}
		if (Log.verbose)
		{
			args.push("-verbose");
		}
		args.push("-nocolor");
		return args;
	}
}
