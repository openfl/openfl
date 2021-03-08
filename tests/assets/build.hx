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

		var platformName = switch (System.hostPlatform)
		{
			case WINDOWS: "Windows" + (System.hostArchitecture == X64 ? "64" : "");
			case MAC: "Mac" + (System.hostArchitecture == X64 ? "64" : "");
			default: "Linux" + (System.hostArchitecture == X64 ? "64" : "");
		}

		System.copyFile(NDLL.getLibraryPath(new NDLL("lime", new Haxelib("lime")), platformName), "bin/lime.ndll");
		System.runCommand("bin", "neko", ["Test.n"]);
	}
}
