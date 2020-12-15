package;

import hxp.*;

class Build extends Script
{
	public function new()
	{
		super();

		// TODO: Headless run?

		if (command == "default")
		{
			// command = "test";
			command = "build";
		}

		if (commandArgs.length == 0)
		{
			commandArgs.push("neko");
		}

		System.runCommand("", "lime", [command].concat(commandArgs));
	}
}
