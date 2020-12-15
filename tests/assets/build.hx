import hxp.*;

class Build extends Script
{
	public function new()
	{
		super();

		var hxml = new HXML();
		hxml.main = "Tests";
		hxml.cp("src");
		hxml.cp("../../src");
		hxml.lib("utest");
		hxml.lib("lime");
		hxml.define("openfl-unit-testing");
		hxml.neko = "bin/Test.n";
		hxml.build();

		var limePath = Haxelib.getPath(new Haxelib("lime"));
		var is64 = (System.hostArchitecture == X64);

		switch (System.hostPlatform)
		{
			case WINDOWS:
				System.copyFile(Path.combine(limePath, "ndll/Windows" + (is64 ? "64" : "") + "/lime.ndll"), "bin/lime.ndll");
			case MAC:
				System.copyFile(Path.combine(limePath, "ndll/Mac/lime.ndll"), "bin/lime.ndll");
			default:
				System.copyFile(Path.combine(limePath, "ndll/Linux" + (is64 ? "64" : "") + "/lime.ndll"), "bin/lime.ndll");
		}

		System.runCommand("bin", "neko", ["Test.n"]);
	}
}
