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
		hxml.define("openfl-unit-testing");
		hxml.neko = "bin/Test.n";
		hxml.build();

		System.runCommand("bin", "neko", ["Test.n"]);
	}
}
