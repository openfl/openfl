package;

import hxp.*;

class Script extends hxp.Script
{
	public function new()
	{
		super();

		if (command == "default") command = "test";

		if (command == "unit-test") command = "test";
		if (command == "integration-test") command = "test";
		if (command == "functional-test") command = "test-functional";

		if (StringTools.startsWith(command, "test"))
		{
			test();
		}
		else
		{
			switch (command)
			{
				case "docs":
					docs();
				default:
					Log.error("Unknown command: \"" + command + "\"");
			}
		}
	}

	private function docs():Void
	{
		System.runCommand("scripts", "haxe", ["docs.hxml"]);
		PlatformTools.launchWebServer("docs-api");
	}

	private function runOpenFLCommand(directory:String, args:Array<String>):Void
	{
		if (Log.verbose) args.push("-verbose");
		System.runCommand(directory, "openfl", args);
	}

	private function test():Void
	{
		if (command == "test-functional")
		{
			var targets = [
				"haxelib", "flash", "html5", "neko", "cpp", "hl", "hashlink", "windows", "mac", "linux", "air", "web", "electron", "extern"
			];

			if (commandArgs.length > 0)
			{
				var target = commandArgs[0];

				if (targets.indexOf(target) == -1)
				{
					Log.error("Unknown target type \"" + target + "\"");
				}

				if (target == "haxelib")
				{
					testHaxelib();
				}
				else
				{
					testHaxelib(target);
				}
			}
			else
			{
				testHaxelib();
			}
		}
		else if (command == "test")
		{
			System.runCommand("tests", "hxp", getTestArgs());
		}
		else
		{
			System.runCommand("tests", "hxp", [command].concat(getTestArgs()));
		}
	}

	private function getTestArgs():Array<String>
	{
		var args = Log.verbose ? ["-verbose"] : [];
		if (defines.exists("target"))
		{
			args.push('-Dtarget=${defines.get("target")}');
		}
		return args;
	}

	private function testHaxelib(target:String = null):Void
	{
		if (command == "test-functional")
		{
			var dir = Path.combine(Sys.getCwd(), "tests/functional");
			var args = ["test"];

			if (target == "extern")
			{
				args.push("html5");
				args.push("-Dopenfl-html5-extern");
			}
			else
			{
				args.push(target == null ? "neko" : target);
			}

			for (flag in flags.keys())
			{
				args.push("-" + flag);
			}

			for (define in defines.keys())
			{
				if (defines.get(define) != "")
				{
					args.push("-D" + define + "=" + defines.get(define));
				}
				else
				{
					args.push("-D" + define);
				}
			}

			runOpenFLCommand(dir, args);
		}
	}
}
