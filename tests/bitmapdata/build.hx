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

		var target = defines.get("target");
		if (target == null)
		{
			target = "neko";
		}
		switch(target)
		{
			case "hl":
				System.removeDirectory("bin/hl");
				hxml.hl = "bin/hl/Test.hl";
			case "neko":
				System.removeDirectory("bin/neko");
				hxml.neko = "bin/neko/Test.n";
			case "cpp":
				System.removeDirectory("bin/cpp");
				hxml.cpp = "bin/cpp";
			default:
				trace('Tests not supported: ${target}');
				Sys.exit(1);
		}

		hxml.build();

		switch(target)
		{
			case "hl":
				System.recursiveCopy("assets", "bin/hl");
				System.copyFile(NDLL.getLibraryPath(new NDLL("lime", new Haxelib("lime")), getPlatformDirectoryName()), "bin/hl/lime.hdll");
				var limePath = Haxelib.getPath(new Haxelib("lime"));
				var hashlinkPath = Path.join([limePath, "templates/bin/hl", getHashLinkPlatformDirectoryName()]);
				System.recursiveCopy(hashlinkPath, "bin/hl", null, false);
				if (System.hostPlatform != WINDOWS)
				{
					System.runCommand("bin/hl", "chmod", ["+x", "hl"]);
				}
				System.runCommand("bin/hl", "./hl", ["Test.hl"]);
			case "neko":
				System.recursiveCopy("assets", "bin/neko");
				System.copyFile(NDLL.getLibraryPath(new NDLL("lime", new Haxelib("lime")), getPlatformDirectoryName()), "bin/neko/lime.ndll");
				var nekoPath = "neko";
				System.runCommand("bin/neko", nekoPath, ["Test.n"]);
			case "cpp":
				System.recursiveCopy("assets", "bin/cpp");
				System.runCommand("bin/cpp", "./Tests");
			default:
				trace('Tests not run for target: ${target}');
				Sys.exit(1);
		}
	}

	private function getHashLinkPlatformDirectoryName():String
	{
		var limePath = Haxelib.getPath(new Haxelib("lime"));
		if (Haxelib.getPathVersion(limePath).major < 8)
		{
			if (System.hostPlatform == WINDOWS)
			{
				return "windows";
			}
			else if (System.hostPlatform == MAC)
			{
				return "mac";
			}
			else
			{
				return "linux";
			}
		}
		return getPlatformDirectoryName();
	}

	private function getPlatformDirectoryName():String
	{
		if (System.hostPlatform == WINDOWS)
		{
			return "Windows";
		}
		else if (System.hostPlatform == MAC)
		{
			return System.hostArchitecture == X64 ? "Mac64" : "Mac";
		}
		else
		{
			return System.hostArchitecture == X64 ? "Linux64" : "Linux";
		}
	}
}
