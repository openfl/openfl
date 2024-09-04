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
		hxml.cp("../../lib/flash-externs/src");
		hxml.lib("utest");
		hxml.lib("lime");
		hxml.define("openfl");
		hxml.define("openfl-unit-testing");

		var target = defines.get("target");
		if (target == null)
		{
			target = "neko";
		}
		switch (target)
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
			case "swf":
				System.removeDirectory("bin/swf");
				hxml.cp("../../lib/flash-externs/src");
				hxml.swf = "bin/swf/Test.swf";
				hxml.swfVersion = "30";
				hxml.define("air");
				hxml.define("fdb");
			default:
				trace('Tests not supported: ${target}');
				Sys.exit(1);
		}

		hxml.build();

		switch (target)
		{
			case "hl":
				var hdllPath = NDLL.getLibraryPath(new NDLL("lime", new Haxelib("lime")), getHashLinkPlatformDirectoryName(true));
				hdllPath = hdllPath.substr(0, hdllPath.length - Path.extension(hdllPath).length) + "hdll";
				System.copyFile(hdllPath, "bin/hl/lime.hdll");
				var limePath = Haxelib.getPath(new Haxelib("lime"));
				var hashlinkPath = Path.join([limePath, "templates/bin/hl", getHashLinkPlatformDirectoryName()]);
				System.recursiveCopy(hashlinkPath, "bin/hl", null, false);
				if (System.hostPlatform != WINDOWS)
				{
					System.runCommand("bin/hl", "chmod", ["+x", "hl"]);
				}
				System.runCommand("bin/hl", "./hl", ["Test.hl"]);
			case "neko":
				var ndllPath = NDLL.getLibraryPath(new NDLL("lime", new Haxelib("lime")), getPlatformDirectoryName());
				System.copyFile(ndllPath, "bin/neko/lime.ndll");
				var nekoPath = "neko";
				System.runCommand("bin/neko", nekoPath, ["Test.n"]);
			case "cpp":
				System.recursiveCopy("assets", "bin/cpp/assets");
				System.runCommand("bin/cpp", "./Tests");
			case "swf":
				System.copyFile("../application.xml", "bin/swf/application.xml");
				var airSdkPath = StringTools.trim(System.runProcess(".", "haxelib", ["run", "lime", "config", "AIR_SDK"]));
				var adlPath = Path.join([airSdkPath, "bin/adl"]);
				System.runCommand("bin/swf", adlPath, ["-nodebug", "application.xml"]);
			default:
				trace('Tests not run for target: ${target}');
				Sys.exit(1);
		}
	}

	private function getHashLinkPlatformDirectoryName(forRuntime:Bool = false):String
	{
		var limePath = Haxelib.getPath(new Haxelib("lime"));
		if (forRuntime && Haxelib.getPathVersion(limePath).major < 8)
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
		if (System.hostPlatform == MAC)
		{
			return (System.hostArchitecture == X64 || System.hostArchitecture == ARM64) ? "Mac64" : "Mac";
		}
		return getPlatformDirectoryName();
	}

	private function getPlatformDirectoryName():String
	{
		if (System.hostPlatform == WINDOWS)
		{
			return System.hostArchitecture == X64 ? "Windows64" : "Windows";
		}
		else if (System.hostPlatform == MAC)
		{
			return switch (System.hostArchitecture)
			{
				case X64: "Mac64";
				case ARM64: "MacArm64";
				default: "Mac";
			}
		}
		else
		{
			return System.hostArchitecture == X64 ? "Linux64" : "Linux";
		}
	}
}
