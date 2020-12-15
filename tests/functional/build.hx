package;

import hxp.*;

class Build extends Script
{
	public function new()
	{
		super();

		if (command == "default")
		{
			command = "test";
		}

		if (commandArgs.length == 0)
		{
			commandArgs.push("neko");
		}

		System.runCommand("", "lime", [command].concat(commandArgs));
	}
}
